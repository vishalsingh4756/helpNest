import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';

abstract class OrderRepo {
  Stream<List<GetOrderParam>> streamOrders();
  Future<void> addOrder({required OrderModel order});
  Future<void> updateOrder({required OrderModel order});
}

class GetOrderParam {
  final ServiceProviderModel provider;
  final UserModel user;
  final UserModel consumer;
  final OrderModel order;
  final List<FeedbackModel> feedback;

  GetOrderParam(
      {required this.provider,
      required this.user,
      required this.consumer,
      required this.order,
      required this.feedback});
}
