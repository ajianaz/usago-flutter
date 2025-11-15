import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../platform/platform_detector.dart';
import '../config/app_config.dart';

/// Enhanced secure storage service dengan enkripsi hardware-level dan enkripsi tambahan
/// Menggunakan Flutter Secure Storage dengan konfigurasi keamanan maksimal
/// Dilengkapi dengan enkripsi AES-256 untuk data sensitif
class EnhancedSecureStorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;
  final AppLogger _logger;
  late final Encrypter _encrypter;
  late final IV _iv;
  static const String _encryptionKeyKey = '_encryption_key_';
  static const String _ivKey = '_encryption_iv_';

  EnhancedSecureStorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _prefs = prefs,
        _logger = logger {
    _initializeEncryption();
  }

  /// Inisialisasi enkripsi dengan key yang aman
  Future<void> _initializeEncryption() async {
    try {
      final key = await _getOrCreateEncryptionKey();
      final iv = await _getOrCreateIV();

      _encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      _iv = iv;

      _logger.info('Enhanced encryption initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize encryption', e);
      rethrow;
    }
  }

  /// Mendapatkan atau membuat encryption key yang aman
  Future<Key> _getOrCreateEncryptionKey() async {
    try {
      String? keyString = await _secureStorage.read(key: _encryptionKeyKey);

      if (keyString == null) {
        // Generate new encryption key menggunakan SHA-256 dari device ID dan app secret
        final deviceKey = await _generateDeviceBasedKey();
        keyString = base64.encode(deviceKey.bytes);
        await _secureStorage.write(key: _encryptionKeyKey, value: keyString);
        _logger.info('New encryption key generated and stored');
      }

      return Key.fromBase64(keyString);
    } catch (e) {
      _logger.error('Failed to get or create encryption key', e);
      rethrow;
    }
  }

  /// Mendapatkan atau membuat IV untuk enkripsi
  Future<IV> _getOrCreateIV() async {
    try {
      String? ivString = await _secureStorage.read(key: _ivKey);

      if (ivString == null) {
        // Generate new IV
        final iv = IV.fromSecureRandom(16);
        ivString = base64.encode(iv.bytes);
        await _secureStorage.write(key: _ivKey, value: ivString);
        _logger.info('New IV generated and stored');
      }

      return IV.fromBase64(ivString);
    } catch (e) {
      _logger.error('Failed to get or create IV', e);
      rethrow;
    }
  }

  /// Generate device-based key untuk keamanan tambahan
  Future<Key> _generateDeviceBasedKey() async {
    try {
      // Combine device identifier dengan app secret untuk key yang unik per device
      final deviceInfo = PlatformDetector.platformName;
      final appSecret = AppConfig.encryptionKey;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      final combined = '$deviceInfo$appSecret$timestamp';
      final bytes = utf8.encode(combined);
      final digest = sha256.convert(bytes);

      return Key(Uint8List.fromList(digest.bytes));
    } catch (e) {
      _logger.error('Failed to generate device-based key', e);
      // Fallback ke random key jika device-based key gagal
      return Key.fromSecureRandom(32);
    }
  }

  /// Konfigurasi Flutter Secure Storage dengan keamanan maksimal
  AndroidOptions get _androidOptions => const AndroidOptions(
        encryptedSharedPreferences: true,
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        sharedPreferencesName: 'SecureStorage',
        preferencesKeyPrefix: 'UsagoSecure_',
        resetOnError: true,
      );

  IOSOptions get _iosOptions => const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
        synchronizable: false,
        accountName: 'usago_secure_storage',
      );

  /// Enkripsi data sebelum disimpan
  String _encryptData(String data) {
    try {
      final encrypted = _encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      _logger.error('Failed to encrypt data', e);
      rethrow;
    }
  }

  /// Dekripsi data setelah dibaca
  String _decryptData(String encryptedData) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedData);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      _logger.error('Failed to decrypt data', e);
      rethrow;
    }
  }

  /// Simpan data sensitif dengan enkripsi maksimal
  Future<void> saveSensitiveData(String key, String value) async {
    try {
      final encryptedValue = _encryptData(value);

      if (isSecureStorageAvailable) {
        await _secureStorage.write(
          key: key,
          value: encryptedValue,
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        );
      } else {
        // Fallback ke SharedPreferences untuk non-mobile platforms
        await _prefs.setString(key, encryptedValue);
      }

      _logger.info('Sensitive data encrypted and saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save sensitive data for key: $key', e);
      rethrow;
    }
  }

  /// Ambil data sensitif dengan dekripsi
  Future<String?> getSensitiveData(String key) async {
    try {
      String? encryptedValue;

      if (isSecureStorageAvailable) {
        encryptedValue = await _secureStorage.read(
          key: key,
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        );
      } else {
        // Fallback ke SharedPreferences untuk non-mobile platforms
        encryptedValue = _prefs.getString(key);
      }

      if (encryptedValue == null) return null;

      final decryptedValue = _decryptData(encryptedValue);
      _logger.info('Sensitive data decrypted and retrieved for key: $key');
      return decryptedValue;
    } catch (e) {
      _logger.error('Failed to get sensitive data for key: $key', e);
      return null;
    }
  }

  /// Hapus data sensitif
  Future<void> removeSensitiveData(String key) async {
    try {
      if (isSecureStorageAvailable) {
        await _secureStorage.delete(
          key: key,
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        );
      } else {
        await _prefs.remove(key);
      }

      _logger.info('Sensitive data removed for key: $key');
    } catch (e) {
      _logger.error('Failed to remove sensitive data for key: $key', e);
      rethrow;
    }
  }

  /// Simpan data non-sensitif tanpa enkripsi
  Future<void> saveNonSensitiveData(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      _logger.info('Non-sensitive data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save non-sensitive data for key: $key', e);
      rethrow;
    }
  }

  /// Ambil data non-sensitif
  Future<String?> getNonSensitiveData(String key) async {
    try {
      final value = _prefs.getString(key);
      _logger.info('Non-sensitive data retrieved for key: $key');
      return value;
    } catch (e) {
      _logger.error('Failed to get non-sensitive data for key: $key', e);
      return null;
    }
  }

  /// Hapus data non-sensitif
  Future<void> removeNonSensitiveData(String key) async {
    try {
      await _prefs.remove(key);
      _logger.info('Non-sensitive data removed for key: $key');
    } catch (e) {
      _logger.error('Failed to remove non-sensitive data for key: $key', e);
      rethrow;
    }
  }

  /// Hapus semua data sensitif
  Future<void> clearAllSensitiveData() async {
    try {
      if (isSecureStorageAvailable) {
        await _secureStorage.deleteAll(
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        );
      }

      _logger.info('All sensitive data cleared');
    } catch (e) {
      _logger.error('Failed to clear all sensitive data', e);
      rethrow;
    }
  }

  /// Hapus semua data non-sensitif
  Future<void> clearAllNonSensitiveData() async {
    try {
      await _prefs.clear();
      _logger.info('All non-sensitive data cleared');
    } catch (e) {
      _logger.error('Failed to clear all non-sensitive data', e);
      rethrow;
    }
  }

  /// Periksa ketersediaan secure storage
  bool get isSecureStorageAvailable {
    try {
      return PlatformDetector.isMobile;
    } catch (e) {
      _logger.warning('Failed to check secure storage availability', e);
      return false;
    }
  }

  /// Dapatkan informasi storage
  Map<String, dynamic> getStorageInfo() {
    return {
      'secureStorageAvailable': isSecureStorageAvailable,
      'platform': PlatformDetector.platformName,
      'encryptionEnabled': true,
      'encryptionAlgorithm': 'AES-256-GCM',
      'keyCipherAlgorithm': 'RSA_ECB_OAEPwithSHA_256andMGF1Padding',
      'storageCipherAlgorithm': 'AES_GCM_NoPadding',
      'recommendedStorage': isSecureStorageAvailable
          ? 'EnhancedFlutterSecureStorage'
          : 'SharedPreferences',
    };
  }

  /// Validasi integritas data
  Future<bool> validateDataIntegrity(String key) async {
    try {
      final data = await getSensitiveData(key);
      return data != null;
    } catch (e) {
      _logger.error('Data integrity validation failed for key: $key', e);
      return false;
    }
  }

  /// Rotasi encryption key untuk keamanan tambahan
  Future<void> rotateEncryptionKey() async {
    try {
      _logger.info('Starting encryption key rotation');

      // Generate new key dan IV
      final newKey = await _generateDeviceBasedKey();
      final newIV = IV.fromSecureRandom(16);

      // Update encrypter dengan key baru
      _encrypter = Encrypter(AES(newKey, mode: AESMode.gcm));
      _iv = newIV;

      // Simpan key dan IV baru
      await _secureStorage.write(
          key: _encryptionKeyKey, value: base64.encode(newKey.bytes));
      await _secureStorage.write(
          key: _ivKey, value: base64.encode(newIV.bytes));

      _logger.info('Encryption key rotation completed successfully');
    } catch (e) {
      _logger.error('Failed to rotate encryption key', e);
      rethrow;
    }
  }

  // Metode spesifik untuk autentikasi
  Future<void> saveToken(String token) async {
    await saveSensitiveData(AppConstants.bearerTokenKey, token);
  }

  Future<String?> getToken() async {
    return await getSensitiveData(AppConstants.bearerTokenKey);
  }

  Future<void> clearToken() async {
    await removeSensitiveData(AppConstants.bearerTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await saveSensitiveData(StorageConstants.refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await getSensitiveData(StorageConstants.refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await removeSensitiveData(StorageConstants.refreshTokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await saveSensitiveData(AppConstants.userDataKey, userData);
  }

  Future<String?> getUserData() async {
    return await getSensitiveData(AppConstants.userDataKey);
  }

  Future<void> clearUserData() async {
    await removeSensitiveData(AppConstants.userDataKey);
  }

  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      final sessionJson = jsonEncode(sessionData);
      await saveSensitiveData('session_data', sessionJson);
      _logger.info('Session data encrypted and saved');
    } catch (e) {
      _logger.error('Failed to save session data', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final sessionJson = await getSensitiveData('session_data');
      if (sessionJson == null) return null;

      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      _logger.info('Session data decrypted and retrieved');
      return sessionMap;
    } catch (e) {
      _logger.error('Failed to get session data', e);
      return null;
    }
  }

  Future<void> clearSessionData() async {
    await removeSensitiveData('session_data');
  }

  Future<void> saveApiKey(String apiKey) async {
    await saveSensitiveData('api_key', apiKey);
  }

  Future<String?> getApiKey() async {
    return await getSensitiveData('api_key');
  }

  Future<void> clearApiKey() async {
    await removeSensitiveData('api_key');
  }

  // Metode untuk membersihkan semua data autentikasi
  Future<void> clearAllAuthData() async {
    await clearToken();
    await clearRefreshToken();
    await clearUserData();
    await clearSessionData();
    await clearApiKey();
    _logger.info('All auth data cleared from enhanced secure storage');
  }

  /// Log informasi platform untuk debugging
  void logPlatformInfo() {
    PlatformDetector.logPlatformInfo();
  }

  /// Periksa apakah fitur didukung
  bool isFeatureSupported(String feature) {
    return PlatformDetector.isFeatureSupported(feature);
  }
}
