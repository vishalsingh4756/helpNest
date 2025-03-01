import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/search/domain/repo/search_remote_repo.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';

class SearchRemoteDs implements SearchRemoteRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<SearchParam> streamSearchResult({required String input}) async* {
    try {
      final serviceStream = _firestore
          .collection('services')
          .where('name', isGreaterThanOrEqualTo: input)
          .where('name', isLessThan: '$input\uf8ff')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromJson(doc.data()))
              .toList());

      final providerStream = _firestore
          .collection('service_providers')
          .where('name', isGreaterThanOrEqualTo: input)
          .where('name', isLessThan: '$input\uf8ff')
          .where('status', isEqualTo: "verified")
          .snapshots();

      await for (final providerSnapshot in providerStream) {
        final providerIds = providerSnapshot.docs
            .map((doc) => doc.data()['id'] as String? ?? "")
            .whereType<String>()
            .toList();

        final userStream = _firestore
            .collection('users')
            .where('id',
                whereIn: providerIds.isNotEmpty ? providerIds : ["dummy"])
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList());

        await for (final services in serviceStream) {
          // ignore: unused_local_variable
          await for (final users in userStream) {
            yield SearchParam(providers: [], services: services);
          }
        }
      }
    } catch (e) {
      yield SearchParam(providers: [], services: []);
    }
  }

  @override
  Future<SearchParam> getSearchResult({
    required String input,
    required List<ServiceModel> services,
  }) async {
    try {
      if (input.trim().isEmpty) {
        return SearchParam(providers: [], services: []);
      }

      final lowerInput = input.toLowerCase();

      // ✅ Filter services based on input
      final matchingServices = services
          .where((service) => service.name.toLowerCase().contains(lowerInput))
          .take(7)
          .toList();

      if (matchingServices.isEmpty) {
        return SearchParam(providers: [], services: []);
      }

      // 🔍 Fetch approved service providers
      final providerSnapshot = await FirebaseFirestore.instance
          .collection('service_providers')
          .where('status', isEqualTo: "verified")
          .get();

      final providerDocs = providerSnapshot.docs;
      final providerMap = {for (var doc in providerDocs) doc.data()['id']: doc};

      final providerIds = providerMap.keys.toList();

      if (providerIds.isEmpty) {
        return SearchParam(providers: [], services: matchingServices);
      }

      // 🔍 Fetch users in a single query using `whereIn`
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id',
              whereIn: providerIds.length > 10
                  ? providerIds.sublist(0, 10)
                  : providerIds)
          .get();

      final users = userSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.name.toLowerCase().contains(lowerInput))
          .take(7)
          .toList();

      if (users.isEmpty) {
        return SearchParam(providers: [], services: matchingServices);
      }

      // ✅ Only map valid providers (Avoiding Null Issue)
      final List<FindServiceProviderParams> providers = await Future.wait(
        users
            .where((user) => providerMap.containsKey(user.id))
            .map((user) async {
          final providerDoc = providerMap[user.id]!;
          final serviceProvider =
              ServiceProviderModel.fromJson(providerDoc.data());

          final orders = await _getOrdersForProvider(user.id);
          final feedbacks = await _getFeedbacksForProvider(user.id);

          return FindServiceProviderParams(
            serviceProvider: serviceProvider,
            user: user,
            orders: orders,
            feedbacks: feedbacks,
            distance: null,
          );
        }),
      );

      return SearchParam(
        providers: providers,
        services: matchingServices,
      );
    } catch (e) {
      log("❌ Error in getSearchResult: $e");
      return SearchParam(providers: [], services: []);
    }
  }

  /// 🏷️ Fetches orders for a provider
  Future<List<OrderModel>> _getOrdersForProvider(String providerId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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

  /// 🏷️ Fetches feedbacks for a provider
  Future<List<FeedbackModel>> _getFeedbacksForProvider(
      String providerId) async {
    QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
        .collection('feedbacks')
        .where('category', isEqualTo: providerId)
        .get();

    return feedbackSnapshot.docs
        .map(
            (doc) => FeedbackModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
