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
    switch (settings.name) {
      case onboarding:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const onBoardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case login:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case otp:
        final Map args = settings.arguments as Map;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => OtpPage(
            phone: args['phone'],
            smsCodeId: args['smsCodeId'],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
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
