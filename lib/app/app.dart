import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/app/themes/theme_data.dart';
import 'package:sociaanet/app/router.dart';
import 'package:sociaanet/core/providers/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeMode = themeState.mode;
    final router = ref.watch(routerProvider);

    // Set system UI overlay based on theme
    final brightness = themeMode == AppThemeMode.dark
        ? Brightness.light
        : themeMode == AppThemeMode.light
            ? Brightness.dark
            : MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? Brightness.light
                : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SociaaNet',
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: themeMode == AppThemeMode.light
          ? ThemeMode.light
          : themeMode == AppThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.system,
      routerConfig: router,
    );
  }
}