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
          input_directory: lib/l10n
          output_directory: lib/l10n
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
├── l10n/
│   ├── i18n.yaml              # Configuration
│   ├── en.i18n.yaml          # English translations
│   ├── id.i18n.yaml          # Indonesian translations
│   ├── app_localizations.g.dart # Generated (don't edit)
│   └── app_locale.dart         # Generated enum
├── core/
│   └── services/
│       └── locale_service.dart # Locale management
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

#### `lib/l10n/i18n.yaml`
```yaml
base_locale: en
locales: [en, id]
```

#### `lib/l10n/en.i18n.yaml`
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

#### `lib/l10n/id.i18n.yaml`
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
import 'package:slang_flutter/slang_flutter.dart';
import '../core/di/injection_container.dart';
import '../core/services/locale_service.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeService = getIt<LocaleService>();

    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: FlutterLocalizationApp(
        supportedLocales: localeService.getSupportedLocales(),
        locale: localeService.getCurrentLocale(),
        builder: (context, localization) {
          return MaterialApp.router(
            title: 'Usago',
            theme: ThemeData(useMaterial3: true),
            routerConfig: AppRouter().config(),
            locale: localization.locale,
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
          );
        },
      ),
    );
  }
}
```

### Step 6: Update UI Components

#### `lib/features/auth/presentation/pages/login_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:slang_flutter/slang_flutter.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../app/router.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.auth.login),
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
                    context.t.auth.welcome_back,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.t.auth.sign_in_to_continue,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.t.auth.dont_have_account),
                      TextButton(
                        onPressed: () {
                          context.router.pushNamed('/register');
                        },
                        child: Text(context.t.auth.register),
                      ),
                    ],
                    ),
                  ],
                ),
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
import 'package:slang_flutter/slang_flutter.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';

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
              labelText: context.t.auth.email,
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validation.required;
              }
              if (!value.isValidEmail) {
                return context.t.validation.email_invalid;
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
              labelText: context.t.auth.password,
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
                return context.t.validation.required;
              }
              if (value.length < 6) {
                return context.t.validation.password_too_short;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Login button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: context.t.auth.login,
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
            child: Text(context.t.auth.forgot_password),
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
   # lib/l10n/i18n.yaml
   base_locale: en
   locales: [en, id, es]  # Add 'es'
   ```

2. **Create Translation File**
   ```yaml
   # lib/l10n/es.i18n.yaml
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

**Last Updated:** 2025-11-12
**Next Review:** After implementation completion
**Status:** Ready for Implementation