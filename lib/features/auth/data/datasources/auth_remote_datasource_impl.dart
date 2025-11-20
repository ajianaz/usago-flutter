import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
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

  AuthRemoteDatasourceImpl({
    required DioClient dioClient,
    required AppLogger logger,
    required AuthLocalDatasource localDatasource,
  })  : _dioClient = dioClient,
        _logger = logger,
        _localDatasource = localDatasource;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting login for email: $email');

      final response = await _dioClient.postWithHeaders(
        AppConstants.signInEndpoint,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      // Extract JWT token from response headers or body
      String? newToken;

      // Try to get token from headers first (JWT standard)
      final headerToken = response.headers['set-authorization'];
      if (headerToken != null && headerToken.isNotEmpty) {
        newToken = headerToken.first;
        await _localDatasource.saveToken(newToken);
        _logger.info('JWT token extracted from headers and saved after login');
      } else {
        // Fallback to response body (JWT plugin response format)
        final responseData = response.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          // Check for token in different possible locations
          if (responseData['token'] != null) {
            newToken = responseData['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (direct) and saved after login');
            }
          } else if (responseData['session'] != null &&
              responseData['session']['token'] != null) {
            newToken = responseData['session']['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (session) and saved after login');
            }
          } else if (responseData['data'] != null &&
              responseData['data']['token'] != null) {
            newToken = responseData['data']['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (data) and saved after login');
            }
          }
        }
      }

      // Extract and save refresh token if provided
      final refreshToken = response.headers['set-refresh-token'];
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _localDatasource.saveRefreshToken(refreshToken.first);
        _logger
            .info('Refresh token extracted from headers and saved after login');
      } else {
        // Check if refresh token is in response body
        final responseData = response.data;
        if (responseData != null &&
            responseData is Map<String, dynamic> &&
            responseData['session'] != null &&
            responseData['session']['refreshToken'] != null) {
          final newRefreshToken =
              responseData['session']['refreshToken'] as String?;
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(newRefreshToken);
            _logger.info(
                'Refresh token extracted from body and saved after login');
          }
        }
      }

      _logger.info('Login successful for user: ${response.data['user']['id']}');

      return UserModel.fromJson(response.data['user']);
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

      final response = await _dioClient.postWithHeaders(
        AppConstants.signUpEndpoint,
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
        },
      );

      // Extract JWT token from response headers or body
      String? newToken;

      // Try to get token from headers first (JWT standard)
      final headerToken = response.headers['set-authorization'];
      if (headerToken != null && headerToken.isNotEmpty) {
        newToken = headerToken.first;
        await _localDatasource.saveToken(newToken);
        _logger.info(
            'JWT token extracted from headers and saved after registration');
      } else {
        // Fallback to response body (JWT plugin response format)
        final responseData = response.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          // Check for token in different possible locations
          if (responseData['token'] != null) {
            newToken = responseData['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (direct) and saved after registration');
            }
          } else if (responseData['session'] != null &&
              responseData['session']['token'] != null) {
            newToken = responseData['session']['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (session) and saved after registration');
            }
          } else if (responseData['data'] != null &&
              responseData['data']['token'] != null) {
            newToken = responseData['data']['token'] as String?;
            if (newToken != null && newToken.isNotEmpty) {
              await _localDatasource.saveToken(newToken);
              _logger.info(
                  'JWT token extracted from body (data) and saved after registration');
            }
          }
        }
      }

      // Extract and save refresh token if provided
      final refreshToken = response.headers['set-refresh-token'];
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _localDatasource.saveRefreshToken(refreshToken.first);
        _logger.info(
            'Refresh token extracted from headers and saved after registration');
      } else {
        // Check if refresh token is in response body
        final responseData = response.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          // Check for refresh token in different possible locations
          String? newRefreshToken;
          if (responseData['refreshToken'] != null) {
            newRefreshToken = responseData['refreshToken'] as String?;
          } else if (responseData['session'] != null &&
              responseData['session']['refreshToken'] != null) {
            newRefreshToken =
                responseData['session']['refreshToken'] as String?;
          } else if (responseData['data'] != null &&
              responseData['data']['refreshToken'] != null) {
            newRefreshToken = responseData['data']['refreshToken'] as String?;
          }

          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(newRefreshToken);
            _logger.info(
                'Refresh token extracted from body and saved after registration');
          }
        }
      }

      _logger.info(
          'Registration successful for user: ${response.data['user']['id']}');

      return UserModel.fromJson(response.data['user']);
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

      final response = await _dioClient.postWithHeaders(
        AppConstants.refreshTokenEndpoint,
        data: {
          'refreshToken': refreshToken,
        },
      );

      // Extract new JWT token from response headers or body
      String? newToken;

      // Try to get token from headers first (JWT standard)
      final headerToken = response.headers['set-authorization'];
      if (headerToken != null && headerToken.isNotEmpty) {
        newToken = headerToken.first;
        _logger.info('New JWT token extracted from headers after refresh');
      } else {
        // Fallback to response body (JWT plugin response format)
        final responseData = response.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          // Check for token in different possible locations
          if (responseData['token'] != null) {
            newToken = responseData['token'] as String?;
            _logger.info(
                'New JWT token extracted from body (direct) after refresh');
          } else if (responseData['session'] != null &&
              responseData['session']['token'] != null) {
            newToken = responseData['session']['token'] as String?;
            _logger.info(
                'New JWT token extracted from body (session) after refresh');
          } else if (responseData['data'] != null &&
              responseData['data']['token'] != null) {
            newToken = responseData['data']['token'] as String?;
            _logger
                .info('New JWT token extracted from body (data) after refresh');
          }
        }
      }

      if (newToken != null && newToken.isNotEmpty) {
        await _localDatasource.saveToken(newToken);
      } else {
        _logger.warning('Token refresh response did not contain new token');
        _logger.debug('Refresh response data: ${response.data}');
        _logger.debug('Refresh response headers: ${response.headers}');
        throw Exception('Token refresh response did not contain new token');
      }

      // Extract and save new refresh token if provided
      final newRefreshToken = response.headers['set-refresh-token'];
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _localDatasource.saveRefreshToken(newRefreshToken.first);
        _logger.info(
            'New refresh token extracted from headers and saved after refresh');
      } else {
        // Check if refresh token is in response body
        final responseData = response.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          // Check for refresh token in different possible locations
          String? newRefreshToken;
          if (responseData['refreshToken'] != null) {
            newRefreshToken = responseData['refreshToken'] as String?;
          } else if (responseData['session'] != null &&
              responseData['session']['refreshToken'] != null) {
            newRefreshToken =
                responseData['session']['refreshToken'] as String?;
          } else if (responseData['data'] != null &&
              responseData['data']['refreshToken'] != null) {
            newRefreshToken = responseData['data']['refreshToken'] as String?;
          }

          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _localDatasource.saveRefreshToken(newRefreshToken);
            _logger.info(
                'New refresh token extracted from body and saved after refresh');
          }
        }
      }

      _logger.info('Token refresh successful');

      // Update user data if provided in response
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else if (response.data != null &&
          response.data is Map<String, dynamic> &&
          response.data['session'] != null &&
          response.data['session']['user'] != null) {
        // Check for user in session data
        return UserModel.fromJson(response.data['session']['user']);
      } else {
        // If no user data in response, get current user from local storage
        final currentUser = await _localDatasource.getUser();
        if (currentUser != null) {
          return currentUser;
        } else {
          throw Exception('No user data available after token refresh');
        }
      }
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
