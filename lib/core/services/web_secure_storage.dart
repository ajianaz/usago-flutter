import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform_storage_interface.dart';
import '../utils/logger.dart';

/// Web secure storage implementation with encryption
///
/// This implementation provides secure storage for web platform
/// using localStorage with XOR encryption for sensitive data.
/// For web, we use SharedPreferences as base storage with encryption layer.
class WebSecureStorage implements PlatformStorageInterface {
  final AppLogger _logger;
  final String _encryptionKey;
  bool _isInitialized = false;
  late SharedPreferences _prefs;

  WebSecureStorage({
    AppLogger? logger,
    String? encryptionKey,
  })  : _logger = logger ?? AppLogger(),
        _encryptionKey = encryptionKey ?? _getStaticKey();

  /// Initialize web secure storage
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      // Migrate old data to new format
      await migrateOldData();

      _isInitialized = true;
      _logger.info('Web secure storage initialized');
    } catch (e) {
      _logger.error('Failed to initialize web secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    await _ensureInitialized();

    try {
      final encryptedValue = _encrypt(value);
      await _prefs.setString(_getStorageKey(key), encryptedValue);
      _logger.info('Web secure data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save web secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();

    try {
      final encryptedValue = _prefs.getString(_getStorageKey(key));
      if (encryptedValue == null) {
        _logger.info('No web secure data found for key: $key');
        return null;
      }

      String? decryptedValue;

      // Try new format first
      if (_isValidEncryptedData(encryptedValue)) {
        try {
          decryptedValue = _decrypt(encryptedValue);
          _logger.info('Web secure data retrieved for key: $key (new format)');
          return decryptedValue;
        } catch (e) {
          _logger.warning(
              'Failed to decrypt with new format for key: $key, trying old format',
              e);
        }
      }

      // Fallback to old format
      try {
        decryptedValue = _decryptOldData(encryptedValue);
        if (decryptedValue != null) {
          // Migrate to new format for future reads
          try {
            final newEncryptedValue = _encrypt(decryptedValue);
            await _prefs.setString(_getStorageKey(key), newEncryptedValue);
            _logger
                .info('Migrated and retrieved data for key: $key (old format)');
          } catch (migrationError) {
            _logger.warning(
                'Failed to migrate data for key: $key', migrationError);
          }
          return decryptedValue;
        }
      } catch (e) {
        _logger.warning('Failed to decrypt with old format for key: $key', e);
      }

      _logger.warning('Could not decrypt data for key: $key');
      return null;
    } catch (e) {
      _logger.error('Failed to read web secure data for key: $key', e);
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();

    try {
      await _prefs.remove(_getStorageKey(key));
      _logger.info('Web secure data deleted for key: $key');
    } catch (e) {
      _logger.error('Failed to delete web secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    await _ensureInitialized();

    try {
      final keys =
          _prefs.getKeys().where((key) => key.startsWith(_securePrefix));
      for (final key in keys) {
        await _prefs.remove(key);
      }
      _logger.info('All web secure data deleted');
    } catch (e) {
      _logger.error('Failed to delete all web secure data', e);
      rethrow;
    }
  }

  /// Migrate old encrypted data to new format
  /// This method should be called during app initialization
  Future<void> migrateOldData() async {
    // Don't call _ensureInitialized() here to avoid circular dependency
    // This method is called from initialize() after _prefs is set
    if (_prefs == null) {
      _logger.warning('SharedPreferences not initialized, skipping migration');
      return;
    }

    try {
      final keys =
          _prefs.getKeys().where((key) => key.startsWith(_securePrefix));
      bool hasMigrated = false;

      for (final storageKey in keys) {
        try {
          final encryptedValue = _prefs.getString(storageKey);
          if (encryptedValue != null && !encryptedValue.startsWith('enc_')) {
            // This is old format data, try to decrypt with old method and re-encrypt
            final decryptedValue = _decryptOldData(encryptedValue);
            if (decryptedValue != null) {
              // Re-encrypt with new format
              final newEncryptedValue = _encrypt(decryptedValue);
              await _prefs.setString(storageKey, newEncryptedValue);
              hasMigrated = true;
              _logger.info('Migrated old encrypted data for key: $storageKey');
            }
          }
        } catch (e) {
          _logger.warning('Failed to migrate data for key: $storageKey', e);
          // Continue with other keys
        }
      }

      if (hasMigrated) {
        _logger.info('Old data migration completed');
      }
    } catch (e) {
      _logger.error('Failed to migrate old data', e);
    }
  }

  /// Decrypt old format data (without prefix)
  String? _decryptOldData(String encryptedData) {
    try {
      final keyBytes = sha256.convert(utf8.encode(_encryptionKey)).bytes;
      final encryptedBytes = base64.decode(encryptedData);

      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      _logger.warning('Failed to decrypt old data format', e);
      return null;
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();

    try {
      return _prefs.containsKey(_getStorageKey(key));
    } catch (e) {
      _logger.error('Failed to check key existence for: $key', e);
      return false;
    }
  }

  @override
  Future<Set<String>> getAllKeys() async {
    await _ensureInitialized();

    try {
      final secureKeys = _prefs
          .getKeys()
          .where((key) => key.startsWith(_securePrefix))
          .map((key) => key.substring(_securePrefix.length))
          .toSet();

      return secureKeys;
    } catch (e) {
      _logger.error('Failed to get all web secure keys', e);
      return <String>{};
    }
  }

  /// Ensure storage is initialized before operations
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get storage key with prefix
  String _getStorageKey(String key) => '$_securePrefix$key';

  /// Encrypt data using XOR cipher with SHA-256 key
  String _encrypt(String data) {
    try {
      final keyBytes = sha256.convert(utf8.encode(_encryptionKey)).bytes;
      final dataBytes = utf8.encode(data);

      final encryptedBytes = <int>[];
      for (int i = 0; i < dataBytes.length; i++) {
        encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      // Add prefix to identify encrypted data
      final encryptedWithPrefix = 'enc_${base64.encode(encryptedBytes)}';
      return encryptedWithPrefix;
    } catch (e) {
      _logger.error('Encryption failed', e);
      rethrow;
    }
  }

  /// Decrypt data using XOR cipher with SHA-256 key
  String? _decrypt(String encryptedData) {
    try {
      final keyBytes = sha256.convert(utf8.encode(_encryptionKey)).bytes;

      // Remove prefix if present
      String actualEncryptedData = encryptedData;
      if (encryptedData.startsWith('enc_')) {
        actualEncryptedData = encryptedData.substring(4);
      }

      // Validate base64 data before decoding
      if (actualEncryptedData.isEmpty) {
        _logger.warning('Empty encrypted data for decryption');
        return null;
      }

      List<int> encryptedBytes;
      try {
        encryptedBytes = base64.decode(actualEncryptedData);
      } catch (e) {
        _logger.warning('Invalid base64 data format: $e');
        return null;
      }

      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      _logger.error('Decryption failed', e);
      return null;
    }
  }

  /// Validate if the encrypted data has correct format
  bool _isValidEncryptedData(String encryptedData) {
    try {
      // Check if data has our encryption prefix
      if (!encryptedData.startsWith('enc_')) {
        return false;
      }

      // Extract actual encrypted part
      final actualEncryptedData = encryptedData.substring(4);

      // Try to decode base64 to validate format
      final decoded = base64.decode(actualEncryptedData);
      return decoded.isNotEmpty;
    } catch (e) {
      _logger.warning('Invalid encrypted data format: $e');
      return false;
    }
  }

  /// Get static encryption key for consistency
  static String _getStaticKey() {
    try {
      // Use a consistent key based on app identifier and platform
      const appIdentifier = 'usago_web_secure_storage';
      const platform = 'web';
      const combined = '${appIdentifier}_${platform}_key_v1';

      return sha256.convert(utf8.encode(combined)).toString();
    } catch (e) {
      // Fallback to a hardcoded key (not recommended for production)
      return 'default_web_secure_storage_key_fallback_v1';
    }
  }

  static const String _securePrefix = 'secure_';
}
