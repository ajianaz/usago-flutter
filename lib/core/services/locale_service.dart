import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/i18n/translations.g.dart';
import '../utils/logger.dart';

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
  AppLocale getCurrentLocale() {
    // Try to get saved locale first
    final savedLocale = getSavedLocale();
    if (savedLocale != null) {
      return savedLocale;
    }

    // Fall back to device locale
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Check if device locale is supported
    if (isLocaleSupported(deviceLocale)) {
      return AppLocaleUtils.parseLocaleParts(
        languageCode: deviceLocale.languageCode,
        countryCode: deviceLocale.countryCode,
      );
    }

    // Fall back to default locale
    return AppLocale.en;
  }

  /// Get saved locale from preferences
  AppLocale? getSavedLocale() {
    try {
      final localeCode = _prefs.getString(_localeKey);
      if (localeCode != null) {
        return AppLocaleUtils.parse(localeCode);
      }
    } catch (e) {
      _logger.error('Failed to get saved locale', e);
    }
    return null;
  }

  /// Save locale to preferences
  Future<void> saveLocale(AppLocale locale) async {
    try {
      await _prefs.setString(_localeKey, locale.languageCode);
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
  Future<void> changeLocale(AppLocale locale) async {
    await saveLocale(locale);

    // Update locale using slang
    await LocaleSettings.setLocale(locale);

    _logger.info('Locale changed to: $locale');
  }

  /// Get all supported locales
  List<Locale> getSupportedLocales() {
    return AppLocaleUtils.supportedLocales;
  }

  /// Get locale display name
  String getLocaleDisplayName(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return 'English';
      case AppLocale.id:
        return 'Bahasa Indonesia';
    }
  }

  /// Get locale display name in native language
  String getLocaleDisplayNameNative(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return 'English';
      case AppLocale.id:
        return 'Bahasa Indonesia';
    }
  }

  /// Initialize locale service and set up initial locale
  Future<void> initialize() async {
    final currentLocale = getCurrentLocale();
    _logger.info('Initializing locale service with locale: $currentLocale');

    // Initialize locale using slang
    await LocaleSettings.setLocale(currentLocale);

    _logger.info('Locale service initialized with locale: $currentLocale');
    _logger.info('Locale service initialized successfully');
  }

  /// Reset to default locale
  Future<void> resetToDefault() async {
    await changeLocale(AppLocale.en);
  }

  /// Get current locale code
  String getCurrentLocaleCode() {
    final currentLocale = getCurrentLocale();
    return currentLocale.languageCode;
  }
}