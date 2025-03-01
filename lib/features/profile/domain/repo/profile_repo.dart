import 'dart:io';

import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/profile/data/models/emergency_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';

abstract class ProfileRepo {
  Future<void> requestServiceProviderAccess(
      {required ServiceProviderModel provider,
      required File? aadhar,
      required File? pan,
      required File? experience});
  Stream<UserModel> getUser();
  Stream<List<ServiceProviderModel>> getProvider();
  Stream<List<FeedbackModel>> getAppFeedback();
  Stream<List<EmergencyModel>> getEmergency();
  Future<void> addFeedback({required FeedbackModel feedback});
  Future<void> reportSafetyEmergency({required EmergencyModel emergency});
  Future<void> updateUser({required UserModel user, required File? image});
  Future<void> updateProvider({required ServiceProviderModel provider});
  Future<void> logOut();
}
