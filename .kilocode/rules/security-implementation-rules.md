# Security Implementation Rules
# Aturan Implementasi Keamanan

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-SECURITY-IMPLEMENTATION |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | Security Rules |
| **Priority** | Critical |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Security Team, Tech Lead |
| **Stakeholders** | Development Team, QA Team, Security Team |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan aturan dan pedoman implementasi keamanan yang wajib diikuti dalam pengembangan aplikasi Usago Mobile. Aturan ini berdasarkan best practices keamanan dan implementasi yang ada di [`../docs/06-operations/security-implementation.md`](../docs/06-operations/security-implementation.md).

---

## 📚 **Table of Contents**

1. [Encryption Rules](#encryption-rules)
2. [Key Management Rules](#key-management-rules)
3. [Authentication Security Rules](#authentication-security-rules)
4. [Network Security Rules](#network-security-rules)
5. [Data Protection Rules](#data-protection-rules)
6. [Storage Security Rules](#storage-security-rules)
7. [Code Security Rules](#code-security-rules)
8. [Security Testing Rules](#security-testing-rules)

---

## 🔐 **Encryption Rules**

### **Rule 1.1: Mandatory Encryption untuk Sensitive Data**

Semua sensitive data WAJIB dienkripsi sebelum disimpan:

```dart
// ✅ BENAR: Gunakan EnhancedSecureStorageService
class UserDataRepository {
  Future<void> saveUserCredentials(UserCredentials credentials) async {
    final encryptedData = await _encryptionService.encrypt(
      jsonEncode(credentials.toJson()),
      _getEncryptionKey(),
    );

    await _secureStorage.storeSecureData('user_credentials', encryptedData);
  }
}

// ❌ SALAH: Simpan data tanpa enkripsi
class InsecureUserDataRepository {
  Future<void> saveUserCredentials(UserCredentials credentials) async {
    await _preferences.setString('user_credentials', jsonEncode(credentials.toJson()));
  }
}
```

### **Rule 1.2: Gunakan AES-256-GCM untuk Enkripsi**

WAJIB menggunakan algoritma AES-256-GCM untuk semua enkripsi:

```dart
// ✅ BENAR: AES-256-GCM dengan IV random
class SecureEncryption {
  Future<String> encrypt(String data, String key) async {
    final iv = _generateRandomIV(16); // 16 bytes IV
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.gcm));
    final encrypted = encrypter.encryptBytes(data.codeUnits, iv: IV(iv));
    return base64.encode(iv + encrypted.bytes);
  }
}

// ❌ SALAH: Algoritma lemah atau tidak ada IV
class InsecureEncryption {
  Future<String> encrypt(String data, String key) async {
    // Tidak ada IV, algoritma lemah
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    final encrypted = encrypter.encrypt(data);
    return encrypted.base64;
  }
}
```

### **Rule 1.3: Integritas Data dengan HMAC**

Semua encrypted data WAJIB memiliki integrity check dengan HMAC:

```dart
// ✅ BENAR: HMAC untuk integritas data
class DataIntegrityService {
  String signData(String data, String key) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(data));
    return base64.encode(digest.bytes);
  }

  bool verifyData(String data, String signature, String key) {
    final expectedSignature = signData(data, key);
    return signature == expectedSignature;
  }
}

// ❌ SALAH: Tidak ada integrity check
class InsecureDataStorage {
  Future<void> storeData(String key, String data) async {
    // Data bisa diubah tanpa deteksi
    await _storage.write(key: key, value: data);
  }
}
```

---

## 🔑 **Key Management Rules**

### **Rule 2.1: Key Rotation Setiap 30 Hari**

Encryption keys WAJIB di-rotasi setiap 30 hari:

```dart
// ✅ BENAR: Implementasi key rotation otomatis
class KeyRotationManager {
  Future<void> performKeyRotation() async {
    final lastRotation = await _getLastRotationDate();
    final now = DateTime.now();

    if (now.difference(lastRotation).inDays >= 30) {
      await _rotateAllKeys();
      await _updateLastRotationDate(now);
    }
  }
}

// ❌ SALAH: Tidak ada key rotation
class StaticKeyManager {
  static const String encryptionKey = 'hardcoded_key'; // Security risk!
}
```

### **Rule 2.2: Secure Key Generation**

Keys WAJIB di-generate dengan cryptographically secure random:

```dart
// ✅ BENAR: Secure key generation
class SecureKeyGenerator {
  String generateSecureKey(int length) {
    final random = Random.secure();
    final keyBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64.encode(keyBytes);
  }
}

// ❌ SALAH: Weak key generation
class WeakKeyGenerator {
  String generateKey() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // Predictable!
  }
}
```

### **Rule 2.3: Key Storage dengan Hardware Security**

Jika tersedia, gunakan hardware-backed key storage:

```dart
// ✅ BENAR: Hardware security jika available
class SecureKeyStorage {
  Future<void> storeKey(String keyName, String key) async {
    if (await _isHardwareSecurityAvailable()) {
      await _storeInHardwareKeystore(keyName, key);
    } else {
      await _storeInSoftwareKeystore(keyName, key);
    }
  }
}
```

---

## 🔐 **Authentication Security Rules**

### **Rule 3.1: Token Management yang Aman**

Access tokens WAJIB memiliki expiry maksimal 1 jam:

```dart
// ✅ BENAR: Token expiry yang tepat
class TokenManager {
  static const Duration accessTokenExpiry = Duration(hours: 1);
  static const Duration refreshTokenExpiry = Duration(days: 7);

  Future<void> storeAccessToken(String token) async {
    final tokenData = {
      'token': token,
      'expiresAt': DateTime.now().add(accessTokenExpiry).toIso8601String(),
    };

    await _secureStorage.storeSecureData('access_token', jsonEncode(tokenData));
  }
}

// ❌ SALAH: Token expiry terlalu lama
class InsecureTokenManager {
  static const Duration accessTokenExpiry = Duration(days: 365); // Too long!
}
```

### **Rule 3.2: Rate Limiting untuk Authentication**

Implementasikan rate limiting untuk mencegah brute force:

```dart
// ✅ BENAR: Rate limiting implementation
class AuthRateLimiter {
  final Map<String, List<DateTime>> _attempts = {};

  Future<bool> isRateLimited(String identifier) async {
    final attempts = _attempts[identifier] ?? [];
    final now = DateTime.now();
    final recentAttempts = attempts.where((attempt) =>
      now.difference(attempt).inMinutes < 15
    ).toList();

    if (recentAttempts.length >= 5) {
      return true; // Rate limited
    }

    recentAttempts.add(now);
    _attempts[identifier] = recentAttempts;
    return false;
  }
}
```

### **Rule 3.3: Biometric Authentication**

Gunakan biometric authentication untuk sensitive operations:

```dart
// ✅ BENAR: Biometric authentication
class BiometricAuthService {
  Future<bool> authenticateForSensitiveOperation() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    if (!isAvailable) return false;

    return await _localAuth.authenticate(
      localizedReason: 'Autentikasi diperlukan untuk melanjutkan',
      biometricOnly: true,
    );
  }
}
```

---

## 🌐 **Network Security Rules**

### **Rule 4.1: HTTPS Only**

Semua network communication WAJIB menggunakan HTTPS:

```dart
// ✅ BENAR: HTTPS only
class SecureApiClient {
  final Dio _dio = Dio();

  SecureApiClient() {
    _dio.options.baseUrl = 'https://api.usago.id'; // HTTPS only
    _dio.interceptors.add(CertificatePinningInterceptor());
  }
}

// ❌ SALAH: HTTP usage
class InsecureApiClient {
  final Dio _dio = Dio();

  InsecureApiClient() {
    _dio.options.baseUrl = 'http://api.usago.id'; // Insecure!
  }
}
```

### **Rule 4.2: Certificate Pinning**

Implementasikan certificate pinning untuk production:

```dart
// ✅ BENAR: Certificate pinning
class CertificatePinningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Implement certificate pinning logic
    super.onRequest(options, handler);
  }
}
```

### **Rule 4.3: Request Signing**

Critical endpoints WAJIB menggunakan request signing:

```dart
// ✅ BENAR: Request signing
class RequestSigningService {
  Future<Map<String, String>> signRequest(
    String method,
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final payload = '$method:$endpoint:$timestamp:${jsonEncode(data)}';
    final signature = _generateHMAC(payload, _getSecretKey());

    return {
      'X-Timestamp': timestamp,
      'X-Signature': signature,
      'X-Algorithm': 'HMAC-SHA256',
    };
  }
}
```

---

## 🛡️ **Data Protection Rules**

### **Rule 5.1: Input Validation**

Semua input WAJIB divalidasi dan disanitasi:

```dart
// ✅ BENAR: Comprehensive input validation
class InputValidator {
  String validateAndSanitizeEmail(String email) {
    email = email.trim().toLowerCase();
    email = email.replaceAll(RegExp(r'[<>"\'\%]'), '');

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw ValidationException('Invalid email format');
    }

    return email;
  }
}

// ❌ SALAH: No input validation
class InsecureInputHandler {
  void processEmail(String email) {
    // Direct usage without validation
    _apiCall(email);
  }
}
```

### **Rule 5.2: Data Masking**

Sensitive data yang ditampilkan di UI WAJIB di-mask:

```dart
// ✅ BENAR: Data masking
class DataMaskingService {
  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];
    final maskedUsername = username.length > 2
      ? '${username.substring(0, 2)}${'*' * (username.length - 2)}'
      : username;

    return '$maskedUsername@$domain';
  }
}
```

### **Rule 5.3: Secure Logging**

Jangan log sensitive data:

```dart
// ✅ BENAR: Secure logging
class SecureLogger {
  void logUserAction(String action, String userId) {
    logger.info('User action: $action', extra: {'userId': userId});
    // Tidak log password, token, atau data sensitive lainnya
  }
}

// ❌ SALAH: Logging sensitive data
class InsecureLogger {
  void logLogin(String email, String password) {
    logger.info('Login attempt: $email with password: $password'); // Security risk!
  }
}
```

---

## 📦 **Storage Security Rules**

### **Rule 6.1: Secure Storage untuk Sensitive Data**

Gunakan secure storage untuk data sensitive:

```dart
// ✅ BENAR: Enhanced secure storage
class SecureDataStorage {
  Future<void> storeSensitiveData(String key, String data) async {
    await _enhancedSecureStorage.storeSecureData(key, data);
  }
}

// ❌ SALAH: Regular storage untuk sensitive data
class InsecureDataStorage {
  Future<void> storeSensitiveData(String key, String data) async {
    await _preferences.setString(key, data); // Not secure!
  }
}
```

### **Rule 6.2: Memory Cleanup**

Cleanup sensitive data dari memory setelah usage:

```dart
// ✅ BENAR: Memory cleanup
class SecureMemoryManager {
  void processSensitiveData(String data) {
    try {
      // Process data
      _doSomething(data);
    } finally {
      // Clear data from memory
      data = '';
      // Force garbage collection in debug mode
      if (kDebugMode) {
        System.gc();
      }
    }
  }
}
```

---

## 💻 **Code Security Rules**

### **Rule 7.1: No Hardcoded Secrets**

Jangan hardcode secrets dalam code:

```dart
// ✅ BENAR: Environment variables
class SecureConfig {
  static String get encryptionKey => EnvConfig.get('ENCRYPTION_KEY');
  static String get jwtSecret => EnvConfig.get('JWT_SECRET');
}

// ❌ SALAH: Hardcoded secrets
class InsecureConfig {
  static const String encryptionKey = 'hardcoded_secret_key'; // Security risk!
  static const String jwtSecret = 'hardcoded_jwt_secret';   // Security risk!
}
```

### **Rule 7.2: Error Handling yang Aman**

Jangan expose sensitive information dalam error messages:

```dart
// ✅ BENAR: Secure error handling
class SecureErrorHandler {
  void handleError(Exception error) {
    if (error is SecurityException) {
      logger.error('Security operation failed', error);
      _showUserFriendlyMessage('Operation failed. Please try again.');
    } else {
      logger.error('Unexpected error', error);
      _showUserFriendlyMessage('An error occurred. Please try again.');
    }
  }
}

// ❌ SALAH: Expose sensitive information
class InsecureErrorHandler {
  void handleError(Exception error) {
    _showUserFriendlyMessage('Error: ${error.toString()}'); // Might expose sensitive info
  }
}
```

---

## 🧪 **Security Testing Rules**

### **Rule 8.1: Security Testing untuk Sensitive Features**

Semua security-related features WAJIB memiliki automated tests:

```dart
// ✅ BENAR: Security tests
void main() {
  group('Security Tests', () {
    test('Encryption should be reversible with correct key', () async {
      final encryptionService = EncryptionService();
      final data = 'sensitive_data';
      final key = 'test_key_32_bytes_long';

      final encrypted = await encryptionService.encrypt(data, key);
      final decrypted = await encryptionService.decrypt(encrypted, key);

      expect(decrypted, equals(data));
    });

    test('Encryption should fail with wrong key', () async {
      final encryptionService = EncryptionService();
      final data = 'sensitive_data';
      final key = 'test_key_32_bytes_long';
      final wrongKey = 'wrong_key_32_bytes_long';

      final encrypted = await encryptionService.encrypt(data, key);

      expect(
        () => encryptionService.decrypt(encrypted, wrongKey),
        throwsA(isA<SecurityException>()),
      );
    });
  });
}
```

### **Rule 8.2: Penetration Testing**

Lakukan penetration testing secara berkala:

- Security testing setiap release
- Penetration testing setiap 3 bulan
- Security audit setiap 6 bulan

---

## ✅ **Security Checklist**

### **Development Phase**
- [ ] Tidak ada hardcoded secrets
- [ ] Semua sensitive data dienkripsi
- [ ] Input validation diimplementasikan
- [ ] Error handling aman
- [ ] Logging tidak expose sensitive data

### **Testing Phase**
- [ ] Security tests untuk encryption
- [ ] Authentication flow testing
- [ ] Network security testing
- [ ] Data protection testing
- [ ] Penetration testing

### **Deployment Phase**
- [ ] Environment variables terkonfigurasi dengan benar
- [ ] Certificate pinning aktif
- [ ] HTTPS only
- [ ] Security headers terkonfigurasi
- [ ] Monitoring security events aktif

---

## 🔗 **Related Documentation**

- [`../docs/06-operations/security-implementation.md`](../docs/06-operations/security-implementation.md) - Complete security implementation guide
- [`../lib/core/constants/security_constants.dart`](../lib/core/constants/security_constants.dart) - Security constants
- [`../lib/core/services/enhanced_secure_storage_service.dart`](../lib/core/services/enhanced_secure_storage_service.dart) - Secure storage implementation
- [`../lib/core/utils/encryption_util.dart`](../lib/core/utils/encryption_util.dart) - Encryption utilities

---

## 📞 **Contact Information**

### **Security Team**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Security Incident** | security@usago.id | 1 hour |
| **Vulnerability Report** | security@usago.id | 2 hours |
| **Security Question** | security@usago.id | 4 hours |

---

## 📝 **Notes**

### **Compliance Requirements**
- GDPR compliance untuk data protection
- PCI DSS compliance untuk payment data
- ISO 27001 compliance untuk security management

### **Security Monitoring**
- Real-time security monitoring
- Automated security alerts
- Regular security audits
- Incident response procedures

---

**Document End**

**Go Digital, Grow Together.**