import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final UserLocationModel location;
  final String image;
  final String gender;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.location,
      required this.image,
      required this.gender,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
}

class UserLocationEntity {
  final String city;
  final String area;
  final String pincode;
  final String locality;
  final String state;
  final String country;
  final String continent;
  final GeoPoint geopoint;
  final Timestamp updateTD;

  UserLocationEntity(
      {required this.city,
      required this.area,
      required this.pincode,
      required this.locality,
      required this.state,
      required this.country,
      required this.continent,
    required this.geopoint,
    required this.updateTD,
  });
}
