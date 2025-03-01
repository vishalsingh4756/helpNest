import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';

class AdminDs {
  Future<void> addService(
      {required ServiceModel service,
      required File logo,
      required File slide1,
      required File slide2}) async {
    try {
      final logoUrl = await uploadFileAndGetUrl(
        bucket: "admin",
        file: logo,
        path: "services/${service.id}/logo.jpg",
      );
      final slide1Url = await uploadFileAndGetUrl(
        bucket: "admin",
        file: slide1,
        path: "services/${service.id}/slide1.jpg",
      );
      final slide2Url = await uploadFileAndGetUrl(
        bucket: "admin",
        file: slide2,
        path: "services/${service.id}/slide2.jpg",
      );

      await FirebaseFirestore.instance
          .collection("services")
          .doc(service.id)
          .set(service.copyWith(
            logo: logoUrl ?? "",
            slides: [slide1Url ?? "", slide2Url ?? ""],
          ).toJson());
    } catch (e) {
      log("ADD_SERVICE_ERROR: $e");
    }
  }
}
