# Panduan Implementasi Cross-Platform Storage

## 📋 Overview

Dokumen ini memberikan panduan lengkap untuk implementasi cross-platform storage di aplikasi Usago. Storage system ini dirancang untuk bekerja secara konsisten di iOS, Android, Web, dan Desktop dengan mempertimbangkan keamanan dan performa optimal untuk setiap platform.

---

## 🏗️ Arsitektur Cross-Platform Storage

### Komponen Utama

```
SecureStorageService
├── PlatformStorageInterface (Abstract Interface)
├── MobileSecureStorage (iOS/Android)
├── WebSecureStorage (Web dengan Enkripsi)
├── DesktopSecureStorage (Windows/Linux/macOS)
└── _FallbackSecureStorage (SharedPreferences fallback)
```

### Platform Detection

System menggunakan `PlatformDetector` untuk mengidentifikasi platform saat runtime dan memilih implementasi storage yang sesuai:

```dart
// Deteksi platform otomatis
if (PlatformDetector.isMobile) {
  // Gunakan MobileSecureStorage
} else if (PlatformDetector.isWeb) {
  // Gunakan WebSecureStorage
} else if (PlatformDetector.isDesktop) {
  // Gunakan DesktopSecureStorage
}
```

---

## 📱 Platform-Specific Implementations

### Mobile (iOS/Android)

**Teknologi**: FlutterSecureStorage

**iOS Configuration**:
- Keychain dengan `first_unlock` accessibility
- Account name: `usago_app`
- Tidak sinkronisasi dengan iCloud

**Android Configuration**:
- EncryptedSharedPreferences
- RSA encryption dengan OAEP padding
- AES-GCM untuk storage encryption

```dart
// Contoh implementasi mobile
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'jwt_token_value');
```

### Web

**Teknologi**: SharedPreferences + Custom Encryption

**Security Features**:
- XOR cipher dengan SHA-256 key derivation
- Browser fingerprinting untuk key generation
- Base64 encoding untuk storage
- Prefix-based key isolation

**Limitations**:
- Tidak ada hardware security module (HSM)
- Rentan terhadap XSS attacks
- Encryption strength terbatas

```dart
// Web otomatis menggunakan encrypted storage
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'jwt_token_value'); // Otomatis terenkripsi
```

### Desktop (Windows/Linux/macOS)

**Teknologi**: FlutterSecureStorage dengan platform backends

**Windows**: DPAPI (Data Protection API)
**Linux**: libsecret/GNOME Keyring
**macOS**: Keychain (mirip iOS)

```dart
// Desktop otomatis menggunakan platform secure storage
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'jwt_token_value');
```

---

## 🔧 Setup dan Konfigurasi

### Dependencies

Tambahkan dependencies berikut di `pubspec.yaml`:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  crypto: ^3.0.3
```

### Platform-Specific Setup

#### iOS

Tambahkan konfigurasi di `ios/Runner/Info.plist`:

```xml
<key>NSKeychainUsageDescription</key>
<string>We need access to keychain to securely store your authentication tokens.</string>
```

#### Android

Tambahkan permissions di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

#### Web

Tidak ada setup khusus required, namun pastikan HTTPS untuk production.

#### Desktop

**Windows**: Tidak ada setup khusus
**Linux**: Install libsecret development packages:
```bash
sudo apt-get install libsecret-1-dev
```

**macOS**: Tidak ada setup khusus

---

## 💻 Penggunaan Dasar

### Inisialisasi

```dart
import 'package:your_app/core/services/secure_storage_service.dart';

class AuthService {
  late SecureStorageService _storage;

  Future<void> initialize() async {
    _storage = SecureStorageService();
    await _storage.initialize();
  }
}
```

### Menyimpan Data

```dart
// Data sensitif (default secure)
await _storage.save('auth_token', 'jwt_token');

// Data non-sensitif
await _storage.save('user_preferences', {'theme': 'dark'}, isSecure: false);

// Data kompleks (Map/List)
await _storage.save('user_profile', {
  'name': 'John Doe',
  'email': 'john@example.com',
  'settings': {'notifications': true}
});
```

### Membaca Data

```dart
// Baca string
final token = await _storage.get<String>('auth_token');

// Baca Map
final preferences = await _storage.get<Map<String, dynamic>>('user_preferences');

// Baca dengan type safety
final profile = await _storage.get<Map<String, dynamic>>('user_profile');
```

### Menghapus Data

```dart
// Hapus spesifik key
await _storage.remove('auth_token');

// Hapus semua data
await _storage.clearAll();
```

### Check Key Existence

```dart
final hasToken = await _storage.containsKey('auth_token');
if (hasToken) {
  // User sudah login
}
```

---

## 🔒 Security Best Practices

### Data Classification

System otomatis mengklasifikasikan data sebagai sensitif jika:

- Key mengandung: 'token', 'password', 'secret', 'key'
- Key ada di daftar sensitive keys
- Explicitly marked sebagai secure via `isSecure: true`

### Sensitive Keys

```dart
static const String authTokenKey = 'auth_token';
static const String bearerTokenKey = 'bearer_token';
static const String refreshTokenKey = 'refresh_token';
static const String sessionDataKey = 'session_data';
static const String biometricEnabledKey = 'biometric_enabled';
```

### Security Levels

| Platform | Security Level | Teknologi |
|----------|---------------|-----------|
| iOS | ⭐⭐⭐⭐⭐ (Tertinggi) | Keychain |
| Android | ⭐⭐⭐⭐⭐ (Tertinggi) | EncryptedSharedPreferences |
| Desktop | ⭐⭐⭐⭐ (Tinggi) | Platform Secure Storage |
| Web | ⭐⭐⭐ (Baik) | Encrypted localStorage |

---

## 🚀 Advanced Usage

### Platform-Specific Operations

```dart
import 'package:your_app/core/services/platform_detector.dart';

Future<void> performPlatformSpecificOperations() async {
  if (PlatformDetector.isMobile) {
    // Mobile-specific operations
    print('Using hardware-backed secure storage');
  } else if (PlatformDetector.isWeb) {
    // Web-specific operations
    print('Using encrypted web storage');
  } else if (PlatformDetector.isDesktop) {
    // Desktop-specific operations
    print('Using system secure storage');
  }
}
```

### Migration dari SharedPreferences

```dart
// Migrasi data lama ke secure storage
await _storage.migrateFromSharedPreferences();
```

### Error Handling

```dart
try {
  await _storage.save('auth_token', token);
} catch (e) {
  // Handle error
  print('Failed to save auth token: $e');
  // Fallback logic
}
```

### Performance Optimization

```dart
// Gunakan non-secure storage untuk data besar/non-sensitif
await _storage.save('large_dataset', largeData, isSecure: false);

// Batch operations untuk performa lebih baik
final operations = [
  _storage.save('key1', 'value1'),
  _storage.save('key2', 'value2'),
  _storage.save('key3', 'value3'),
];
await Future.wait(operations);
```

---

## 🧪 Testing

### Unit Testing

```dart
void main() {
  group('SecureStorageService', () {
    late SecureStorageService storage;

    setUp(() async {
      storage = SecureStorageService();
      await storage.initialize();
    });

    test('should save and retrieve data', () async {
      await storage.save('test_key', 'test_value');
      final value = await storage.get<String>('test_key');
      expect(value, equals('test_value'));
    });
  });
}
```

### Platform Testing

Test pada semua target platforms:
- iOS Simulator/Device
- Android Emulator/Device
- Web browsers (Chrome, Firefox, Safari)
- Desktop (Windows, Linux, macOS)

### Security Testing

- Verifikasi encryption works correctly
- Test fallback mechanisms
- Validate data isolation
- Check for data leakage

---

## 📊 Performance Considerations

### Mobile
- ✅ Fast access to hardware security modules
- ✅ Optimized for battery usage
- ✅ Minimal overhead

### Web
- ⚠️ Encryption/decryption overhead
- ⚠️ Browser storage limitations
- ⚠️ Network-dependent untuk beberapa operasi

### Desktop
- ✅ System-level encryption overhead
- ✅ File system-based operations
- ✅ Generally fastest untuk large datasets

---

## 🔍 Troubleshooting

### Common Issues

#### Initialization Fails
```dart
// Check platform support
if (!PlatformDetector.isSecureStorageSupported) {
  // Handle unsupported platform
}
```

#### Data Not Persisting
```dart
// Verify storage backend
final platform = PlatformDetector.platformName;
print('Current platform: $platform');
```

#### Performance Issues
```dart
// Use non-secure storage untuk large data
await storage.save('large_data', data, isSecure: false);
```

### Debug Logging

```dart
final storage = SecureStorageService(
  logger: AppLogger(level: LogLevel.debug)
);
```

---

## 📈 Monitoring dan Analytics

### Storage Usage Tracking

```dart
// Monitor storage operations
class StorageMonitor {
  static void logOperation(String operation, String key, bool isSecure) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $operation: $key (secure: $isSecure)');
  }
}
```

### Performance Metrics

```dart
// Track performance
final stopwatch = Stopwatch()..start();
await storage.save('test_key', 'test_value');
print('Save operation took: ${stopwatch.elapsedMilliseconds}ms');
```

---

## 🔄 Migration Guide

### Dari SharedPreferences

```dart
// Step 1: Initialize secure storage
final secureStorage = SecureStorageService();
await secureStorage.initialize();

// Step 2: Migrate existing data
await secureStorage.migrateFromSharedPreferences();

// Step 3: Update code untuk menggunakan SecureStorageService
```

### Dari Platform-Specific Storage

```dart
// Example: Migration dari flutter_secure_storage langsung
// Old code:
// final oldStorage = FlutterSecureStorage();
// await oldStorage.write(key: 'token', value: token);

// New code:
// final newStorage = SecureStorageService();
// await newStorage.initialize();
// await newStorage.save('token', token);
```

---

## 📚 Referensi

- [Flutter Secure Storage Package](https://pub.dev/packages/flutter_secure_storage)
- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)
- [Platform Detection Documentation](./platform_detection_guide.md)
- [Security Considerations](./platform_security_considerations.md)

---

**Last Updated**: November 21, 2025
**Version**: 1.0.0
**Next Review**: November 28, 2025

---

*Go Digital, Grow Together.*