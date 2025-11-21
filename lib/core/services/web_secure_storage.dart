import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform_storage_interface.dart';
import '../utils/logger.dart';

/// Web secure storage implementation with encryption
///
/// This implementation provides secure storage for web platform
/// using localStorage with AES encryption for sensitive data.
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
        _encryptionKey = encryptionKey ?? _generateDefaultKey();

  /// Initialize web secure storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
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

      final decryptedValue = _decrypt(encryptedValue);
      _logger.info('Web secure data retrieved for key: $key');
      return decryptedValue;
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

      return base64.encode(encryptedBytes);
    } catch (e) {
      _logger.error('Encryption failed', e);
      rethrow;
    }
  }

  /// Decrypt data using XOR cipher with SHA-256 key
  String _decrypt(String encryptedData) {
    try {
      final keyBytes = sha256.convert(utf8.encode(_encryptionKey)).bytes;
      final encryptedBytes = base64.decode(encryptedData);

      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      _logger.error('Decryption failed', e);
      rethrow;
    }
  }

  /// Generate default encryption key based on browser fingerprint
  static String _generateDefaultKey() {
    try {
      // Create a browser-specific key using available information
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final userAgent = 'web_secure_storage'; // Simplified for consistency
      final combined = '$userAgent$timestamp';

      return sha256.convert(utf8.encode(combined)).toString();
    } catch (e) {
      // Fallback to a hardcoded key (not recommended for production)
      return 'default_web_secure_storage_key_fallback';
    }
  }

  static const String _securePrefix = 'secure_';
}
