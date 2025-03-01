import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/color.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:badges/badges.dart' as badge;
import 'package:iconsax/iconsax.dart';

class ServiceProviderList extends StatefulWidget {
  const ServiceProviderList({super.key});

  @override
  State<ServiceProviderList> createState() => _ServiceProviderListState();
}

class _ServiceProviderListState extends State<ServiceProviderList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCubit, ServiceState>(
      listener: (context, state) {},
      builder: (context, state) {
        final service =
            state.services.where((s) => s.id == state.serviceID).first;
        final providers = state.serviceProviders;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              service.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHorizontalScroll(slides: service.slides),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Text(
                    service.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                _buildSection(
                  title: "Service Provider Near You",
                  itemCount: providers.length,
                  itemBuilder: (context, index) => _buildPersonTile(
                    showDivider: index != (providers.length - 1),
                    provider: providers[index],
                    service: service,
                  ),
                ),
                SizedBox(height: 20.h),
                if (providers.length > 20) ...[
                  _buildSection(
                  title: "Top Plumbers",
                  itemCount: providers.length,
                  itemBuilder: (context, index) => _buildPersonTile(
                    showDivider: index != (providers.length - 1),
                    provider: providers[index],
                    service: service,
                  ),
                ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: itemCount == 0
          ? []
          : [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemBuilder: itemBuilder,
        ),
      ],
    );
  }

  Widget _buildPersonTile(
      {required bool showDivider,
      required FindServiceProviderParams provider,
      required ServiceModel service}) {
    num avgRating = 5.0;
    num avgFee = 0;
    if (provider.feedbacks.isNotEmpty) {
      double totalRating =
          provider.feedbacks.fold(0, (sum, feedback) => sum + feedback.rating);
      avgRating = totalRating / provider.feedbacks.length;
    } 
    if (provider.orders.isNotEmpty) {
      double totalFee =
          provider.orders.fold(0, (sum, order) => sum + order.orderFee);
      avgFee = totalFee / provider.orders.length;
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.providerProfile,
          arguments: {'provider': provider},
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfileImage(provider.user.image),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${service.name}\t\t\t\t\t$avgRating ★"),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\u20b9 ${avgFee == 0 ? "N/A" : avgFee}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    "${provider.distance?.toDouble().toStringAsFixed(2) ?? 0} Km",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h),
          const Text("Last Location",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h),
          Text(
              "${provider.user.location.area}, ${provider.user.location.city}, ${provider.user.location.state}, ${provider.user.location.country} Pin - ${provider.user.location.pincode}"),
          if (showDivider) ...[
            SizedBox(height: 20.h),
            Divider(color: Colors.grey.withOpacity(.3)),
          ],
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return badge.Badge(
      showBadge: true,
      badgeContent:
          Icon(Iconsax.shield_tick5, color: AppColors.green500, size: 20.r),
      badgeStyle: badge.BadgeStyle(
          badgeColor: Colors.white, padding: EdgeInsets.all(.0.w)),
      position: badge.BadgePosition.bottomEnd(bottom: 1.h, end: -5),
      child: ClipOval(
        child: CachedNetworkImage(
          height: 50.h,
          width: 50.h,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  Widget _buildHorizontalScroll({required List slides}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 20.w),
          ...slides.map((url) => _buildPopularItem(url)),
        ],
      ),
    );
  }

  /// Builds an individual popular item.
  Widget _buildPopularItem(String imageUrl) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CachedNetworkImage(
          height: 250.h,
          width: 350.w,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context, url) => SizedBox(
            height: 250.h,
            width: 350.w,
            child: const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            )),
          ),
          errorWidget: (context, url, error) => SizedBox(
            height: 250.h,
            width: 350.w,
            child: Center(child: Icon(Icons.error, size: 50.w)),
          ),
        ),
      ),
    );
  }
}
