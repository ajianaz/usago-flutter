import 'package:flutter/material.dart';
import '../di/injection_container.dart';
import '../services/locale_service.dart';
import '../../l10n/app_localizations.g.dart';

/// Service for managing localization/internationalization
class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  LocalizationService._();

  /// Get current AppLocalizations based on current locale
  AppLocalizations get current {
    final localeService = getIt<LocaleService>();
    final currentLocale = localeService.getCurrentLocale();

    if (currentLocale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }

  /// Get AppLocalizations for specific locale
  AppLocalizations getForLocale(Locale locale) {
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }

  /// Get localized string by key
  String getString(String key) {
    switch (key) {
      // App
      case 'appTitle':
        return current.appTitle;
      case 'appWelcome':
        return current.appWelcome;

      // Auth
      case 'authLogin':
        return current.authLogin;
      case 'authRegister':
        return current.authRegister;
      case 'authEmail':
        return current.authEmail;
      case 'authPassword':
        return current.authPassword;
      case 'authForgotPassword':
        return current.authForgotPassword;
      case 'authDontHaveAccount':
        return current.authDontHaveAccount;
      case 'authWelcomeBack':
        return current.authWelcomeBack;
      case 'authSignInToContinue':
        return current.authSignInToContinue;
      case 'authCreateAccount':
        return current.authCreateAccount;
      case 'authSignUpToContinue':
        return current.authSignUpToContinue;
      case 'authAlreadyHaveAccount':
        return current.authAlreadyHaveAccount;
      case 'name':
        return current.name;
      case 'confirmPassword':
        return current.confirmPassword;
      case 'passwordsDoNotMatch':
        return current.passwordsDoNotMatch;
      case 'enterYourName':
        return current.enterYourName;
      case 'enterYourEmail':
        return current.enterYourEmail;
      case 'enterYourPassword':
        return current.enterYourPassword;
      case 'confirmYourPassword':
        return current.confirmYourPassword;

      // Validation
      case 'validationRequired':
        return current.validationRequired;
      case 'validationEmailInvalid':
        return current.validationEmailInvalid;
      case 'validationPasswordTooShort':
        return current.validationPasswordTooShort;
      case 'validationPasswordTooLong':
        return current.validationPasswordTooLong;

      // Messages
      case 'messagesLoginSuccess':
        return current.messagesLoginSuccess;
      case 'messagesLoginFailed':
        return current.messagesLoginFailed;
      case 'messagesRegisterSuccess':
        return current.messagesRegisterSuccess;
      case 'messagesRegisterFailed':
        return current.messagesRegisterFailed;
      case 'messagesNetworkError':
        return current.messagesNetworkError;
      case 'messagesUnknownError':
        return current.messagesUnknownError;

      // Common
      case 'commonOk':
        return current.commonOk;
      case 'commonCancel':
        return current.commonCancel;
      case 'commonSave':
        return current.commonSave;
      case 'commonDelete':
        return current.commonDelete;
      case 'commonEdit':
        return current.commonEdit;
      case 'commonLoading':
        return current.commonLoading;
      case 'commonRetry':
        return current.commonRetry;
      case 'commonClose':
        return current.commonClose;

      default:
        return key;
    }
  }

  /// Update localization when locale changes
  void updateLocale(Locale locale) {
    // This method can be used to notify listeners when locale changes
    // Implementation depends on state management solution used
  }
}