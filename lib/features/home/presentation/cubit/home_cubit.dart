import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/home/data/models/ad_banner_model.dart';
import 'package:helpnest/features/home/domain/repo/ad_banner_repo.dart';
import 'package:helpnest/features/home/domain/repo/home_remote_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AdBannerRepo _adBannerRepo;
  final HomeRemoteRepo _homeRemoteRepo;
  StreamSubscription? _isLocationEnabledSubscription;
  StreamSubscription? _detectingOrderWithActiveSubscription;

  HomeCubit(
      {required AdBannerRepo adBannerRepo,
      required HomeRemoteRepo homeRemoteRepo})
      : _adBannerRepo = adBannerRepo,
        _homeRemoteRepo = homeRemoteRepo,
        super(const HomeState()) {
    initializeIsLocationEnabledListener();
    detectingOrderWithActiveListener();
  }

  Future<void> updatePosition({required Position position}) async {
    emit(state.copyWith(position: position));
  }

  Future<void> updateProviderMode({required bool providerMode}) async {
    emit(state.copyWith(providerMode: providerMode));
  }

  Future<void> updateBottomNavIndex({required int index}) async {
    emit(state.copyWith(bottomNavIndex: index));
  }

  Future<void> getAdBanner({required Position? position}) async {
    try {
      emit(state.copyWith(getAdBannerStatus: StateStatus.loading));
      final adBanners = await _adBannerRepo.getAdBanner(position: position);
      emit(state.copyWith(
          adBanners: adBanners, getAdBannerStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          getAdBannerStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Timer? _locationTimer;

  void initializeIsLocationEnabledListener() async {
    final bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    // also check if location permission is not set to don't allow
    emit(state.copyWith(locationEnabled: isLocationEnabled));

    if (isLocationEnabled) {
      _startLocationLogging();
    }

    _isLocationEnabledSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      final bool isNowEnabled = status == ServiceStatus.enabled;
      emit(state.copyWith(locationEnabled: isNowEnabled));

      if (isNowEnabled) {
        _startLocationLogging();
      } else {
        _locationTimer?.cancel();
        _locationTimer = null;
      }
    });
  }

  Future<void> _startLocationLogging(
      {String orderIdWithActiveOrderForProvider = ""}) async {
    await _getLocation(activeOrder: orderIdWithActiveOrderForProvider);
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(
        orderIdWithActiveOrderForProvider.isNotEmpty
            ? const Duration(minutes: 1)
            : const Duration(minutes: 5), (timer) async {
      await _getLocation(activeOrder: orderIdWithActiveOrderForProvider);
    });
  }

  Future<void> _getLocation({String activeOrder = ""}) async {
    try {
      emit(state.copyWith(getLocationStatus: StateStatus.loading));
      final position = await Geolocator.getCurrentPosition();

      if (state.lastLocation.isNotEmpty) {
        final lastLocation = state.lastLocation.first.geopoint;
        if ((position.latitude - lastLocation.latitude).abs() < 0.0001 &&
            (position.longitude - lastLocation.longitude).abs() < 0.0001) {
          log("Location unchanged, skipping update.");
          return;
        }
      }

      updatePosition(position: position);
      final lastLocation = await getUserLocationFromPosition(position);
      emit(state.copyWith(
          lastLocation: [lastLocation],
          getLocationStatus: StateStatus.success));

      await updateLocationToDatabase(location: lastLocation);

      if (activeOrder.isNotEmpty) {
        await _homeRemoteRepo.updatePoints(
            orderID: activeOrder, point: lastLocation.geopoint);
      }

      log("Location updated: ${lastLocation.geopoint.latitude}, ${lastLocation.geopoint.longitude}");
    } catch (e) {
      log("GET_LOCATION_STATUS_ERROR: $e");
      emit(state.copyWith(getLocationStatus: StateStatus.failure));
    }
  }

  Future<void> updateLocationToDatabase(
      {required UserLocationModel location}) async {
    try {
      emit(state.copyWith(updateLocationToDatabaseStatus: StateStatus.loading));
      await _homeRemoteRepo.updateLocationToDatabase(location: location);
      emit(state.copyWith(updateLocationToDatabaseStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          updateLocationToDatabaseStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> getLocationFromDatabase() async {
    try {
      emit(state.copyWith(getLocationFromDatabaseStatus: StateStatus.loading));
      final location = await _homeRemoteRepo.getLocationFromDatabase();
      emit(state.copyWith(
          position: location != null &&
                  location.geopoint.latitude != 0 &&
                  location.state.isNotEmpty
              ? Position(
                  longitude: location.geopoint.longitude,
                  latitude: location.geopoint.latitude,
                  timestamp: Timestamp.now().toDate(),
                  accuracy: 100,
                  altitude: 100,
                  altitudeAccuracy: 100,
                  heading: 100,
                  headingAccuracy: 100,
                  speed: 100,
                  speedAccuracy: 100)
              : null,
          lastLocation: location != null &&
                  location.geopoint.latitude != 0 &&
                  location.state.isNotEmpty
              ? [location]
              : [],
          getLocationFromDatabaseStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          getLocationFromDatabaseStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  void detectingOrderWithActiveListener() async {
    emit(state.copyWith(detectActiveOrderStatus: StateStatus.loading));
    try {
      _detectingOrderWithActiveSubscription =
          _homeRemoteRepo.getOrderIdToUpdatePoints().listen((orderID) {
        if (orderID.isNotEmpty) {
          _startLocationLogging(orderIdWithActiveOrderForProvider: orderID);
        } else {
          _locationTimer?.cancel();
          // _startLocatioLogging(); // might add this without any params because normal update is stopping after stopping order update
        }
      });
      emit(state.copyWith(detectActiveOrderStatus: StateStatus.success));
    } catch (e) {
      log("STREAM_ORDER_ERROR: $e");
      emit(state.copyWith(
          detectActiveOrderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  @override
  Future<void> close() {
    _isLocationEnabledSubscription?.cancel();
    _locationTimer?.cancel();
    _detectingOrderWithActiveSubscription?.cancel();
    return super.close();
  }
}
