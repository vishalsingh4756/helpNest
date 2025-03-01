import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/profile/data/models/emergency_model.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/profile/domain/repo/profile_repo.dart';

class ProfileRemoteDs implements ProfileRepo {
  final firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFeedback({required FeedbackModel feedback}) async {
    try {
      await firestore
          .collection('feedbacks')
          .doc(feedback.id)
          .set(feedback.toJson());
    } catch (e) {
      throw Exception('Error adding feedback: $e');
    }
  }

  @override
  Stream<List<FeedbackModel>> getAppFeedback() {
    try {
      return firestore
          .collection('feedbacks')
          .where("module", isNotEqualTo: "SERVICE PROVIDER")
          .where("createdBy",
              isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FeedbackModel.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Error fetching feedback: $e');
    }
  }

  @override
  Stream<List<ServiceProviderModel>> getProvider() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        return Stream.value([]);
      }

      return firestore
          .collection('service_providers')
          .doc(userId)
          .snapshots()
          .map((doc) {
        if (!doc.exists || doc.data() == null) {
          return [];
        }
        return [ServiceProviderModel.fromJson(doc.data()!)];
      });
    } catch (e) {
      return Stream.value([]);
    }
  }


  @override
  Stream<UserModel> getUser() {
    try {
      return firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
          .snapshots()
          .map((doc) => UserModel.fromJson(doc.data()!));
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  Stream<List<EmergencyModel>> getEmergency() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        return Stream.value([]);
      }

      return firestore
          .collection('emergencies')
          .where("status", isNotEqualTo: "Resolved")
          .where("reportedBy", isEqualTo: userId)
          .orderBy("emergencyTD", descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty
              ? [EmergencyModel.fromJson(snapshot.docs.first.data())]
              : []);
    } catch (e) {
      return Stream.value([]);
    }
  }


  @override
  Future<void> reportSafetyEmergency(
      {required EmergencyModel emergency}) async {
    try {
      await firestore
          .collection('emergencies')
          .doc(emergency.id)
          .set(emergency.toJson());
    } catch (e) {
      throw Exception('Error reporting emergency: $e');
    }
  }

  @override
  Future<void> requestServiceProviderAccess({
    required ServiceProviderModel provider,
    required File? aadhar,
    required File? pan,
    required File? experience,
  }) async {
    try {
      String? aadharUrl;
      String? panUrl;
      String? experienceUrl;
      if (aadhar != null) {
        aadharUrl = await uploadFileAndGetUrl(
          file: aadhar,
          path: "${FirebaseAuth.instance.currentUser?.uid}/profile/aadhar.jpg",
        );
      }
      if (pan != null) {
        panUrl = await uploadFileAndGetUrl(
          file: pan,
          path: "${FirebaseAuth.instance.currentUser?.uid}/profile/pan.jpg",
        );
      }
      if (experience != null) {
        experienceUrl = await uploadFileAndGetUrl(
          file: experience,
          path:
              "${FirebaseAuth.instance.currentUser?.uid}/profile/experience.jpg",
        );
      }
      await firestore
          .collection('service_providers')
          .doc(provider.id)
          .set(provider
              .copyWith(
                aadharCardImageURL: aadharUrl ?? "",
                panCardImageURL: panUrl ?? "",
                experienceDocImageURL: experienceUrl ?? "",
              )
              .toJson(),
          SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error requesting provider access: $e');
    }
  }

  @override
  Future<void> updateProvider({required ServiceProviderModel provider}) async {
    try {
      await firestore
          .collection('service_providers')
          .doc(provider.id)
          .update(provider.toJson());
    } catch (e) {
      throw Exception('Error updating provider: $e');
    }
  }

  @override
  Future<void> updateUser(
      {required UserModel user, required File? image}) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadFileAndGetUrl(
          file: image,
          path: "${FirebaseAuth.instance.currentUser?.uid}/profile/image.jpg",
        );
      } else {
        imageUrl = user.image;
      }
      await firestore
          .collection('users')
          .doc(user.id)
          .update(user.copyWith(image: imageUrl).toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw Exception("Couldn't log out: $e");
    }
  }
}
