// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Foundation;
import 'package:slang_flutter/slang_flutter.dart';

class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations();
  }

  static const AppLocalizations instance = AppLocalizations();

  // App
  String get appTitle => 'Usago';
  String get appWelcome => 'Welcome';

  // Auth
  String get authLogin => 'Login';
  String get authRegister => 'Register';
  String get authEmail => 'Email';
  String get authPassword => 'Password';
  String get authForgotPassword => 'Forgot Password?';
  String get authDontHaveAccount => "Don't have an account?";
  String get authWelcomeBack => 'Welcome Back';
  String get authSignInToContinue => 'Sign in to continue';
  String get authCreateAccount => 'Create Account';
  String get authSignUpToContinue => 'Sign up to continue';
  String get authAlreadyHaveAccount => 'Already have an account?';
  String get name => 'Name';
  String get confirmPassword => 'Confirm Password';
  String get passwordsDoNotMatch => 'Passwords do not match';
  String get enterYourName => 'Enter your name';
  String get enterYourEmail => 'Enter your email';
  String get enterYourPassword => 'Enter your password';
  String get confirmYourPassword => 'Confirm your password';

  // Validation
  String get validationRequired => 'This field is required';
  String get validationEmailInvalid => 'Please enter a valid email';
  String get validationPasswordTooShort => 'Password must be at least 6 characters';
  String get validationPasswordTooLong => 'Password must be less than 50 characters';

  // Messages
  String get messagesLoginSuccess => 'Login successful';
  String get messagesLoginFailed => 'Login failed';
  String get messagesRegisterSuccess => 'Registration successful';
  String get messagesRegisterFailed => 'Registration failed';
  String get messagesNetworkError => 'Network error. Please check your connection.';
  String get messagesUnknownError => 'An unknown error occurred';

  // Common
  String get commonOk => 'OK';
  String get commonCancel => 'Cancel';
  String get commonSave => 'Save';
  String get commonDelete => 'Delete';
  String get commonEdit => 'Edit';
  String get commonLoading => 'Loading...';
  String get commonRetry => 'Retry';
  String get commonClose => 'Close';
}

// Indonesian translations
class AppLocalizationsId extends AppLocalizations {
  const AppLocalizationsId();

  @override
  String get appTitle => 'Usago';
  @override
  String get appWelcome => 'Selamat Datang';

  @override
  String get authLogin => 'Masuk';
  @override
  String get authRegister => 'Daftar';
  @override
  String get authEmail => 'Email';
  @override
  String get authPassword => 'Kata Sandi';
  @override
  String get authForgotPassword => 'Lupa Kata Sandi?';
  @override
  String get authDontHaveAccount => 'Belum punya akun?';
  @override
  String get authWelcomeBack => 'Selamat Datang Kembali';
  @override
  String get authSignInToContinue => 'Masuk untuk melanjutkan';
  @override
  String get authCreateAccount => 'Buat Akun';
  @override
  String get authSignUpToContinue => 'Daftar untuk melanjutkan';
  @override
  String get authAlreadyHaveAccount => 'Sudah punya akun?';
  @override
  String get name => 'Nama';
  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';
  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';
  @override
  String get enterYourName => 'Masukkan nama Anda';
  @override
  String get enterYourEmail => 'Masukkan email Anda';
  @override
  String get enterYourPassword => 'Masukkan kata sandi Anda';
  @override
  String get confirmYourPassword => 'Konfirmasi kata sandi Anda';

  @override
  String get validationRequired => 'Field ini wajib diisi';
  @override
  String get validationEmailInvalid => 'Masukkan email yang valid';
  @override
  String get validationPasswordTooShort => 'Kata sandi minimal 6 karakter';
  @override
  String get validationPasswordTooLong => 'Kata sandi maksimal 50 karakter';

  @override
  String get messagesLoginSuccess => 'Login berhasil';
  @override
  String get messagesLoginFailed => 'Login gagal';
  @override
  String get messagesRegisterSuccess => 'Pendaftaran berhasil';
  @override
  String get messagesRegisterFailed => 'Pendaftaran gagal';
  @override
  String get messagesNetworkError => 'Error jaringan. Periksa koneksi Anda.';
  @override
  String get messagesUnknownError => 'Terjadi error yang tidak diketahui';

  @override
  String get commonOk => 'OK';
  @override
  String get commonCancel => 'Batal';
  @override
  String get commonSave => 'Simpan';
  @override
  String get commonDelete => 'Hapus';
  @override
  String get commonEdit => 'Edit';
  @override
  String get commonLoading => 'Memuat...';
  @override
  String get commonRetry => 'Coba Lagi';
  @override
  String get commonClose => 'Tutup';
}

// Locale enum
enum AppLocale {
  en('en', 'English'),
  id('id', 'Bahasa Indonesia');

  const AppLocale(this.code, this.displayName);

  final String code;
  final String displayName;

  static AppLocale? fromString(String? code) {
    for (final locale in AppLocale.values) {
      if (locale.code == code) return locale;
    }
    return null;
  }

  static AppLocale fromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return AppLocale.en;
      case 'id':
        return AppLocale.id;
      default:
        return AppLocale.en;
    }
  }

  Locale get flutterLocale {
    switch (this) {
      case AppLocale.en:
        return const Locale('en');
      case AppLocale.id:
        return const Locale('id');
    }
  }

  Future<void> load() async {
    // This would normally load the translation files
    // For now, we'll use the hardcoded translations
  }
}

// Extension for easy access
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get t {
    final locale = Localizations.localeOf(this);
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }
}