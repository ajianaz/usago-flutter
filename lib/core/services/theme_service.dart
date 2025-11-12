import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing theme preferences
class ThemeService {
  static ThemeService? _instance;
  static ThemeService get instance {
    _instance ??= ThemeService._();
    return _instance!;
  }

  ThemeService._();

  static const String _themeKey = 'theme_mode';

  /// Get current theme mode
  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2;

    switch (themeIndex) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      case 2:
      default:
        return ThemeMode.system;
    }
  }

  /// Save theme mode preference
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    int themeIndex;

    switch (themeMode) {
      case ThemeMode.light:
        themeIndex = 0;
        break;
      case ThemeMode.dark:
        themeIndex = 1;
        break;
      case ThemeMode.system:
        themeIndex = 2;
        break;
    }

    await prefs.setInt(_themeKey, themeIndex);
  }
}