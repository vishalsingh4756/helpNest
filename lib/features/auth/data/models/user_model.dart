import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.location,
    required super.image,
    required super.gender,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      location: UserLocationModel.fromJson(json['location'] ?? {}),
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      creationTD: json['creationTD'] ?? Timestamp.now(),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'image': image,
      'gender': gender,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  @override
String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, location: $location, image: $image, gender: $gender, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate)';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserLocationModel? location,
    String? image,
    String? gender,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

}

class UserLocationModel extends UserLocationEntity {
  UserLocationModel({
    required super.city,
    required super.area,
    required super.pincode,
    required super.locality,
    required super.state,
    required super.country,
    required super.continent,
    required super.geopoint,
    required super.updateTD,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      pincode: json['pincode'] ?? '',
      locality: json['locality'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      continent: json['continent'] ?? '',
      geopoint: json['geopoint'] ?? const GeoPoint(0, 0),
      updateTD: json['updateTD'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'area': area,
      'pincode': pincode,
      'locality': locality,
      'state': state,
      'country': country,
      'continent': continent,
      'geopoint': geopoint,
      'updateTD': updateTD,
    };
  }

  @override
  String toString() {
    return 'UserLocationModel(city: $city, area: $area, pincode: $pincode, locality: $locality, state: $state, country: $country, continent: $continent, geopoint: $geopoint, updateTD: $updateTD)';
  }

  UserLocationModel copyWith({
    String? city,
    String? area,
    String? pincode,
    String? locality,
    String? state,
    String? country,
    String? continent,
    GeoPoint? geopoint,
    Timestamp? updateTD,
  }) {
    return UserLocationModel(
      city: city ?? this.city,
      area: area ?? this.area,
      pincode: pincode ?? this.pincode,
      locality: locality ?? this.locality,
      state: state ?? this.state,
      country: country ?? this.country,
      continent: continent ?? this.continent,
      geopoint: geopoint ?? this.geopoint,
      updateTD: updateTD ?? this.updateTD,
    );
  }
}
