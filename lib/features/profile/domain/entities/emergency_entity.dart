import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';

class EmergencyEntity {
  final String id;
  final Timestamp emergencyTD;
  final UserLocationModel location;
  final String reportedBy;
  final String adminResponse;
  final String phoneNumber;
  final String status;

  EmergencyEntity({
    required this.id,
    required this.emergencyTD,
    required this.location,
    required this.reportedBy,
    required this.adminResponse,
    required this.phoneNumber,
    required this.status,
  });
}
