import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpnest/features/auth/presentation/pages/onboarding_page.dart';
import 'package:helpnest/features/home/presentation/pages/home_controller.dart';
import 'package:helpnest/features/order/presentation/pages/past_order.dart';
import 'package:helpnest/features/profile/presentation/pages/about_page.dart';
import 'package:helpnest/features/profile/presentation/pages/become_provider_page.dart';
import 'package:helpnest/features/profile/presentation/pages/become_provider_status_page.dart';
import 'package:helpnest/features/profile/presentation/pages/edit_pro_page.dart';
import 'package:helpnest/features/profile/presentation/pages/privacy_policy.dart';
import 'package:helpnest/features/profile/presentation/pages/profile_main_page.dart';
import 'package:helpnest/features/profile/presentation/pages/report_safety_emergency_page.dart';
import 'package:helpnest/features/profile/presentation/pages/send_feedback_page.dart';
import 'package:helpnest/features/profile/presentation/pages/support_page.dart';
import 'package:helpnest/features/profile/presentation/pages/terms_condition.dart';
import 'package:helpnest/features/search/presentation/pages/provider_profile.dart';
import 'package:helpnest/features/service/presentation/pages/service_provider_list.dart';

class AppRoutes {
  static const String core = '/';
  static const String onboardingPage = '/onboardingPage';
  static const String home = '/home';

  // auth
  static const String aboutPage = '/aboutPage';
  static const String becomeProviderPage = '/becomeProviderPage';
  static const String becomeProviderStatusPage = '/becomeProviderStatusPage';
  static const String editProPage = '/editProPage';
  static const String privacyPolicy = '/privacyPolicy';
  static const String profileMainPage = '/profileMainPage';
  static const String sendFeedbackPage = '/sendFeedbackPage';
  static const String supportPage = '/supportPage';
  static const String termsCondition = '/termsCondition';
  static const String reportSafetyEmergencyPage = '/reportSafetyEmergencyPage';

  // service
  static const String serviceProviderListPage = '/serviceProviderListPage';

  // search
  static const String providerProfile = '/providerProfile';

  // order
  static const String pastOrder = '/pastOrder';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case core:
        if (FirebaseAuth.instance.currentUser != null) {
          return MaterialPageRoute(builder: (_) => const HomeController());
        } else {
          return MaterialPageRoute(builder: (_) => const OnboardingPage());
        }
      case home:
        return MaterialPageRoute(builder: (_) => const HomeController());
      case onboardingPage:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      // auth
      case aboutPage:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case becomeProviderPage:
        return MaterialPageRoute(builder: (_) => const BecomeProviderPage());
      case becomeProviderStatusPage:
        return MaterialPageRoute(
            builder: (_) => const BecomeProviderStatusPage());
      case editProPage:
        return MaterialPageRoute(builder: (_) => const EditProPage());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicy());
      case profileMainPage:
        return MaterialPageRoute(builder: (_) => const ProfileMainPage());
      case sendFeedbackPage:
        return MaterialPageRoute(builder: (_) => const SendFeedbackPage());
      case supportPage:
        return MaterialPageRoute(builder: (_) => const SupportPage());
      case termsCondition:
        return MaterialPageRoute(builder: (_) => const TermsCondition());
      case reportSafetyEmergencyPage:
        return MaterialPageRoute(
            builder: (_) => const ReportSafetyEmergencyPage());
        
      // service
      case serviceProviderListPage:
        return MaterialPageRoute(builder: (_) => const ServiceProviderList());
        
      // search
      case providerProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (_) => ProviderProfile(
                  provider: args?['provider'],
                ));

      // order
      case pastOrder:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (_) => PastOrder(
                  provider: args?['provider'],
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
        );
    }
  }

  static Future<void> navigateTo(
      BuildContext context, String routeName, Object? arguments) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<void> replaceWith(BuildContext context, String routeName) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}
