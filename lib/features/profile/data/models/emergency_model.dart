import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/profile/domain/entities/emergency_entity.dart';

class EmergencyModel extends EmergencyEntity {
  EmergencyModel({
    required super.id,
    required super.emergencyTD,
    required super.location,
    required super.reportedBy,
    required super.adminResponse,
    required super.phoneNumber,
    required super.status,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }
    return EmergencyModel(
      id: json['id'] ?? '',
      emergencyTD: json['emergencyTD'] ?? Timestamp.now(),
      location: UserLocationModel.fromJson(json['location'] ?? {}),
      reportedBy: json['reportedBy'] ?? '',
      adminResponse: json['adminResponse'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emergencyTD': emergencyTD,
      'location': location.toJson(),
      'reportedBy': reportedBy,
      'adminResponse': adminResponse,
      'phoneNumber': phoneNumber,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'EmergencyModel(id: $id, emergencyTD: $emergencyTD, location: $location, reportedBy: $reportedBy, adminResponse: $adminResponse, phoneNumber: $phoneNumber, status: $status)';
  }

  EmergencyModel copyWith({
    String? id,
    Timestamp? emergencyTD,
    UserLocationModel? location,
    String? reportedBy,
    String? adminResponse,
    String? phoneNumber, // phone number of admin which is now active for call
    String? status,
  }) {
    return EmergencyModel(
      id: id ?? this.id,
      emergencyTD: emergencyTD ?? this.emergencyTD,
      location: location ?? this.location,
      reportedBy: reportedBy ?? this.reportedBy,
      adminResponse: adminResponse ?? this.adminResponse,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}
