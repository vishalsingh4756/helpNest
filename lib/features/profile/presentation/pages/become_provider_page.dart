import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/profile/data/models/service_provier_model.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';

class BecomeProviderPage extends StatefulWidget {
  const BecomeProviderPage({super.key});

  @override
  State<BecomeProviderPage> createState() => _BecomeProviderPageState();
}

class _BecomeProviderPageState extends State<BecomeProviderPage> {
  TextEditingController serviceController = TextEditingController();
  String selectedServiceID = "";
  File? _aadhar;
  File? _pan;
  File? _experience;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.error != const CommonError()) {
          log(state.error.consoleMessage);
        } else if (state.requestServiceProviderAccessStatus ==
            StateStatus.success) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.becomeProviderStatusPage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Become a Service Provider",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(330.r, 55.r),
              ),
              onPressed: state.requestServiceProviderAccessStatus ==
                      StateStatus.loading
                  ? () {}
                  : () {
                      if (serviceController.text.isNotEmpty &&
                          _aadhar != null &&
                          _pan != null &&
                          _experience != null) {
                        context
                            .read<ProfileCubit>()
                            .requestServiceProviderAccess(
                                ServiceProviderModel(
                                    id: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "",
                                    aadharCardImageURL: "",
                                    panCardImageURL: "",
                                    status: "submitted",
                                    approvedTD: Timestamp.now(),
                                    approvedBy: "",
                                    serviceID: selectedServiceID,
                                    experienceDocImageURL: "",
                                    creationTD: Timestamp.now(),
                                    createdBy: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "",
                                    deactivate: false),
                                _aadhar,
                                _pan,
                                _experience);
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Request Verification",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  if (state.requestServiceProviderAccessStatus ==
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
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    labelText: "Select Service",
                    controller: serviceController,
                    keyboardType: TextInputType.text,
                    suffixIcon: Iconsax.arrow_down_1,
                    onTap: () async {
                      await _onServiceTap(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text("Aadhar Card",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) => setState(() => _aadhar = file),
                    image: _aadhar,
                    onCancel: () => setState(() => _aadhar = null),
                  ),
                  SizedBox(height: 20.h),
                  Text("PAN Card",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) => setState(() => _pan = file),
                    image: _pan,
                    onCancel: () => setState(() => _pan = null),
                  ),
                  SizedBox(height: 20.h),
                  Text("Experience Certificate",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) =>
                        setState(() => _experience = file),
                    image: _experience,
                    onCancel: () => setState(() => _experience = null),
                  ),
                  SizedBox(height: 200.h)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onServiceTap(BuildContext context) async {
    final serviceID = await showModalBottomSheet<String>(
      useSafeArea: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 600.h),
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, serviceState) {
            if (serviceState.services.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "No services available.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Service",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: serviceState.services.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final service = serviceState.services[index];
                        return _buildPersonTile(
                          imageUrl: service.logo,
                          title: service.name,
                          subtitle: service.description,
                          averageCharge: service.avgCharge,
                          averageTime: service.avgTime,
                          onTap: () {
                            Navigator.pop(context, service.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Update selectedServiceID and the controller's text
    if (serviceID != null) {
      setState(() {
        selectedServiceID = serviceID;
        serviceController.text = context
            .read<ServiceCubit>()
            .state
            .services
            .firstWhere((service) => service.id == selectedServiceID)
            .name;
      });
    }
  }

  Widget _buildPersonTile(
      {required String imageUrl,
      required String title,
      required String subtitle,
      required num averageCharge,
      required String averageTime,
      required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfileImage(imageUrl),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$title Service",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
              // SizedBox(width: 15.w),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Text(
              //       "\u20b9 $averageCharge",
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Theme.of(context).primaryColor),
              //     ),
              //     Text(
              //       "$averageTime hrs",
              //       style: const TextStyle(
              //           fontWeight: FontWeight.bold, color: Colors.grey),
              //     ),
              //   ],
              // )
            ],
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3)),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: CachedNetworkImage(
        height: 25.h,
        width: 25.h,
        fit: BoxFit.contain,
        imageUrl: imageUrl,
        placeholder: (context, url) => SizedBox(
          height: 40.h,
          width: 40.h,
          child: const Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          )),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error, size: 40.w),
      ),
    );
  }
}
