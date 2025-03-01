import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';

abstract class ServiceRemoteRepo {
  Future<List<ServiceModel>> getServices();
  Future<List<FindServiceProviderParams>> findServiceProvider(
      {required String serviceID, required Position? position});
  Future<void> addOrder({required OrderModel order});
}

class FindServiceProviderParams {
  final ServiceProviderModel serviceProvider;
  final UserModel user;
  final List<OrderModel> orders;
  final List<FeedbackModel> feedbacks;
  final double? distance;

  FindServiceProviderParams({
    required this.serviceProvider,
    required this.user,
    required this.orders,
    required this.feedbacks,
    this.distance,
  });

  FindServiceProviderParams copyWith({
    ServiceProviderModel? serviceProvider,
    UserModel? user,
    List<OrderModel>? orders,
    List<FeedbackModel>? feedbacks,
    double? distance,
  }) {
    return FindServiceProviderParams(
      serviceProvider: serviceProvider ?? this.serviceProvider,
      user: user ?? this.user,
      orders: orders ?? List.from(this.orders),
      feedbacks: feedbacks ?? List.from(this.feedbacks),
      distance: distance ?? this.distance,
    );
  }
}

