import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../../l10n/app_localizations.g.dart';

/// Service for managing app locale and language settings
class LocaleService {
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;
  final AppLogger _logger;

  LocaleService({
    required SharedPreferences prefs,
    required AppLogger logger,
  })  : _prefs = prefs,
        _logger = logger;

  /// Get current locale from device settings or saved preference
  Locale getCurrentLocale() {
    // Try to get saved locale first
    final savedLocale = getSavedLocale();
    if (savedLocale != null) {
      return savedLocale;
    }

    // Fall back to device locale
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Check if device locale is supported
    if (isLocaleSupported(deviceLocale)) {
      return deviceLocale;
    }

    // Fall back to default locale
    return const Locale('en');
  }

  /// Get saved locale from preferences
  Locale? getSavedLocale() {
    try {
      final localeCode = _prefs.getString(_localeKey);
      if (localeCode != null) {
        final parts = localeCode.split('_');
        if (parts.length == 2) {
          return Locale(parts[0], parts[1]);
        } else {
          return Locale(localeCode);
        }
      }
    } catch (e) {
      _logger.error('Failed to get saved locale', e);
    }
    return null;
  }

  /// Save locale to preferences
  Future<void> saveLocale(Locale locale) async {
    try {
      await _prefs.setString(_localeKey, locale.toString());
      _logger.info('Locale saved: $locale');
    } catch (e) {
      _logger.error('Failed to save locale', e);
    }
  }

  /// Check if locale is supported
  bool isLocaleSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  /// Change app locale
  Future<void> changeLocale(Locale locale) async {
    if (!isLocaleSupported(locale)) {
      _logger.warning('Locale not supported: $locale');
      return;
    }

    await saveLocale(locale);

    // Update locale (simplified implementation)
    _logger.info('Locale changed to: $locale');

    _logger.info('Locale changed to: $locale');
  }

  /// Get all supported locales
  List<Locale> getSupportedLocales() {
    return [
      const Locale('en'),
      const Locale('id'),
    ];
  }

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return locale.toString();
    }
  }

  /// Get locale display name in native language
  String getLocaleDisplayNameNative(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return locale.toString();
    }
  }

  /// Initialize locale service and set up initial locale
  Future<void> initialize() async {
    final currentLocale = getCurrentLocale();
    _logger.info('Initializing locale service with locale: $currentLocale');

    // Initialize locale (simplified implementation)
    _logger.info('Locale service initialized with locale: $currentLocale');
    _logger.info('Locale service initialized successfully');
  }

  /// Reset to default locale
  Future<void> resetToDefault() async {
    await changeLocale(const Locale('en'));
  }

  /// Get current locale code
  String getCurrentLocaleCode() {
    final currentLocale = getCurrentLocale();
    return currentLocale.languageCode;
  }
}