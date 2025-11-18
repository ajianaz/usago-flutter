import 'package:flutter/material.dart';
import '../services/locale_service.dart';
import '../di/injection_container.dart';
import 'dart:async';
import '../../i18n/translations.g.dart';

/// Helper for instant locale switching without delay
/// Uses a combination of ValueNotifier and immediate state updates
class InstantLocaleHelper {
  static InstantLocaleHelper? _instance;
  static InstantLocaleHelper get instance {
    _instance ??= InstantLocaleHelper._();
    return _instance!;
  }

  InstantLocaleHelper._();

  final ValueNotifier<AppLocale> _localeNotifier = ValueNotifier<AppLocale>(AppLocale.en);
  final LocaleService _localeService = getIt<LocaleService>();

  /// Get current locale
  AppLocale get currentLocale => _localeNotifier.value;

  /// Get current locale as Flutter Locale for UI
  Locale get currentFlutterLocale => _localeNotifier.value.flutterLocale;

  /// Get locale notifier for listening to changes
  ValueNotifier<AppLocale> get localeNotifier => _localeNotifier;

  /// Initialize locale helper with saved locale
  Future<void> initialize() async {
    final savedLocale = _localeService.getCurrentLocale();
    _localeNotifier.value = savedLocale;
  }

  /// Change locale instantly without delay
  Future<void> changeLocale(AppLocale locale) async {
    // Update UI immediately
    _localeNotifier.value = locale;

    // Save to storage in background without await
    _localeService.changeLocale(locale);
  }

  /// Toggle between English and Indonesian instantly
  Future<void> toggleLanguage() async {
    final newLocale = _localeNotifier.value == AppLocale.en
        ? AppLocale.id
        : AppLocale.en;
    await changeLocale(newLocale);
  }

  /// Get locale display name
  String getLocaleDisplayName(AppLocale locale) {
    return _localeService.getLocaleDisplayName(locale);
  }

  /// Get all supported locales
  List<Locale> getSupportedLocales() {
    return _localeService.getSupportedLocales();
  }

  /// Dispose the notifier
  void dispose() {
    _localeNotifier.dispose();
  }
}