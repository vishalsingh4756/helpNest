import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/firebase_options.dart';
import 'package:helpnest/core/config/injection.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/core/config/supabase_config.dart';
import 'package:helpnest/core/config/theme.dart';
import 'package:helpnest/features/auth/presentation/cubit/auth_state.dart';
import 'package:helpnest/features/home/presentation/cubit/home_cubit.dart';
import 'package:helpnest/features/order/presentation/cubit/order_cubit.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:helpnest/features/search/presentation/cubit/search_cubit.dart';
import 'package:helpnest/features/service/presentation/cubit/service_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SupabaseConfig.initializeApp();
  await Injections.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => Injections.get<AuthCubit>()),
        BlocProvider<ProfileCubit>(
            create: (_) => Injections.get<ProfileCubit>()),
        BlocProvider<ServiceCubit>(
            create: (_) => Injections.get<ServiceCubit>()),
        BlocProvider<HomeCubit>(create: (_) => Injections.get<HomeCubit>()),
        BlocProvider<SearchCubit>(create: (_) => Injections.get<SearchCubit>()),
        BlocProvider<OrderCubit>(create: (_) => Injections.get<OrderCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            themeMode: ThemeMode.light,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
