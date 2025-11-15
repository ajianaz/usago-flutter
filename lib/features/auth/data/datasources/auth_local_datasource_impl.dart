import 'dart:convert';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Local datasource implementation
/// Handles all local storage operations using unified secure storage
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SecureStorageService _secureStorage;
  final AppLogger _logger;

  AuthLocalDatasourceImpl({
    required SecureStorageService secureStorage,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _logger = logger;

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.saveUserData(userJson);
      _logger.info('User saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save user to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = await _secureStorage.getUserData();
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      _logger.info('User retrieved from secure storage');

      return UserModel.fromJson(userMap);
    } catch (e) {
      _logger.error('Failed to get user from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _secureStorage.clearUserData();
      _logger.info('User cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear user from secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.saveToken(token);
      _logger.info('Bearer token saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save bearer token to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.getToken();
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
      await _secureStorage.clearToken();
      _logger.info('Bearer token cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear bearer token from secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      await _secureStorage.saveSessionData(sessionData);
      _logger.info('Session data saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save session data to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final sessionMap = await _secureStorage.getSessionData();
      _logger.info('Session data retrieved from secure storage');

      return sessionMap;
    } catch (e) {
      _logger.error('Failed to get session data from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> clearSessionData() async {
    try {
      await _secureStorage.clearSessionData();
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

      _logger.info('Last login time retrieved from secure storage');
      return DateTime.parse(lastLoginString);
    } catch (e) {
      _logger.error('Failed to get last login time from secure storage', e);
      return null;
    }
  }

  @override
  Future<void> saveLastLoginTime(DateTime time) async {
    try {
      final sessionData = await getSessionData() ?? {};
      sessionData['last_login'] = time.toIso8601String();

      await saveSessionData(sessionData);
      _logger.info('Last login time saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save last login time to secure storage', e);
      rethrow;
    }
  }

  @override
  Future<void> clearAllAuthData() async {
    try {
      await clearUser();
      await clearToken();
      await clearSessionData();
      _logger.info('All auth data cleared from secure storage');
    } catch (e) {
      _logger.error('Failed to clear all auth data from secure storage', e);
      rethrow;
    }
  }
}
