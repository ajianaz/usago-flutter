import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import '../constants/app_constants.dart';
import '../platform/platform_detector.dart';

/// Secure storage service that handles both secure and non-secure storage
/// Uses Flutter Secure Storage for sensitive data and SharedPreferences for non-sensitive data
/// Compatible with all platforms (mobile, web, desktop)
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;
  final AppLogger _logger;

  SecureStorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _prefs = prefs,
        _logger = logger;

  /// Save sensitive data securely (tokens, credentials, etc.)
  Future<void> saveSecureData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      _logger.info('Secure data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save secure data for key: $key', e);
      rethrow;
    }
  }

  /// Get sensitive data securely
  Future<String?> getSecureData(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      _logger.info('Secure data retrieved for key: $key');
      return value;
    } catch (e) {
      _logger.error('Failed to get secure data for key: $key', e);
      return null;
    }
  }

  /// Remove sensitive data securely
  Future<void> removeSecureData(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _logger.info('Secure data removed for key: $key');
    } catch (e) {
      _logger.error('Failed to remove secure data for key: $key', e);
      rethrow;
    }
  }

  /// Save non-sensitive data (preferences, settings, etc.)
  Future<void> saveNonSecureData(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      _logger.info('Non-secure data saved for key: $key');
    } catch (e) {
      _logger.error('Failed to save non-secure data for key: $key', e);
      rethrow;
    }
  }

  /// Get non-sensitive data
  Future<String?> getNonSecureData(String key) async {
    try {
      final value = _prefs.getString(key);
      _logger.info('Non-secure data retrieved for key: $key');
      return value;
    } catch (e) {
      _logger.error('Failed to get non-secure data for key: $key', e);
      return null;
    }
  }

  /// Remove non-sensitive data
  Future<void> removeNonSecureData(String key) async {
    try {
      await _prefs.remove(key);
      _logger.info('Non-secure data removed for key: $key');
    } catch (e) {
      _logger.error('Failed to remove non-secure data for key: $key', e);
      rethrow;
    }
  }

  /// Clear all secure data
  Future<void> clearAllSecureData() async {
    try {
      await _secureStorage.deleteAll();
      _logger.info('All secure data cleared');
    } catch (e) {
      _logger.error('Failed to clear all secure data', e);
      rethrow;
    }
  }

  /// Clear all non-secure data
  Future<void> clearAllNonSecureData() async {
    try {
      await _prefs.clear();
      _logger.info('All non-secure data cleared');
    } catch (e) {
      _logger.error('Failed to clear all non-secure data', e);
      rethrow;
    }
  }

  /// Check if secure storage is available
  bool get isSecureStorageAvailable {
    // Flutter Secure Storage is available on mobile platforms
    // For web and desktop, it might not be available
    try {
      // Use platform detector for accurate detection
      return PlatformDetector.isMobile;
    } catch (e) {
      _logger.warning('Failed to check secure storage availability', e);
      return false;
    }
  }

  /// Check if current platform is mobile
  bool _isMobilePlatform() {
    // Use platform detector for accurate detection
    try {
      return PlatformDetector.isMobile;
    } catch (e) {
      _logger.warning('Failed to detect mobile platform', e);
      return false;
    }
  }

  /// Get platform-specific storage info
  Map<String, dynamic> getStorageInfo() {
    return {
      'secureStorageAvailable': isSecureStorageAvailable,
      'platform': _getPlatformName(),
      'recommendedStorage': _getRecommendedStorage(),
    };
  }

  /// Get platform name as string
  String _getPlatformName() {
    // Use platform detector for accurate detection
    try {
      return PlatformDetector.platformName;
    } catch (e) {
      _logger.warning('Failed to get platform name', e);
      return 'Flutter';
    }
  }

  /// Get recommended storage method for current platform
  String _getRecommendedStorage() {
    if (isSecureStorageAvailable) {
      return 'FlutterSecureStorage';
    }
    return 'SharedPreferences';
  }

  /// Log platform information for debugging
  void logPlatformInfo() {
    PlatformDetector.logPlatformInfo();
  }

  /// Get platform-specific capabilities and features
  bool isFeatureSupported(String feature) {
    return PlatformDetector.isFeatureSupported(feature);
  }

  // Auth-specific methods for backward compatibility
  Future<void> saveToken(String token) async {
    await saveSecureData(AppConstants.bearerTokenKey, token);
  }

  Future<String?> getToken() async {
    return await getSecureData(AppConstants.bearerTokenKey);
  }

  Future<void> clearToken() async {
    await removeSecureData(AppConstants.bearerTokenKey);
  }

  // User data methods
  Future<void> saveUserData(String userData) async {
    await saveSecureData(AppConstants.userDataKey, userData);
  }

  Future<String?> getUserData() async {
    return await getSecureData(AppConstants.userDataKey);
  }

  Future<void> clearUserData() async {
    await removeSecureData(AppConstants.userDataKey);
  }

  // Session data methods
  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      final sessionJson = sessionData.toString();
      await saveSecureData('session_data', sessionJson);
      _logger.info('Session data saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save session data', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final sessionJson = await getSecureData('session_data');
      if (sessionJson == null) return null;

      // Parse JSON string properly
      try {
        Map<String, dynamic> sessionMap = {};

        if (sessionJson.isNotEmpty) {
          // Handle different JSON formats
          if (sessionJson.startsWith('{') && sessionJson.endsWith('}')) {
            // Standard JSON format
            sessionMap = Map<String, dynamic>.from(jsonDecode(sessionJson) as Map<String, dynamic>);
          } else {
            // Simple key:value format (comma-separated)
            final List<String> entries = sessionJson.split(',');

            for (final entry in entries) {
              final parts = entry.trim().split(':');
              if (parts.length >= 2) {
                final key = parts[0].trim();
                final value = parts.sublist(1).join(':').trim();
                sessionMap[key] = value;
              }
            }
          }
        }

        _logger.info('Session data parsed successfully from secure storage');
        return sessionMap;
      } catch (e) {
        _logger.error('Failed to parse session data', e);
        return <String, dynamic>{};
      }
    } catch (e) {
      _logger.error('Failed to get session data', e);
      return <String, dynamic>{};
    }
  }

  Future<void> clearSessionData() async {
    try {
      await removeSecureData('session_data');
      _logger.info('Session data cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear session data', e);
      rethrow;
    }
  }

  // Legacy methods for backward compatibility
  Future<void> clearAllAuthData() async {
    await clearToken();
    await clearUserData();
    await clearSessionData();
    _logger.info('All auth data cleared from secure storage');
  }
}