# Internationalization Guidelines

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Translation System Architecture](#translation-system-architecture)
3. [Using Translation System Correctly](#using-translation-system-correctly)
4. [Multi-Language Support Best Practices](#multi-language-support-best-practices)
5. [Locale-Based Error Messages](#locale-based-error-messages)
6. [Avoiding Hardcoded Text](#avoiding-hardcoded-text)
7. [Translation Key Organization](#translation-key-organization)
8. [Advanced Translation Features](#advanced-translation-features)
9. [Testing Internationalization](#testing-internationalization)
10. [Common Pitfalls](#common-pitfalls)

---

## 🎯 Overview

This guide provides comprehensive guidelines for implementing internationalization (i18n) in the Usago Flutter project. Following these practices ensures consistent, maintainable, and scalable multi-language support.

### Key Principles

1. **Never hardcode user-facing text**
2. **Always use translation system for UI text**
3. **Support dynamic locale switching**
4. **Maintain consistency across all languages**
5. **Test all supported languages**

---

## 🏗️ Translation System Architecture

### Slang Integration

We use Slang for type-safe internationalization:

```dart
// Translation files are generated into:
// lib/i18n/translations.g.dart
// lib/i18n/translations_en.g.dart
// lib/i18n/translations_id.g.dart

// Usage with context extension
Text(context.t.brandTitle)
Text(context.t.authLogin)
Text(context.t.validationRequired)
```

### Locale Management

```dart
// Core locale management
class InstantLocaleHelper {
  static InstantLocaleHelper get instance => _instance ??= InstantLocaleHelper._();

  final ValueNotifier<Locale> _localeNotifier = ValueNotifier<Locale>(const Locale('en'));

  // Get current locale
  Locale get currentLocale => _localeNotifier.value;

  // Change locale instantly
  Future<void> changeLocale(Locale locale) async {
    _localeNotifier.value = locale;
    await _localeService.changeLocale(locale);
  }
}
```

### Supported Languages

- **English (en)** - Default language
- **Indonesian (id)** - Secondary language

---

## 🔤 Using Translation System Correctly

### Basic Translation Usage

```dart
// ✅ GOOD - Using context extension
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.authLogin), // Using translation
      ),
      body: Column(
        children: [
          Text(context.t.authWelcomeBack),
          Text(context.t.authSignInToContinue),
        ],
      ),
    );
  }
}

// ❌ BAD - Hardcoded text
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Hardcoded! Wrong!
      ),
      body: Column(
        children: [
          Text('Welcome Back'), // Hardcoded! Wrong!
          Text('Sign in to continue'), // Hardcoded! Wrong!
        ],
      ),
    );
  }
}
```

### Translation in BLoC

```dart
// ✅ GOOD - Locale-aware BLoC messages
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.'
            : 'No internet connection. Please check your connection and try again.';
      case ValidationFailure:
        return failure.message; // Already localized
      default:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.'
            : 'An unexpected error occurred. Please try again.';
    }
  }
}

// ❌ BAD - Hardcoded BLoC messages
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred'; // Hardcoded! Wrong!
  }
}
```

### Dynamic Locale Detection

```dart
// ✅ GOOD - Dynamic locale-based content
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  Future<void> _onLoadAllBrandData(
    LoadAllBrandDataEvent event,
    Emitter<BrandListState> emit,
  ) async {
    // ... loading logic ...

    // Check if no brands exist
    if (userBrands.isEmpty && accessibleBrands.isEmpty) {
      final message = LocaleSettings.currentLocale == AppLocale.id
          ? 'Anda belum memiliki brand. Buat brand pertama Anda sekarang!'
          : 'You don\'t have any brands yet. Create your first brand now!';
      emit(BrandListEmpty(message: message));
    }
  }
}
```

---

## 🌍 Multi-Language Support Best Practices

### Translation File Structure

```yaml
# lib/i18n/en.i18n.yaml
app:
  title: Usago
  welcome: Welcome

auth:
  login: Login
  register: Register
  email: Email
  password: Password
  welcome_back: Welcome Back
  sign_in_to_continue: Sign in to continue
  dont_have_account: Don't have an account?
  already_have_account: Already have an account?

brand:
  title: Brand Management
  create_brand: Create Brand
  edit_brand: Edit Brand
  brand_name: Brand Name
  brand_description: Brand Description
  save_brand: Save Brand
  delete_brand: Delete Brand

validation:
  required: This field is required
  email_invalid: Please enter a valid email
  password_too_short: Password must be at least 6 characters
  password_too_long: Password must be less than 50 characters

messages:
  success: Operation completed successfully
  error: An error occurred
  network_error: Network error. Please check your connection.
  unknown_error: An unknown error occurred

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

```yaml
# lib/i18n/id.i18n.yaml
app:
  title: Usago
  welcome: Selamat Datang

auth:
  login: Masuk
  register: Daftar
  email: Email
  password: Kata Sandi
  welcome_back: Selamat Datang Kembali
  sign_in_to_continue: Masuk untuk melanjutkan
  dont_have_account: Belum punya akun?
  already_have_account: Sudah punya akun?

brand:
  title: Manajemen Merek
  create_brand: Buat Merek
  edit_brand: Edit Merek
  brand_name: Nama Merek
  brand_description: Deskripsi Merek
  save_brand: Simpan Merek
  delete_brand: Hapus Merek

validation:
  required: Field ini wajib diisi
  email_invalid: Masukkan email yang valid
  password_too_short: Kata sandi minimal 6 karakter
  password_too_long: Kata sandi maksimal 50 karakter

messages:
  success: Operasi berhasil diselesaikan
  error: Terjadi kesalahan
  network_error: Error jaringan. Periksa koneksi Anda.
  unknown_error: Terjadi error yang tidak diketahui

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

### Translation Key Naming Conventions

```yaml
# ✅ GOOD - Consistent naming
auth:
  login: Login
  register: Register
  forgot_password: Forgot Password?
  welcome_back: Welcome Back

validation:
  required: This field is required
  email_invalid: Please enter a valid email
  password_too_short: Password must be at least 6 characters

# ❌ BAD - Inconsistent naming
auth:
  login: Login
  register: Register
  forgotPassword: Forgot Password?  # camelCase instead of snake_case
  welcomeBack: Welcome Back        # camelCase instead of snake_case

validation:
  required: Required field          # Different structure
  email_invalid: Invalid email      # Different structure
  password_too_short: Password too short  # Different structure
```

### Parameterized Translations

```yaml
# lib/i18n/en.i18n.yaml
welcome_user: Welcome, {username}!
items_count: You have {count} {count, plural,
  zero {items}
  one {item}
  other {items}
}
date_format: {day}/{month}/{year}

# lib/i18n/id.i18n.yaml
welcome_user: Selamat datang, {username}!
items_count: Anda memiliki {count} {count, plural,
  zero {item}
  one {item}
  other {item}
}
date_format: {day}/{month}/{year}
```

```dart
// Usage in code
Text(context.t.welcomeUser(username: 'John'))
Text(context.t.itemsCount(count: 5))
Text(context.t.dateFormat(day: 18, month: 11, year: 2025))
```

---

## 💬 Locale-Based Error Messages

### Error Message Localization

```dart
// ✅ GOOD - Localized error messages
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return _getServerErrorMessage(failure as ServerFailure);
      case NetworkFailure:
        return _getNetworkErrorMessage();
      case ValidationFailure:
        return failure.message; // Already localized
      case BetterAuthFailure:
        return _getAuthErrorMessage();
      default:
        return _getDefaultErrorMessage();
    }
  }

  String _getServerErrorMessage(ServerFailure failure) {
    switch (failure.statusCode) {
      case 401:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Anda tidak memiliki izin untuk mengakses data brand'
            : 'You don\'t have permission to access brand data';
      case 403:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Akses ditolak. Anda tidak memiliki izin yang cukup.'
            : 'Access denied. You don\'t have sufficient permissions.';
      case 404:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Data brand tidak ditemukan'
            : 'Brand data not found';
      case 422:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Data yang dikirim tidak valid. Periksa kembali input Anda.'
            : 'Invalid data submitted. Please check your input.';
      case 500:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Terjadi kesalahan server. Silakan coba lagi nanti.'
            : 'Server error occurred. Please try again later.';
      default:
        return failure.message;
    }
  }

  String _getNetworkErrorMessage() {
    return LocaleSettings.currentLocale == AppLocale.id
        ? 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.'
        : 'No internet connection. Please check your connection and try again.';
  }

  String _getAuthErrorMessage() {
    return LocaleSettings.currentLocale == AppLocale.id
        ? 'Anda tidak memiliki izin untuk mengakses data brand'
        : 'You don\'t have permission to access brand data';
  }

  String _getDefaultErrorMessage() {
    return LocaleSettings.currentLocale == AppLocale.id
        ? 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.'
        : 'An unexpected error occurred. Please try again.';
  }
}
```

### Success Message Localization

```dart
// ✅ GOOD - Localized success messages
class BrandManagementBloc extends Bloc<BrandManagementEvent, BrandManagementState> {
  String _getSuccessMessage(String action) {
    final isIndonesian = LocaleSettings.currentLocale == AppLocale.id;

    switch (action) {
      case 'create':
        return isIndonesian ? 'Brand berhasil dibuat' : 'Brand created successfully';
      case 'update':
        return isIndonesian ? 'Brand berhasil diperbarui' : 'Brand updated successfully';
      case 'delete':
        return isIndonesian ? 'Brand berhasil dihapus' : 'Brand deleted successfully';
      default:
        return isIndonesian ? 'Operasi berhasil' : 'Operation successful';
    }
  }
}
```

---

## 🚫 Avoiding Hardcoded Text

### Complete UI Translation

```dart
// ✅ GOOD - Fully translated UI
class CreateBrandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.brandCreateBrand),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: context.t.brandName,
                hintText: context.t.brandNameHint,
                errorText: _nameError ? context.t.brandNameRequired : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: context.t.brandDescription,
                hintText: context.t.brandDescriptionHint,
                errorText: _descriptionError ? context.t.brandDescriptionRequired : null,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isFormValid ? _createBrand : null,
              child: Text(context.t.brandSaveBrand),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _cancel,
              child: Text(context.t.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ BAD - Mixed hardcoded and translated text
class CreateBrandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Brand'), // Hardcoded!
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Brand Name', // Hardcoded!
                hintText: 'Enter brand name', // Hardcoded!
                errorText: _nameError ? 'Brand name is required' : null, // Hardcoded!
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: context.t.brandDescription, // Mixed!
                hintText: 'Enter brand description', // Hardcoded!
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isFormValid ? _createBrand : null,
              child: Text(context.t.brandSaveBrand), // Mixed!
            ),
          ],
        ),
      ),
    );
  }
}
```

### Form Validation Messages

```dart
// ✅ GOOD - Localized validation
class BrandForm extends StatefulWidget {
  @override
  _BrandFormState createState() => _BrandFormState();
}

class _BrandFormState extends State<BrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return context.t.brandNameRequired;
    }
    if (value.length < 3) {
      return context.t.brandNameTooShort;
    }
    if (value.length > 50) {
      return context.t.brandNameTooLong;
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return context.t.brandDescriptionRequired;
    }
    if (value.length < 10) {
      return context.t.brandDescriptionTooShort;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: _validateName,
            decoration: InputDecoration(
              labelText: context.t.brandName,
              hintText: context.t.brandNameHint,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            validator: _validateDescription,
            decoration: InputDecoration(
              labelText: context.t.brandDescription,
              hintText: context.t.brandDescriptionHint,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
```

---

## 📁 Translation Key Organization

### Feature-Based Organization

```yaml
# ✅ GOOD - Organized by feature
auth:
  login: Login
  register: Register
  email: Email
  password: Password
  forgot_password: Forgot Password?
  welcome_back: Welcome Back
  sign_in_to_continue: Sign in to continue
  dont_have_account: Don't have an account?
  already_have_account: Already have an account?

brand:
  title: Brand Management
  create_brand: Create Brand
  edit_brand: Edit Brand
  delete_brand: Delete Brand
  brand_name: Brand Name
  brand_description: Brand Description
  save_brand: Save Brand
  brand_created_success: Brand created successfully
  brand_updated_success: Brand updated successfully
  brand_deleted_success: Brand deleted successfully
  confirm_delete_brand: Are you sure you want to delete this brand?

validation:
  required: This field is required
  email_invalid: Please enter a valid email
  password_too_short: Password must be at least 6 characters
  password_too_long: Password must be less than 50 characters
  name_too_short: Name must be at least 3 characters
  name_too_long: Name must be less than 50 characters

messages:
  success: Operation completed successfully
  error: An error occurred
  network_error: Network error. Please check your connection.
  unknown_error: An unknown error occurred
  operation_success: Operation successful
  operation_failed: Operation failed

common:
  ok: OK
  cancel: Cancel
  save: Save
  delete: Delete
  edit: Edit
  loading: Loading...
  retry: Retry
  close: Close
  yes: Yes
  no: No
  confirm: Confirm
```

### Hierarchical Organization

```yaml
# ✅ GOOD - Hierarchical structure
brand:
  # Page titles
  title: Brand Management
  create_title: Create Brand
  edit_title: Edit Brand

  # Form fields
  name: Brand Name
  description: Brand Description
  name_hint: Enter brand name
  description_hint: Enter brand description

  # Actions
  create: Create Brand
  update: Update Brand
  delete: Delete Brand
  save: Save Brand
  cancel: Cancel

  # Messages
  created_success: Brand created successfully
  updated_success: Brand updated successfully
  deleted_success: Brand deleted successfully
  confirm_delete: Are you sure you want to delete this brand?

  # Validation
  name_required: Brand name is required
  description_required: Brand description is required
  name_too_short: Brand name must be at least 3 characters
  name_too_long: Brand name must be less than 50 characters

# ❌ BAD - Flat structure
brand_title: Brand Management
brand_create: Create Brand
brand_edit: Edit Brand
brand_name: Brand Name
brand_description: Brand Description
brand_save: Save Brand
brand_created_success: Brand created successfully
brand_name_required: Brand name is required
# ... and so on, becomes hard to manage
```

---

## 🔧 Advanced Translation Features

### Pluralization

```yaml
# lib/i18n/en.i18n.yaml
items_count:
  zero: No items
  one: {count} item
  other: {count} items

brands_count:
  zero: You have no brands
  one: You have {count} brand
  other: You have {count} brands

# lib/i18n/id.i18n.yaml
items_count:
  zero: Tidak ada item
  one: {count} item
  other: {count} item

brands_count:
  zero: Anda tidak memiliki brand
  one: Anda memiliki {count} brand
  other: Anda memiliki {count} brand
```

```dart
// Usage
Text(context.t.itemsCount(count: 0)) // "No items" / "Tidak ada item"
Text(context.t.itemsCount(count: 1)) // "1 item" / "1 item"
Text(context.t.itemsCount(count: 5)) // "5 items" / "5 item"

Text(context.t.brandsCount(count: 0)) // "You have no brands" / "Anda tidak memiliki brand"
Text(context.t.brandsCount(count: 1)) // "You have 1 brand" / "Anda memiliki 1 brand"
Text(context.t.brandsCount(count: 3)) // "You have 3 brands" / "Anda memiliki 3 brand"
```

### Context-Aware Translations

```yaml
# lib/i18n/en.i18n.yaml
brand:
  actions:
    create: Create Brand
    update: Update Brand
    delete: Delete Brand
  navigation:
    brands: Brands
    create_new: Create New Brand
  messages:
    empty: No brands found
    loading: Loading brands...

# lib/i18n/id.i18n.yaml
brand:
  actions:
    create: Buat Brand
    update: Perbarui Brand
    delete: Hapus Brand
  navigation:
    brands: Brand
    create_new: Buat Brand Baru
  messages:
    empty: Tidak ada brand ditemukan
    loading: Memuat brand...
```

```dart
// Usage with context
Text(context.t.brand.actions.create)
Text(context.t.brand.navigation.brands)
Text(context.t.brand.messages.empty)
```

### Date and Number Formatting

```dart
// ✅ GOOD - Localized formatting
class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(brand.createdAt);
    final formattedCount = _formatCount(brand.employeeCount);

    return Card(
      child: ListTile(
        title: Text(brand.name),
        subtitle: Text(
          context.t.brandInfo(
            createdDate: formattedDate,
            employeeCount: formattedCount,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final isIndonesian = LocaleSettings.currentLocale == AppLocale.id;

    if (isIndonesian) {
      return '${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatCount(int count) {
    final isIndonesian = LocaleSettings.currentLocale == AppLocale.id;

    if (isIndonesian) {
      return '$count karyawan';
    } else {
      return '$count employees';
    }
  }
}
```

---

## 🧪 Testing Internationalization

### Unit Testing Translations

```dart
void main() {
  group('Translation Tests', () {
    test('English translations should return correct values', () {
      final localizations = const AppLocalizations();

      expect(localizations.authLogin, 'Login');
      expect(localizations.authRegister, 'Register');
      expect(localizations.validationRequired, 'This field is required');
      expect(localizations.brandTitle, 'Brand Management');
    });

    test('Indonesian translations should return correct values', () {
      final localizations = const AppLocalizationsId();

      expect(localizations.authLogin, 'Masuk');
      expect(localizations.authRegister, 'Daftar');
      expect(localizations.validationRequired, 'Field ini wajib diisi');
      expect(localizations.brandTitle, 'Manajemen Merek');
    });

    test('Parameterized translations should work correctly', () {
      final enLocalizations = const AppLocalizations();
      final idLocalizations = const AppLocalizationsId();

      expect(
        enLocalizations.welcomeUser(username: 'John'),
        'Welcome, John!',
      );
      expect(
        idLocalizations.welcomeUser(username: 'John'),
        'Selamat datang, John!',
      );
    });
  });
}
```

### Widget Testing with Locales

```dart
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
  });
}
```

### BLoC Testing with Locales

```dart
void main() {
  group('BrandListBloc Localization Tests', () {
    late BrandListBloc bloc;
    late MockGetUserBrandsUseCase mockGetUserBrandsUseCase;

    setUp(() {
      mockGetUserBrandsUseCase = MockGetUserBrandsUseCase();

      bloc = BrandListBloc(
        getUserBrandsUseCase: mockGetUserBrandsUseCase,
        getAccessibleBrandsUseCase: MockGetAccessibleBrandsUseCase(),
        getActiveBrandUseCase: MockGetActiveBrandUseCase(),
      );
    });

    tearDown(() => bloc.close());

    blocTest<BrandListBloc, BrandListState>(
      'emits localized error message for network failure in English',
      setUp: () {
        LocaleSettings.currentLocale = AppLocale.en;
        when(() => mockGetUserBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Left(NetworkFailure('No internet')));
      },
      act: (bloc) => bloc.add(const LoadUserBrandsEvent()),
      expect: () => [
        const BrandListLoading(),
        BrandListError(
          message: 'No internet connection. Please check your connection and try again.',
          errorCode: 'NETWORK_ERROR',
        ),
      ],
    );

    blocTest<BrandListBloc, BrandListState>(
      'emits localized error message for network failure in Indonesian',
      setUp: () {
        LocaleSettings.currentLocale = AppLocale.id;
        when(() => mockGetUserBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Left(NetworkFailure('No internet')));
      },
      act: (bloc) => bloc.add(const LoadUserBrandsEvent()),
      expect: () => [
        const BrandListLoading(),
        BrandListError(
          message: 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.',
          errorCode: 'NETWORK_ERROR',
        ),
      ],
    );
  });
}
```

---

## ⚠️ Common Pitfalls

### 1. Hardcoded Text in UI

```dart
// ❌ WRONG
Text('Create Brand')
ElevatedButton(
  onPressed: () {},
  child: Text('Save'),
)

// ✅ RIGHT
Text(context.t.brandCreateBrand)
ElevatedButton(
  onPressed: () {},
  child: Text(context.t.brandSave),
)
```

### 2. Missing Translations

```dart
// ❌ WRONG - Missing Indonesian translation
// en.i18n.yaml
brand:
  new_feature: New Feature

// id.i18n.yaml
brand:
  # Missing new_feature key!

// ✅ RIGHT - Complete translations
// en.i18n.yaml
brand:
  new_feature: New Feature

// id.i18n.yaml
brand:
  new_feature: Fitur Baru
```

### 3. Inconsistent Key Names

```dart
// ❌ WRONG - Inconsistent naming
auth:
  login: Login
  register: Register
  forgotPassword: Forgot Password  # camelCase

validation:
  required: This field is required
  emailInvalid: Invalid email  # camelCase

// ✅ RIGHT - Consistent snake_case
auth:
  login: Login
  register: Register
  forgot_password: Forgot Password  # snake_case

validation:
  required: This field is required
  email_invalid: Invalid email  # snake_case
```

### 4. Hardcoded Error Messages in BLoC

```dart
// ❌ WRONG
String _mapFailureToMessage(Failure failure) {
  return 'An error occurred'; // Hardcoded!
}

// ✅ RIGHT
String _mapFailureToMessage(Failure failure) {
  return LocaleSettings.currentLocale == AppLocale.id
      ? 'Terjadi kesalahan'
      : 'An error occurred';
}
```

### 5. Not Testing All Languages

```dart
// ❌ WRONG - Only testing English
testWidgets('Should display login form', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'), // Only English!
      home: const LoginPage(),
    ),
  );

  expect(find.text('Login'), findsOneWidget);
});

// ✅ RIGHT - Testing all supported languages
for (final locale in [const Locale('en'), const Locale('id')]) {
  testWidgets('Should display login form in ${locale.languageCode}', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
        ],
        home: const LoginPage(),
      ),
    );

    final expectedText = locale.languageCode == 'en' ? 'Login' : 'Masuk';
    expect(find.text(expectedText), findsOneWidget);
  });
}
```

---

## 📝 Summary Checklist

### Translation Implementation
- [ ] Always use `context.t.key` for user-facing text
- [ ] Never hardcode strings in UI components
- [ ] Use locale-based messages in BLoC error handling
- [ ] Organize translation keys by feature and purpose
- [ ] Use consistent naming conventions (snake_case)

### Multi-Language Support
- [ ] Maintain complete translations for all supported languages
- [ ] Use hierarchical organization for complex features
- [ ] Implement parameterized translations for dynamic content
- [ ] Use pluralization for count-based messages
- [ ] Test with all supported locales

### Error Message Localization
- [ ] Localize all error messages in BLoC
- [ ] Use dynamic locale detection
- [ ] Handle different error types with appropriate messages
- [ ] Provide context-specific error messages
- [ ] Include error codes for debugging

### Testing
- [ ] Write unit tests for all translation keys
- [ ] Test widgets with different locales
- [ ] Test BLoC error messages with different locales
- [ ] Test parameterized translations
- [ ] Test pluralization rules

### Maintenance
- [ ] Keep translation files in sync
- [ ] Review translations for consistency
- [ ] Update documentation when adding new languages
- [ ] Use automation scripts for validation
- [ ] Regular testing with all languages

---

**Last Updated:** November 20, 2025
**Next Review:** After adding new language support
**Status:** Active Implementation Guide
**Version:** 1.0.0

---

*This guide should be updated regularly as new translation patterns emerge and new languages are added.*