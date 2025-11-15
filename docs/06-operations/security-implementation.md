# Security Implementation Guide
# Panduan Implementasi Keamanan

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-SECURITY-IMPLEMENTATION |
| **Version** | 1.0 |
| **Status** | Ready to Implement |
| **Category** | Security Documentation |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Security Team, Tech Lead |
| **Stakeholders** | Development Team, QA Team, Security Team |

---

## 🎯 **Purpose**

Dokumen ini menjelaskan implementasi keamanan yang digunakan dalam aplikasi Usago Mobile. Panduan ini mencakup encryption patterns di [`EnhancedSecureStorageService`](../lib/core/services/enhanced_secure_storage_service.dart), key rotation, security constants, dan best practices untuk memastikan keamanan data dan aplikasi.

---

## 📚 **Table of Contents**

1. [Security Overview](#security-overview)
2. [Encryption Implementation](#encryption-implementation)
3. [Key Management](#key-management)
4. [Secure Storage](#secure-storage)
5. [Authentication Security](#authentication-security)
6. [Network Security](#network-security)
7. [Data Protection](#data-protection)
8. [Security Best Practices](#security-best-practices)

---

## 🔒 **Security Overview**

### Arsitektur Keamanan

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SECURITY ARCHITECTURE                         │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    ENHANCED SECURE STORAGE             │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │ Encryption  │  │   Key       │  │   Data      │ │   │
│  │  │   Manager   │  │  Rotation   │  │ Integrity   │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    AUTHENTICATION SECURITY                   │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Token     │  │   Session   │  │   Biometric  │ │   │
│  │  │ Management  │  │ Management  │  │ Security    │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    NETWORK SECURITY                           │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │ Certificate │  │   Request   │  │   Response   │ │   │
│  │  │ Pinning    │  │ Signing    │  │ Validation  │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    DATA PROTECTION                           │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Field     │  │   Input     │  │   Output    │ │   │
│  │  │ Validation  │  │ Sanitization│  │ Encryption  │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Prinsip Keamanan

1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimum access required for functionality
3. **Zero Trust**: Verify everything, trust nothing
4. **Data Minimization**: Collect only necessary data
5. **Secure by Default**: Secure configurations out of the box

---

## 🔐 **Encryption Implementation**

### Enhanced Secure Storage Service

[`EnhancedSecureStorageService`](../lib/core/services/enhanced_secure_storage_service.dart) menyediakan encryption dan secure storage:

```dart
class EnhancedSecureStorageService {
  static final EnhancedSecureStorageService _instance = EnhancedSecureStorageService._internal();
  factory EnhancedSecureStorageService() => _instance;
  EnhancedSecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final EncryptionService _encryptionService = EncryptionService();

  // Encrypt and store data
  Future<void> storeSecureData(String key, String value) async {
    try {
      // Generate encryption key
      final encryptionKey = await _getOrCreateEncryptionKey(key);

      // Encrypt data
      final encryptedData = await _encryptionService.encrypt(
        value,
        encryptionKey,
      );

      // Store encrypted data
      await _secureStorage.write(key: key, value: encryptedData);

      // Store metadata
      await _storeEncryptionMetadata(key, encryptionKey);
    } catch (e) {
      throw SecurityException(
        message: 'Failed to store secure data',
        type: SecurityExceptionType.encryptionError,
        originalError: e,
      );
    }
  }

  // Retrieve and decrypt data
  Future<String?> getSecureData(String key) async {
    try {
      // Get encrypted data
      final encryptedData = await _secureStorage.read(key: key);
      if (encryptedData == null) return null;

      // Get encryption key
      final encryptionKey = await _getEncryptionKey(key);
      if (encryptionKey == null) return null;

      // Decrypt data
      final decryptedData = await _encryptionService.decrypt(
        encryptedData,
        encryptionKey,
      );

      return decryptedData;
    } catch (e) {
      throw SecurityException(
        message: 'Failed to retrieve secure data',
        type: SecurityExceptionType.decryptionError,
        originalError: e,
      );
    }
  }
}
```

### Encryption Service

```dart
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Encrypt data with AES-256-GCM
  Future<String> encrypt(String data, String encryptionKey) async {
    try {
      // Generate random IV
      final iv = _generateRandomIV();

      // Create cipher
      final encrypter = Encrypter(
        AES(
          Key.fromUtf8(encryptionKey),
          mode: AESMode.gcm,
          padding: 'PKCS7',
        ),
      );

      // Encrypt data
      final encrypted = encrypter.encryptBytes(data.codeUnits);

      // Combine IV and encrypted data
      final combined = iv + encrypted.bytes;

      // Return base64 encoded result
      return base64.encode(combined);
    } catch (e) {
      throw SecurityException(
        message: 'Encryption failed',
        type: SecurityExceptionType.encryptionError,
        originalError: e,
      );
    }
  }

  // Decrypt data with AES-256-GCM
  Future<String> decrypt(String encryptedData, String encryptionKey) async {
    try {
      // Decode base64
      final combined = base64.decode(encryptedData);

      // Extract IV and encrypted data
      final iv = combined.sublist(0, SecurityConstants.ivSize);
      final encrypted = combined.sublist(SecurityConstants.ivSize);

      // Create cipher
      final decrypter = Encrypter(
        AES(
          Key.fromUtf8(encryptionKey),
          mode: AESMode.gcm,
          padding: 'PKCS7',
        ),
      );

      // Decrypt data
      final decrypted = decrypter.decryptBytes(encrypted);

      return String.fromCharCodes(decrypted);
    } catch (e) {
      throw SecurityException(
        message: 'Decryption failed',
        type: SecurityExceptionType.decryptionError,
        originalError: e,
      );
    }
  }

  // Generate random IV
  Uint8List _generateRandomIV() {
    final random = Random.secure();
    final iv = Uint8List(SecurityConstants.ivSize);

    for (int i = 0; i < SecurityConstants.ivSize; i++) {
      iv[i] = random.nextInt(256);
    }

    return iv;
  }
}
```

### Data Integrity Check

```dart
class DataIntegrityService {
  static final DataIntegrityService _instance = DataIntegrityService._internal();
  factory DataIntegrityService() => _instance;
  DataIntegrityService._internal();

  // Generate HMAC for data integrity
  String generateHMAC(String data, String key) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(data));
    return base64.encode(digest.bytes);
  }

  // Verify HMAC for data integrity
  bool verifyHMAC(String data, String key, String hmac) {
    final expectedHMAC = generateHMAC(data, key);
    return hmac == expectedHMAC;
  }

  // Generate checksum for data
  String generateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  // Verify checksum for data
  bool verifyChecksum(String data, String checksum) {
    final expectedChecksum = generateChecksum(data);
    return checksum == expectedChecksum;
  }

  // Generate digital signature
  Future<String> generateSignature(String data, String privateKey) async {
    try {
      final key = rsa.PEMKeyParser().parse(privateKey);
      final signer = rsa.Signer(privateKey, sha256);

      final signature = signer.sign(utf8.encode(data));
      return base64.encode(signature);
    } catch (e) {
      throw SecurityException(
        message: 'Signature generation failed',
        type: SecurityExceptionType.signatureError,
        originalError: e,
      );
    }
  }

  // Verify digital signature
  Future<bool> verifySignature(String data, String signature, String publicKey) async {
    try {
      final key = rsa.PEMKeyParser().parse(publicKey);
      final verifier = rsa.Verifier(publicKey, sha256);

      return verifier.verify(utf8.encode(data), base64.decode(signature));
    } catch (e) {
      throw SecurityException(
        message: 'Signature verification failed',
        type: SecurityExceptionType.signatureError,
        originalError: e,
      );
    }
  }
}
```

---

## 🔑 **Key Management**

### Key Rotation System

Key rotation diimplementasikan untuk security yang lebih baik:

```dart
class KeyRotationService {
  static final KeyRotationService _instance = KeyRotationService._internal();
  factory KeyRotationService() => _instance;
  KeyRotationService._internal();

  final Map<String, KeyMetadata> _keys = {};
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Rotate encryption keys
  Future<void> rotateKeys() async {
    try {
      final currentKeys = await _getAllKeys();

      for (final entry in currentKeys.entries) {
        final keyId = entry.key;
        final keyMetadata = entry.value;

        // Check if key needs rotation
        if (_shouldRotateKey(keyMetadata)) {
          await _rotateKey(keyId, keyMetadata);
        }
      }
    } catch (e) {
      throw SecurityException(
        message: 'Key rotation failed',
        type: SecurityExceptionType.keyRotationError,
        originalError: e,
      );
    }
  }

  // Check if key should be rotated
  bool _shouldRotateKey(KeyMetadata metadata) {
    final now = DateTime.now();
    final keyAge = now.difference(metadata.createdAt);

    // Rotate based on age
    if (keyAge.inDays >= SecurityConstants.keyRotationInterval.inDays) {
      return true;
    }

    // Rotate based on usage
    if (metadata.usageCount >= SecurityConstants.maxKeyUsageCount) {
      return true;
    }

    // Rotate if compromised
    if (metadata.isCompromised) {
      return true;
    }

    return false;
  }

  // Rotate specific key
  Future<void> _rotateKey(String keyId, KeyMetadata oldMetadata) async {
    // Generate new key
    final newKey = _generateSecureKey();
    final newMetadata = KeyMetadata(
      keyId: _generateKeyId(),
      key: newKey,
      createdAt: DateTime.now(),
      usageCount: 0,
      isCompromised: false,
    );

    // Re-encrypt data with new key
    await _reencryptDataWithNewKey(keyId, oldMetadata.key, newKey);

    // Update key metadata
    _keys[keyId] = newMetadata;
    await _storeKeyMetadata(keyId, newMetadata);

    // Mark old key for deletion
    await _markKeyForDeletion(keyId, oldMetadata);
  }

  // Generate secure key
  String _generateSecureKey() {
    final random = Random.secure();
    final keyBytes = List<int>.generate(
      SecurityConstants.randomKeyLength,
      (_) => random.nextInt(256),
    );

    return base64.encode(keyBytes);
  }

  // Generate unique key ID
  String _generateKeyId() {
    return 'key_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}

class KeyMetadata {
  final String keyId;
  final String key;
  final DateTime createdAt;
  final int usageCount;
  final bool isCompromised;
  final DateTime? lastUsedAt;
  final String? algorithm;

  const KeyMetadata({
    required this.keyId,
    required this.key,
    required this.createdAt,
    required this.usageCount,
    required this.isCompromised,
    this.lastUsedAt,
    this.algorithm,
  });
}
```

### Key Derivation

```dart
class KeyDerivationService {
  static final KeyDerivationService _instance = KeyDerivationService._internal();
  factory KeyDerivationService() => _instance;
  KeyDerivationService._internal();

  // Derive key from password using PBKDF2
  Future<String> deriveKeyFromPassword(
    String password,
    String salt, {
    int iterations = SecurityConstants.pbkdf2Iterations,
    int keyLength = SecurityConstants.aesKeyLength ~/ 8,
  }) async {
    try {
      final bytes = utf8.encode(password);
      final saltBytes = utf8.encode(salt);

      final derivator = PBKDF2(
        hmac: Hmac(sha256, bytes),
        iterations: iterations,
        derivedKeyLength: keyLength,
      );

      final derivedKey = await derivator.process(saltBytes);
      return base64.encode(derivedKey);
    } catch (e) {
      throw SecurityException(
        message: 'Key derivation failed',
        type: SecurityExceptionType.keyDerivationError,
        originalError: e,
      );
    }
  }

  // Generate secure salt
  String generateSecureSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(
      SecurityConstants.saltLength,
      (_) => random.nextInt(256),
    );

    return base64.encode(saltBytes);
  }

  // Generate pepper for additional security
  String generatePepper() {
    final random = Random.secure();
    final pepperBytes = List<int>.generate(
      32, // 256 bits
      (_) => random.nextInt(256),
    );

    return base64.encode(pepperBytes);
  }
}
```

---

## 🛡️ **Secure Storage**

### Secure Storage Patterns

```dart
class SecureStoragePatterns {
  // Pattern 1: Encrypt before storage
  static Future<void> storeSecurely(String key, String data) async {
    final encryptionKey = await _getEncryptionKey();
    final encryptedData = await _encryptData(data, encryptionKey);
    await _secureStorage.write(key: key, value: encryptedData);
  }

  // Pattern 2: Store metadata separately
  static Future<void> storeWithMetadata(String key, String data) async {
    final metadata = {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'checksum': _generateChecksum(data),
    };

    await _secureStorage.write(key: key, value: data);
    await _secureStorage.write('${key}_metadata', value: jsonEncode(metadata));
  }

  // Pattern 3: Use hardware security if available
  static Future<void> storeWithHardwareSecurity(String key, String data) async {
    if (await _isHardwareSecurityAvailable()) {
      await _storeInHardwareKeystore(key, data);
    } else {
      await _storeInSoftwareKeystore(key, data);
    }
  }

  // Check hardware security availability
  static Future<bool> _isHardwareSecurityAvailable() async {
    try {
      // Check for biometric availability
      final localAuth = LocalAuthentication();
      final canCheckBiometrics = await localAuth.canCheckBiometrics;

      // Check for secure enclave/keychain
      final deviceInfo = DeviceInfoPlugin();
      final isSecureDevice = await _isSecureDevice(deviceInfo);

      return canCheckBiometrics && isSecureDevice;
    } catch (e) {
      return false;
    }
  }
}
```

### Storage Security Constants

[`SecurityConstants`](../lib/core/constants/security_constants.dart:4) mendefinisikan storage security constants:

```dart
class SecurityConstants {
  // ==================== Encryption ====================

  /// AES key length (256 bits)
  static const int aesKeyLength = 256;

  /// IV (Initialization Vector) size (16 bytes)
  static const int ivSize = 16;

  /// Random key length untuk generate (32 bytes)
  static const int randomKeyLength = 32;

  /// Salt length untuk hashing
  static const int saltLength = 16;

  /// PBKDF2 iterations
  static const int pbkdf2Iterations = 10000;

  // ==================== Key Management ====================

  /// Key rotation interval (30 hari)
  static const Duration keyRotationInterval = Duration(days: 30);

  /// Maximum key age sebelum rotation
  static const Duration maxKeyAge = Duration(days: 30);

  /// Key derivation iteration count
  static const int keyDerivationIterations = 100000;

  /// Minimum key strength score
  static const int minKeyStrengthScore = 80;

  // ==================== Token Management ====================

  /// Access token expiry (1 jam)
  static const Duration accessTokenExpiry = Duration(hours: 1);

  /// Refresh token expiry (7 hari)
  static const Duration refreshTokenExpiry = Duration(days: 7);

  /// Reset token expiry (1 jam)
  static const Duration resetTokenExpiry = Duration(hours: 1);

  /// Verification token expiry (24 jam)
  static const Duration verificationTokenExpiry = Duration(hours: 24);

  /// OTP token expiry (5 menit)
  static const Duration otpTokenExpiry = Duration(minutes: 5);
}
```

---

## 🔐 **Authentication Security**

### Token Management

```dart
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final EnhancedSecureStorageService _secureStorage = EnhancedSecureStorageService();

  // Store access token
  Future<void> storeAccessToken(String token) async {
    final tokenData = {
      'token': token,
      'type': 'access',
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now()
          .add(SecurityConstants.accessTokenExpiry)
          .toIso8601String(),
    };

    await _secureStorage.storeSecureData('access_token', jsonEncode(tokenData));
  }

  // Store refresh token
  Future<void> storeRefreshToken(String token) async {
    final tokenData = {
      'token': token,
      'type': 'refresh',
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now()
          .add(SecurityConstants.refreshTokenExpiry)
          .toIso8601String(),
    };

    await _secureStorage.storeSecureData('refresh_token', jsonEncode(tokenData));
  }

  // Get valid access token
  Future<String?> getValidAccessToken() async {
    final tokenData = await _secureStorage.getSecureData('access_token');
    if (tokenData == null) return null;

    final data = jsonDecode(tokenData);
    final expiresAt = DateTime.parse(data['expiresAt']);

    if (DateTime.now().isAfter(expiresAt)) {
      // Token expired, try refresh
      return await _refreshAccessToken();
    }

    return data['token'];
  }

  // Refresh access token
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _secureStorage.getSecureData('refresh_token');
    if (refreshToken == null) return null;

    try {
      final response = await _dioClient.post('/auth/refresh', data: {
        'refresh_token': jsonDecode(refreshToken)['token'],
      });

      final newAccessToken = response.data['access_token'];
      await storeAccessToken(newAccessToken);

      return newAccessToken;
    } catch (e) {
      // Refresh failed, clear tokens
      await clearAllTokens();
      return null;
    }
  }

  // Clear all tokens
  Future<void> clearAllTokens() async {
    await _secureStorage.deleteSecureData('access_token');
    await _secureStorage.deleteSecureData('refresh_token');
  }
}
```

### Biometric Authentication

```dart
class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check biometric availability
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access secure data',
    bool useErrorDialogs = true,
    List<BiometricType> allowedBiometrics = const [
      BiometricType.fingerprint,
      BiometricType.face,
    ],
  }) async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        useErrorDialogs: useErrorDialogs,
        biometricOnly: true,
        allowedBiometrics: allowedBiometrics,
      );

      return isAuthenticated;
    } catch (e) {
      throw SecurityException(
        message: 'Biometric authentication failed',
        type: SecurityExceptionType.biometricError,
        originalError: e,
      );
    }
  }

  // Store biometric-protected data
  Future<void> storeWithBiometricProtection(String key, String data) async {
    // First authenticate with biometrics
    final isAuthenticated = await authenticateWithBiometrics(
      reason: 'Authenticate to store secure data',
    );

    if (!isAuthenticated) {
      throw SecurityException(
        message: 'Biometric authentication failed',
        type: SecurityExceptionType.biometricError,
      );
    }

    // Store data after successful authentication
    await _secureStorage.storeSecureData(key, data);
  }
}
```

---

## 🌐 **Network Security**

### Certificate Pinning

```dart
class CertificatePinningService {
  static final CertificatePinningService _instance = CertificatePinningService._internal();
  factory CertificatePinningService() => _instance;
  CertificatePinningService._internal();

  final Map<String, String> _pinnedCertificates = {};

  // Initialize certificate pinning
  Future<void> initialize() async {
    // Load pinned certificates
    await _loadPinnedCertificates();

    // Configure Dio with certificate pinning
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // Check if certificate is pinned
        final isPinned = _isCertificatePinned(cert, host);
        if (!isPinned) {
          throw SecurityException(
            message: 'Certificate pinning failed for $host:$port',
            type: SecurityExceptionType.certificateError,
          );
        }

        return true; // Accept certificate
      };
    };
  }

  // Check if certificate is pinned
  bool _isCertificatePinned(X509Certificate cert, String host) {
    final pinnedCert = _pinnedCertificates[host];
    if (pinnedCert == null) return false;

    // Compare certificate fingerprints
    final certFingerprint = _getCertificateFingerprint(cert);
    final pinnedFingerprint = _getCertificateFingerprintFromString(pinnedCert);

    return certFingerprint == pinnedFingerprint;
  }

  // Get certificate fingerprint
  String _getCertificateFingerprint(X509Certificate cert) {
    final bytes = cert.der;
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  // Load pinned certificates
  Future<void> _loadPinnedCertificates() async {
    // Load from secure storage
    final storedCerts = await _secureStorage.getSecureData('pinned_certificates');
    if (storedCerts != null) {
      final certs = jsonDecode(storedCerts);
      _pinnedCertificates.addAll(Map<String, String>.from(certs));
    }

    // Load from assets if not in storage
    if (_pinnedCertificates.isEmpty) {
      await _loadCertificatesFromAssets();
    }
  }

  // Load certificates from assets
  Future<void> _loadCertificatesFromAssets() async {
    try {
      final certData = await rootBundle.loadString('assets/certificates/pinned_certs.json');
      final certs = jsonDecode(certData);
      _pinnedCertificates.addAll(Map<String, String>.from(certs));

      // Store in secure storage
      await _secureStorage.storeSecureData('pinned_certificates', certData);
    } catch (e) {
      throw SecurityException(
        message: 'Failed to load pinned certificates',
        type: SecurityExceptionType.certificateError,
        originalError: e,
      );
    }
  }
}
```

### Request Signing

```dart
class RequestSigningService {
  static final RequestSigningService _instance = RequestSigningService._internal();
  factory RequestSigningService() => _instance;
  RequestSigningService._internal();

  // Sign HTTP request
  Future<Map<String, String>> signRequest({
    required String method,
    required String endpoint,
    required Map<String, dynamic> data,
    required String privateKey,
  }) async {
    try {
      // Generate timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create canonical request
      final canonicalRequest = _createCanonicalRequest(
        method: method,
        endpoint: endpoint,
        data: data,
        timestamp: timestamp,
      );

      // Generate signature
      final signature = await _generateSignature(canonicalRequest, privateKey);

      return {
        'X-Timestamp': timestamp,
        'X-Signature': signature,
        'X-Algorithm': 'RSA-SHA256',
      };
    } catch (e) {
      throw SecurityException(
        message: 'Request signing failed',
        type: SecurityExceptionType.signatureError,
        originalError: e,
      );
    }
  }

  // Create canonical request
  String _createCanonicalRequest({
    required String method,
    required String endpoint,
    required Map<String, dynamic> data,
    required String timestamp,
  }) {
    final sortedData = Map.from(data);
    sortedData.removeWhere((key, value) => key.startsWith('_'));

    final sortedKeys = sortedData.keys.toList()..sort();
    final queryString = sortedKeys.map((key) => '$key=${sortedData[key]}').join('&');

    return '$method\n$endpoint\n$timestamp\n$queryString';
  }

  // Generate RSA signature
  Future<String> _generateSignature(String data, String privateKey) async {
    final key = rsa.PEMKeyParser().parse(privateKey);
    final signer = rsa.Signer(key, sha256);

    final signature = signer.sign(utf8.encode(data));
    return base64.encode(signature);
  }
}
```

---

## 🛡️ **Data Protection**

### Input Validation and Sanitization

```dart
class DataProtectionService {
  static final DataProtectionService _instance = DataProtectionService._internal();
  factory DataProtectionService() => _instance;
  DataProtectionService._internal();

  // Validate and sanitize email
  String validateAndSanitizeEmail(String email) {
    // Remove leading/trailing whitespace
    email = email.trim();

    // Convert to lowercase
    email = email.toLowerCase();

    // Remove potentially dangerous characters
    email = email.replaceAll(RegExp(r'[<>"\'\%]'), '');

    // Validate email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw ValidationException(
        message: 'Invalid email format',
        field: 'email',
        code: 'INVALID_EMAIL',
      );
    }

    return email;
  }

  // Validate and sanitize phone number
  String validateAndSanitizePhone(String phone) {
    // Remove all non-digit characters
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Validate length
    if (phone.length < ValidationConstants.phoneMinLength ||
        phone.length > ValidationConstants.phoneMaxLength) {
      throw ValidationException(
        message: 'Invalid phone number length',
        field: 'phone',
        code: 'INVALID_PHONE_LENGTH',
      );
    }

    return phone;
  }

  // Sanitize user input
  String sanitizeUserInput(String input) {
    // Remove HTML tags
    input = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove potentially dangerous characters
    input = input.replaceAll(RegExp(r'[<>"\'\%&;]'), '');

    // Normalize whitespace
    input = input.replaceAll(RegExp(r'\s+'), ' ');

    return input.trim();
  }

  // Validate password strength
  void validatePasswordStrength(String password) {
    if (password.length < ValidationConstants.passwordMinLength) {
      throw ValidationException(
        message: 'Password must be at least ${ValidationConstants.passwordMinLength} characters',
        field: 'password',
        code: 'PASSWORD_TOO_SHORT',
      );
    }

    if (password.length > ValidationConstants.passwordMaxLength) {
      throw ValidationException(
        message: 'Password must be at most ${ValidationConstants.passwordMaxLength} characters',
        field: 'password',
        code: 'PASSWORD_TOO_LONG',
      );
    }

    // Check password strength
    final strengthScore = _calculatePasswordStrength(password);
    if (strengthScore < ValidationConstants.passwordMinStrengthScore) {
      throw ValidationException(
        message: 'Password is too weak',
        field: 'password',
        code: 'PASSWORD_TOO_WEAK',
      );
    }
  }

  // Calculate password strength
  int _calculatePasswordStrength(String password) {
    int score = 0;

    // Length bonus
    if (password.length >= 8) score += 10;
    if (password.length >= 12) score += 20;

    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) score += 10; // lowercase
    if (password.contains(RegExp(r'[A-Z]'))) score += 10; // uppercase
    if (password.contains(RegExp(r'[0-9]'))) score += 10; // numbers
    if (password.contains(RegExp(r'[!@#$%^&*]'))) score += 20; // special chars

    return score;
  }
}
```

### Data Masking

```dart
class DataMaskingService {
  static final DataMaskingService _instance = DataMaskingService._internal();
  factory DataMaskingService() => _instance;
  DataMaskingService._internal();

  // Mask sensitive data
  String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) {
      return data;
    }

    final visiblePart = data.substring(0, visibleChars);
    final maskedPart = '*' * (data.length - visibleChars);

    return '$visiblePart$maskedPart';
  }

  // Mask email
  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    final maskedUsername = _maskSensitiveData(username, visibleChars: 2);
    return '$maskedUsername@$domain';
  }

  // Mask phone number
  String maskPhoneNumber(String phone) {
    if (phone.length <= 4) return phone;

    final visiblePart = phone.substring(0, 4);
    final maskedPart = '*' * (phone.length - 4);

    return '$visiblePart$maskedPart';
  }

  // Mask credit card number
  String maskCreditCard(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;

    final lastFour = cardNumber.substring(cardNumber.length - 4);
    final maskedPart = '*' * (cardNumber.length - 4);

    return '$maskedPart$lastFour';
  }
}
```

---

## ✅ **Security Best Practices**

### 1. **Secure Development Practices**

```dart
// ✅ GOOD: Secure configuration
class SecureConfig {
  // Use environment variables for secrets
  static String get encryptionKey => EnvConfig.get('ENCRYPTION_KEY');
  static String get jwtSecret => EnvConfig.get('JWT_SECRET');

  // Never log sensitive data
  static void logSecureOperation(String operation) {
    if (AppConfig.enableLogging) {
      logger.info('Secure operation: $operation'); // No sensitive data logged
    }
  }
}

// ❌ BAD: Insecure configuration
class InsecureConfig {
  // Hardcoded secrets
  static const String encryptionKey = 'hardcoded_secret_key'; // Security risk!
  static const String jwtSecret = 'hardcoded_jwt_secret';   // Security risk!

  // Log sensitive data
  static void logSecureOperation(String operation, String sensitiveData) {
    logger.info('$operation: $sensitiveData'); // Sensitive data logged!
  }
}
```

### 2. **Secure Storage Practices**

```dart
// ✅ GOOD: Secure storage with encryption
class SecureStorageManager {
  static Future<void> storeUserData(UserData userData) async {
    // Encrypt before storage
    final encryptedData = await _encryptionService.encrypt(
      jsonEncode(userData.toJson()),
      _getEncryptionKey(),
    );

    await _secureStorage.write('user_data', encryptedData);
  }
}

// ❌ BAD: Insecure storage
class InsecureStorageManager {
  static Future<void> storeUserData(UserData userData) async {
    // Store without encryption
    await _preferences.setString('user_data', jsonEncode(userData.toJson())); // Security risk!
  }
}
```

### 3. **Secure Network Practices**

```dart
// ✅ GOOD: Secure network communication
class SecureApiClient {
  Future<Response> makeSecureRequest(String endpoint, Map<String, dynamic> data) async {
    // Use HTTPS only
    final url = 'https://api.usago.id$endpoint';

    // Sign request
    final headers = await _signRequest(data);

    // Use certificate pinning
    final response = await _dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );

    return response;
  }
}

// ❌ BAD: Insecure network communication
class InsecureApiClient {
  Future<Response> makeInsecureRequest(String endpoint, Map<String, dynamic> data) async {
    // Use HTTP (no encryption)
    final url = 'http://api.usago.id$endpoint'; // Security risk!

    // No request signing
    final response = await _dio.post(url, data: data); // Security risk!

    return response;
  }
}
```

### 4. **Secure Authentication Practices**

```dart
// ✅ GOOD: Secure authentication
class SecureAuthService {
  Future<bool> authenticateUser(String email, String password) async {
    // Rate limiting
    if (await _isRateLimited(email)) {
      throw SecurityException(
        message: 'Too many authentication attempts',
        type: SecurityExceptionType.rateLimitExceeded,
      );
    }

    // Use secure password hashing
    final hashedPassword = await _hashPassword(password, user.salt);

    // Implement account lockout
    if (user.failedAttempts >= SecurityConstants.maxFailedAttempts) {
      await _lockAccount(user);
    }

    return await _verifyCredentials(email, hashedPassword);
  }
}

// ❌ BAD: Insecure authentication
class InsecureAuthService {
  Future<bool> authenticateUser(String email, String password) async {
    // No rate limiting
    // Plain text password comparison
    // No account lockout

    return await _verifyPlainCredentials(email, password); // Security risk!
  }
}
```

---

## 🔗 **Related Documentation**

- [`shared-utilities-guide.md`](./shared-utilities-guide.md) - Shared utilities documentation
- [`architecture-patterns.md`](./architecture-patterns.md) - Architecture patterns and data flow
- [`configuration-management.md`](./configuration-management.md) - Configuration and constants
- [`performance-monitoring.md`](./performance-monitoring.md) - Performance monitoring guide
- [`code-review-checklist.md`](./code-review-checklist.md) - Code review guidelines

---

## 📞 **Contact Information**

### **Development Team**

| Role | Name | Contact |
|-------|-------|----------|
| **Mobile Lead** | [Name] | [Email] |
| **Security Team** | [Name] | [Email] |
| **Tech Lead** | [Name] | [Email] |

### **Support**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Security Incident** | [Name] | 1 hour |
| **Vulnerability Report** | [Name] | 2 hours |
| **Security Question** | [Name] | 4 hours |
| **Security Audit** | [Name] | 1 week |

---

## 📝 **Notes**

### **Current Status (November 15, 2025)**
- ✅ **Encryption Implementation**: AES-256-GCM with secure key management
- ✅ **Key Rotation**: Automated key rotation with metadata tracking
- ✅ **Secure Storage**: Hardware-backed secure storage with encryption
- ✅ **Authentication Security**: Token management and biometric authentication
- ✅ **Network Security**: Certificate pinning and request signing
- ✅ **Data Protection**: Input validation, sanitization, and masking

### **Future Enhancements**
- 🔄 **Zero Trust Architecture**: Implement zero trust security model
- 🔄 **Hardware Security Module**: HSM integration for key management
- 🔄 **Advanced Threat Detection**: ML-based anomaly detection
- 🔄 **Security Analytics**: Advanced security monitoring and analytics
- 🔄 **Compliance Framework**: Automated compliance checking

---

**Document End**

**Go Digital, Grow Together.**