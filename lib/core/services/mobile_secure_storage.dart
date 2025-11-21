import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'platform_storage_interface.dart';
import 'platform_detector.dart';
import '../utils/logger.dart';

/// Mobile secure storage implementation
///
/// This implementation provides secure storage for mobile platforms
/// (iOS/Android) using FlutterSecureStorage with platform-specific
/// configurations for optimal security.
class MobileSecureStorage implements PlatformStorageInterface {
  final AppLogger _logger;
  late FlutterSecureStorage _secureStorage;
  bool _isInitialized = false;

  MobileSecureStorage({
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  /// Initialize mobile secure storage based on platform
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure secure storage based on specific mobile platform
      if (PlatformDetector.isIOS) {
        _secureStorage = _getIOSSecureStorage();
      } else if (PlatformDetector.isAndroid) {
        _secureStorage = _getAndroidSecureStorage();
      } else {
        // Fallback to default configuration
        _secureStorage = const FlutterSecureStorage();
      }

      _isInitialized = true;
      _logger.info(
          'Mobile secure storage initialized for ${PlatformDetector.platformName}');
    } catch (e) {
      _logger.error('Failed to initialize mobile secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    await _ensureInitialized();

    try {
      await _secureStorage.write(key: key, value: value);
      _logger.info('Mobile secure data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save mobile secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();

    try {
      final value = await _secureStorage.read(key: key);
      _logger.info('Mobile secure data retrieved for key: $key');
      return value;
    } catch (e) {
      _logger.error('Failed to read mobile secure data for key: $key', e);
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();

    try {
      await _secureStorage.delete(key: key);
      _logger.info('Mobile secure data deleted for key: $key');
    } catch (e) {
      _logger.error('Failed to delete mobile secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    await _ensureInitialized();

    try {
      await _secureStorage.deleteAll();
      _logger.info('All mobile secure data deleted');
    } catch (e) {
      _logger.error('Failed to delete all mobile secure data', e);
      rethrow;
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();

    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      _logger.error('Failed to check key existence for: $key', e);
      return false;
    }
  }

  @override
  Future<Set<String>> getAllKeys() async {
    await _ensureInitialized();

    try {
      final allData = await _secureStorage.readAll();
      return allData.keys.toSet();
    } catch (e) {
      _logger.error('Failed to get all mobile secure keys', e);
      return <String>{};
    }
  }

  /// Ensure storage is initialized before operations
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get iOS-specific secure storage configuration
  FlutterSecureStorage _getIOSSecureStorage() {
    return const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
        synchronizable: false,
        accountName: 'usago_app',
      ),
    );
  }

  /// Get Android-specific secure storage configuration
  FlutterSecureStorage _getAndroidSecureStorage() {
    return const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      ),
    );
  }

  /// Get platform-specific security information
  String getSecurityInfo() {
    if (PlatformDetector.isIOS) {
      return 'iOS: Using Keychain with first_unlock_this_device_only accessibility';
    } else if (PlatformDetector.isAndroid) {
      return 'Android: Using EncryptedSharedPreferences with RSA/AES encryption';
    }
    return 'Unknown mobile platform';
  }
}
