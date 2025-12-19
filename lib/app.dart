import 'package:flutter/material.dart';
import 'package:sociaanet/themes/theme_data.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';

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