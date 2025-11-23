import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/auth_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/device_info_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';
import 'auth_remote_datasource.dart';

/// Remote datasource implementation
/// Handles all API calls
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  final AppLogger _logger;
  final AuthLocalDatasource _localDatasource;
  final DeviceInfoService _deviceInfoService;

  AuthRemoteDatasourceImpl({
    required DioClient dioClient,
    required AppLogger logger,
    required AuthLocalDatasource localDatasource,
    required DeviceInfoService deviceInfoService,
  })  : _dioClient = dioClient,
        _logger = logger,
        _localDatasource = localDatasource,
        _deviceInfoService = deviceInfoService;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting login for email: $email');

      // Get device info
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      _logger
          .info('Device info retrieved for login: ${deviceInfo['deviceId']}');

      final response = await _dioClient.postWithHeaders(
        AuthEndpoints.signIn,
        data: {
          'email': email.trim(),
          'password': password,
          'deviceInfo': deviceInfo,
        },
      );

      // Extract tokens from response body based on new API format
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        // Extract data from response
        final data = responseData['data'] as Map<String, dynamic>?;
        if (data != null) {
          // Save JWT token
          final token = data['token'] as String?;
          if (token != null && token.isNotEmpty) {
            await _localDatasource.saveToken(token);
            _logger.info(
                'JWT token extracted from response body and saved after login');
          }

          // Save refresh token
          final refreshToken = data['refreshToken'] as String?;
          if (refreshToken != null && refreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(refreshToken);
            _logger.info(
                'Refresh token extracted from response body and saved after login');
          }

          // Extract user data
          final userData = data['user'] as Map<String, dynamic>?;
          if (userData != null) {
            _logger.info('Login successful for user: ${userData['id']}');
            return UserModel.fromJson(userData);
          }
        }
      }

      throw Exception('Invalid response format from login endpoint');
    } on DioException catch (e) {
      _logger.error('Login failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during login', e);
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _logger.info('Attempting registration for email: $email');

      // Get device info
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      _logger.info(
          'Device info retrieved for registration: ${deviceInfo['deviceId']}');

      final response = await _dioClient.postWithHeaders(
        AuthEndpoints.signUp,
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
          'deviceInfo': deviceInfo,
        },
      );

      // Extract tokens from response body based on new API format
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        // Extract data from response
        final data = responseData['data'] as Map<String, dynamic>?;
        if (data != null) {
          // Save JWT token
          final token = data['token'] as String?;
          if (token != null && token.isNotEmpty) {
            await _localDatasource.saveToken(token);
            _logger.info(
                'JWT token extracted from response body and saved after registration');
          }

          // Save refresh token
          final refreshToken = data['refreshToken'] as String?;
          if (refreshToken != null && refreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(refreshToken);
            _logger.info(
                'Refresh token extracted from response body and saved after registration');
          }

          // Extract user data
          final userData = data['user'] as Map<String, dynamic>?;
          if (userData != null) {
            _logger.info('Registration successful for user: ${userData['id']}');
            return UserModel.fromJson(userData);
          }
        }
      }

      throw Exception('Invalid response format from register endpoint');
    } on DioException catch (e) {
      _logger.error('Registration failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during registration', e);
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.info('Attempting logout');

      await _dioClient.post(AppConstants.signOutEndpoint);

      _logger.info('Logout successful');
    } on DioException catch (e) {
      _logger.error('Logout failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during logout', e);
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> refreshToken() async {
    try {
      _logger.info('Attempting token refresh');

      // Check if we have a token to refresh
      final currentToken = await _localDatasource.getToken();
      if (currentToken == null || currentToken.isEmpty) {
        _logger.warning('No token available for refresh');
        throw Exception('No token available for refresh');
      }

      // Get refresh token from local storage
      final refreshToken = await _localDatasource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.warning('No refresh token available for refresh');
        throw Exception('No refresh token available for refresh');
      }

      // Get device info and generate fingerprint
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      final deviceFingerprint =
          _deviceInfoService.generateDeviceFingerprint(deviceInfo);
      _logger.info(
          'Device fingerprint generated for refresh token: ${deviceFingerprint.substring(0, 8)}...');

      final response = await _dioClient.postWithHeaders(
        AuthEndpoints.refreshToken,
        data: {
          'refreshToken': refreshToken,
          'deviceFingerprint': deviceFingerprint,
        },
      );

      // Extract tokens from response body based on new API format
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        // Extract data from response
        final data = responseData['data'] as Map<String, dynamic>?;
        if (data != null) {
          // Save JWT token
          final newToken = data['token'] as String?;
          if (newToken != null && newToken.isNotEmpty) {
            await _localDatasource.saveToken(newToken);
            _logger.info(
                'New JWT token extracted from response body and saved after refresh');
          } else {
            _logger.warning('Token refresh response did not contain new token');
            _logger.debug('Refresh response data: ${response.data}');
            throw Exception('Token refresh response did not contain new token');
          }

          // Save refresh token (token rotation)
          final newRefreshToken = data['refreshToken'] as String?;
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(newRefreshToken);
            _logger.info(
                'New refresh token extracted from response body and saved after refresh');
          }

          // Extract user data
          final userData = data['user'] as Map<String, dynamic>?;
          if (userData != null) {
            _logger
                .info('Token refresh successful for user: ${userData['id']}');
            return UserModel.fromJson(userData);
          }
        }
      }

      throw Exception('Invalid response format from refresh token endpoint');
    } on DioException catch (e) {
      _logger.error('Token refresh failed', e);

      // Handle specific token refresh errors
      if (e.response?.statusCode == 401) {
        _logger
            .warning('Token refresh failed - token may be invalid or expired');
        // Clear invalid tokens
        await _localDatasource.clearToken();
        await _localDatasource.clearRefreshToken();
        throw Exception('Token refresh failed - please login again');
      }

      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during token refresh', e);
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      _logger.info('Sending password reset email to: $email');

      await _dioClient.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email.trim()},
      );

      _logger.info('Password reset email sent successfully');
    } on DioException catch (e) {
      _logger.error('Password reset failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during password reset', e);
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      _logger.info('Resetting password with token');

      await _dioClient.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      _logger.info('Password reset successful');
    } on DioException catch (e) {
      _logger.error('Password reset failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during password reset', e);
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _logger.info('Changing password');

      await _dioClient.post(
        AppConstants.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      _logger.info('Password change successful');
    } on DioException catch (e) {
      _logger.error('Password change failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during password change', e);
      throw Exception('Password change failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? profilePicture,
  }) async {
    try {
      _logger.info('Updating user profile');

      final data = <String, dynamic>{};
      if (name != null) data['name'] = name.trim();
      if (profilePicture != null) data['profilePicture'] = profilePicture;

      final response = await _dioClient.put(
        AppConstants.updateProfileEndpoint,
        data: data,
      );

      _logger.info('Profile update successful');

      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      _logger.error('Profile update failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during profile update', e);
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      _logger.info('Verifying email with token');

      await _dioClient.post(
        AppConstants.verifyEmailEndpoint,
        data: {'token': token},
      );

      _logger.info('Email verification successful');
    } on DioException catch (e) {
      _logger.error('Email verification failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during email verification', e);
      throw Exception('Email verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      _logger.info('Resending verification email');

      await _dioClient.post(AppConstants.resendVerificationEmailEndpoint);

      _logger.info('Verification email resent successfully');
    } on DioException catch (e) {
      _logger.error('Resend verification failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during resend verification', e);
      throw Exception('Resend verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      _logger.info('Deleting user account');

      await _dioClient.delete(AppConstants.deleteAccountEndpoint);

      _logger.info('Account deletion successful');
    } on DioException catch (e) {
      _logger.error('Account deletion failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during account deletion', e);
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createRefreshToken() async {
    try {
      _logger.info('Creating new refresh token');

      // Get device info
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      _logger.info(
          'Device info retrieved for create refresh token: ${deviceInfo['deviceId']}');

      final response = await _dioClient.postWithHeaders(
        AuthEndpoints.createRefreshToken,
        data: {
          'deviceId': deviceInfo['deviceId'],
          'deviceName': deviceInfo['deviceName'],
          'deviceType': deviceInfo['deviceType'],
          'platform': deviceInfo['platform'],
          'appVersion': deviceInfo['appVersion'],
        },
      );

      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final data = responseData['data'] as Map<String, dynamic>?;
        if (data != null) {
          // Save new refresh token if provided
          final refreshToken = data['refreshToken'] as String?;
          if (refreshToken != null && refreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(refreshToken);
            _logger.info('New refresh token saved after creation');
          }

          _logger.info('Refresh token creation successful');
          return data;
        }
      }

      throw Exception(
          'Invalid response format from create refresh token endpoint');
    } on DioException catch (e) {
      _logger.error('Create refresh token failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during create refresh token', e);
      throw Exception('Create refresh token failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRefreshTokens() async {
    try {
      _logger.info('Getting list of refresh tokens');

      final response = await _dioClient.get(
        AuthEndpoints.getRefreshTokens,
      );

      if (response != null && response is Map<String, dynamic>) {
        final data = response['data'] as List<dynamic>?;
        if (data != null) {
          final tokens =
              data.map((token) => token as Map<String, dynamic>).toList();
          _logger.info('Retrieved ${tokens.length} refresh tokens');
          return tokens;
        }
      }

      throw Exception(
          'Invalid response format from get refresh tokens endpoint');
    } on DioException catch (e) {
      _logger.error('Get refresh tokens failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during get refresh tokens', e);
      throw Exception('Get refresh tokens failed: ${e.toString()}');
    }
  }

  @override
  Future<void> revokeToken(String tokenId) async {
    try {
      _logger.info('Revoking refresh token: $tokenId');

      await _dioClient.postWithHeaders(
        AuthEndpoints.revokeToken,
        data: {
          'refreshToken': tokenId,
        },
      );

      _logger.info('Refresh token revoked successfully: $tokenId');
    } on DioException catch (e) {
      _logger.error('Revoke token failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during revoke token', e);
      throw Exception('Revoke token failed: ${e.toString()}');
    }
  }

  @override
  Future<void> revokeAllTokens() async {
    try {
      _logger.info('Revoking all refresh tokens');

      await _dioClient.postWithHeaders(
        AuthEndpoints.revokeAllTokens,
      );

      _logger.info('All refresh tokens revoked successfully');
    } on DioException catch (e) {
      _logger.error('Revoke all tokens failed', e);
      _handleBetterAuthError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during revoke all tokens', e);
      throw Exception('Revoke all tokens failed: ${e.toString()}');
    }
  }

  /// Handle Better Auth specific error format
  void _handleBetterAuthError(DioException e) {
    if (e.response?.data != null) {
      final errorData = e.response?.data as Map<String, dynamic>;
      final code = errorData['code'] as String?;
      final message = errorData['message'] as String? ?? 'Unknown error';

      _logger.error('Better Auth error - Code: $code, Message: $message');

      // Log specific Better Auth error codes for debugging
      switch (code) {
        case 'INVALID_CREDENTIALS':
          _logger.warning('Invalid email or password');
          break;
        case 'USER_NOT_FOUND':
          _logger.warning('User not found');
          break;
        case 'EMAIL_ALREADY_EXISTS':
          _logger.warning('Email already exists');
          break;
        case 'WEAK_PASSWORD':
          _logger.warning('Password is too weak');
          break;
        case 'INVALID_TOKEN':
          _logger.warning('Invalid or expired token');
          break;
        default:
          _logger.warning('Unhandled Better Auth error code: $code');
      }
    }
  }
}
