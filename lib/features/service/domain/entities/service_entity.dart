import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceEntity {
  final String id;
  final String name;
  final String logo;
  final String description;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;
  final num avgCharge;
  final String avgTime;
  final List slides;

  ServiceEntity(
      {required this.id,
      required this.name,
      required this.logo,
      required this.description,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate,
      required this.avgCharge,
      required this.avgTime,
      required this.slides});
}
