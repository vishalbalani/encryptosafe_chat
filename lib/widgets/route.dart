import 'package:encryptosafe/main.dart';
import 'package:encryptosafe/pages/auth/login_page.dart';
import 'package:encryptosafe/pages/auth/otp_page.dart';
import 'package:encryptosafe/pages/onboarding/onboarding_page.dart';
import 'package:encryptosafe/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String otp = 'otp';
  static const String home = 'home';
  static const String main = 'main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const onBoardingPage(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case otp:
        final Map args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => OtpPage(
            phone: args['phone'],
            smsCodeId: args['smsCodeId'],
          ),
        );
      case main:
        return MaterialPageRoute(
          builder: (_) => const MyApp(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const BottomNav(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}
