import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Local datasource implementation
/// Handles all local storage operations
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences _prefs;
  final SecureStorageService _secureStorage;
  final AppLogger _logger;

  AuthLocalDatasourceImpl({
    required SharedPreferences prefs,
    required AppLogger logger,
    SecureStorageService? secureStorage,
  })  : _prefs = prefs,
        _secureStorage = secureStorage ?? SecureStorageService(),
        _logger = logger;

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userDataKey, userJson);
      _logger.info('User saved to local storage');
    } catch (e) {
      _logger.error('Failed to save user to local storage', e);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = _prefs.getString(AppConstants.userDataKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      _logger.info('User retrieved from local storage');

      return UserModel.fromJson(userMap);
    } catch (e) {
      _logger.error('Failed to get user from local storage', e);
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _prefs.remove(AppConstants.userDataKey);
      _logger.info('User cleared from local storage');
    } catch (e) {
      _logger.error('Failed to clear user from local storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.save(AppConstants.bearerTokenKey, token,
          isSecure: true);
      _logger.info('Bearer token saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save bearer token to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token =
          await _secureStorage.get<String>(AppConstants.bearerTokenKey);
      _logger.info('Bearer token retrieved from secure storage');
      return token;
    } catch (e) {
      _logger.error('Failed to get bearer token from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _secureStorage.remove(AppConstants.bearerTokenKey, isSecure: true);
      _logger.info('Bearer token cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear bearer token from secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.save(StorageConstants.refreshTokenKey, refreshToken,
          isSecure: true);
      _logger.info('Refresh token saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save refresh token to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final refreshToken =
          await _secureStorage.get<String>(StorageConstants.refreshTokenKey);
      _logger.info('Refresh token retrieved from secure storage');
      return refreshToken;
    } catch (e) {
      _logger.error('Failed to get refresh token from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> clearRefreshToken() async {
    try {
      await _secureStorage.remove(StorageConstants.refreshTokenKey,
          isSecure: true);
      _logger.info('Refresh token cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear refresh token from secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      await _secureStorage.save(StorageConstants.sessionDataKey, sessionData,
          isSecure: true);
      _logger.info('Session data saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save session data to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final sessionData = await _secureStorage
          .get<Map<String, dynamic>>(StorageConstants.sessionDataKey);
      if (sessionData == null) return null;

      _logger.info('Session data retrieved from secure storage');
      return sessionData;
    } catch (e) {
      _logger.error('Failed to get session data from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> clearSessionData() async {
    try {
      await _secureStorage.remove(StorageConstants.sessionDataKey,
          isSecure: true);
      _logger.info('Session data cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear session data from secure storage', e);
      rethrow;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getToken();
      final user = await getUser();
      _logger
          .info('User login status checked: ${token != null && user != null}');
      return token != null && user != null;
    } catch (e) {
      _logger.error('Failed to check user login status', e);
      return false;
    }
  }

  @override
  Future<DateTime?> getLastLoginTime() async {
    try {
      final sessionData = await getSessionData();
      if (sessionData == null) return null;

      final lastLoginString = sessionData['last_login'] as String?;
      if (lastLoginString == null) return null;

      _logger.info('Last login time retrieved from local storage');
      return DateTime.parse(lastLoginString);
    } catch (e) {
      _logger.error('Failed to get last login time from local storage', e);
      return null;
    }
  }

  @override
  Future<void> saveLastLoginTime(DateTime time) async {
    try {
      final sessionData = await getSessionData() ?? {};
      sessionData['last_login'] = time.toIso8601String();

      await saveSessionData(sessionData);
      _logger.info('Last login time saved to local storage');
    } catch (e) {
      _logger.error('Failed to save last login time to local storage', e);
      rethrow;
    }
  }

  @override
  Future<void> clearAllAuthData() async {
    try {
      await clearUser();
      await clearToken();
      await clearRefreshToken();
      await clearSessionData();
      _logger.info('All auth data cleared from local storage');
    } catch (e) {
      _logger.error('Failed to clear all auth data from local storage', e);
      rethrow;
    }
  }
}
