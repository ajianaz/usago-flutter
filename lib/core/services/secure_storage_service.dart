import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';
import '../utils/logger.dart';
import 'platform_storage_interface.dart';
import 'platform_detector.dart';
import 'mobile_secure_storage.dart';
import 'web_secure_storage.dart';
import 'desktop_secure_storage.dart';

/// Secure storage service untuk sensitive data seperti tokens
///
/// Menggunakan platform-specific secure storage implementations:
/// - Mobile (iOS/Android): FlutterSecureStorage dengan konfigurasi optimal
/// - Web: SharedPreferences dengan encryption layer
/// - Desktop (Windows/Linux/macOS): Platform-specific secure storage
///
/// Class ini menyediakan interface yang konsisten untuk semua operasi storage
/// di semua platform dengan fallback mechanism untuk error handling.
class SecureStorageService {
  late PlatformStorageInterface _secureStorage;
  final AppLogger _logger;
  bool _isInitialized = false;

  SecureStorageService({
    PlatformStorageInterface? secureStorage,
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger() {
    if (secureStorage != null) {
      _secureStorage = secureStorage;
    }
  }

  /// Initialize secure storage with platform-specific implementation
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize platform-specific secure storage
      if (PlatformDetector.isMobile) {
        _secureStorage = MobileSecureStorage(logger: _logger);
        await _secureStorage.initialize();
      } else if (PlatformDetector.isWeb) {
        _secureStorage = WebSecureStorage(logger: _logger);
        await _secureStorage.initialize();
      } else if (PlatformDetector.isDesktop) {
        _secureStorage = DesktopSecureStorage(logger: _logger);
        await _secureStorage.initialize();
      } else {
        // Fallback to basic implementation
        _secureStorage = _createFallbackStorage();
        await _secureStorage.initialize();
      }

      _isInitialized = true;
      _logger.info(
          'SecureStorageService initialized for ${PlatformDetector.platformName}');
    } catch (e) {
      _logger.error('Failed to initialize SecureStorageService', e);
      // Fallback to SharedPreferences in case of initialization failure
      _secureStorage = _createFallbackStorage();
      await _secureStorage.initialize();
      _isInitialized = true;
      _logger.warning('SecureStorageService initialized with fallback storage');
    }
  }

  /// Create fallback storage using SharedPreferences
  PlatformStorageInterface _createFallbackStorage() {
    return _FallbackSecureStorage(logger: _logger);
  }

  /// Ensure storage is initialized before operations
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Save data to secure storage
  ///
  /// [key] Storage key
  /// [value] Value to save (will be JSON encoded if it's a Map or List)
  /// [isSecure] Whether to use secure storage (default: true for sensitive keys)
  Future<void> save(String key, dynamic value, {bool isSecure = true}) async {
    try {
      // Determine if this is sensitive data based on key or explicit parameter
      final shouldUseSecureStorage = isSecure || _isSensitiveKey(key);

      String stringValue;
      if (value is Map || value is List) {
        stringValue = jsonEncode(value);
      } else {
        stringValue = value.toString();
      }

      if (shouldUseSecureStorage) {
        await _secureStorage.write(key, stringValue);
        _logger.info('Secure data saved for key: $key');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, stringValue);
        _logger.info('Data saved to preferences for key: $key');
      }
    } catch (e) {
      _logger.error('Failed to save data for key: $key', e);
      rethrow;
    }
  }

  /// Get data from storage
  ///
  /// [key] Storage key
  /// [isSecure] Whether to use secure storage (default: true for sensitive keys)
  /// Returns [T?] or null if not found
  Future<T?> get<T>(String key, {bool isSecure = true}) async {
    try {
      // Determine if this is sensitive data based on key or explicit parameter
      final shouldUseSecureStorage = isSecure || _isSensitiveKey(key);

      String? stringValue;

      if (shouldUseSecureStorage) {
        stringValue = await _secureStorage.read(key);
      } else {
        final prefs = await SharedPreferences.getInstance();
        stringValue = prefs.getString(key);
      }

      if (stringValue == null) {
        _logger.info('No data found for key: $key');
        return null;
      }

      // Try to parse as JSON first
      try {
        final decoded = jsonDecode(stringValue);

        if (T == Map<String, dynamic>) {
          return decoded as T;
        } else if (T == String) {
          return stringValue as T;
        } else if (decoded is T) {
          return decoded;
        }
      } catch (e) {
        // If JSON parsing fails, return as string
        if (T == String) {
          return stringValue as T;
        }
      }

      // Fallback to string conversion
      if (T == String) {
        return stringValue as T;
      }

      _logger.warning('Could not convert data to expected type for key: $key');
      return null;
    } catch (e) {
      _logger.error('Failed to get data for key: $key', e);
      return null;
    }
  }

  /// Remove data from storage
  ///
  /// [key] Storage key
  /// [isSecure] Whether to use secure storage (default: true for sensitive keys)
  Future<void> remove(String key, {bool isSecure = true}) async {
    try {
      // Determine if this is sensitive data based on key or explicit parameter
      final shouldUseSecureStorage = isSecure || _isSensitiveKey(key);

      if (shouldUseSecureStorage) {
        await _secureStorage.delete(key);
        _logger.info('Secure data removed for key: $key');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
        _logger.info('Data removed from preferences for key: $key');
      }
    } catch (e) {
      _logger.error('Failed to remove data for key: $key', e);
      rethrow;
    }
  }

  /// Clear all data from both secure and regular storage
  Future<void> clearAll() async {
    try {
      // Clear secure storage
      await _secureStorage.deleteAll();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _logger.info('All storage data cleared');
    } catch (e) {
      _logger.error('Failed to clear all storage data', e);
      rethrow;
    }
  }

  /// Check if key exists in storage
  ///
  /// [key] Storage key
  /// [isSecure] Whether to use secure storage (default: true for sensitive keys)
  /// Returns [bool] true if key exists
  Future<bool> containsKey(String key, {bool isSecure = true}) async {
    try {
      // Determine if this is sensitive data based on key or explicit parameter
      final shouldUseSecureStorage = isSecure || _isSensitiveKey(key);

      if (shouldUseSecureStorage) {
        final value = await _secureStorage.read(key);
        return value != null;
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey(key);
      }
    } catch (e) {
      _logger.error('Failed to check key existence for: $key', e);
      return false;
    }
  }

  /// Get all keys from secure storage
  Future<Set<String>> getSecureKeys() async {
    try {
      return await _secureStorage.getAllKeys();
    } catch (e) {
      _logger.error('Failed to get secure keys', e);
      return <String>{};
    }
  }

  /// Determine if a key should be stored securely
  bool _isSensitiveKey(String key) {
    final sensitiveKeys = [
      StorageConstants.authTokenKey,
      StorageConstants.bearerTokenKey,
      StorageConstants.refreshTokenKey,
      StorageConstants.sessionDataKey,
      StorageConstants.biometricEnabledKey,
    ];

    return sensitiveKeys.contains(key) ||
        key.toLowerCase().contains('token') ||
        key.toLowerCase().contains('password') ||
        key.toLowerCase().contains('secret') ||
        key.toLowerCase().contains('key');
  }

  /// Migrate data from SharedPreferences to SecureStorage
  ///
  /// Ini adalah utility untuk migrasi data lama ke secure storage
  Future<void> migrateFromSharedPreferences() async {
    try {
      _logger
          .info('Starting migration from SharedPreferences to SecureStorage');

      final prefs = await SharedPreferences.getInstance();
      final keysToMigrate = [
        StorageConstants.bearerTokenKey,
        StorageConstants.refreshTokenKey,
        StorageConstants.authTokenKey,
        StorageConstants.sessionDataKey,
      ];

      for (final key in keysToMigrate) {
        final value = prefs.getString(key);
        if (value != null && value.isNotEmpty) {
          await save(key, value, isSecure: true);
          await prefs.remove(key);
          _logger.info('Migrated key: $key to secure storage');
        }
      }

      _logger.info('Migration completed successfully');
    } catch (e) {
      _logger.error('Migration failed', e);
      rethrow;
    }
  }
}

/// Fallback secure storage implementation using SharedPreferences
///
/// This is a fallback implementation that uses SharedPreferences
/// when secure storage is not available or fails to initialize.
/// Note: This is NOT secure and should only be used as fallback.
class _FallbackSecureStorage implements PlatformStorageInterface {
  final AppLogger _logger;
  bool _isInitialized = false;
  late SharedPreferences _prefs;

  _FallbackSecureStorage({required AppLogger logger}) : _logger = logger;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      _logger.warning('Fallback storage initialized (NOT SECURE)');
    } catch (e) {
      _logger.error('Failed to initialize fallback storage', e);
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    await _ensureInitialized();
    await _prefs.setString('fallback_$key', value);
    _logger.warning('Fallback storage write for key: $key (NOT SECURE)');
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();
    return _prefs.getString('fallback_$key');
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();
    await _prefs.remove('fallback_$key');
  }

  @override
  Future<void> deleteAll() async {
    await _ensureInitialized();
    final keys = _prefs.getKeys().where((key) => key.startsWith('fallback_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs.containsKey('fallback_$key');
  }

  @override
  Future<Set<String>> getAllKeys() async {
    await _ensureInitialized();
    return _prefs
        .getKeys()
        .where((key) => key.startsWith('fallback_'))
        .map((key) => key.substring(9)) // Remove 'fallback_' prefix
        .toSet();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
