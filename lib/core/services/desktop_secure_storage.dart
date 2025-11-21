import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'platform_storage_interface.dart';
import 'platform_detector.dart';
import '../utils/logger.dart';

/// Desktop secure storage implementation
///
/// This implementation provides secure storage for desktop platforms
/// (Windows, Linux, macOS) using platform-specific secure storage mechanisms.
/// It uses the appropriate flutter_secure_storage_* package for each platform.
class DesktopSecureStorage implements PlatformStorageInterface {
  final AppLogger _logger;
  late FlutterSecureStorage _secureStorage;
  bool _isInitialized = false;

  DesktopSecureStorage({
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  /// Initialize desktop secure storage based on platform
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure secure storage based on specific desktop platform
      if (PlatformDetector.isWindows) {
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
      } else if (PlatformDetector.isLinux) {
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
      } else if (PlatformDetector.isMacOS) {
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
      } else {
        // Fallback to default options
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
      }

      _isInitialized = true;
      _logger.info(
          'Desktop secure storage initialized for ${PlatformDetector.platformName}');
    } catch (e) {
      _logger.error('Failed to initialize desktop secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    await _ensureInitialized();

    try {
      await _secureStorage.write(key: key, value: value);
      _logger.info('Desktop secure data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save desktop secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();

    try {
      final value = await _secureStorage.read(key: key);
      _logger.info('Desktop secure data retrieved for key: $key');
      return value;
    } catch (e) {
      _logger.error('Failed to read desktop secure data for key: $key', e);
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();

    try {
      await _secureStorage.delete(key: key);
      _logger.info('Desktop secure data deleted for key: $key');
    } catch (e) {
      _logger.error('Failed to delete desktop secure data for key: $key', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    await _ensureInitialized();

    try {
      await _secureStorage.deleteAll();
      _logger.info('All desktop secure data deleted');
    } catch (e) {
      _logger.error('Failed to delete all desktop secure data', e);
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
      _logger.error('Failed to get all desktop secure keys', e);
      return <String>{};
    }
  }

  /// Ensure storage is initialized before operations
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get platform-specific configuration notes
  String _getPlatformConfig() {
    if (PlatformDetector.isWindows) {
      return 'Windows: Using DPAPI for encryption';
    } else if (PlatformDetector.isLinux) {
      return 'Linux: Using libsecret for secure storage';
    } else if (PlatformDetector.isMacOS) {
      return 'macOS: Using Keychain for secure storage';
    }
    return 'Unknown platform';
  }
}
