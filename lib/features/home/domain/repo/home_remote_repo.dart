import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';

abstract class HomeRemoteRepo {
  Future<UserLocationModel?> getLocationFromDatabase();
  Future<void> updateLocationToDatabase({required UserLocationModel location});
  Stream<String> getOrderIdToUpdatePoints();
  Future<void> updatePoints({required String orderID, required GeoPoint point});
}
