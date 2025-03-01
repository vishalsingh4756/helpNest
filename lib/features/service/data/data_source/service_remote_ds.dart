import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';
import 'package:latlong2/latlong.dart';

class ServiceRemoteDs implements ServiceRemoteRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addOrder({required OrderModel order}) async {
    try {
      await firestore.collection('orders').doc(order.id).set(order.toJson());
    } catch (e) {
      throw Exception('Error adding order: $e');
    }
  }

  @override
  Future<List<FindServiceProviderParams>> findServiceProvider({
    required String serviceID,
    required Position? position,
  }) async {
    try {
      // 🔍 Fetch service providers with the given serviceID
      QuerySnapshot serviceProvidersSnapshot = await firestore
          .collection('service_providers')
          .where('serviceID', isEqualTo: serviceID)
          .where("status", isEqualTo: "verified")
          .get();

      List<ServiceProviderModel> serviceProviders = serviceProvidersSnapshot
          .docs
          .map((doc) =>
              ServiceProviderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // 🚀 Fetch user & feedback data in parallel
      List<FindServiceProviderParams> result = await Future.wait(
        serviceProviders.map((serviceProvider) async {
          UserModel user = await _getUserForProvider(serviceProvider.id);
          List<OrderModel> orders =
              await _getOrdersForProvider(serviceProvider.id);
          List<FeedbackModel> feedbacks =
              await _getFeedbacksForProvider(serviceProvider.id);

          double? distance;
          if (position != null &&
              user.location.geopoint != const GeoPoint(0, 0)) {
            distance = calculateDistance(
              point1: LatLng(position.latitude, position.longitude),
              point2: LatLng(
                user.location.geopoint.latitude,
                user.location.geopoint.longitude
              ),
            );
          }

          return FindServiceProviderParams(
            serviceProvider: serviceProvider,
            orders: orders,
            user: user,
            feedbacks: feedbacks,
            distance: distance,
          );
        }),
      );

      // 📏 Sort providers by distance if position is available
      if (position != null) {
        result.sort((a, b) => (a.distance ?? double.infinity)
            .compareTo(b.distance ?? double.infinity));
      }

      return result;
    } catch (e) {
      throw Exception('❌ Error finding service providers params: $e');
    }
  }

  /// 🏷️ Fetches orders for a provider
  Future<List<OrderModel>> _getOrdersForProvider(String providerId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('orders')
        .where('providerID', isEqualTo: providerId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      log('❌ No orders found for provider ID: $providerId');
      return [];
    }

    return querySnapshot.docs
        .map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// 🏷️ Fetches user data for a provider
  Future<UserModel> _getUserForProvider(String providerId) async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(providerId).get();

    if (!userSnapshot.exists) {
      throw Exception('❌ User not found for provider ID: $providerId');
    }

    return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }

  /// 🏷️ Fetches feedbacks for a provider
  Future<List<FeedbackModel>> _getFeedbacksForProvider(
      String providerId) async {
    QuerySnapshot feedbackSnapshot = await firestore
        .collection('feedbacks')
        .where('category', isEqualTo: providerId)
        .get();

    return feedbackSnapshot.docs
        .map(
            (doc) => FeedbackModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      QuerySnapshot serviceSnapshot =
          await firestore.collection('services').get();

      return serviceSnapshot.docs
          .map((doc) =>
              ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching services: $e');
    }
  }
}
