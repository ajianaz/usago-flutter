import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Blue Gradient
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryVariant = Color(0xFF4338CA);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary Colors - Warm Teal
  static const Color secondary = Color(0xFF14B8A6);
  static const Color secondaryVariant = Color(0xFF0D9488);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightBorderLight = Color(0xFFF5F5F5);
  static const Color lightBorderDark = Color(0xFF424242);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFE0E0E0);
  static const Color darkTextDisabled = Color(0xFF666666);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkBorderLight = Color(0xFF2C2C2C);
  static const Color darkBorderDark = Color(0xFF404040);

  // Background Colors (for backward compatibility)
  static const Color background = lightBackground;
  static const Color surface = lightSurface;
  static const Color onBackground = lightOnBackground;
  static const Color onSurface = lightOnSurface;

  // Error Colors
  static const Color error = Color(0xFFB00020);
  static const Color errorContainer = Color(0xFFDE3B3B);
  static const Color onError = Color(0xFFFFFFFF);

  // Success Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFE8F5E8);
  static const Color onSuccess = Color(0xFF000000);

  // Warning Colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color onWarning = Color(0xFF000000);

  // Info Colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Text Colors (for backward compatibility)
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textDisabled = lightTextDisabled;

  // Border Colors (for backward compatibility)
  static const Color border = lightBorder;
  static const Color borderLight = lightBorderLight;
  static const Color borderDark = lightBorderDark;

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF4F46E5),
    Color(0xFF4338CA),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF14B8A6),
    Color(0xFF0D9488),
  ];

  // Helper methods to get colors based on theme brightness
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color getOnBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOnBackground
        : lightOnBackground;
  }

  static Color getOnSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOnSurface
        : lightOnSurface;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color getTextDisabled(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextDisabled
        : lightTextDisabled;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : lightBorder;
  }

  static Color getBorderLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorderLight
        : lightBorderLight;
  }

  static Color getBorderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorderDark
        : lightBorderDark;
  }

  // Helper method to get appropriate color based on brightness
  static Color getColorForBrightness({
    required BuildContext context,
    required Color lightColor,
    required Color darkColor,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? darkColor : lightColor;
  }
}