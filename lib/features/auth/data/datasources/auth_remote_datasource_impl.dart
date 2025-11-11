import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Remote datasource implementation
/// Handles all API calls
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  final AppLogger _logger;

  AuthRemoteDatasourceImpl({
    required DioClient dioClient,
    required AppLogger logger,
  })  : _dioClient = dioClient,
        _logger = logger;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting login for email: $email');

      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      _logger.info('Login successful for user: ${response['user']['id']}');

      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      _logger.error('Login failed', e);
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

      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
        },
      );

      _logger.info('Registration successful for user: ${response['user']['id']}');

      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      _logger.error('Registration failed', e);
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

      await _dioClient.post('/auth/logout');

      _logger.info('Logout successful');
    } on DioException catch (e) {
      _logger.error('Logout failed', e);
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

      final response = await _dioClient.post('/auth/refresh-token');

      _logger.info('Token refresh successful');

      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      _logger.error('Token refresh failed', e);
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
        '/auth/forgot-password',
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
        '/auth/reset-password',
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
        '/auth/change-password',
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
        '/auth/profile',
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
        '/auth/verify-email',
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

      await _dioClient.post('/auth/resend-verification');

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

      await _dioClient.delete('/auth/account');

      _logger.info('Account deletion successful');
    } on DioException catch (e) {
      _logger.error('Account deletion failed', e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error during account deletion', e);
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }
}