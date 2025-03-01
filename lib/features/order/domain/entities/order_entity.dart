import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';

class OrderEntity {
  final String id;
  final String consumerID;
  final String providerID;
  final String serviceID;
  final Timestamp orderTD;
  final Timestamp completionTD;
  final UserLocationModel consumerLocation;
  final UserLocationModel providerLocation;
  final num orderFee;
  final num estimatedFee;
  final List trackingPolylinePoints;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;
  final String status;

  OrderEntity(
      {required this.id,
      required this.consumerID,
      required this.providerID,
      required this.serviceID,
      required this.orderTD,
      required this.completionTD,
      required this.consumerLocation,
    required this.providerLocation,
      required this.orderFee,
    required this.estimatedFee,
      required this.trackingPolylinePoints,
      required this.creationTD,
      required this.createdBy,
    required this.deactivate,
    required this.status,
  });
}
