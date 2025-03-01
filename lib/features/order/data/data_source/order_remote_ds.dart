import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/order/domain/repo/order_repo.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';

class OrderRemoteDs implements OrderRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser?.uid ?? "";

  @override
  Future<void> addOrder({required OrderModel order}) async {
    try {
      final String id = Timestamp.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(id)
          .set(order.copyWith(id: id).toJson());
    } catch (e) {
      log("ORDER_REMOTE_DS_ADD_ORDER_ERROR: $e");
    }
  }

  @override
  Future<void> updateOrder({required OrderModel order}) async {
    try {
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(order.id)
          .set(order.toJson(), SetOptions(merge: true));
    } catch (e) {
      log("ORDER_REMOTE_DS_UPDATE_ORDER_ERROR: $e");
    }
  }

  @override
  Stream<List<GetOrderParam>> streamOrders() {
    if (userId.isEmpty) return Stream.value([]);

    final consumerOrdersStream = firestore
        .collection("orders")
        .where("consumerID", isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => OrderModel.fromJson(doc.data()))
            .toList());

    final providerOrdersStream = firestore
        .collection("orders")
        .where("providerID", isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => OrderModel.fromJson(doc.data()))
            .toList());

    return Rx.combineLatest2<List<OrderModel>, List<OrderModel>,
            List<OrderModel>>(consumerOrdersStream, providerOrdersStream,
        (consumerOrders, providerOrders) {
      return [...consumerOrders, ...providerOrders];
    }).switchMap((orders) {
      if (orders.isEmpty) return Stream.value(<GetOrderParam>[]);

      final providerStreams = orders.map((order) => firestore
          .collection("service_providers")
          .doc(order.providerID)
          .snapshots()
          .map((doc) =>
              doc.exists ? ServiceProviderModel.fromJson(doc.data()!) : null)
          .onErrorReturn(null));

      final userStreams = orders.map((order) => firestore
          .collection("users")
          .doc(order.providerID)
          .snapshots()
          .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null)
          .onErrorReturn(null));

      final consumerStreams = orders.map((order) => firestore
          .collection("users")
          .doc(order.consumerID)
          .snapshots()
          .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null)
          .onErrorReturn(null));

      final feedbackStreams = orders.map((order) => firestore
          .collection("feedbacks")
          .where("category", isEqualTo: order.providerID)
          .where("title", isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FeedbackModel.fromJson(doc.data()))
              .toList())
          .onErrorReturn([]));

      return Rx.combineLatest4<List<ServiceProviderModel>, List<UserModel>,
              List<UserModel>, List<List<FeedbackModel>>, List<GetOrderParam>>(
          Rx.combineLatestList(providerStreams).map((list) =>
              list.map((e) => e ?? ServiceProviderModel.fromJson({})).toList()),
          Rx.combineLatestList(userStreams).map(
              (list) => list.map((e) => e ?? UserModel.fromJson({})).toList()),
          Rx.combineLatestList(consumerStreams).map(
              (list) => list.map((e) => e ?? UserModel.fromJson({})).toList()),
          Rx.combineLatestList(feedbackStreams),
          (List<ServiceProviderModel> providers, List<UserModel> users,
              List<UserModel> consumers, List<List<FeedbackModel>> feedbacks) {
        return List.generate(orders.length, (index) {
          return GetOrderParam(
            provider: providers[index],
            user: users[index],
            consumer: consumers[index],
            order: orders[index],
            feedback: feedbacks[index],
          );
        });
      });
    }).handleError((e) {
      log("ORDER_REMOTE_DS_GET_ORDERS_ERROR: $e");
    });
  }
}
