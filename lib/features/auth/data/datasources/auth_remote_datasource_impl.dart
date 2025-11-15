import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';
import 'auth_remote_datasource.dart';

/// Remote datasource implementation
/// Handles all API calls with proper error handling using Either<Failure, T>
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
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Attempting login for email: $email');
      _logger
          .info('[$correlationId] Using base URL: ${AppConstants.apiBaseUrl}');
      _logger.info(
          '[$correlationId] Using sign-in endpoint: ${AppConstants.signInEndpoint}');
      _logger.info(
          '[$correlationId] Full login URL: ${AppConstants.apiBaseUrl}${AppConstants.signInEndpoint}');

      final response = await _dioClient.postWithHeaders(
        AppConstants.signInEndpoint,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      // Extract Bearer token from response headers
      final authToken = response.headers['set-auth-token'];
      if (authToken != null && authToken.isNotEmpty) {
        await _localDatasource.saveToken(authToken.first);
        _logger.info('[$correlationId] Bearer token extracted and saved');
      }

      _logger.info(
          '[$correlationId] Login successful for user: ${response.data['user']['id']}');

      return Right(UserModel.fromJson(response.data['user']));
    } on DioException catch (e) {
      _logger.error('[$correlationId] Login failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error('[$correlationId] Unexpected error during login', e);
      return Left(UnknownFailure(
        message: 'Login failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final correlationId = const Uuid().v4();

    try {
      _logger
          .info('[$correlationId] Attempting registration for email: $email');
      _logger
          .info('[$correlationId] Using base URL: ${AppConstants.apiBaseUrl}');
      _logger.info(
          '[$correlationId] Using sign-up endpoint: ${AppConstants.signUpEndpoint}');
      _logger.info(
          '[$correlationId] Full register URL: ${AppConstants.apiBaseUrl}${AppConstants.signUpEndpoint}');

      final response = await _dioClient.postWithHeaders(
        AppConstants.signUpEndpoint,
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
        },
      );

      // Extract Bearer token from response headers
      final authToken = response.headers['set-auth-token'];
      if (authToken != null && authToken.isNotEmpty) {
        await _localDatasource.saveToken(authToken.first);
        _logger.info(
            '[$correlationId] Bearer token extracted and saved after registration');
      }

      _logger.info(
          '[$correlationId] Registration successful for user: ${response.data['user']['id']}');

      return Right(UserModel.fromJson(response.data['user']));
    } on DioException catch (e) {
      _logger.error('[$correlationId] Registration failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error('[$correlationId] Unexpected error during registration', e);
      return Left(UnknownFailure(
        message: 'Registration failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Attempting logout');

      await _dioClient.post(AppConstants.signOutEndpoint);

      _logger.info('[$correlationId] Logout successful');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Logout failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error('[$correlationId] Unexpected error during logout', e);
      return Left(UnknownFailure(
        message: 'Logout failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, UserModel>> refreshToken() async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Attempting token refresh');
      _logger
          .info('[$correlationId] Using base URL: ${AppConstants.apiBaseUrl}');
      _logger.info(
          '[$correlationId] Using refresh endpoint: ${AppConstants.refreshTokenEndpoint}');
      _logger.info(
          '[$correlationId] Full refresh URL: ${AppConstants.apiBaseUrl}${AppConstants.refreshTokenEndpoint}');

      final response =
          await _dioClient.postWithHeaders(AppConstants.refreshTokenEndpoint);

      // Extract new Bearer token from response headers
      final authToken = response.headers['set-auth-token'];
      if (authToken != null && authToken.isNotEmpty) {
        await _localDatasource.saveToken(authToken.first);
        _logger.info(
            '[$correlationId] New Bearer token extracted and saved after refresh');
      }

      _logger.info('[$correlationId] Token refresh successful');

      return Right(UserModel.fromJson(response.data['user']));
    } on DioException catch (e) {
      _logger.error('[$correlationId] Token refresh failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during token refresh', e);
      return Left(UnknownFailure(
        message: 'Token refresh failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Sending password reset email to: $email');

      await _dioClient.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email.trim()},
      );

      _logger.info('[$correlationId] Password reset email sent successfully');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Password reset failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during password reset', e);
      return Left(UnknownFailure(
        message: 'Password reset failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Resetting password with token');

      await _dioClient.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      _logger.info('[$correlationId] Password reset successful');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Password reset failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during password reset', e);
      return Left(UnknownFailure(
        message: 'Password reset failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Changing password');

      await _dioClient.post(
        AppConstants.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      _logger.info('[$correlationId] Password change successful');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Password change failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during password change', e);
      return Left(UnknownFailure(
        message: 'Password change failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? profilePicture,
  }) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Updating user profile');

      final data = <String, dynamic>{};
      if (name != null) data['name'] = name.trim();
      if (profilePicture != null) data['profilePicture'] = profilePicture;

      final response = await _dioClient.put(
        AppConstants.updateProfileEndpoint,
        data: data,
      );

      _logger.info('[$correlationId] Profile update successful');

      return Right(UserModel.fromJson(response['user']));
    } on DioException catch (e) {
      _logger.error('[$correlationId] Profile update failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during profile update', e);
      return Left(UnknownFailure(
        message: 'Profile update failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Verifying email with token');

      await _dioClient.post(
        AppConstants.verifyEmailEndpoint,
        data: {'token': token},
      );

      _logger.info('[$correlationId] Email verification successful');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Email verification failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during email verification', e);
      return Left(UnknownFailure(
        message: 'Email verification failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Resending verification email');

      await _dioClient.post(AppConstants.resendVerificationEmailEndpoint);

      _logger.info('[$correlationId] Verification email resent successfully');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Resend verification failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during resend verification', e);
      return Left(UnknownFailure(
        message: 'Resend verification failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    final correlationId = const Uuid().v4();

    try {
      _logger.info('[$correlationId] Deleting user account');

      await _dioClient.delete(AppConstants.deleteAccountEndpoint);

      _logger.info('[$correlationId] Account deletion successful');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('[$correlationId] Account deletion failed', e);
      final failure = _handleBetterAuthError(e, correlationId);
      return Left(failure);
    } catch (e) {
      _logger.error(
          '[$correlationId] Unexpected error during account deletion', e);
      return Left(UnknownFailure(
        message: 'Account deletion failed: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  /// Handle Better Auth specific error format
  /// Returns appropriate Failure object based on error type
  Failure _handleBetterAuthError(DioException e, [String? correlationId]) {
    if (e.response?.data != null) {
      final errorData = e.response?.data as Map<String, dynamic>;
      final code = errorData['code'] as String?;
      final message = errorData['message'] as String? ?? 'Unknown error';

      if (correlationId != null) {
        _logger.error(
            '[$correlationId] Better Auth error - Code: $code, Message: $message');
      } else {
        _logger.error('Better Auth error - Code: $code, Message: $message');
      }

      // Map Better Auth error codes to appropriate Failure types
      switch (code) {
        case 'INVALID_CREDENTIALS':
          _logger.warning('Invalid email or password');
          return AuthFailure(
            message: message,
            code: code,
            type: AuthExceptionType.invalidCredentials,
            originalError: e,
          );
        case 'USER_NOT_FOUND':
          _logger.warning('User not found');
          return AuthFailure(
            message: message,
            code: code,
            type: AuthExceptionType.unauthorized,
            originalError: e,
          );
        case 'EMAIL_ALREADY_EXISTS':
          _logger.warning('Email already exists');
          return AuthFailure(
            message: message,
            code: code,
            type: AuthExceptionType.forbidden,
            originalError: e,
          );
        case 'WEAK_PASSWORD':
          _logger.warning('Password is too weak');
          return ValidationFailure(
            message: message,
            code: code,
            originalError: e,
          );
        case 'INVALID_TOKEN':
          _logger.warning('Invalid or expired token');
          return AuthFailure(
            message: message,
            code: code,
            type: AuthExceptionType.tokenInvalid,
            originalError: e,
          );
        default:
          _logger.warning('Unhandled Better Auth error code: $code');
          return ServerFailure(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
            endpoint: e.requestOptions.path,
            originalError: e,
          );
      }
    }

    // Handle network errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkFailure(
        message: 'Connection timeout. Please check your internet connection.',
        code: 'TIMEOUT',
        statusCode: e.response?.statusCode,
        endpoint: e.requestOptions.path,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return NetworkFailure(
        message: 'No internet connection. Please check your network settings.',
        code: 'NO_CONNECTION',
        statusCode: e.response?.statusCode,
        endpoint: e.requestOptions.path,
        originalError: e,
      );
    }

    // Default server error
    return ServerFailure(
      message: e.message ?? 'Server error occurred',
      code: 'SERVER_ERROR',
      statusCode: e.response?.statusCode,
      endpoint: e.requestOptions.path,
      originalError: e,
    );
  }
}
