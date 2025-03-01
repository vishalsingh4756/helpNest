import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.consumerID,
    required super.providerID,
    required super.serviceID,
    required super.orderTD,
    required super.completionTD,
    required super.consumerLocation,
    required super.providerLocation,
    required super.orderFee,
    required super.estimatedFee,
    required super.trackingPolylinePoints,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
    required super.status, // 1. Order Requested, 2. Estimated Fee Submitted, 3. Order Placed, 4. On the Way, 5. Order Completed, 6. Order Cancelled
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      consumerID: json['consumerID'] ?? '',
      providerID: json['providerID'] ?? '',
      serviceID: json['serviceID'] ?? '',
      orderTD: json['orderTD'] ?? Timestamp.now(),
      completionTD: json['completionTD'] ?? Timestamp.now(),
      consumerLocation:
          UserLocationModel.fromJson(json['consumerLocation'] ?? {}),
      providerLocation:
          UserLocationModel.fromJson(json['providerLocation'] ?? {}),
      orderFee: json['orderFee'] ?? 0,
      estimatedFee: json['estimatedFee'] ?? 0,
      trackingPolylinePoints: json['trackingPolylinePoints'] ?? [],
      creationTD: json['creationTD'] ?? Timestamp.now(),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumerID': consumerID,
      'providerID': providerID,
      'serviceID': serviceID,
      'orderTD': orderTD,
      'completionTD': completionTD,
      'consumerLocation': consumerLocation.toJson(),
      'providerLocation': providerLocation.toJson(),
      'orderFee': orderFee,
      'estimatedFee': estimatedFee,
      'trackingPolylinePoints': trackingPolylinePoints,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, consumerID: $consumerID, providerID: $providerID, serviceID: $serviceID, orderTD: $orderTD, completionTD: $completionTD, consumerLocation: $consumerLocation, providerLocation: $providerLocation, orderFee: $orderFee, estimatedFee: $estimatedFee, trackingPolylinePoints: $trackingPolylinePoints, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate, status: $status)';
  }

  OrderModel copyWith({
    String? id,
    String? consumerID,
    String? providerID,
    String? serviceID,
    Timestamp? orderTD,
    Timestamp? completionTD,
    UserLocationModel? consumerLocation,
    UserLocationModel? providerLocation,
    num? orderFee,
    num? estimatedFee,
    List? trackingPolylinePoints,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      consumerID: consumerID ?? this.consumerID,
      providerID: providerID ?? this.providerID,
      serviceID: serviceID ?? this.serviceID,
      orderTD: orderTD ?? this.orderTD,
      completionTD: completionTD ?? this.completionTD,
      consumerLocation: consumerLocation ?? this.consumerLocation,
      providerLocation: providerLocation ?? this.providerLocation,
      orderFee: orderFee ?? this.orderFee,
      estimatedFee: estimatedFee ?? this.estimatedFee,
      trackingPolylinePoints:
          trackingPolylinePoints ?? this.trackingPolylinePoints,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
      status: status ?? this.status,
    );
  }
}
