# Platform-Specific Security Considerations

## 📋 Overview

Dokumen ini membahas pertimbangan keamanan spesifik untuk setiap platform dalam implementasi cross-platform storage. Setiap platform memiliki karakteristik keamanan yang berbeda dan memerlukan pendekatan khusus untuk memastikan data pengguna tetap aman.

---

## 🔒 Security Levels Overview

| Platform | Security Level | Teknologi Utama | Threat Model |
|----------|---------------|-----------------|--------------|
| **iOS** | ⭐⭐⭐⭐⭐ (Tertinggi) | Keychain | Device compromise, jailbreak |
| **Android** | ⭐⭐⭐⭐⭐ (Tertinggi) | EncryptedSharedPreferences | Root access, device theft |
| **Desktop** | ⭐⭐⭐⭐ (Tinggi) | Platform Secure Storage | Malware, system compromise |
| **Web** | ⭐⭐⭐ (Baik) | Encrypted localStorage | XSS, CSRF, browser compromise |

---

## 📱 iOS Security Considerations

### Keychain Security

**Implementation**: iOS Keychain dengan `first_unlock` accessibility

```dart
// iOS-specific configuration
const FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
    synchronizable: false, // Tidak sync dengan iCloud
    accountName: 'usago_app',
  ),
);
```

### Security Features

- **Hardware-Backed Encryption**: Data dienkripsi di hardware level
- **Secure Enclave**: Private keys tersimpan di Secure Enclave (iPhone 5s+)
- **Device-Specific Encryption**: Data hanya bisa diakses di device yang sama
- **Biometric Protection**: Integrasi dengan Touch ID/Face ID

### Threat Mitigation

#### Jailbreak Detection
```dart
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

Future<bool> isJailbroken() async {
  return await JailbreakRootDetection.instance.isJailbroken();
}

// Usage dalam storage service
if (await isJailbroken()) {
  // Kurangi security level atau block aplikasi
  _logger.warning('Device is jailbroken - using reduced security');
}
```

#### Keychain Access Control
```dart
// Batasi akses berdasarkan device state
const iOptions = IOSOptions(
  accessibility: KeychainAccessibility.when_unlocked_this_device_only,
  // Hanya accessible ketika device unlocked
);
```

### Best Practices untuk iOS

1. **Gunakan `first_unlock_this_device_only`** untuk sensitive data
2. **Hindari `synchronizable: true`** untuk data sensitif
3. **Implementasi jailbreak detection** untuk high-security apps
4. **Gunakan biometric authentication** untuk additional protection
5. **Regular key rotation** untuk long-term security

---

## 🤖 Android Security Considerations

### EncryptedSharedPreferences

**Implementation**: Android Keystore + EncryptedSharedPreferences

```dart
// Android-specific configuration
const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
  ),
);
```

### Security Features

- **Android Keystore**: Hardware-backed key storage
- **TEE (Trusted Execution Environment)**: Isolated secure environment
- **Key Attestation**: Verifikasi key integrity
- **Strongbox**: Hardware security module (Pixel 3+)

### Threat Mitigation

#### Root Detection
```dart
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

Future<bool> isRooted() async {
  return await JailbreakRootDetection.instance.isJailbroken();
}

// Usage dalam storage service
if (await isRooted()) {
  _logger.warning('Device is rooted - using reduced security');
  // Implementasi additional security measures
}
```

#### Key Attestation
```dart
// Verifikasi key integrity (Android 8.0+)
Future<bool> verifyKeyAttestation() async {
  try {
    // Implementasi key attestation check
    return true; // Placeholder
  } catch (e) {
    _logger.error('Key attestation failed', e);
    return false;
  }
}
```

### Best Practices untuk Android

1. **Gunakan EncryptedSharedPreferences** untuk semua sensitive data
2. **Implementasi root detection** untuk high-security apps
3. **Gunakan Strongbox jika available** untuk hardware security
4. **Enable key attestation** untuk key integrity verification
5. **Regular security updates** untuk patch vulnerabilities

---

## 🖥️ Desktop Security Considerations

### Platform-Specific Implementations

#### Windows (DPAPI)
```dart
// Windows menggunakan Data Protection API
const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
```

**Security Features**:
- **DPAPI**: System-level encryption
- **User-specific keys**: Data hanya accessible oleh user yang sama
- **Machine binding**: Data terikat ke specific machine

#### Linux (libsecret)
```dart
// Linux menggunakan libsecret/GNOME Keyring
const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
```

**Security Features**:
- **GNOME Keyring/KWallet**: System keyring integration
- **Session-based encryption**: Keys terikat ke user session
- **Password-based protection**: Optional master password

#### macOS (Keychain)
```dart
// macOS menggunakan Keychain (mirip iOS)
const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
```

**Security Features**:
- **Keychain Access**: System keychain integration
- **Secure Enclave**: Hardware security (Mac dengan T2 chip)
- **iCloud Sync**: Optional synchronization

### Threat Mitigation

#### Malware Protection
```dart
// Implementasi integrity checks
Future<bool> verifyApplicationIntegrity() async {
  try {
    // Check untuk tampering
    // Verify digital signatures
    // Check untuk unauthorized modifications
    return true; // Placeholder
  } catch (e) {
    _logger.error('Integrity check failed', e);
    return false;
  }
}
```

#### Session Management
```dart
// Lock storage ketika system locked
class DesktopSecurityManager {
  static void handleSystemLock() {
    // Clear sensitive data dari memory
    // Lock storage operations
    // Require re-authentication on unlock
  }
}
```

### Best Practices untuk Desktop

1. **Gunakan system keyring** untuk storage management
2. **Implementasi session timeout** untuk inactivity
3. **Regular integrity checks** untuk tamper detection
4. **Secure memory management** untuk sensitive data
5. **User education** tentang security practices

---

## 🌐 Web Security Considerations

### Encrypted Web Storage

**Implementation**: localStorage dengan XOR encryption

```dart
class WebSecureStorage implements PlatformStorageInterface {
  // Encrypt data menggunakan XOR cipher dengan SHA-256 key
  String _encrypt(String data) {
    final keyBytes = sha256.convert(utf8.encode(_encryptionKey)).bytes;
    final dataBytes = utf8.encode(data);

    final encryptedBytes = <int>[];
    for (int i = 0; i < dataBytes.length; i++) {
      encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64.encode(encryptedBytes);
  }
}
```

### Security Features

- **Client-side Encryption**: Data terenkripsi sebelum storage
- **Browser Fingerprinting**: Key generation berdasarkan browser context
- **Base64 Encoding**: Safe storage di browser
- **Prefix Isolation**: Key separation dari app data lain

### Threat Mitigation

#### XSS Protection
```dart
// Content Security Policy headers
class SecurityHeaders {
  static const Map<String, String> cspHeaders = {
    'Content-Security-Policy':
      "default-src 'self'; script-src 'self' 'unsafe-inline'; " +
      "style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; " +
      "connect-src 'self' https://api.example.com; " +
      "font-src 'self'; object-src 'none'; frame-ancestors 'none';"
  };
}
```

#### CSRF Protection
```dart
// CSRF token implementation
class CSRFProtection {
  static String generateToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure().nextInt(1000000);
    return sha256.convert(utf8.encode('$timestamp$random')).toString();
  }

  static bool validateToken(String token, String sessionToken) {
    return token == sessionToken;
  }
}
```

#### Secure Context Enforcement
```dart
// Hanya allow HTTPS di production
class SecurityValidator {
  static bool isSecureContext() {
    if (kDebugMode) return true; // Allow HTTP di development

    return window.location.protocol == 'https:' ||
           window.location.hostname == 'localhost';
  }
}
```

### Limitations dan Mitigations

#### Browser Storage Limitations
```dart
// Handle quota exceeded
class StorageManager {
  static Future<bool> checkStorageQuota() async {
    try {
      final storage = html.window.localStorage;
      final usage = storage.length * 2; // Approximate size
      const quota = 5 * 1024 * 1024; // 5MB typical limit

      return usage < quota * 0.8; // Use 80% threshold
    } catch (e) {
      return false;
    }
  }
}
```

#### Session Management
```dart
// Implementasi secure session timeout
class WebSessionManager {
  static const Duration sessionTimeout = Duration(hours: 1);
  static DateTime? _lastActivity;

  static void updateActivity() {
    _lastActivity = DateTime.now();
  }

  static bool isSessionValid() {
    if (_lastActivity == null) return false;
    return DateTime.now().difference(_lastActivity!) < sessionTimeout;
  }
}
```

### Best Practices untuk Web

1. **Gunakan HTTPS** untuk semua production environments
2. **Implementasi CSP headers** untuk XSS protection
3. **Regular token rotation** untuk session management
4. **Secure cookie attributes** (HttpOnly, Secure, SameSite)
5. **Browser compatibility testing** untuk encryption support

---

## 🔐 Cross-Platform Security Strategies

### Defense in Depth

```dart
class SecurityManager {
  // Multiple layers of security
  static Future<bool> validateSecurityContext() async {
    final checks = [
      _checkPlatformSecurity(),
      _checkApplicationIntegrity(),
      _checkEnvironmentSecurity(),
      _checkUserAuthentication(),
    ];

    final results = await Future.wait(checks);
    return results.every((result) => result);
  }

  static Future<bool> _checkPlatformSecurity() async {
    if (PlatformDetector.isMobile) {
      return !(await _isDeviceCompromised());
    }
    return true;
  }

  static Future<bool> _checkApplicationIntegrity() async {
    // Verify app signature dan integrity
    return true;
  }

  static Future<bool> _checkEnvironmentSecurity() async {
    if (PlatformDetector.isWeb) {
      return SecurityValidator.isSecureContext();
    }
    return true;
  }

  static Future<bool> _checkUserAuthentication() async {
    // Verify user authentication status
    return true;
  }
}
```

### Risk-Based Authentication

```dart
class RiskBasedAuth {
  static SecurityLevel determineSecurityLevel() {
    if (PlatformDetector.isMobile) {
      return SecurityLevel.high; // Hardware-backed security
    } else if (PlatformDetector.isDesktop) {
      return SecurityLevel.medium; // System-level security
    } else if (PlatformDetector.isWeb) {
      return SecurityLevel.low; // Software-based security
    }
    return SecurityLevel.unknown;
  }

  static Future<bool> requireAdditionalAuth() async {
    final level = determineSecurityLevel();
    return level == SecurityLevel.low;
  }
}
```

### Data Classification and Handling

```dart
enum DataSensitivity {
  public,      // Tidak perlu encryption
  internal,    // Basic encryption
  confidential, // Strong encryption
  restricted,  // Maximum security
}

class DataClassification {
  static DataSensitivity classifyData(String key, dynamic value) {
    final sensitiveKeys = [
      'auth_token', 'password', 'secret', 'key',
      'credit_card', 'ssn', 'personal_data'
    ];

    final keyLower = key.toLowerCase();

    if (sensitiveKeys.any((sensitive) => keyLower.contains(sensitive))) {
      return DataSensitivity.restricted;
    } else if (keyLower.contains('user') || keyLower.contains('profile')) {
      return DataSensitivity.confidential;
    } else if (keyLower.contains('app') || keyLower.contains('cache')) {
      return DataSensitivity.internal;
    }

    return DataSensitivity.public;
  }

  static bool shouldUseSecureStorage(String key, dynamic value) {
    final sensitivity = classifyData(key, value);
    return sensitivity != DataSensitivity.public;
  }
}
```

---

## 🚨 Incident Response

### Security Breach Detection

```dart
class SecurityMonitor {
  static void detectAnomalies() {
    // Monitor untuk unusual patterns
    _monitorFailedAuthAttempts();
    _monitorDataAccessPatterns();
    _monitorSystemChanges();
  }

  static void _monitorFailedAuthAttempts() {
    // Track failed login attempts
    // Implement rate limiting
    // Trigger lockout mechanisms
  }

  static void _monitorDataAccessPatterns() {
    // Detect unusual data access
    // Monitor untuk bulk data extraction
    // Alert pada suspicious activities
  }

  static void _monitorSystemChanges() {
    // Detect jailbreak/root
    // Monitor untuk app tampering
    // Check environment integrity
  }
}
```

### Incident Response Procedures

```dart
class IncidentResponse {
  static Future<void> handleSecurityBreach(SecurityEvent event) async {
    switch (event.type) {
      case SecurityEventType.deviceCompromised:
        await _handleDeviceCompromise();
        break;
      case SecurityEventType.dataBreach:
        await _handleDataBreach();
        break;
      case SecurityEventType.unauthorizedAccess:
        await _handleUnauthorizedAccess();
        break;
    }
  }

  static Future<void> _handleDeviceCompromise() async {
    // Clear all sensitive data
    // Force logout semua sessions
    // Require re-authentication
    // Report ke security team
  }

  static Future<void> _handleDataBreach() async {
    // Identify compromised data
    // Rotate semua keys
    // Notify affected users
    // Implement additional controls
  }

  static Future<void> _handleUnauthorizedAccess() async {
    // Block suspicious activities
    // Invalidate affected sessions
    // Implement additional authentication
    // Log detailed incident information
  }
}
```

---

## 📊 Security Monitoring and Analytics

### Security Metrics

```dart
class SecurityMetrics {
  static void trackSecurityEvent(SecurityEvent event) {
    // Log security events
    // Track response times
    // Measure effectiveness
    // Generate reports
  }

  static Map<String, dynamic> generateSecurityReport() {
    return {
      'total_events': _getTotalEvents(),
      'blocked_attempts': _getBlockedAttempts(),
      'response_time': _getAverageResponseTime(),
      'security_score': _calculateSecurityScore(),
    };
  }
}
```

### Compliance Tracking

```dart
class ComplianceTracker {
  static bool checkGDPRCompliance() {
    // Data minimization
    // User consent management
    // Right to deletion
    // Data portability
    return true;
  }

  static bool checkSOC2Compliance() {
    // Access controls
    // Encryption standards
    // Audit logging
    // Incident response
    return true;
  }
}
```

---

## 📚 Referensi dan Resources

### Security Standards
- [OWASP Mobile Security Testing Guide](https://owasp.org/www-project-mobile-security-testing-guide/)
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Platform Documentation
- [iOS Security Overview](https://developer.apple.com/documentation/security)
- [Android Security Documentation](https://developer.android.com/topic/security)
- [Web Security Guidelines](https://developers.google.com/web/fundamentals/security)

### Tools and Libraries
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Jailbreak Root Detection](https://pub.dev/packages/jailbreak_root_detection)
- [Crypto Package](https://pub.dev/packages/crypto)

---

**Last Updated**: November 21, 2025
**Version**: 1.0.0
**Security Review**: December 21, 2025

---

*Go Digital, Grow Together.*