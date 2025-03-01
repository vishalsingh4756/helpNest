// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/order/presentation/cubit/order_cubit.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackPage extends StatefulWidget {
  final String orderID;
  const TrackPage({super.key, required this.orderID});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  MapController _mapController = MapController();
  bool _appBarExpanded = false;
  bool _bottomBarExpanded = false;
  List<LatLng> routeCoordinates = [];
  bool routeLoading = true;
  String? lastFetchedRoute;
  TextEditingController _orderFee = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRouteData();
  }

  Future<void> _fetchRouteData() async {
    final state = context.read<OrderCubit>().state;
    final orderData =
        state.orders.firstWhere((order) => order.order.id == widget.orderID);

    final newRoute = await fetchRoute(
      consumerLatLng: LatLng(
        orderData.order.consumerLocation.geopoint.latitude,
        orderData.order.consumerLocation.geopoint.longitude,
      ),
      providerLatLng: LatLng(
        orderData.user.location.geopoint.latitude,
        orderData.user.location.geopoint.longitude,
      ),
    );

    if (mounted) {
      setState(() {
        routeCoordinates = newRoute;
        routeLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listenWhen: (previous, current) => previous.orders != current.orders,
      listener: (context, state) async {
        final orderData = state.orders
            .firstWhere((order) => order.order.id == widget.orderID);

        final newRoute = await fetchRoute(
          consumerLatLng: LatLng(
            orderData.order.consumerLocation.geopoint.latitude,
            orderData.order.consumerLocation.geopoint.longitude,
          ),
          providerLatLng: LatLng(
            orderData.user.location.geopoint.latitude,
            orderData.user.location.geopoint.longitude,
          ),
        );

        setState(() {
          routeCoordinates = newRoute;
          routeLoading = false;
        });
      },
      builder: (context, state) {
        final orderData = state.orders
            .firstWhere((order) => order.order.id == widget.orderID);
        final order = orderData.order;
        final provider = orderData.user;
        final service = context
            .read<ServiceCubit>()
            .state
            .services
            .firstWhere((service) => service.id == order.serviceID);
        final me = orderData.consumer;
        log("LOADING");

        return Scaffold(
          floatingActionButton: _bottomBar(
              context: context,
              provider: provider,
              service: service,
              order: order),
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Stack(
            children: [
              _map(order, provider, me),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _appBar(
                      context: context,
                      provider: provider,
                      service: service,
                      consumer: me,
                      order: order))
            ],
          ),
        );
      },
    );
  }

  FlutterMap _map(OrderModel order, UserModel provider, UserModel me) {
    final LatLng consumerLatLng = LatLng(
        order.consumerLocation.geopoint.latitude,
        order.consumerLocation.geopoint.longitude);

    final LatLng providerLatLng = LatLng(provider.location.geopoint.latitude,
        provider.location.geopoint.longitude);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([consumerLatLng, providerLatLng]),
          padding: EdgeInsets.all(50.r),
        ),
      ),
      children: [
        TileLayer(
          // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          urlTemplate:
              "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=4796c8bcd90d4d4aa12b29a5d7bbcf17",
          // urlTemplate:
          //     "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
          // urlTemplate:
          //     "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          userAgentPackageName: "com.example.helpnest",
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routeCoordinates,
              color: Colors.black.withOpacity(1),
              strokeWidth: 3.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            _marker(consumerLatLng, me),
            _marker(providerLatLng, provider),
          ],
        ),
      ],
    );
  }

  _appBar(
      {required BuildContext context,
      required UserModel provider,
      required ServiceModel service,
      required UserModel consumer,
      required OrderModel order}) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: _appBarExpanded ? 20.w : 10.h,
            top: 10.h),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildProfileImages(
                          providerImage: provider.id ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? consumer.image
                              : provider.image,
                          serviceImage: service.logo),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.id ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? consumer.name
                                : provider.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            provider.id ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? "Consumer"
                                : "${service.name} Service",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildIconButton(
                    icon: _appBarExpanded
                        ? Iconsax.arrow_up_2
                        : Iconsax.arrow_down_1,
                    onPressed: () =>
                        setState(() => _appBarExpanded = !_appBarExpanded)),
              ],
            ),
            if (_appBarExpanded) ...[
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r))),
                      onPressed: () async => call(
                          context: context,
                          phoneNumber: order.providerID ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? consumer.phoneNumber
                              : provider.phoneNumber),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call, color: Colors.white, size: 20.r),
                          SizedBox(width: 10.w),
                          Text(
                            "Call",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.red,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r))),
                      // onPressed: () => context
                      //     .read<OrderCubit>()
                      //     .updateOrder(
                      //         order: order.copyWith(status: "Order Cancelled"))
                      //     // ignore: use_build_context_synchronously
                      //     .whenComplete(() => Navigator.pop(context)),
                      onPressed: () async {
                        commonDialog(
                          context: context,
                          title: "Confirm Order Cancellation",
                          description:
                              "Are you sure you want to cancel the order?",
                          cancelText: "Go Back",
                          cancelOnTap: () => Navigator.pop(context),
                          agreeText: "Cancel Order",
                          agreeOnTap: () {
                            Navigator.pop(context);
                            context
                                .read<OrderCubit>()
                                .updateOrder(
                                    order: order.copyWith(
                                        status: "Order Cancelled"))
                                // ignore: use_build_context_synchronously
                                .whenComplete(() => Navigator.pop(context));
                          },
                          icon: Iconsax.briefcase,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.white, size: 20.r),
                          SizedBox(width: 10.w),
                          Text(
                            "Cancel Order",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (order.providerID ==
                  FirebaseAuth.instance.currentUser?.uid) ...[
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        labelText: "Order Fee",
                        controller: _orderFee,
                        underlineBorderedTextField: false,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r))),
                        onPressed: () async {
                          if (_orderFee.text.isEmpty) {
                            showSnack(
                                context: context,
                                text:
                                    "Please enter order fee before completing the order");
                          } else {
                            commonDialog(
                              context: context,
                              title: "Confirm Order Completion",
                              description:
                                  "Are you sure you want to complete the order?",
                              cancelText: "Cancel",
                              cancelOnTap: () => Navigator.pop(context),
                              agreeText: "Complete Order",
                              agreeOnTap: () {
                                Navigator.pop(context);
                                context
                                    .read<OrderCubit>()
                                    .updateOrder(
                                        order: order.copyWith(
                                            orderFee:
                                                num.tryParse(_orderFee.text),
                                            status: "Order Completed"))
                                    // ignore: use_build_context_synchronously
                                    .whenComplete(() => Navigator.pop(context));
                              },
                              icon: Iconsax.tick_circle,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Complete Order",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  _bottomBar(
      {required BuildContext context,
      required UserModel provider,
      required ServiceModel service,
      required OrderModel order}) {
    num distance = 0;
    if (routeLoading == false) {
      distance = calculateDistance(points: routeCoordinates);
    }

    final isProvider =
        order.providerID == FirebaseAuth.instance.currentUser?.uid;
    return GestureDetector(
      onTap: () => setState(() => _bottomBarExpanded = !_bottomBarExpanded),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: isProvider && order.status != "On the Way"
                      ? () => context.read<OrderCubit>().updateOrder(
                          order: order.copyWith(status: "On the Way"))
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            isProvider ? Theme.of(context).primaryColor : null,
                        border: Border.all(color: Colors.grey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(30.r)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isProvider ? Iconsax.gps : Icons.circle,
                            color: isProvider ? Colors.white : Colors.green,
                            size: 14.r),
                        SizedBox(width: 10.w),
                        Text(
                          order.status != "On the Way"
                              ? isProvider
                                  ? "Tap to start Tracking"
                                  : "Provider will reach you soon"
                              : isProvider
                                  ? "Actively Tracking"
                                  : "On the way to your location",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isProvider ? Colors.white : null),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                    routeLoading
                        ? "Loading"
                        : "${distance.toStringAsFixed(1)} KM",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15.h),
            TimelineTile(
              axis: TimelineAxis.vertical,
              alignment: TimelineAlign.start,
              isFirst: true,
              indicatorStyle: IndicatorStyle(width: 15.r),
              afterLineStyle:
                  LineStyle(thickness: 1, color: Colors.grey.withOpacity(.3)),
              endChild: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Provider Location",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "${provider.location.area}, ${provider.location.city}, ${provider.location.state}, ${provider.location.country} Pin - ${provider.location.pincode}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            if (_bottomBarExpanded) ...[
              SizedBox(height: 20.h),
              TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.start,
                isLast: true,
                indicatorStyle: IndicatorStyle(width: 15.r),
                beforeLineStyle:
                    LineStyle(thickness: 1, color: Colors.grey.withOpacity(.3)),
                endChild: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Order Location",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "${order.consumerLocation.area}, ${order.consumerLocation.city}, ${order.consumerLocation.state}, ${order.consumerLocation.country} Pin - ${order.consumerLocation.pincode}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImages(
      {required String providerImage, required String serviceImage}) {
    return Center(
      child: SizedBox(
        width: 90.w,
        height: 60.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildCircularImage(imageUrl: serviceImage, padded: true),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildCircularImage(imageUrl: providerImage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularImage({required String imageUrl, bool padded = false}) {
    return Container(
      alignment: Alignment.center,
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 10),
        ],
        border: Border.all(color: Colors.white, width: 4.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: EdgeInsets.all(padded ? 5.r : 0),
          child: CachedNetworkImage(
            height: 50.h,
            width: 50.h,
            fit: BoxFit.cover,
            errorWidget: (c, u, e) {
              return const Icon(Iconsax.gallery);
            },
            imageUrl: imageUrl,
          ),
        ),
      ),
    );
  }

  _marker(LatLng consumerLocation, UserModel provider) {
    return Marker(
      point: consumerLocation,
      width: 70.r,
      height: 70.r,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20.r,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(Iconsax.location5, color: Colors.white, size: 70.r),
            Positioned(
              top: 5.r,
              child: Container(
                height: 50.h,
                width: 50.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(4.w),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(provider.image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildIconButton(
      {required IconData icon, required void Function() onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        shape: CircleBorder(
          side: BorderSide(color: Colors.grey.withOpacity(.3)),
        ),
      ),
    );
  }
}
