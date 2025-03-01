import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/features/home/data/models/ad_banner_model.dart';
import 'package:helpnest/features/home/domain/repo/ad_banner_repo.dart';

class AdBannerRemoteDs implements AdBannerRepo {
  @override
  Future<List<AdBannerModel>> getAdBanner({required Position? position}) async {
    try {
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final querySnapshot =
          await FirebaseFirestore.instance.collection('ad_banner').get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      List<AdBannerModel> adBanners = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return AdBannerModel.fromJson({...data, 'id': doc.id});
      }).where((banner) {
        final bool hasValidParticularID = _validateParticularID(
          particularID: banner.particularID,
          currentUserId: currentUserId,
        );

        final bool hasValidParticularDay = _validateParticularDay(
          particularDay: banner.particularDay,
          startTD: banner.startTD,
          endTD: banner.endTD,
        );

        final bool isWithinTimeRange =
            _isWithinTimeRange(startTD: banner.startTD, endTD: banner.endTD);

        final bool isWithinLocation = position == null ||
            _validateGeoPoints(
              geoPoints: banner.geoPoints,
              userLat: position.latitude,
              userLng: position.longitude,
              radius: banner.radius,
            );

        return hasValidParticularID &&
            hasValidParticularDay &&
            isWithinTimeRange &&
            isWithinLocation;
      }).toList();

      return adBanners;
    } catch (error) {
      throw Exception('Error fetching ad_banners: $error');
    }
  }


  bool _validateParticularID({
    required List<String> particularID,
    required String? currentUserId,
  }) {
    if (particularID.isEmpty) {
      return true; 
    }
    return currentUserId != null && particularID.contains(currentUserId);
  }

  bool _validateParticularDay({
    required List<Timestamp> particularDay,
    required Timestamp startTD,
    required Timestamp endTD,
  }) {
    final DateTime now = DateTime.now();
    if (particularDay.isEmpty) {
      return now.isAfter(startTD.toDate()) && now.isBefore(endTD.toDate());
    }
    return particularDay.any((day) {
      final DateTime particularDate = day.toDate();
      return now.year == particularDate.year &&
          now.month == particularDate.month &&
          now.day == particularDate.day;
    });
  }

  bool _isWithinTimeRange({
    required Timestamp startTD,
    required Timestamp endTD,
  }) {
    final DateTime now = DateTime.now();
    return now.isAfter(startTD.toDate()) && now.isBefore(endTD.toDate());
  }

  bool _validateGeoPoints({
    required List<GeoPoint> geoPoints,
    required double userLat,
    required double userLng,
    required num radius,
  }) {
    if (geoPoints.isEmpty) {
      return true; // Show to all if geoPoints are empty.
    }
    return geoPoints.any((geoPoint) {
      return _isWithinRadius(
        userLat: userLat,
        userLng: userLng,
        bannerLat: geoPoint.latitude,
        bannerLng: geoPoint.longitude,
        radius: radius,
      );
    });
  }

  bool _isWithinRadius({
    required double userLat,
    required double userLng,
    required double bannerLat,
    required double bannerLng,
    required num radius,
  }) {
    const double earthRadiusKm = 6371.0;

    double degToRad(double deg) => deg * (pi / 180);
    double dLat = degToRad(bannerLat - userLat);
    double dLng = degToRad(bannerLng - userLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(userLat)) *
            cos(degToRad(bannerLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadiusKm * c;
    return distance <= (radius / 1000.0);
  }
}
