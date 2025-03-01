import 'package:get_it/get_it.dart';
import 'package:helpnest/features/auth/data/data_source/auth_remote_ds.dart';
import 'package:helpnest/features/auth/domain/repo/auth_repo.dart';
import 'package:helpnest/features/auth/presentation/cubit/auth_state.dart';
import 'package:helpnest/features/home/data/data_source/ad_banner_remote_ds.dart';
import 'package:helpnest/features/home/data/data_source/home_remote_ds.dart';
import 'package:helpnest/features/home/domain/repo/ad_banner_repo.dart';
import 'package:helpnest/features/home/domain/repo/home_remote_repo.dart';
import 'package:helpnest/features/home/presentation/cubit/home_cubit.dart';
import 'package:helpnest/features/order/data/data_source/order_remote_ds.dart';
import 'package:helpnest/features/order/domain/repo/order_repo.dart';
import 'package:helpnest/features/order/presentation/cubit/order_cubit.dart';
import 'package:helpnest/features/profile/data/data_source/profile_remote_ds.dart';
import 'package:helpnest/features/profile/domain/repo/profile_repo.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:helpnest/features/search/data/data_source/search_local_ds.dart';
import 'package:helpnest/features/search/data/data_source/search_remote_ds.dart';
import 'package:helpnest/features/search/domain/repo/search_local_repo.dart';
import 'package:helpnest/features/search/domain/repo/search_remote_repo.dart';
import 'package:helpnest/features/search/presentation/cubit/search_cubit.dart';
import 'package:helpnest/features/service/data/data_source/service_remote_ds.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';

class Injections {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {
    // auth
    _getIt.registerFactory<AuthRepo>(() => AuthRemoteDs());
    _getIt.registerFactory<AuthCubit>(() => AuthCubit(repo: _getIt()));

    // profile
    _getIt.registerFactory<ProfileRepo>(() => ProfileRemoteDs());
    _getIt.registerFactory<ProfileCubit>(() => ProfileCubit(repo: _getIt()));

    // service
    _getIt.registerFactory<ServiceRemoteRepo>(() => ServiceRemoteDs());
    _getIt.registerFactory<ServiceCubit>(
        () => ServiceCubit(remoteRepo: _getIt()));

    // home
    _getIt.registerFactory<AdBannerRepo>(() => AdBannerRemoteDs());
    _getIt.registerFactory<HomeRemoteRepo>(() => HomeRemoteDs());
    _getIt.registerFactory<HomeCubit>(
        () => HomeCubit(adBannerRepo: _getIt(), homeRemoteRepo: _getIt()));

    // search
    _getIt.registerFactory<SearchLocalRepo>(() => SearchLocalDs());
    _getIt.registerFactory<SearchRemoteRepo>(() => SearchRemoteDs());
    _getIt.registerFactory<SearchCubit>(
        () => SearchCubit(localRepo: _getIt(), remoteRepo: _getIt()));

    // order
    _getIt.registerFactory<OrderRepo>(() => OrderRemoteDs());
    _getIt.registerFactory<OrderCubit>(
        () => OrderCubit(orderRemoteRepo: _getIt()));
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
