// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/color.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/features/home/presentation/cubit/home_cubit.dart';
import 'package:helpnest/features/search/presentation/cubit/search_cubit.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ignore: prefer_final_fields
  TextEditingController _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        final keywords = state.keywords;
        final providers = state.providers;
        final services = state.services;
        final servicesFromServiceCubit =
            context.read<ServiceCubit>().state.services.toList();

        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(
                    context: context,
                    state: state,
                    services: servicesFromServiceCubit),
                if (keywords.isEmpty &&
                    providers.isEmpty &&
                    services.isEmpty) ...[
                  _buildEmpty(),
                ],
                if (keywords.isNotEmpty &&
                    state.getSearchResultStatus != StateStatus.loading) ...[
                  _buildSection(
                    title: "History",
                    itemCount: keywords.take(4).toList().length,
                    itemBuilder: (context, index) => _buildKeywordTile(
                        bottomSpace: index != 4,
                        input: keywords.take(4).toList()[index],
                        services: servicesFromServiceCubit),
                  ),
                ],
                if (providers.isNotEmpty) ...[
                  _buildSection(
                    title: "People",
                    itemCount: providers.length,
                    itemBuilder: (context, index) => _buildPersonTile(
                        provider: providers[index],
                        services: servicesFromServiceCubit,
                        verified: true),
                  ),
                ],
                if (services.isNotEmpty) ...[
                  _buildSection(
                    title: "Services",
                    itemCount: services.length,
                    itemBuilder: (context, index) =>
                        _buildServiceTile(service: services[index]),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            "Search",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5.w),
          AnimatedTextKit(
            animatedTexts: [
              _buildAnimatedText("Services"),
              _buildAnimatedText("Service Provider"),
              _buildAnimatedText("Price"),
            ],
            repeatForever: true,
          ),
        ],
      ),
    );
  }

  FadeAnimatedText _buildAnimatedText(String text) {
    return FadeAnimatedText(
      text,
      textStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.bold),
      duration: const Duration(seconds: 3),
    );
  }

  Widget _buildSearchBar(
      {required BuildContext context,
      required SearchState state,
      required List<ServiceModel> services}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: _search,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w500),
        onChanged: (query) => context
            .read<SearchCubit>()
            .getSearchResult(input: query, services: services),
        maxLines: null,
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.search_normal_1),
          filled: true,
          suffixIcon: state.getSearchResultStatus == StateStatus.loading
              ? Container(
                  height: 5.h,
                  width: 5.h,
                  padding: EdgeInsets.all(10.w),
                  child: CircularProgressIndicator(
                      strokeWidth: 2.r, color: Colors.grey))
              : null,
          hintText: "Search for anything",
          fillColor: Colors.grey.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
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
      {required FindServiceProviderParams provider,
      required List<ServiceModel> services,
      bool verified = false}) {
    final service = services.firstWhere(
        (service) => service.id == provider.serviceProvider.serviceID);
    return InkWell(
      onTap: () {
        context.read<SearchCubit>().addSearchKeyword(input: _search.text);
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
              _buildProfileImage(provider.user.image, false,
                  verified: verified),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(service.name),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildKeywordTile(
      {bool bottomSpace = true,
      required String input,
      required List<ServiceModel> services}) {
    return InkWell(
      onTap: () {
        // setState(() => _search.text = input);
        _search.text = input;
        context
            .read<SearchCubit>()
            .getSearchResult(input: input, services: services);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.clock),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  input,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () => context
                      .read<SearchCubit>()
                      .deleteSearchKeyword(input: input),
                  icon: const Icon(CupertinoIcons.multiply)),
              SizedBox(width: 0.w),
            ],
          ),
          if (bottomSpace) SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _buildServiceTile({required ServiceModel service}) {
    return InkWell(
      onTap: () async {
        if (mounted) {
          context.read<SearchCubit>().addSearchKeyword(input: _search.text);
          await context
              .read<ServiceCubit>()
              .updateServiceID(serviceID: service.id);
          await context.read<ServiceCubit>().findServiceProviders(
              serviceID: service.id,
              position: context.read<HomeCubit>().state.position);
          Navigator.pushNamed(context, AppRoutes.serviceProviderListPage);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfileImage(service.logo, true),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("1000+ service provided"),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl, bool givePadding,
      {bool verified = false}) {
    return badge.Badge(
      showBadge: verified,
      badgeContent:
          Icon(Iconsax.shield_tick5, color: AppColors.green500, size: 20.r),
      badgeStyle: badge.BadgeStyle(
          badgeColor: Colors.white, padding: EdgeInsets.all(.0.w)),
      position: badge.BadgePosition.bottomEnd(bottom: 1.h, end: -5),
      child: ClipOval(
        child: Container(
          height: 50.h,
          width: 50.h,
          padding: givePadding ? EdgeInsets.all(7.w) : null,
          child: CachedNetworkImage(
            height: 50.h,
            width: 50.h,
            fit: BoxFit.cover,
            imageUrl: imageUrl,
          ),
        ),
      ),
    );
  }

  _buildEmpty() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 200.h),
          CachedNetworkImage(
            height: 50.h,
            width: 50.h,
            fit: BoxFit.cover,
            imageUrl: "https://cdn-icons-png.flaticon.com/128/7486/7486760.png",
          ),
          SizedBox(height: 30.h),
          const Text("It's quite in here...",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          const Text(
            "You can explore our services, our trustworthy and professional service providers to get the best user experience.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
