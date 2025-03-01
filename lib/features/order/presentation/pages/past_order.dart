import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/color.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/order/presentation/cubit/order_cubit.dart';
import 'package:helpnest/features/profile/data/models/feedback_model.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;
import 'package:intl/intl.dart';

class PastOrder extends StatefulWidget {
  final FindServiceProviderParams provider;
  const PastOrder({super.key, required this.provider});

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  // ignore: prefer_final_fields
  TextEditingController _feedback = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {},
      builder: (context, state) {
        final providerData = widget.provider.user;
        final service = context.read<ServiceCubit>().state.services.firstWhere(
            (e) => e.id == widget.provider.serviceProvider.serviceID);
        return Scaffold(
          floatingActionButton: _addFeedbackButton(context),
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: Text(
              providerData.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section
                _buildProfileImages(
                    providerImage: widget.provider.user.image,
                    serviceImage: service.logo),
                SizedBox(height: 10.h),
                Text(providerData.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(service.name),
                SizedBox(height: 20.h),
                // Location Details
                _buildLocationInfo(
                  icon: Iconsax.location,
                  title: "Service Provider Past Location",
                  description:
                      "${widget.provider.orders.first.providerLocation.area}, ${widget.provider.orders.first.providerLocation.city}, ${widget.provider.orders.first.providerLocation.state}, ${widget.provider.orders.first.providerLocation.country} Pin - ${widget.provider.orders.first.providerLocation.pincode}",
                ),
                _buildLocationInfo(
                  icon: Iconsax.location,
                  title: "Order Location",
                  description:
                      "${widget.provider.orders.first.consumerLocation.area}, ${widget.provider.orders.first.consumerLocation.city}, ${widget.provider.orders.first.consumerLocation.state}, ${widget.provider.orders.first.consumerLocation.country} Pin - ${widget.provider.orders.first.consumerLocation.pincode}",
                ),

                SizedBox(height: 10.h),

                // Service Fee and Distance Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        icon: Iconsax.location_tick,
                        title: "Distance",
                        value:
                            "${widget.provider.distance?.toStringAsFixed(1) ?? 0} KM",
                      ),
                      SizedBox(width: 20.w),
                      _buildInfoCard(
                        icon: Iconsax.wallet_2,
                        title: "Service Fee",
                        value:
                            "₹ ${widget.provider.orders.isNotEmpty ? widget.provider.orders.first.orderFee : "N/A"}",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add Review",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextFormField(
                    labelText: "Enter Feedback",
                    underlineBorderedTextField: true,
                    controller: _feedback,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an option";
                      }
                      return null;
                    },
                  ),
                ),

                if (widget.provider.feedbacks.isNotEmpty) ...[
                  SizedBox(height: 40.h),
                  // Review Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Your Review",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  _buildReviewsSection(
                      context: context, feedbacks: widget.provider.feedbacks)
                ],

                SizedBox(height: 200.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsSection(
      {required BuildContext context, required List<FeedbackModel> feedbacks}) {
    if (feedbacks.isNotEmpty) {
      feedbacks.sort((a, b) => b.creationTD.compareTo(a.creationTD));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feedbacks.isNotEmpty ? "Reviews - ${feedbacks.length}+" : ""),
          SizedBox(height: 20.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              return _buildReviewCard(
                  context: context, feedback: feedbacks[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
      {required BuildContext context, required FeedbackModel feedback}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  feedback.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 30.w),
              Text(DateFormat("MMM dd").format(feedback.creationTD.toDate())),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: List.generate(
                feedback.rating.toInt(),
                (index) => _buildStarIcon(
                    true, Iconsax.star_15, Theme.of(context).primaryColor)),
          ),
          SizedBox(height: 10.h),
          Text(
            feedback.description,
          ),
        ],
      ),
    );
  }

  Widget _buildStarIcon(bool small, IconData icon, Color? color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
      child: Icon(
        icon,
        size: small ? 15.h : null,
        color: color,
      ),
    );
  }

  Widget _buildProfileImages(
      {required String providerImage, required String serviceImage}) {
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 150.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildCircularImage(imageUrl: serviceImage, padded: true),
            ),
            Align(
              alignment: Alignment.centerRight,
              child:
                  _buildCircularImage(imageUrl: providerImage, verified: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularImage(
      {required String imageUrl, bool padded = false, bool verified = false}) {
    return badge.Badge(
      showBadge: verified,
      badgeContent:
          Icon(Iconsax.shield_tick5, color: AppColors.green500, size: 30.r),
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
                return const Icon(Iconsax.gallery);
              },
              imageUrl: imageUrl,
            ),
          ),
        ),
      ),
    );
  }

  // Location Details Section
  Widget _buildLocationInfo({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18.h),
                SizedBox(width: 5.w),
                Text(title),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Information Card
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                SizedBox(width: 10.w),
                Text(title),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addFeedbackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(330.r, 55.r),
            ),
            onPressed: state.addFeedbackStatus == StateStatus.loading
                ? () {}
                : () async {
                    if (_feedback.text.isEmpty) {
                      showSnack(
                          context: context,
                          text: "Feedback field can't be empty");
                    } else {
                      final td = Timestamp.now();
                      context.read<ProfileCubit>().addFeedback(FeedbackModel(
                            id: td.millisecondsSinceEpoch.toString(),
                            rating: 0,
                            module: "ORDER",
                            category: widget.provider.user.id,
                            title: FirebaseAuth.instance.currentUser?.uid ?? "",
                            description: _feedback.text,
                            response: "",
                            responseTD: td,
                            creationTD: td,
                            createdBy:
                                FirebaseAuth.instance.currentUser?.uid ?? "",
                            deactivate: false,
                          ));
                      _feedback.text = "";
                      Navigator.pop(context);
                    }
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Submit Feedback",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                if (state.addFeedbackStatus == StateStatus.loading) ...[
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
          );
        },
      ),
    );
  }
}
