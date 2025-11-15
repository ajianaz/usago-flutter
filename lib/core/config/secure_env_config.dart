import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/encryption_util.dart';

/// Secure Environment Configuration untuk handle encrypted environment variables
class SecureEnvConfig {
  static bool _isInitialized = false;
  static Map<String, String> _envMap = {};
  static Map<String, bool> _isEncryptedMap = {};

  /// List of sensitive environment variables yang harus dienkripsi
  static const Set<String> _sensitiveKeys = {
    'ENCRYPTION_KEY',
    'JWT_SECRET',
    'API_SECRET_KEY',
    'DATABASE_PASSWORD',
    'STRIPE_SECRET_KEY',
    'GOOGLE_MAPS_API_KEY',
    'FIREBASE_API_KEY',
    'SENTRY_DSN',
    'TWILIO_AUTH_TOKEN',
    'AWS_SECRET_ACCESS_KEY',
    'REDIS_PASSWORD',
    'SSL_CERTIFICATE_PASSWORD',
    'OAUTH_CLIENT_SECRET',
    'PAYMENT_GATEWAY_SECRET',
    'EXTERNAL_API_SECRET',
  };

  /// Initialize secure environment configuration
  static Future<void> initialize({String? envFileName}) async {
    if (_isInitialized) return;

    try {
      // Determine which .env file to load
      String fileName = envFileName ?? _getEnvFileName();

      // Load the appropriate .env file
      await dotenv.load(fileName: fileName);
      _envMap = dotenv.env;
      _isEncryptedMap = {};

      // Check dan decrypt sensitive variables
      await _processSensitiveVariables();

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading secure environment: $e');
      }
      // Fallback ke empty maps
      _envMap = {};
      _isEncryptedMap = {};
      _isInitialized = true;
    }
  }

  /// Get the appropriate .env file name based on build mode
  static String _getEnvFileName() {
    if (kReleaseMode) {
      return '.env.production';
    } else if (kProfileMode) {
      return '.env.staging';
    } else {
      return '.env.development';
    }
  }

  /// Process sensitive variables - decrypt jika terenkripsi
  static Future<void> _processSensitiveVariables() async {
    for (final key in _sensitiveKeys) {
      if (_envMap.containsKey(key)) {
        final value = _envMap[key]!;

        // Check apakah value terenkripsi
        if (EncryptionUtil.isEncrypted(value)) {
          try {
            // Decrypt value
            final decryptedValue = await EncryptionUtil.decrypt(value);
            _envMap[key] = decryptedValue;
            _isEncryptedMap[key] = true;

            if (kDebugMode) {
              print('Decrypted sensitive variable: ${_maskSensitiveKey(key)}');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Failed to decrypt ${_maskSensitiveKey(key)}: $e');
            }
            _isEncryptedMap[key] = false;
          }
        } else {
          _isEncryptedMap[key] = false;

          // Warning untuk development jika sensitive variables tidak terenkripsi
          if (kDebugMode) {
            print('Warning: Sensitive variable ${_maskSensitiveKey(key)} is not encrypted');
          }
        }
      }
    }
  }

  /// Get environment variable dengan automatic decryption untuk sensitive variables
  static String get(String key, {String? defaultValue}) {
    if (!_isInitialized) {
      throw Exception('SecureEnvConfig not initialized. Call initialize() first.');
    }

    final value = _envMap[key];
    if (value == null || value.isEmpty) {
      return defaultValue ?? '';
    }

    return value;
  }

  /// Get environment variable sebagai boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Get environment variable sebagai integer
  static int getInt(String key, {int defaultValue = 0}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return int.tryParse(value) ?? defaultValue;
  }

  /// Get environment variable sebagai double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return double.tryParse(value) ?? defaultValue;
  }

  /// Check apakah environment variable adalah sensitive
  static bool isSensitive(String key) {
    return _sensitiveKeys.contains(key);
  }

  /// Check apakah environment variable terenkripsi
  static bool isEncrypted(String key) {
    if (!_isInitialized) {
      throw Exception('SecureEnvConfig not initialized. Call initialize() first.');
    }
    return _isEncryptedMap[key] ?? false;
  }

  /// Encrypt sensitive environment variable
  static Future<String> encryptSensitiveValue(String key, String value) async {
    if (!_sensitiveKeys.contains(key)) {
      throw Exception('Key $key is not in the sensitive keys list');
    }

    return await EncryptionUtil.encrypt(value);
  }

  /// Encrypt semua sensitive variables di map
  static Future<Map<String, String>> encryptAllSensitive() async {
    final encryptedMap = <String, String>{};

    for (final key in _sensitiveKeys) {
      if (_envMap.containsKey(key) && !(_isEncryptedMap[key] ?? false)) {
        try {
          final encryptedValue = await EncryptionUtil.encrypt(_envMap[key]!);
          encryptedMap[key] = encryptedValue;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to encrypt ${_maskSensitiveKey(key)}: $e');
          }
        }
      }
    }

    return encryptedMap;
  }

  /// Validate required environment variables
  static List<String> validateRequired(List<String> requiredKeys) {
    final missingKeys = <String>[];

    for (final key in requiredKeys) {
      final value = get(key);
      if (value.isEmpty) {
        missingKeys.add(key);
      }
    }

    return missingKeys;
  }

  /// Get semua environment variables (untuk debugging)
  static Map<String, String> get all {
    if (!_isInitialized) {
      throw Exception('SecureEnvConfig not initialized. Call initialize() first.');
    }

    // Return copy untuk prevent modification
    return Map.unmodifiable(_envMap);
  }

  /// Get semua sensitive keys
  static Set<String> get sensitiveKeys => Set.unmodifiable(_sensitiveKeys);

  /// Check apakah environment variable exists
  static bool contains(String key) {
    if (!_isInitialized) {
      throw Exception('SecureEnvConfig not initialized. Call initialize() first.');
    }
    return _envMap.containsKey(key) && _envMap[key]!.isNotEmpty;
  }

  /// Add new sensitive key
  static void addSensitiveKey(String key) {
    if (!_sensitiveKeys.contains(key)) {
      _sensitiveKeys.add(key);
      if (kDebugMode) {
        print('Added new sensitive key: ${_maskSensitiveKey(key)}');
      }
    }
  }

  /// Remove sensitive key
  static void removeSensitiveKey(String key) {
    if (_sensitiveKeys.contains(key)) {
      _sensitiveKeys.remove(key);
      if (kDebugMode) {
        print('Removed sensitive key: ${_maskSensitiveKey(key)}');
      }
    }
  }

  /// Refresh configuration (reload dan re-process)
  static Future<void> refresh({String? envFileName}) async {
    _isInitialized = false;
    await initialize(envFileName: envFileName);
  }

  /// Get encryption status summary
  static Map<String, dynamic> getEncryptionStatus() {
    if (!_isInitialized) {
      throw Exception('SecureEnvConfig not initialized. Call initialize() first.');
    }

    final status = <String, dynamic>{};
    for (final key in _sensitiveKeys) {
      status[key] = {
        'exists': _envMap.containsKey(key),
        'encrypted': _isEncryptedMap[key] ?? false,
        'sensitive': true,
      };
    }

    return status;
  }

  /// Mask sensitive key untuk logging
  static String _maskSensitiveKey(String key) {
    if (key.length <= 4) {
      return '${key.substring(0, 1)}***';
    }
    return '${key.substring(0, 2)}***${key.substring(key.length - 2)}';
  }
}