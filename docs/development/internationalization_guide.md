# Flutter Internationalization Guide with Slang

## 📋 Table of Contents

1. [Overview](#overview)
2. [Why Slang?](#why-slang)
3. [Setup & Configuration](#setup--configuration)
4. [Multi-Platform Support](#multi-platform-support)
5. [Implementation Steps](#implementation-steps)
6. [Best Practices](#best-practices)
7. [Future Language Additions](#future-language-additions)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This guide covers implementing internationalization (i18n) for the Usago Flutter project using the **Slang** library, with focus on:
- **2 languages**: English (default) and Indonesian
- **Mobile settings integration**: Read language from device settings
- **Multi-platform support**: Android, iOS, and Web
- **Scalable architecture**: Easy to add more languages later

---

## 🚀 Why Slang?

### Advantages over Flutter's built-in i18n:

| Feature | Slang | Flutter i18n |
|---------|-------|--------------|
| **Type Safety** | ✅ Compile-time checking | ❌ Runtime errors possible |
| **Code Generation** | ✅ Auto-generated classes | ⚠️ Manual string access |
| **Pluralization** | ✅ Built-in support | ⚠️ Complex implementation |
| **Context** | ✅ Context-aware translations | ❌ No context support |
| **Hot Reload** | ✅ Works with hot reload | ⚠️ Requires restart |
| **IDE Support** | ✅ Autocomplete & navigation | ❌ No IDE support |
| **Performance** | ✅ Optimized generated code | ⚠️ Dynamic lookups |

### Key Benefits for Usago:
1. **Type Safety** - Compile-time error detection
2. **Developer Experience** - Excellent IDE support with autocomplete
3. **Performance** - Generated code is optimized
4. **Maintainability** - Easy to manage translations
5. **Scalability** - Simple to add new languages

---

## ⚙️ Setup & Configuration

### 1. Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  slang: ^3.25.0
  slang_flutter: ^3.25.0

dev_dependencies:
  slang_build_runner: ^3.25.0
```

### 2. Build Configuration

Create `build.yaml`:

```yaml
targets:
  $default:
    builders:
      slang_build_runner:
        options:
          base_locale: en
          input_directory: lib/i18n
          output_directory: lib/i18n
          output_localization_file: app_localizations.g.dart
          output_class_name: AppLocalizations
          namespaces: true
          translation_class_visibility: private
          enum_name: AppLocale
          enum_output_directory: lib/l10n
          key_case: snake
          key_map_case: snake
          string_interpolation: true
          pluralization:
            auto: plural
            parameter: count
          context_parameter: context
```

### 3. Directory Structure

```
lib/
├── i18n/
│   ├── i18n.yaml              # Configuration
│   ├── en.i18n.yaml          # English translations
│   ├── id.i18n.yaml          # Indonesian translations
│   └── app_localizations.g.dart # Generated (don't edit)
├── core/
│   ├── services/
│   │   └── locale_service.dart # Locale management
│   └── helpers/
│       └── instant_locale_helper.dart # Instant locale switching
└── ...
```

---

## 🌐 Multi-Platform Support

### Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application
        android:label="@string/app_name"
        android:supportsRtl="true">
        <!-- Add supported locales -->
        <meta-data
            android:name="android.locale.config"
            android:resource="@xml/locales_config" />
    </application>
</manifest>
```

Create `android/app/src/main/res/xml/locales_config.xml`:

```xml
<locale-config xmlns:android="http://schemas.android.com/apk/res/android">
    <locale android:name="en"/>
    <locale android:name="id"/>
</locale-config>
```

### iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>id</string>
</array>
```

### Web Configuration

Update `web/index.html`:

```html
<html>
<head>
    <!-- Add language meta tag -->
    <meta name="language" content="en">
    <!-- Add supported languages -->
    <meta name="supported-languages" content="en,id">
</head>
</html>
```

---

## 📝 Implementation Steps

### Step 1: Create Translation Files

#### `lib/i18n/i18n.yaml`
```yaml
base_locale: en
locales: [en, id]
```

#### `lib/i18n/en.i18n.yaml`
```yaml
# App
app:
  title: Usago
  welcome: Welcome

# Auth
auth:
  login: Login
  register: Register
  email: Email
  password: Password
  forgot_password: Forgot Password?
  dont_have_account: Don't have an account?
  welcome_back: Welcome Back
  sign_in_to_continue: Sign in to continue
  create_account: Create Account
  sign_up_to_continue: Sign up to continue
  already_have_account: Already have an account?

# Validation
validation:
  required: This field is required
  email_invalid: Please enter a valid email
  password_too_short: Password must be at least 6 characters
  password_too_long: Password must be less than 50 characters

# Messages
messages:
  login_success: Login successful
  login_failed: Login failed
  register_success: Registration successful
  register_failed: Registration failed
  network_error: Network error. Please check your connection.
  unknown_error: An unknown error occurred

# Common
common:
  ok: OK
  cancel: Cancel
  save: Save
  delete: Delete
  edit: Edit
  loading: Loading...
  retry: Retry
  close: Close
```

#### `lib/i18n/id.i18n.yaml`
```yaml
# App
app:
  title: Usago
  welcome: Selamat Datang

# Auth
auth:
  login: Masuk
  register: Daftar
  email: Email
  password: Kata Sandi
  forgot_password: Lupa Kata Sandi?
  dont_have_account: Belum punya akun?
  welcome_back: Selamat Datang Kembali
  sign_in_to_continue: Masuk untuk melanjutkan
  create_account: Buat Akun
  sign_up_to_continue: Daftar untuk melanjutkan
  already_have_account: Sudah punya akun?

# Validation
validation:
  required: Field ini wajib diisi
  email_invalid: Masukkan email yang valid
  password_too_short: Kata sandi minimal 6 karakter
  password_too_long: Kata sandi maksimal 50 karakter

# Messages
messages:
  login_success: Login berhasil
  login_failed: Login gagal
  register_success: Pendaftaran berhasil
  register_failed: Pendaftaran gagal
  network_error: Error jaringan. Periksa koneksi Anda.
  unknown_error: Terjadi error yang tidak diketahui

# Common
common:
  ok: OK
  cancel: Batal
  save: Simpan
  delete: Hapus
  edit: Edit
  loading: Memuat...
  retry: Coba Lagi
  close: Tutup
```

### Step 2: Generate Code

Run the build runner:

```bash
flutter packages pub run slang_build_runner
```

Or watch for changes:

```bash
flutter packages pub run slang_build_runner --watch
```

### Step 3: Create Locale Service

#### `lib/core/services/locale_service.dart`
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

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
}
```

#### `lib/core/helpers/instant_locale_helper.dart`
```dart
import 'package:flutter/material.dart';
import '../services/locale_service.dart';
import '../di/injection_container.dart';
import 'dart:async';

/// Helper for instant locale switching without delay
/// Uses a combination of ValueNotifier and immediate state updates
class InstantLocaleHelper {
  static InstantLocaleHelper? _instance;
  static InstantLocaleHelper get instance {
    _instance ??= InstantLocaleHelper._();
    return _instance!;
  }

  InstantLocaleHelper._();

  final ValueNotifier<Locale> _localeNotifier = ValueNotifier<Locale>(const Locale('en'));
  final LocaleService _localeService = getIt<LocaleService>();

  /// Get current locale
  Locale get currentLocale => _localeNotifier.value;

  /// Get locale notifier for listening to changes
  ValueNotifier<Locale> get localeNotifier => _localeNotifier;

  /// Initialize locale helper with saved locale
  Future<void> initialize() async {
    final savedLocale = _localeService.getCurrentLocale();
    _localeNotifier.value = savedLocale;
  }

  /// Change locale instantly without delay
  Future<void> changeLocale(Locale locale) async {
    // Update UI immediately
    _localeNotifier.value = locale;

    // Save to storage in background without await
    _localeService.changeLocale(locale);
  }

  /// Toggle between English and Indonesian instantly
  Future<void> toggleLanguage() async {
    final newLocale = _localeNotifier.value.languageCode == 'en'
        ? const Locale('id')
        : const Locale('en');
    await changeLocale(newLocale);
  }

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
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
```
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slang_flutter/slang_flutter.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

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
    return AppLocale.en.flutterLocale;
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
    return AppLocale.values.any((appLocale) =>
        appLocale.flutterLocale.languageCode == locale.languageCode);
  }

  /// Change app locale
  Future<void> changeLocale(Locale locale) async {
    if (!isLocaleSupported(locale)) {
      _logger.warning('Locale not supported: $locale');
      return;
    }

    await saveLocale(locale);

    // Find matching AppLocale
    final appLocale = AppLocale.values.firstWhere(
      (appLocale) => appLocale.flutterLocale.languageCode == locale.languageCode,
      orElse: () => AppLocale.en,
    );

    // Update Slang locale
    appLocale.load();

    _logger.info('Locale changed to: $locale');
  }

  /// Get all supported locales
  List<Locale> getSupportedLocales() {
    return AppLocale.values.map((appLocale) => appLocale.flutterLocale).toList();
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
}
```

### Step 4: Update Dependency Injection

#### `lib/core/di/injection_container.dart`
```dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../utils/logger.dart';
import '../errors/error_handler.dart';
import '../services/locale_service.dart';
import '../../features/auth/di/auth_injection.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCoreServices();
  setupAuthDependencies(getIt);
}

Future<void> _setupCoreServices() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  getIt.registerSingleton(DioClient());
  getIt.registerSingleton(AppLogger());
  getIt.registerSingleton(ErrorHandler());

  // Register locale service
  getIt.registerSingleton(LocaleService(
    prefs: sharedPreferences,
    logger: getIt(),
  ));
}
```

### Step 5: Update Main App

#### `lib/app/app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../shared/themes/theme.dart';
import '../core/di/injection_container.dart';
import '../core/services/locale_service.dart';
import '../core/helpers/instant_theme_helper.dart';
import '../core/helpers/instant_locale_helper.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/brand/presentation/bloc/brand_bloc.dart';
import '../i18n/app_localizations.g.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final localeService = getIt<LocaleService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<AuthBloc>(),
        ),
        BlocProvider.value(
          value: getIt<BrandBloc>(),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: InstantThemeHelper.instance.themeNotifier,
        builder: (context, themeMode, child) {
          return ValueListenableBuilder<Locale>(
            valueListenable: InstantLocaleHelper.instance.localeNotifier,
            builder: (context, locale, child) {
              return MaterialApp.router(
                title: 'Usago',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: appRouter.config(),
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: localeService.getSupportedLocales(),
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true;
  }

  @override
  String toString() => 'AppLocalizationsDelegate(${supportedLocales.join(', ')})';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];
}
```

---

## 🚀 Implementing i18n in New Features

### Feature Development Workflow

When implementing a new feature that requires internationalization, follow these steps:

#### Step 1: Plan Your Translation Keys

Before writing any code, identify all text that needs translation:

```dart
// Example: New Brand Feature
// Text elements to translate:
// - Page titles
// - Form labels
// - Button text
// - Error messages
// - Success messages
// - Validation messages
// - Dialog content
```

#### Step 2: Add Translation Keys

Add keys to all language files at the same time:

```yaml
# lib/i18n/en.i18n.yaml
# ... existing content ...

brand:
  title: Brand Management
  create_brand: Create Brand
  edit_brand: Edit Brand
  brand_name: Brand Name
  brand_description: Brand Description
  save_brand: Save Brand
  brand_created_success: Brand created successfully
  brand_updated_success: Brand updated successfully
  brand_deleted_success: Brand deleted successfully
  confirm_delete_brand: Are you sure you want to delete this brand?
  brand_name_required: Brand name is required
  brand_description_required: Brand description is required

# lib/i18n/id.i18n.yaml
# ... existing content ...

brand:
  title: Manajemen Merek
  create_brand: Buat Merek
  edit_brand: Edit Merek
  brand_name: Nama Merek
  brand_description: Deskripsi Merek
  save_brand: Simpan Merek
  brand_created_success: Merek berhasil dibuat
  brand_updated_success: Merek berhasil diperbarui
  brand_deleted_success: Merek berhasil dihapus
  confirm_delete_brand: Apakah Anda yakin ingin menghapus merek ini?
  brand_name_required: Nama merek wajib diisi
  brand_description_required: Deskripsi merek wajib diisi
```

#### Step 3: Generate Translation Code

Run the build runner to update the generated classes:

```bash
flutter packages pub run slang_build_runner
```

#### Step 4: Implement in UI Components

Use the generated translation keys in your widgets:

```dart
// lib/features/brand/presentation/pages/create_brand_page.dart
import 'package:flutter/material.dart';
import '../../../../i18n/app_localizations.g.dart';

class CreateBrandPage extends StatelessWidget {
  const CreateBrandPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.brandTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: context.t.brandName,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.t.brandNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: context.t.brandDescription,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.t.brandDescriptionRequired;
                }

---

## 🔧 Custom Implementation Details

### AppLocalizationsDelegate

The `AppLocalizationsDelegate` is a custom implementation that handles loading the appropriate translation class based on the current locale:

```dart
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true; // Always reload to support dynamic locale changes
  }

  @override
  String toString() => 'AppLocalizationsDelegate(${supportedLocales.join(', ')})';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];
}
```

#### Key Features:
- **Locale Detection**: Automatically selects the appropriate translation class
- **Dynamic Reloading**: Returns `true` for `shouldReload` to support instant locale changes
- **Supported Locales**: Centralized list of supported locales
- **Error Handling**: Falls back to English for unsupported locales

### InstantLocaleHelper

The `InstantLocaleHelper` provides instant locale switching without delays:

```dart
class InstantLocaleHelper {
  static InstantLocaleHelper? _instance;
  static InstantLocaleHelper get instance {
    _instance ??= InstantLocaleHelper._();
    return _instance!;
  }

  InstantLocaleHelper._();

  final ValueNotifier<Locale> _localeNotifier = ValueNotifier<Locale>(const Locale('en'));
  final LocaleService _localeService = getIt<LocaleService>();

  /// Get current locale
  Locale get currentLocale => _localeNotifier.value;

  /// Get locale notifier for listening to changes
  ValueNotifier<Locale> get localeNotifier => _localeNotifier;

  /// Initialize locale helper with saved locale
  Future<void> initialize() async {
    final savedLocale = _localeService.getCurrentLocale();
    _localeNotifier.value = savedLocale;
  }

  /// Change locale instantly without delay
  Future<void> changeLocale(Locale locale) async {
    // Update UI immediately
    _localeNotifier.value = locale;

    // Save to storage in background without await
    _localeService.changeLocale(locale);
  }

  /// Toggle between English and Indonesian instantly
  Future<void> toggleLanguage() async {
    final newLocale = _localeNotifier.value.languageCode == 'en'
        ? const Locale('id')
        : const Locale('en');
    await changeLocale(newLocale);
  }

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
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
```


---

## 🧪 Testing i18n Functionality

### Unit Testing Translations

Test individual translation methods and keys:

```dart
// test/i18n/app_localizations_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/i18n/app_localizations.g.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('English translations should return correct values', () {
      final localizations = const AppLocalizations();

      expect(localizations.appTitle, 'Usago');
      expect(localizations.authLogin, 'Login');
      expect(localizations.authRegister, 'Register');
      expect(localizations.validationRequired, 'This field is required');
    });

    test('Indonesian translations should return correct values', () {
      final localizations = const AppLocalizationsId();

      expect(localizations.appTitle, 'Usago');
      expect(localizations.authLogin, 'Masuk');
      expect(localizations.authRegister, 'Daftar');
      expect(localizations.validationRequired, 'Field ini wajib diisi');
    });

    test('Parameterized translations should work correctly', () {
      final enLocalizations = const AppLocalizations();
      final idLocalizations = const AppLocalizationsId();

      final email = 'test@example.com';

      expect(
        enLocalizations.passwordResetEmailSent(email),
        'Password reset email sent to $email',
      );
      expect(
        idLocalizations.passwordResetEmailSent(email),
        'Email reset kata sandi telah dikirim ke $email',
      );
    });
  });
}
```

### Widget Testing with Locales

Test widgets with different locales:

```dart
// test/features/auth/presentation/pages/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usago/features/auth/presentation/pages/login_page.dart';
import 'package:usago/i18n/app_localizations.g.dart';

void main() {
  group('LoginPage Localization Tests', () {
    testWidgets('Should display English text for English locale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        ),
      );

      // Check English text
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('Should display Indonesian text for Indonesian locale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        ),
      );

      // Check Indonesian text
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Selamat Datang Kembali'), findsOneWidget);
      expect(find.text('Belum punya akun?'), findsOneWidget);
      expect(find.text('Masuk untuk melanjutkan'), findsOneWidget);
    });

    testWidgets('Should display validation messages in correct language', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        ),
      );

      // Find and tap login button without filling form
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Check English validation messages
      expect(find.text('This field is required'), findsNWidgets(2)); // Email and password
    });

    testWidgets('Should display Indonesian validation messages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginPage(),
        ),
      );

      // Find and tap login button without filling form
      final loginButton = find.text('Masuk');
      await tester.tap(loginButton);
      await tester.pump();

      // Check Indonesian validation messages
      expect(find.text('Field ini wajib diisi'), findsNWidgets(2)); // Email and password
    });
  });
}
```

### Integration Testing Locale Switching

Test locale switching functionality:

```dart
// test/integration/locale_switching_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/app/app.dart';
import 'package:usago/core/helpers/instant_locale_helper.dart';
import 'package:usago/i18n/app_localizations.g.dart';

void main() {
  group('Locale Switching Integration Tests', () {
    testWidgets('Should switch language instantly', (tester) async {
      // Initialize locale helper
      await InstantLocaleHelper.instance.initialize();

      await tester.pumpWidget(const MyApp());

      // Initially should be in English (default)
      expect(find.text('Login'), findsOneWidget);

      // Switch to Indonesian
      await InstantLocaleHelper.instance.changeLocale(const Locale('id'));
      await tester.pump();

      // Should now be in Indonesian
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('Should toggle language correctly', (tester) async {
      // Initialize locale helper
      await InstantLocaleHelper.instance.initialize();

      await tester.pumpWidget(const MyApp());

      // Initially should be in English
      expect(find.text('Login'), findsOneWidget);

      // Toggle to Indonesian
      await InstantLocaleHelper.instance.toggleLanguage();
      await tester.pump();

      // Should now be in Indonesian
      expect(find.text('Masuk'), findsOneWidget);

      // Toggle back to English
      await InstantLocaleHelper.instance.toggleLanguage();
      await tester.pump();

      // Should be back to English
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
```

### Testing Custom Components

Test custom widgets that use translations:

```dart

---

## 🔧 Maintenance Workflow

### Adding New Translation Keys

Follow this workflow when adding new translation keys to the project:

#### Step 1: Plan Your Keys

Before adding keys, consider:
- All contexts where the text will be used
- Whether parameters are needed
- If pluralization is required
- Consistent naming with existing keys

#### Step 2: Update All Language Files

Add the same keys to all language files simultaneously:

```yaml
# lib/i18n/en.i18n.yaml
# Add new keys to appropriate namespace
new_feature:
  title: New Feature
  description: This is a new feature
  action_button: Get Started
  success_message: Feature activated successfully!
  error_message: Failed to activate feature

# lib/i18n/id.i18n.yaml
# Add same keys with Indonesian translations
new_feature:
  title: Fitur Baru
  description: Ini adalah fitur baru
  action_button: Mulai
  success_message: Fitur berhasil diaktifkan!
  error_message: Gagal mengaktifkan fitur
```

#### Step 3: Generate Translation Code

Run the build runner to update generated classes:

```bash
# One-time generation
flutter packages pub run slang_build_runner

# Or watch for changes during development
flutter packages pub run slang_build_runner --watch
```

#### Step 4: Verify Generated Code

Check that the generated code includes your new keys:

```dart
// lib/i18n/app_localizations.g.dart
// Verify these methods are generated:
String get newFeatureTitle => 'New Feature';
String get newFeatureDescription => 'This is a new feature';
String get newFeatureActionButton => 'Get Started';
String get newFeatureSuccessMessage => 'Feature activated successfully!';
String get newFeatureErrorMessage => 'Failed to activate feature';
```

#### Step 5: Update UI Components

Use the new translation keys in your widgets:

```dart
// Before
Text('New Feature')
Text('This is a new feature')
ElevatedButton(
  onPressed: () {},
  child: Text('Get Started'),
)

// After
Text(context.t.newFeatureTitle)
Text(context.t.newFeatureDescription)
ElevatedButton(
  onPressed: () {},
  child: Text(context.t.newFeatureActionButton),
)
```

#### Step 6: Test All Languages

Test the new translations in all supported languages:

```bash
# Run tests
flutter test

# Manual testing
# 1. Run the app
# 2. Switch to each language
# 3. Navigate to feature
# 4. Verify all text is translated
```

### Updating Existing Translations

When modifying existing translations:

#### Step 1: Review Impact

Check where the translation is used:

```bash
# Search for usage of the translation key
grep -r "context.t.existingKey" lib/
```

#### Step 2: Update All Language Files

Maintain consistency across all languages:

```yaml
# lib/i18n/en.i18n.yaml
existing_key: Updated translation

# lib/i18n/id.i18n.yaml
existing_key: Terjemahan diperbarui
```

#### Step 3: Regenerate and Test

```bash
# Regenerate translation code
flutter packages pub run slang_build_runner

# Run tests to ensure no breaking changes
flutter test

# Test UI changes in all languages
```

### Removing Translation Keys

When removing unused translation keys:

#### Step 1: Verify Usage

Confirm the key is no longer used:

```bash
# Search for any remaining usage
grep -r "context.t.unusedKey" lib/
```

#### Step 2: Remove from All Files

Remove the key from all language files:

```yaml
# lib/i18n/en.i18n.yaml
# Remove this section or key
# unused_key: This is no longer needed

# lib/i18n/id.i18n.yaml
# Remove this section or key
# unused_key: Ini tidak lagi diperlukan
```

#### Step 3: Regenerate and Test

```bash
# Regenerate translation code
flutter packages pub run slang_build_runner

# Run tests to ensure no compilation errors
flutter test
```

### Adding a New Language

When adding a new language (e.g., Spanish):

#### Step 1: Update Configuration

```yaml
# lib/i18n/i18n.yaml
base_locale: en
locales: [en, id, es]  # Add 'es'
```

#### Step 2: Create Translation File

```yaml
# lib/i18n/es.i18n.yaml
# Copy structure from en.i18n.yaml and translate
app:
  title: Usago
  welcome: Bienvenido

auth:
  login: Iniciar sesión
  register: Registrarse
  # ... translate all existing keys
```

#### Step 3: Update Locale Service

```dart
// lib/core/services/locale_service.dart
bool isLocaleSupported(Locale locale) {
  return ['en', 'id', 'es'].contains(locale.languageCode);  // Add 'es'
}

List<Locale> getSupportedLocales() {
  return [
    const Locale('en'),
    const Locale('id'),
    const Locale('es'),  // Add this
  ];
}

String getLocaleDisplayName(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'id':
      return 'Bahasa Indonesia';
    case 'es':  // Add this
      return 'Español';
    default:
      return locale.toString();
  }
}
```

#### Step 4: Update AppLocalizationsDelegate

```dart
// lib/app/app.dart
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'id', 'es'].contains(locale.languageCode);  // Add 'es'
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'id':
        return const AppLocalizationsId();
      case 'es':  // Add this
        return const AppLocalizationsEs();
      default:
        return const AppLocalizations();
    }
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
    Locale('es'),  // Add this
  ];
}
```

#### Step 5: Regenerate and Test

```bash
# Regenerate with new language
flutter packages pub run slang_build_runner

# Test new language
flutter test
```

### Automation Scripts

Create scripts to streamline maintenance:

#### Script: Add New Translation Keys

```bash
#!/bin/bash
# scripts/add_translation.sh

KEY_NAME=$1
EN_VALUE=$2
ID_VALUE=$3

if [ -z "$KEY_NAME" ] || [ -z "$EN_VALUE" ] || [ -z "$ID_VALUE" ]; then
  echo "Usage: ./add_translation.sh key_name english_value indonesian_value"
  exit 1
fi

# Add to English file
echo "  $KEY_NAME: $EN_VALUE" >> lib/i18n/en.i18n.yaml

# Add to Indonesian file
echo "  $KEY_NAME: $ID_VALUE" >> lib/i18n/id.i18n.yaml

# Regenerate
flutter packages pub run slang_build_runner

echo "Added translation key: $KEY_NAME"
```

#### Script: Validate Translations

```bash
#!/bin/bash
# scripts/validate_translations.sh

# Check for missing keys
echo "Checking for missing translation keys..."

# Get all keys from English file
EN_KEYS=$(grep -E '^\s*[a-z_]+:' lib/i18n/en.i18n.yaml | sed 's/^\s*//' | sed 's/:.*//')

# Check each key in Indonesian file
for key in $EN_KEYS; do
  if ! grep -q "^\s*$key:" lib/i18n/id.i18n.yaml; then
    echo "Missing key in Indonesian: $key"
  fi
done

echo "Validation complete."
```

### Maintenance Checklist

#### Daily/Weekly Tasks
- [ ] Review new translation requests
- [ ] Update translation files if needed
- [ ] Regenerate translation code
- [ ] Run tests to ensure no regressions

#### Monthly Tasks
- [ ] Review translation consistency
- [ ] Check for unused translation keys
- [ ] Update documentation if needed
- [ ] Plan for new language additions

#### Release Tasks
- [ ] Finalize all translations
- [ ] Run full test suite with all languages
- [ ] Update platform configurations if new languages added
- [ ] Update documentation

### Common Issues and Solutions

#### Issue: Build Runner Fails
```bash
# Clean and regenerate
flutter clean
flutter packages get
flutter packages pub run slang_build_runner --delete-conflicting-outputs
```

#### Issue: Missing Translations
- Check YAML syntax in all translation files
- Ensure keys are identical across all files
- Regenerate with `--verbose` flag to see errors

#### Issue: Language Not Switching
- Verify `InstantLocaleHelper` is initialized
- Check if `ValueListenableBuilder` is properly set up
- Ensure `AppLocalizationsDelegate` returns `true` for `shouldReload`

### Documentation Updates

Keep documentation in sync with implementation:
- Update supported languages list
- Document any new translation patterns
- Update code examples in documentation
- Maintain changelog of translation changes
// test/shared/widgets/language_switcher_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/shared/widgets/language_switcher.dart';
import 'package:usago/core/helpers/instant_locale_helper.dart';
import 'package:usago/i18n/app_localizations.g.dart';

void main() {
  group('LanguageSwitcher Tests', () {
    setUp(() async {
      // Initialize locale helper before each test
      await InstantLocaleHelper.instance.initialize();
    });

    testWidgets('Should display language options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: Scaffold(
            appBar: AppBar(
              actions: const [LanguageSwitcher()],
            ),
          ),
        ),
      );

      // Tap language switcher
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Check language options
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsOneWidget);
    });

    testWidgets('Should switch language when option selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: Scaffold(
            appBar: AppBar(
              title: Text('Test'),
              actions: const [LanguageSwitcher()],
            ),
            body: Center(
              child: Builder(
                builder: (context) => Text(context.t.authLogin),
              ),
            ),
          ),
        ),
      );

      // Initially should be in English
      expect(find.text('Login'), findsOneWidget);

      // Tap language switcher
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Select Indonesian
      await tester.tap(find.text('Bahasa Indonesia'));
      await tester.pumpAndSettle();

      // Should now be in Indonesian
      expect(find.text('Masuk'), findsOneWidget);
    });
  });
}
```

### Testing Best Practices

1. **Test All Supported Locales**: Always test with all supported languages
2. **Test Parameterized Strings**: Verify parameter substitution works correctly
3. **Test Dynamic Content**: Test widgets that change based on locale
4. **Test Locale Persistence**: Verify locale changes are persisted
5. **Test Edge Cases**: Test unsupported locales and fallback behavior
6. **Test UI Layout**: Ensure translated text fits in UI layouts

### Test Utilities

Create helper utilities for i18n testing:

```dart
// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usago/i18n/app_localizations.g.dart';

class TestHelpers {
  static Widget createTestWidget({
    required Widget child,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }

  static Future<void> pumpTestWidget(
    WidgetTester tester,
    Widget child, {
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(createTestWidget(child: child, locale: locale));
    await tester.pumpAndSettle();
  }

  static List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('id'),
  ];
}
```

### Automated Testing Workflow

Add to your CI/CD pipeline:

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'

    - name: Install dependencies
      run: flutter pub get

    - name: Generate translations
      run: flutter packages pub run slang_build_runner

    - name: Run tests
      run: flutter test --coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v3
```
#### Key Features:
- **Instant Updates**: Uses `ValueNotifier` for immediate UI updates
- **Background Persistence**: Saves locale preference without blocking UI
- **Toggle Functionality**: Quick toggle between supported languages
- **Singleton Pattern**: Ensures consistent locale state across the app
- **Dependency Injection**: Integrates with `LocaleService` for persistence

### Integration in Main App

The custom implementations are integrated in the main app:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final localeService = getIt<LocaleService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<BrandBloc>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: InstantThemeHelper.instance.themeNotifier,
        builder: (context, themeMode, child) {
          return ValueListenableBuilder<Locale>(
            valueListenable: InstantLocaleHelper.instance.localeNotifier,
            builder: (context, locale, child) {
              return MaterialApp.router(
                title: 'Usago',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: appRouter.config(),
                debugShowCheckedModeBanner: false,
                locale: locale, // Uses InstantLocaleHelper locale
                supportedLocales: localeService.getSupportedLocales(),
                localizationsDelegates: const [
                  AppLocalizationsDelegate(), // Custom delegate
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
```

### Language Switcher Widget

The `LanguageSwitcher` widget demonstrates how to use the InstantLocaleHelper:

```dart
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: InstantLocaleHelper.instance.localeNotifier,
      builder: (context, currentLocale, child) {
        return PopupMenuButton<Locale>(
          icon: const Icon(Icons.language),
          onSelected: (Locale locale) {
            InstantLocaleHelper.instance.changeLocale(locale);
          },
          itemBuilder: (BuildContext context) {
            return InstantLocaleHelper.instance.getSupportedLocales()
                .map((Locale locale) {
              return PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Text(
                      InstantLocaleHelper.instance.getLocaleDisplayName(locale),
                    ),
                    if (locale.languageCode == currentLocale.languageCode)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.check, color: Colors.blue),
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
```

### Benefits of Custom Implementation

1. **Instant Language Switching**: No delay when changing languages
2. **Centralized Locale Management**: Single source of truth for locale state
3. **Automatic UI Updates**: `ValueNotifier` ensures UI updates automatically
4. **Persistent Settings**: Language preference is saved and restored
5. **Clean Architecture**: Separation of concerns between UI and locale logic
6. **Testability**: Easy to mock and test locale changes
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save brand logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.t.brandCreatedSuccess)),
                );
              },
              child: Text(context.t.saveBrand),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Step 5: Test with Different Locales

Test your feature with all supported languages:

```dart
// In your test file
testWidgets('Brand page displays correctly in English', (tester) async {
  // Set locale to English
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const CreateBrandPage(),
    ),
  );

  // Verify English text
  expect(find.text('Brand Management'), findsOneWidget);
  expect(find.text('Brand Name'), findsOneWidget);
});

testWidgets('Brand page displays correctly in Indonesian', (tester) async {
  // Set locale to Indonesian
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('id'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const CreateBrandPage(),
    ),
  );

  // Verify Indonesian text
  expect(find.text('Manajemen Merek'), findsOneWidget);
  expect(find.text('Nama Merek'), findsOneWidget);
});
```

### Best Practices for New Features

1. **Consistent Naming**: Use consistent naming conventions across all language files
2. **Namespace Organization**: Group related translations under the same namespace
3. **Parameterized Strings**: Use parameterization for dynamic content
4. **Contextual Translations**: Consider context when translating (e.g., button vs. label)
5. **Testing**: Always test with all supported languages

### Translation Key Guidelines

#### Naming Conventions

```yaml
# Use snake_case for all keys
user_profile: User Profile
user_profile_edit: Edit User Profile

# Group related keys with namespaces
user:
  profile: User Profile
  settings: User Settings
  preferences: User Preferences

# Use descriptive names
button_save: Save
button_cancel: Cancel
error_network: Network Error
success_saved: Saved Successfully
```

#### Parameterized Translations

```yaml
# Use parameters for dynamic content
welcome_user: Welcome, {username}!
items_count: You have {count} items
date_format: {day}/{month}/{year}

# In Dart code
Text(context.t.welcomeUser(username: 'John'))
Text(context.t.itemsCount(count: 5))
Text(context.t.dateFormat(day: 18, month: 11, year: 2025))
```

#### Pluralization

```yaml
# Handle plural forms
items_count:
  zero: No items
  one: {count} item
  many: {count} items

# In Dart code
Text(context.t.itemsCount(count: 0)) // "No items"
Text(context.t.itemsCount(count: 1)) // "1 item"
Text(context.t.itemsCount(count: 5)) // "5 items"
```

### Step 6: Update UI Components

#### `lib/features/auth/presentation/pages/login_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../app/router.dart';
import '../../../../i18n/app_localizations.g.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.authLogin),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.router.replace(const HomeRoute());
          } else if (state is AuthFailure) {
            context.showErrorSnackBar(state.message);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    context.t.authWelcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.t.authSignInToContinue,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.t.authDontHaveAccount),
                      TextButton(
                        onPressed: () {
                          context.router.pushNamed('/register');
                        },
                        child: Text(context.t.authRegister),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

#### `lib/features/auth/presentation/widgets/login_form.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../i18n/app_localizations.g.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        context.read<AuthBloc>().add(LoginEvent(
          email: email,
          password: password,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: context.t.authEmail,
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (!value.isValidEmail) {
                return context.t.validationEmailInvalid;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.md),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: context.t.authPassword,
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (value.length < 6) {
                return context.t.validationPasswordTooShort;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Login button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: context.t.authLogin,
                isLoading: state is AuthLoading,
                onPressed: _submitForm,
              );
            },
          ),

          SizedBox(height: AppSpacing.md),

          // Forgot password link
          TextButton(
            onPressed: () {
              // TODO: Navigate to forgot password
            },
            child: Text(context.t.authForgotPassword),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Best Practices

### 1. Translation Organization
- Use nested namespaces for logical grouping
- Keep keys descriptive and consistent
- Use snake_case for all keys
- Group related strings together

### 2. Context Usage
- Always use `context.t` for accessing translations
- Pass context to widgets that need translations
- Avoid storing translated strings in state

### 3. Performance
- Use generated code (no runtime lookups)
- Cache frequently used translations if needed
- Avoid unnecessary rebuilds

### 4. Testing
- Test all supported languages
- Test language switching
- Test edge cases (missing translations)

### 5. Maintenance
- Keep translation files in sync
- Use descriptive comments for complex translations
- Document any special formatting requirements

---

## 🚀 Future Language Additions

### Adding a New Language (Example: Spanish)

1. **Update Configuration**
   ```yaml
   # lib/i18n/i18n.yaml
   base_locale: en
   locales: [en, id, es]  # Add 'es'
   ```

2. **Create Translation File**
   ```yaml
   # lib/i18n/es.i18n.yaml
   app:
     title: Usago
     welcome: Bienvenido

   auth:
     login: Iniciar sesión
     register: Registrarse
     # ... rest of translations
   ```

3. **Update Platform Configurations**
   - Android: Add to `locales_config.xml`
   - iOS: Add to `Info.plist`
   - Web: Update `index.html`

4. **Regenerate Code**
   ```bash
   flutter packages pub run slang_build_runner
   ```

5. **Update Locale Service**
   ```dart
   // lib/core/services/locale_service.dart
   String getLocaleDisplayName(Locale locale) {
     switch (locale.languageCode) {
       case 'en':
         return 'English';
       case 'id':
         return 'Bahasa Indonesia';
       case 'es':  // Add this
         return 'Español';
       default:
         return locale.toString();
     }
   }
   ```

### Automated Translation Workflow

1. **Extract New Strings**
   ```bash
   flutter packages pub run slang_build_runner --extract
   ```

2. **Update Translation Files**
   - Add new keys to all language files
   - Use translation tools or services
   - Review translations for accuracy

3. **Validate Translations**
   ```bash
   flutter packages pub run slang_build_runner --validate
   ```

---

## 🔧 Troubleshooting

### Common Issues

1. **Build Runner Not Working**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter packages get
   flutter packages pub run slang_build_runner --delete-conflicting-outputs
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Missing Translations**
   - Check if all keys exist in all language files
   - Run build runner with `--verbose` flag
   - Validate YAML syntax

3. **Language Not Changing**
   - Check if locale is supported
   - Verify locale service implementation
   - Check if app is rebuilt after locale change

4. **Platform-Specific Issues**
   - **Android**: Check `locales_config.xml`
   - **iOS**: Check `Info.plist` configuration
   - **Web**: Check browser language detection

### Debug Mode

Enable debug logging for Slang:

```dart
// In main.dart
void main() {
  // Enable debug mode for Slang
  SlangFlutter.enableDebugMode();

  runApp(const MyApp());
}
```

### Performance Monitoring

Monitor translation performance:

```dart
// Add to locale service
void _logTranslationPerformance(String key, Duration duration) {
  if (duration.inMilliseconds > 10) {
    _logger.warning('Slow translation: $key took ${duration.inMilliseconds}ms');
  }
}
```

---

## 📚 Additional Resources

- [Slang Documentation](https://pub.dev/packages/slang)
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Android Locale Configuration](https://developer.android.com/guide/topics/resources/app-languages)
- [iOS Localization](https://developer.apple.com/documentation/uikit/app_and_environment/localizing_your_app)

---

**Last Updated:** 2025-11-18
**Next Review:** After implementation completion
**Status:** Updated for Current Implementation