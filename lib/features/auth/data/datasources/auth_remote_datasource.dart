import '../models/user_model.dart';

/// Abstract remote datasource
/// Defines contract for remote API calls
abstract interface class AuthRemoteDatasource {
  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<void> logout();

  /// Refresh authentication token
  Future<UserModel> refreshToken();

  /// Send password reset email
  Future<void> forgotPassword(String email);

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? profilePicture,
  });

  /// Verify email with token
  Future<void> verifyEmail(String token);

  /// Resend verification email
  Future<void> resendVerificationEmail();

  /// Delete user account
  Future<void> deleteAccount();

  /// Create new refresh token
  Future<Map<String, dynamic>> createRefreshToken();

  /// Get list of refresh tokens
  Future<List<Map<String, dynamic>>> getRefreshTokens();

  /// Revoke specific refresh token
  Future<void> revokeToken(String tokenId);

  /// Revoke all refresh tokens
  Future<void> revokeAllTokens();
}
