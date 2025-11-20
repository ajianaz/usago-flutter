import '../models/user_model.dart';

/// Abstract local datasource
/// Defines contract for local storage
abstract interface class AuthLocalDatasource {
  /// Save user to local storage
  Future<void> saveUser(UserModel user);

  /// Get user from local storage
  Future<UserModel?> getUser();

  /// Clear user from local storage
  Future<void> clearUser();

  /// Save auth token
  Future<void> saveToken(String token);

  /// Get auth token from local storage
  Future<String?> getToken();

  /// Clear auth token from local storage
  Future<void> clearToken();

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken);

  /// Get refresh token from local storage
  Future<String?> getRefreshToken();

  /// Clear refresh token from local storage
  Future<void> clearRefreshToken();

  /// Save user session data
  Future<void> saveSessionData(Map<String, dynamic> sessionData);

  /// Get user session data
  Future<Map<String, dynamic>?> getSessionData();

  /// Clear user session data
  Future<void> clearSessionData();

  /// Check if user is logged in
  Future<bool> isUserLoggedIn();

  /// Get last login timestamp
  Future<DateTime?> getLastLoginTime();

  /// Save last login timestamp
  Future<void> saveLastLoginTime(DateTime time);

  /// Clear all auth data
  Future<void> clearAllAuthData();
}
