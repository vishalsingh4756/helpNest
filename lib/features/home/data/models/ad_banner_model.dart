import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/home/domain/entities/ad_banner_entity.dart';

class AdBannerModel extends AdBannerEntity {
  const AdBannerModel({
    required super.id,
    required super.particularID,
    required super.particularDay,
    required super.startTD,
    required super.endTD,
    required super.slides,
    required super.route,
    required super.url,
    required super.geoPoints,
    required super.radius,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  /// Converts a Firestore document to an AdBannerModel.
  factory AdBannerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AdBannerModel(
        id: '',
        particularID: const [],
        particularDay: const [],
        startTD: Timestamp.now(),
        endTD: Timestamp.now(),
        slides: const [],
        route: '',
        url: '',
        geoPoints: const [],
        radius: 0,
        creationTD: Timestamp.now(),
        createdBy: '',
        deactivate: false,
      );
    }

    return AdBannerModel(
      id: json['id'] ?? '',
      particularID: List<String>.from(json['particularID'] ?? []),
      particularDay: (json['particularDay'] as List<dynamic>?)
              ?.map((e) => e as Timestamp)
              .toList() ??
          [],
      startTD: json['startTD'] ?? Timestamp.now(),
      endTD: json['endTD'] ?? Timestamp.now(),
      slides: List<String>.from(json['slides'] ?? []),
      route: json['route'] ?? '',
      url: json['url'] ?? '',
      geoPoints: (json['geoPoints'] as List<dynamic>?)
              ?.map((e) => e as GeoPoint)
              .toList() ??
          [],
      radius: json['radius'] ?? 0,
      creationTD: json['creationTD'] ?? Timestamp.now(),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }

  /// Converts AdBannerModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'particularID': particularID,
      'particularDay': particularDay,
      'startTD': startTD,
      'endTD': endTD,
      'slides': slides,
      'route': route,
      'url': url,
      'geoPoints': geoPoints,
      'radius': radius,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  /// Creates a copy of the AdBannerModel with updated fields.
  AdBannerModel copyWith({
    String? id,
    List<String>? particularID,
    List<Timestamp>? particularDay,
    Timestamp? startTD,
    Timestamp? endTD,
    List<String>? slides,
    String? route,
    String? url,
    List<GeoPoint>? geoPoints,
    num? radius,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return AdBannerModel(
      id: id ?? this.id,
      particularID: particularID ?? this.particularID,
      particularDay: particularDay ?? this.particularDay,
      startTD: startTD ?? this.startTD,
      endTD: endTD ?? this.endTD,
      slides: slides ?? this.slides,
      route: route ?? this.route,
      url: url ?? this.url,
      geoPoints: geoPoints ?? this.geoPoints,
      radius: radius ?? this.radius,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  @override
  String toString() {
    return 'AdBannerModel(id: $id, particularID: $particularID, particularDay: $particularDay, startTD: $startTD, endTD: $endTD, slides: $slides, route: $route, url: $url, geoPoints: $geoPoints, radius: $radius, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate)';
  }
}
