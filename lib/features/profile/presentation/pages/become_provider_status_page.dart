import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:iconsax/iconsax.dart';

class BecomeProviderStatusPage extends StatelessWidget {
  const BecomeProviderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.error != const CommonError()) {
          log(state.error.consoleMessage);
        } else if (state.requestServiceProviderAccessStatus ==
            StateStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingPage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Service Provider Stats",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.becomeProviderPage),
                  icon: Icon(
                    Iconsax.edit,
                    size: 20.r,
                  )),
              SizedBox(width: 10.w),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Aadhar Card",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) {},
                    image: null,
                    onCancel: () {},
                    readOnly: true,
                    imageUrl: state.provider.first.aadharCardImageURL,
                  ),
                  SizedBox(height: 20.h),
                  Text("PAN Card",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) {},
                    image: null,
                    onCancel: () {},
                    readOnly: true,
                    imageUrl: state.provider.first.panCardImageURL,
                  ),
                  SizedBox(height: 20.h),
                  Text("Experience Certificate",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  CustomImageUploader(
                    onSelected: (File file) {},
                    image: null,
                    onCancel: () {},
                    readOnly: true,
                    imageUrl: state.provider.first.experienceDocImageURL,
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
}
