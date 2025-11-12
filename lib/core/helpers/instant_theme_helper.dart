import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import 'dart:async';

/// Helper for instant theme switching without delay
/// Uses a combination of ValueNotifier and immediate state updates
class InstantThemeHelper {
  static InstantThemeHelper? _instance;
  static InstantThemeHelper get instance {
    _instance ??= InstantThemeHelper._();
    return _instance!;
  }

  InstantThemeHelper._();

  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  final ThemeService _themeService = ThemeService.instance;

  /// Get current theme mode
  ThemeMode get currentTheme => _themeNotifier.value;

  /// Get theme notifier for listening to changes
  ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;

  /// Initialize theme helper with saved theme
  Future<void> initialize() async {
    final savedTheme = await _themeService.getThemeMode();
    _themeNotifier.value = savedTheme;
  }

  /// Change theme instantly without delay
  Future<void> changeTheme(ThemeMode themeMode) async {
    // Update UI immediately
    _themeNotifier.value = themeMode;

    // Save to storage in background without await
    _themeService.saveThemeMode(themeMode);
  }

  /// Toggle between light and dark theme instantly
  Future<void> toggleTheme() async {
    final newTheme = _themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await changeTheme(newTheme);
  }

  /// Cycle through all theme modes instantly
  Future<void> cycleTheme() async {
    ThemeMode newTheme;
    switch (_themeNotifier.value) {
      case ThemeMode.light:
        newTheme = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newTheme = ThemeMode.system;
        break;
      case ThemeMode.system:
        newTheme = ThemeMode.light;
        break;
    }
    await changeTheme(newTheme);
  }

  /// Dispose the notifier
  void dispose() {
    _themeNotifier.dispose();
  }
}