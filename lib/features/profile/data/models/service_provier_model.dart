import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/profile/domain/entities/service_provider_entity.dart';

class ServiceProviderModel extends ServiceProviderEntity {
  ServiceProviderModel({
    required super.id,
    required super.aadharCardImageURL,
    required super.panCardImageURL,
    required super.status,
    required super.approvedTD,
    required super.approvedBy,
    required super.serviceID,
    required super.experienceDocImageURL,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'] ?? '',
      aadharCardImageURL: json['aadharCardImageURL'] ?? '',
      panCardImageURL: json['panCardImageURL'] ?? '',
      status: json['status'] ?? '',
      approvedTD: json['approvedTD'] ?? '',
      approvedBy: json['approvedBy'] ?? '',
      serviceID: json['serviceID'] ?? "",
      experienceDocImageURL: json['experienceDocImageURL'] ?? '',
      creationTD: json['creationTD'] ?? Timestamp.now(),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aadharCardImageURL': aadharCardImageURL,
      'panCardImageURL': panCardImageURL,
      'status': status,
      'approvedTD': approvedTD,
      'approvedBy': approvedBy,
      'serviceID': serviceID,
      'experienceDocImageURL': experienceDocImageURL,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  @override
  String toString() {
    return 'ServiceProviderModel(id: $id, aadharCardImageURL: $aadharCardImageURL, status: $status, approvedTD: $approvedTD, approvedBy: $approvedBy, serviceID: $serviceID, experienceDocImageURL: $experienceDocImageURL, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate)';
  }

  ServiceProviderModel copyWith({
    String? id,
    String? aadharCardImageURL,
    String? panCardImageURL,
    String? status,
    Timestamp? approvedTD,
    String? approvedBy,
    String? serviceID,
    String? experienceDocImageURL,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      aadharCardImageURL: aadharCardImageURL ?? this.aadharCardImageURL,
      panCardImageURL: panCardImageURL ?? this.panCardImageURL,
      status: status ?? this.status,
      approvedTD: approvedTD ?? this.approvedTD,
      approvedBy: approvedBy ?? this.approvedBy,
      serviceID: serviceID ?? this.serviceID,
      experienceDocImageURL:
          experienceDocImageURL ?? this.experienceDocImageURL,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }
}
