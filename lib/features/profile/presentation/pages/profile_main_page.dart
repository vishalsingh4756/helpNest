// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/color.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/features/home/presentation/cubit/home_cubit.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({super.key});

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.error != const CommonError()) {
          log(state.error.consoleMessage);
        } else if (state.logOutStatus == StateStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingPage);
        }
        if (state.getUserStatus == StateStatus.success) {}
      },
      builder: (context, state) {
        context
            .read<HomeCubit>()
            .updateProviderMode(providerMode: state.provider.isNotEmpty);
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileSection(context, state),
                SizedBox(height: 30.h),
                _buildListTile(
                  icon: Iconsax.frame_1,
                  title: "Your Profile",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProPage),
                ),
                _buildListTile(
                  icon: Iconsax.briefcase,
                  title: "Become a Service Provider",
                  onTap: () => Navigator.pushNamed(
                      context,
                      state.provider.isNotEmpty
                          ? AppRoutes.becomeProviderStatusPage
                          : AppRoutes.becomeProviderPage),
                ),
                _buildListTile(
                  icon: Iconsax.info_circle,
                  title: "Report a Safety Emergency",
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.reportSafetyEmergencyPage),
                ),
                _buildListTile(
                  icon: Iconsax.support,
                  title: "Support",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.supportPage),
                ),
                _buildListTile(
                  icon: Iconsax.edit_2,
                  title: "Send Feedback",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.sendFeedbackPage),
                ),
                _buildListTile(
                  icon: Iconsax.more_circle,
                  title: "About",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.aboutPage),
                ),
                _buildListTile(
                  icon: Iconsax.shield_tick,
                  title: "Privacy Policy",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                ),
                _buildListTile(
                  icon: Iconsax.receipt_1,
                  title: "Terms and Conditions",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.termsCondition),
                ),
                _buildListTile(
                  icon: Iconsax.unlock,
                  title: state.logOutStatus == StateStatus.loading
                      ? "Logging out"
                      : "Log out",
                  onTap: () async {
                    commonDialog(
                      context: context,
                      title: "Confirm Logout",
                      description: "Are you sure you want to log out?",
                      cancelText: "Cancel",
                      cancelOnTap: () => Navigator.pop(context),
                      agreeText: "Log Out",
                      agreeOnTap: () {
                        Navigator.pop(context);
                        context.read<ProfileCubit>().logOut();
                      },
                      icon: Iconsax.lock_1,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: AppBar(
          title: Text(
            "My Profile",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          actions: const [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Iconsax.menu_1),
            //   style: ElevatedButton.styleFrom(
            //       shape: CircleBorder(
            //           side: BorderSide(color: Colors.grey.withOpacity(.3)))),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImages(
      {required String? providerImage,
      required String? serviceLogo,
      required ProfileState state}) {
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 150.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildCircularImage(
                padded: true,
                imageUrl: serviceLogo ??
                    "https://cdn.dribbble.com/userupload/16281153/file/original-b6ff14bfc931d716c801ea7e250965ce.png?resize=1600x1200&vertical=center",
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildCircularImage(
                verified: state.provider.isNotEmpty
                    ? state.provider.first.status == "verified"
                    : null,
                imageUrl: providerImage ??
                    "https://cdn.dribbble.com/userupload/16366138/file/original-c35bbf68ba08abeb0509f09de77dd62b.jpg?resize=1600x1200&vertical=center",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularImage(
      {required String imageUrl, bool padded = false, bool? verified}) {
    return badge.Badge(
      showBadge: verified != null,
      badgeContent: Icon(
          verified != null && verified ? Iconsax.shield_tick5 : Iconsax.clock,
          color: verified != null && verified
              ? AppColors.green500
              : Colors.grey.withOpacity(.8),
          size: 30.r),
      badgeStyle: badge.BadgeStyle(
          badgeColor: Colors.white, padding: EdgeInsets.all(3.w)),
      position: badge.BadgePosition.bottomEnd(bottom: 3.h, end: 2.w),
      child: Container(
        alignment: Alignment.center,
        height: 125.h,
        width: 125.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 10),
          ],
          border: Border.all(color: Colors.white, width: 7.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(padded ? 20.r : 0),
            child: CachedNetworkImage(
              height: 125.h,
              width: 125.h,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) {
                log("CACHED_IMAGE_ERROR: $e");
                return const Icon(Iconsax.gallery);
              },
              imageUrl: imageUrl,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, ProfileState state) {
    return Column(
      children: [
        if (state.provider.isNotEmpty) ...[
          _buildProfileImages(
              providerImage: state.user.first.image,
              serviceLogo: context
                  .read<ServiceCubit>()
                  .state
                  .services
                  .where((e) => e.id == state.provider.first.serviceID)
                  .first
                  .logo,
              state: state)
        ] else ...[
          SizedBox(
            height: 135.h,
            child: Center(
              child: _buildCircularImage(
                  imageUrl: state.user.isNotEmpty
                      ? state.user.first.image
                      : "helpNest User"),
            ),
          ),
        ],
        SizedBox(height: 5.h),
        Text(
          state.user.isNotEmpty ? state.user.first.name : "helpNest User",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        if (state.provider.isNotEmpty) ...[
          Text(
            state.provider.isNotEmpty
                ? context
                    .read<ServiceCubit>()
                    .state
                    .services
                    .where((e) => e.id == state.provider.first.serviceID)
                    .first
                    .name
                : "Provider",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24.w),
                SizedBox(width: 20.w),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Iconsax.arrow_right_3, size: 24.w),
          ],
        ),
      ),
    );
  }
}
