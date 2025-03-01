import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/color.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/profile/data/models/emergency_model.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:iconsax/iconsax.dart';

class ReportSafetyEmergencyPage extends StatefulWidget {
  const ReportSafetyEmergencyPage({super.key});

  @override
  State<ReportSafetyEmergencyPage> createState() =>
      _ReportSafetyEmergencyPageState();
}

class _ReportSafetyEmergencyPageState extends State<ReportSafetyEmergencyPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        log(state.emergency.length.toString());
        final EmergencyModel? activeEmergency =
            state.emergency.isNotEmpty ? state.emergency.first : null;
        return Scaffold(
          appBar: _appBar(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: _submitButton(context, state),
          body: Column(
            children: [
              _reportBox(
                  context: context, emergency: activeEmergency, state: state),
              if (activeEmergency != null) ...[
                _callNowBox(context: context, emergency: activeEmergency),
              ],
            ],
          ),
        );
      },
    );
  }

  

  Container _reportBox(
      {required BuildContext context,
      required EmergencyModel? emergency,
      required ProfileState state}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.flag, color: Colors.white, size: 17.r),
              SizedBox(width: 5.w),
              Expanded(
                  child: Text(
                "Emergency Needed",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
              ))
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            "Report a Safety Emergency",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20.h),
          LinearProgressIndicator(
            backgroundColor: Colors.white,
            value: emergency == null
                ? 0
                : emergency.status == "Emergency Reported"
                    ? 25 / 100
                    : emergency.status == "Reviewing Emergency"
                        ? 50 / 100
                        : emergency.status == "Admin Responded"
                            ? 75 / 100
                            : 100 / 100,
            color: AppColors.red300,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emergency == null
                    ? "0%"
                    : emergency.status == "Emergency Reported"
                        ? "25%"
                        : emergency.status == "Reviewing Emergency"
                            ? "50%"
                            : emergency.status == "Admin Responded"
                                ? "75%"
                                : "100%",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Text(
                emergency == null
                    ? "Report Emergency"
                    : emergency.status == "Emergency Reported"
                        ? "Wait for the response"
                        : emergency.status == "Reviewing Emergency"
                            ? "Under Review"
                            : emergency.status == "Admin Responded"
                                ? "Check for Response"
                                : "Resolved",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "If you witness a safety emergency, report it immediately to the relevant authorities or emergency services. Providing timely and accurate details can help ensure a swift response and protect those involved.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
              onPressed: () {
                if (emergency != null) {
                } else {
                  final td = Timestamp.now();
                  context
                      .read<ProfileCubit>()
                      .reportSafetyEmergency(EmergencyModel(
                        id: td.millisecondsSinceEpoch.toString(),
                        emergencyTD: td,
                        location: UserLocationModel(
                            city: "city",
                            area: "area",
                            pincode: "pincode",
                            locality: "locality",
                            state: "state",
                            country: "country",
                            continent: "continent",
                            geopoint: const GeoPoint(0, 0),
                            updateTD: Timestamp.now()),
                        reportedBy:
                            FirebaseAuth.instance.currentUser?.uid ?? "",
                        adminResponse: "",
                        phoneNumber: "",
                        status: "Emergency Reported",
                      ));
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (emergency != null) ...[
                    Icon(
                        emergency.status == "Reviewing Emergency"
                            ? Iconsax.health
                            : emergency.status == "Admin Responded"
                                ? Iconsax.message
                                : Iconsax.gps,
                        color: Colors.red,
                        size: 20.sp),
                    SizedBox(width: 20.w),
                  ],
                  Text(
                    emergency == null ? "Report Emergency" : emergency.status,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  if (state.reportSafetyEmergencyStatus ==
                      StateStatus.loading) ...[
                    SizedBox(width: 30.w),
                    SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  ],
                ],
              ))
        ],
      ),
    );
  }

  Container _callNowBox(
      {required BuildContext context, required EmergencyModel emergency}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              emergency.adminResponse.isNotEmpty
                  ? "Admin Response"
                  : "Emergency Report Status",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h),
          Text(
            emergency.adminResponse.isNotEmpty
                ? emergency.adminResponse
                : "Your request has been received. Our emergency team is reaching out to you. Please keep your phone on and stay attentive to incoming calls.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
              onPressed: () async =>
                  call(context: context, phoneNumber: emergency.phoneNumber),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.call, color: Colors.white),
                  SizedBox(width: 20.w),
                  Text(
                    "Call Now",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  // ignore: unused_element
  Padding _submitButton(BuildContext context, ProfileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Resolve",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (state.reportSafetyEmergencyStatus == StateStatus.loading) ...[
              SizedBox(width: 30.w),
              SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            ],
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Report a Safety Emergency",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
