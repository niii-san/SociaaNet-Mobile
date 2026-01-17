import 'package:flutter/material.dart';

/// Modern minimal black & white theme colors for SociaaNet
class AppColors {
  AppColors._();

  // Primary Colors - Deep black with subtle variations
  static const Color primary = Color(0xFF0A0A0A); // Near black
  static const Color primaryLight = Color(0xFF1A1A1A); // Lighter black
  static const Color primaryDark = Color(0xFF000000); // Pure black

  // Accent Colors - Subtle gray accents
  static const Color accent = Color(0xFF2D2D2D); // Dark gray accent
  static const Color accentLight = Color(0xFF404040); // Medium gray

  // Background Colors
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light gray
  static const Color surfaceDark = Color(0xFF0A0A0A); // Dark surface

  // Text Colors
  static const Color textPrimary = Color(0xFF0A0A0A); // Near black
  static const Color textSecondary = Color(0xFF6B6B6B); // Medium gray
  static const Color textTertiary = Color(0xFF9E9E9E); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on dark

  // Semantic Colors
  static const Color success = Color(0xFF1DB954); // Spotify green
  static const Color warning = Color(0xFFFFB800); // Warm yellow
  static const Color error = Color(0xFFE53935); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  // Border & Divider
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF2D2D2D);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadows
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x29000000);

  // Gradient Colors (for special elements)
  static const List<Color> gradientPrimary = [
    Color(0xFF1A1A1A),
    Color(0xFF0A0A0A),
  ];

  static const List<Color> gradientAccent = [
    Color(0xFF2D2D2D),
    Color(0xFF1A1A1A),
  ];

  // Interactive States
  static const Color hover = Color(0xFFF0F0F0);
  static const Color pressed = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF0F0F0);

  // Input Fields
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusBorder = Color(0xFF0A0A0A);
}
