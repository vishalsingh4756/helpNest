import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderEntity {
  final String id;
  final String aadharCardImageURL;
  final String panCardImageURL;
  final String status;
  final Timestamp approvedTD;
  final String approvedBy;
  final String serviceID;
  final String experienceDocImageURL;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  ServiceProviderEntity(
      {required this.id,
      required this.aadharCardImageURL,
      required this.panCardImageURL,
      required this.status,
      required this.approvedTD,
      required this.approvedBy,
      required this.serviceID,
      required this.experienceDocImageURL,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
}
