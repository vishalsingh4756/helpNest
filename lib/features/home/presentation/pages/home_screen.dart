// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/home/presentation/cubit/home_cubit.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHorizontalScroll(),
            SizedBox(height: 20.h),
            _buildSectionTitle(context, "Services"),
            _buildServiceGrid(),
            SizedBox(height: 10.h),
            // _buildSectionTitle(context, "Popular"),
            // _buildHorizontalScroll(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  /// Builds the custom app bar.
  _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(65.h),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: AppBar(
              automaticallyImplyLeading: false,
              // leading: _buildIconButton(icon: Iconsax.menu_1, onPressed: () {}),
              title: Text(
                "helpNest",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              actions: [
                _buildIconButton(
                    icon: Iconsax.location,
                    onPressed: () => _handleLocation(
                        location: state.lastLocation.isNotEmpty
                            ? state.lastLocation.first
                            : null),
                    activeIcon: Iconsax.location5,
                    activeWidget: state.locationEnabled
                        ? Text(
                            state.lastLocation.isNotEmpty
                                ? state.lastLocation.first.city
                                : "India",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                          )
                        : null),
                // _buildIconButton(icon: Iconsax.notification, onPressed: () {}),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleLocation({UserLocationModel? location}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isDismissible: false,
        builder: (_) => LocationBottomSheet(context: context));
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Widget? activeWidget,
    IconData? activeIcon,
  }) {
    if (activeWidget != null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
            side: BorderSide(color: Colors.grey.withOpacity(.3)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(activeIcon ?? icon,
                color: Theme.of(context).primaryColor, size: 18.r),
            SizedBox(width: 10.w),
            Flexible(child: activeWidget),
            SizedBox(width: 10.w),
            Icon(Iconsax.arrow_down_1,
                size: 18.r, color: Theme.of(context).iconTheme.color),
          ],
        ),
      );
    }
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(color: Colors.grey.withOpacity(.3)),
        ),
      ),
    );
  }

  /// Builds the main header image.
  // ignore: unused_element
  Widget _buildHeaderImage() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.adBanners.isEmpty) {
          return SizedBox(height: 250.h);
        }
        final randomService = (state.adBanners..shuffle()).first;
        return CachedNetworkImage(
          height: 250.h,
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: randomService.slides[0],
          placeholder: (context, url) => SizedBox(
            height: 250.h,
            child: const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            )),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 50.w),
        );
      },
    );
  }

  /// Builds the grid of services.
  Widget _buildServiceGrid() {
    return BlocConsumer<ServiceCubit, ServiceState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0.h),
          itemCount: state.services.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final service = state.services[index];
            return _buildServiceItem(
                title: service.name,
                imageUrl: service.logo,
                onPressed: () async {
                  await context
                      .read<ServiceCubit>()
                      .updateServiceID(serviceID: service.id);
                  await context.read<ServiceCubit>().findServiceProviders(
                      serviceID: service.id,
                      position: context.read<HomeCubit>().state.position);
                  Navigator.pushNamed(
                      context, AppRoutes.serviceProviderListPage);
                });
          },
        );
      },
    );
  }

  /// Builds an individual service item for the grid.
  Widget _buildServiceItem(
      {required String title,
      required String imageUrl,
      required void Function() onPressed}) {
    return IconButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          overlayColor: Colors.grey.withOpacity(.1)),
      icon: Column(
        children: [
          Container(
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: Colors.white,
            //   boxShadow: [
            //     BoxShadow(
            //         color: Colors.grey.withOpacity(0.2),
            //         spreadRadius: 1,
            //         blurRadius: 2,
            //         offset: const Offset(0, 3)),
            //   ],
            // ),
            padding: EdgeInsets.all(15.w),
            child: CachedNetworkImage(
              height: 35.h,
              width: 35.h,
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
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, size: 40.w),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the title for a section.
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.only(bottom: 10.h),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Builds the horizontal scroll view for popular items.
  Widget _buildHorizontalScroll() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final banners = state.adBanners;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 20.w),
              ...banners.expand((banner) => banner.slides
                  .map((slide) => _buildPopularItem(image: slide))),
              SizedBox(width: 20.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularItem({required String image}) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          children: [
            CachedNetworkImage(
              height: 250.h,
              width: 350.w,
              fit: BoxFit.cover,
              imageUrl: image,
              placeholder: (context, url) => SizedBox(
                height: 250.h,
                width: 350.w,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, size: 50.w),
            ),
            // // Black fade effect
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     height: 80.h,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Colors.transparent,
            //           Colors.black.withOpacity(1),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       SizedBox(width: 15.w),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "${service.name} Service",
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodyLarge!
            //                   .copyWith(
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.white),
            //             ),
            //             Text(
            //               "Around 10,345 order was placed last week",
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodySmall!
            //                   .copyWith(
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.white),
            //             ),
            //             SizedBox(height: 15.w)
            //           ],
            //         ),
            //       ),
            //       SizedBox(width: 15.w)
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final UserLocationModel? location =
            state.lastLocation.isNotEmpty ? state.lastLocation.first : null;
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey.withOpacity(.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: location != null
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              _header(context),
              Divider(color: Colors.grey.withOpacity(.2), height: 30.h),
              if (location != null) ...[
                SizedBox(height: 10.h),
                CustomImageUploader(
                    // imageUrl: "https://api.mapbox"
                    //     ".com/styles/v1/mapbox/streets-v11/static/pin-l+006600(${location.geopoint.longitude},"
                    //     "${location.geopoint.latitude})"
                    //     "/auto/800x800?padding=120&access_token=pk.eyJ1Ijoic2F1cmFiaC10ZWNoMjYwMyIsImEiOiJjbDk4b2FwemQwcTU4M3BtdjYzNHNkc3d1In0.K3wmWSc7atSi-EqkGtKbwg",
                    imageUrl: mapImage(points: [location.geopoint]),
                    readOnly: true,
                    onSelected: (image) {},
                    onCancel: () {}),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "updated: ${DateFormat("dd MMM, hh:mm a").format(location.updateTD.toDate())}",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                    "${location.area}, ${location.city}, ${location.state}, ${location.country} Pin - ${location.pincode}"),
              ] else ...[
                SizedBox(height: 20.h),
                Image.network(
                    "https://cdn-icons-gif.flaticon.com/15591/15591402.gif",
                    height: 100.h),
                SizedBox(height: 20.h),
                Text(
                    state.getLocationStatus == StateStatus.loading
                        ? "Getting your location"
                        : "Turn on your location",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Text(
                    state.getLocationStatus == StateStatus.loading
                        ? "Fetching your location... Please wait while we determine your current position."
                        : "Enable location services to get accurate recommendations and a seamless experience based on your current location.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Row _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.location5, size: 20.r),
            SizedBox(width: 10.w),
            const Text(
              "Your Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.multiply, size: 20.r))
      ],
    );
  }
}
