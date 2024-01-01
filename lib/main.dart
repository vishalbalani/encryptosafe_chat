import 'package:dynamic_color/dynamic_color.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/firebase_options.dart';
import 'package:encryptosafe/model/db_handle.dart';
import 'package:encryptosafe/pages/onboarding/onboarding_page.dart';
import 'package:encryptosafe/widgets/bottom_nav.dart';
import 'package:encryptosafe/widgets/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DatabaseHandler.instance.database;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static final defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);
  static final defaultDarkColorScheme = ColorScheme.fromSwatch(
      brightness: Brightness.dark, primarySwatch: Colors.blue);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 875),
      minTextAdapt: true,
      builder: (context, child) {
        return DynamicColorBuilder(
          builder: (
            lightColorScheme,
            darkColorScheme,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Constants.darkBK,
                colorScheme: lightColorScheme ?? defaultDarkColorScheme,
                primarySwatch: Colors.blue,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                scaffoldBackgroundColor: Constants.darkBK,
                colorScheme: darkColorScheme ?? defaultDarkColorScheme,
                useMaterial3: true,
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const BottomNav();
                  }
                  return const onBoardingPage();
                },
              ),
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        );
      },
    );
  }
}
