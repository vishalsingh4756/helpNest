import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/profile/data/models/emergency_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/profile/domain/repo/profile_repo.dart';

part 'profile_cubit.dart';

class ProfileState extends Equatable {
  final List<UserModel> user;
  final List<ServiceProviderModel> provider;
  final List<FeedbackModel> appFeedbacks;
  final List<EmergencyModel> emergency;
  final CommonError error;
  final GeoPoint currentLocation;
  final StateStatus addFeedbackStatus;
  final StateStatus getAppFeedbackStatus;
  final StateStatus getProviderStatus;
  final StateStatus getUserStatus;
  final StateStatus reportSafetyEmergencyStatus;
  final StateStatus getEmergencyStatus;
  final StateStatus requestServiceProviderAccessStatus;
  final StateStatus updateProviderStatus;
  final StateStatus updateUserStatus;
  final StateStatus logOutStatus;

  const ProfileState({
    this.user = const [],
    this.provider = const [],
    this.appFeedbacks = const [],
    this.emergency = const [],
    this.error = const CommonError(),
    this.currentLocation = const GeoPoint(0, 0),
    this.addFeedbackStatus = StateStatus.initial,
    this.getAppFeedbackStatus = StateStatus.initial,
    this.getProviderStatus = StateStatus.initial,
    this.getUserStatus = StateStatus.initial,
    this.reportSafetyEmergencyStatus = StateStatus.initial,
    this.getEmergencyStatus = StateStatus.initial,
    this.requestServiceProviderAccessStatus = StateStatus.initial,
    this.updateProviderStatus = StateStatus.initial,
    this.updateUserStatus = StateStatus.initial,
    this.logOutStatus = StateStatus.initial,
  });

  ProfileState copyWith({
    List<UserModel>? user,
    List<ServiceProviderModel>? provider,
    List<FeedbackModel>? appFeedbacks,
    List<EmergencyModel>? emergency,
    CommonError? error,
    GeoPoint? currentLocation,
    StateStatus? addFeedbackStatus,
    StateStatus? getAppFeedbackStatus,
    StateStatus? getProviderStatus,
    StateStatus? getUserStatus,
    StateStatus? reportSafetyEmergencyStatus,
    StateStatus? getEmergencyStatus,
    StateStatus? requestServiceProviderAccessStatus,
    StateStatus? updateProviderStatus,
    StateStatus? updateUserStatus,
    StateStatus? logOutStatus,
  }) {
    return ProfileState(
      user: user ?? this.user,
      provider: provider ?? this.provider,
      appFeedbacks: appFeedbacks ?? this.appFeedbacks,
      emergency: emergency ?? this.emergency,
      error: error ?? this.error,
      currentLocation: currentLocation ?? this.currentLocation,
      addFeedbackStatus: addFeedbackStatus ?? this.addFeedbackStatus,
      getAppFeedbackStatus: getAppFeedbackStatus ?? this.getAppFeedbackStatus,
      getProviderStatus: getProviderStatus ?? this.getProviderStatus,
      getUserStatus: getUserStatus ?? this.getUserStatus,
      reportSafetyEmergencyStatus:
          reportSafetyEmergencyStatus ?? this.reportSafetyEmergencyStatus,
      getEmergencyStatus: getEmergencyStatus ?? this.getEmergencyStatus,
      requestServiceProviderAccessStatus: requestServiceProviderAccessStatus ??
          this.requestServiceProviderAccessStatus,
      updateProviderStatus: updateProviderStatus ?? this.updateProviderStatus,
      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      logOutStatus: logOutStatus ?? this.logOutStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        provider,
        appFeedbacks,
        emergency,
        error,
        currentLocation,
        addFeedbackStatus,
        getAppFeedbackStatus,
        getProviderStatus,
        getUserStatus,
        reportSafetyEmergencyStatus,
        getEmergencyStatus,
        requestServiceProviderAccessStatus,
        updateProviderStatus,
        updateUserStatus,
        logOutStatus,
      ];
}
