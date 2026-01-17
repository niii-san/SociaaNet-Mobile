import 'package:flutter/material.dart';
import 'package:sociaanet/app/themes/theme_data.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SociaaNet',
      theme: getApplicationTheme(),
      home: SplashScreen(
        nextPage: OnboardingScreen(
          nextPage: const LoginScreen(),
        ),
      ),
    );
  }
}