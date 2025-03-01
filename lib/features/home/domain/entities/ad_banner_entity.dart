import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AdBannerEntity extends Equatable {
  final String id;
  final List<String> particularID;
  final List<Timestamp> particularDay;
  final Timestamp startTD;
  final Timestamp endTD;
  final List<String> slides;
  final String route;
  final String url;
  final List<GeoPoint> geoPoints;
  final num radius;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const AdBannerEntity({
    required this.id,
    required this.particularID,
    required this.particularDay,
    required this.startTD,
    required this.endTD,
    required this.slides,
    required this.route,
    required this.url,
    required this.geoPoints,
    required this.radius,
    required this.creationTD,
    required this.createdBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [];
}
