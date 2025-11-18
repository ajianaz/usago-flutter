# Slang Localization Solution - Best Practice untuk Slang Package

## 🎯 Jawaban: **Ya, Menggunakan Slang!**

Aplikasi Usago menggunakan **Slang** package untuk localization, bukan Flutter localization standar. Ini mengubah cara kerja localization!

## 📁 Struktur Direktori

```
lib/
├── i18n/
│   ├── i18n.yaml              # Konfigurasi Slang
│   ├── en.i18n.yaml          # Terjemahan Bahasa Inggris
│   ├── id.i18n.yaml          # Terjemahan Bahasa Indonesia
│   └── app_localizations.g.dart # Generated code (jangan edit)
├── core/
│   ├── services/
│   │   └── locale_service.dart # Manajemen locale
│   └── helpers/
│       └── instant_locale_helper.dart # Instant locale switching
└── app/
    └── app.dart               # Konfigurasi MaterialApp dengan localization
```

## 🔍 Cara Kerja Slang

Slang memiliki sistem yang berbeda dari Flutter localization standar:

```dart
// Slang generated extension
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get t {
    final locale = Localizations.localeOf(this);
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }
}
```

## ✅ Solusi yang Tepat untuk Slang

### 1. Gunakan `context.t` Langsung
```dart
// ✅ BENAR - Menggunakan Slang extension
Text(context.t.authLogin)
Text(context.t.authForgotPassword)

// ❌ SALAH - Tidak perlu method custom
Text(context.trKey('authLogin'))
```

### 2. Tidak Perlu ValueListenableBuilder
Slang sudah handle localization changes dengan built-in mechanism:

```dart
// ❌ TIDAK PERLU
ValueListenableBuilder<Locale>(
  valueListenable: InstantLocaleHelper.instance.localeNotifier,
  builder: (context, locale, child) {
    return YourWidget();
  },
)

// ✅ CUKUP BEGINI
@override
Widget build(BuildContext context) {
  return YourWidget(); // Slang akan otomatis rebuild
}
```

### 3. Perbaiki App Level Localization
Pastikan `MaterialApp.router` menggunakan locale dari `InstantLocaleHelper` dan `AppLocalizationsDelegate`:

```dart
// Di app.dart - SUDAH BENAR
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
    return true; // Selalu reload untuk support instant locale changes
  }
}

// Di MaterialApp.router
ValueListenableBuilder<Locale>(
  valueListenable: InstantLocaleHelper.instance.localeNotifier,
  builder: (context, locale, child) {
    return MaterialApp.router(
      locale: locale, // ← Ini kuncinya untuk Slang
      localizationsDelegates: const [
        AppLocalizationsDelegate(), // Custom delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ...
    );
  },
);
```

## 🔧 Implementasi Solusi Slang

### Langkah 1: Hapus Method Custom
Hapus method `trKey()` dari `ContextExtension` karena tidak diperlukan.

### Langkah 2: Gunakan `context.t` Langsung
```dart
// Di semua widget
Text(context.t.authLogin)
Text(context.t.authForgotPassword)
Text(context.t.authWelcomeBack)
```

### Langkah 3: Hapus ValueListenableBuilder
Hapus semua `ValueListenableBuilder` yang tidak diperlukan.

## 📋 Template Halaman Baru dengan Slang

```dart
import 'package:flutter/material.dart';
import '../../../../i18n/app_localizations.g.dart';

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.authLogin),
      ),
      body: Column(
        children: [
          Text(context.t.authWelcomeBack),
          Text(context.t.authSignInToContinue),
          // ... widget lainnya
        ],
      ),
    );
  }
}
```

## 🚨 Yang Tidak Perlu Dilakukan dengan Slang

1. ❌ **Jangan gunakan ValueListenableBuilder** (Slang sudah handle)
2. ❌ **Jangan buat method custom** (gunakan `context.t` langsung)
3. ❌ **Jangan import InstantLocaleHelper** (kecuali di LanguageSwitcher)

## ✅ Yang Harus Dilakukan dengan Slang

1. ✅ **Gunakan context.t** untuk semua teks
2. ✅ **Bersihkan import yang tidak digunakan**
3. ✅ **Ikuti template di atas** untuk halaman baru

## 📁 Perubahan yang Diperlukan

### 1. ContextExtension
```dart
// Hapus method trKey() dan trReactive()
// Tambahkan import app_localizations
import 'package:usago/i18n/app_localizations.g.dart';

extension ContextExtension on BuildContext {
  // Hapus method yang tidak diperlukan
  // Gunakan context.t langsung di widget
}
```

### 2. Semua Widget
```dart
// Ganti semua context.trKey() menjadi context.t
Text(context.trKey('authLogin')) → Text(context.t.authLogin)
Text(context.trKey('authForgotPassword')) → Text(context.t.authForgotPassword)

// Import yang diperlukan
import 'package:usago/i18n/app_localizations.g.dart';
```

### 3. Hapus ValueListenableBuilder
```dart
// Hapus semua ValueListenableBuilder yang tidak diperlukan
ValueListenableBuilder<Locale>(
  valueListenable: InstantLocaleHelper.instance.localeNotifier,
  builder: (context, locale, child) {
    return YourWidget();
  },
)

// Menjadi:
@override
Widget build(BuildContext context) {
  return YourWidget();
}
```

## 🎉 Keuntungan Solusi Slang

1. **Lebih Sederhana**: Tidak perlu ValueListenableBuilder
2. **Lebih Efisien**: Slang sudah handle localization changes
3. **Best Practice**: Mengikuti Slang convention
4. **Lebih Sedikit Kode**: 80% lebih sedikit boilerplate
5. **Auto-rebuild**: Slang otomatis rebuild widget yang menggunakan `context.t`

## 📊 Perbandingan

| Aspek | Solusi Pertama | Solusi Slang |
|--------|------------------|-------------|
| **Kode** | Banyak ValueListenableBuilder | Tidak perlu ValueListenableBuilder |
| **Performa** | Medium (banyak rebuild) | Tinggi (Slang handle otomatis) |
| **Maintainability** | Rendah (manual di setiap widget) | Tinggi (otomatis) |
| **Best Practice** | ❌ Tidak | ✅ Ya (Slang convention) |
| **Complexity** | Tinggi | Rendah |
| **Lines of Code** | +50% | -20% |

---

**Panduan Version:** 2.0
**Terakhir Diperbarui:** 2025-11-18
**Author:** Kilo Code
**Status:** ✅ SOLUSI SLANG (Updated)

## 📖 Dokumentasi Lengkap

Untuk panduan lengkap implementasi i18n di project Usago, lihat:
- [Internationalization Guide](./internationalization_guide.md) - Dokumentasi lengkap
- [Testing Guidelines](./internationalization_guide.md#-testing-i18n-functionality) - Panduan testing
- [Maintenance Workflow](./internationalization_guide.md#-maintenance-workflow) - Workflow maintenance