import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Repository implementation for authentication
/// Handles business logic and data coordination
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final ErrorHandler _errorHandler;
  final AppLogger _logger;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required ErrorHandler errorHandler,
    required AppLogger logger,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _errorHandler = errorHandler,
        _logger = logger;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Login attempt for email: $email');

      // Call remote datasource
      final userModel = await _remoteDatasource.login(
        email: email,
        password: password,
      );

      // Cache user locally
      await _localDatasource.saveUser(userModel);
      await _localDatasource.saveLastLoginTime(DateTime.now());

      _logger.info('Login successful for user: ${userModel.id}');

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      _logger.error('Login failed with auth exception', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      _logger.error('Login failed with network exception', e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } on ValidationException catch (e) {
      _logger.error('Login failed with validation exception', e);
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        code: e.code,
        originalError: e.originalError,
      ));
    } on ServerException catch (e) {
      _logger.error('Login failed with server exception', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } catch (e) {
      _logger.error('Login failed with unknown exception', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during login',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _logger.info('Registration attempt for email: $email');

      // Call remote datasource
      final userModel = await _remoteDatasource.register(
        email: email,
        password: password,
        name: name,
      );

      // Cache user locally
      await _localDatasource.saveUser(userModel);
      await _localDatasource.saveLastLoginTime(DateTime.now());

      _logger.info('Registration successful for user: ${userModel.id}');

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      _logger.error('Registration failed with auth exception', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      _logger.error('Registration failed with network exception', e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } on ValidationException catch (e) {
      _logger.error('Registration failed with validation exception', e);
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        code: e.code,
        originalError: e.originalError,
      ));
    } on ServerException catch (e) {
      _logger.error('Registration failed with server exception', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } catch (e) {
      _logger.error('Registration failed with unknown exception', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during registration',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      _logger.info('Logout attempt');

      // Call remote datasource
      await _remoteDatasource.logout();

      // Clear local cache
      await _localDatasource.clearAllAuthData();

      _logger.info('Logout successful');
      return const Right(null);
    } on AuthException catch (e) {
      _logger.error('Logout failed with auth exception', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      _logger.error('Logout failed with network exception', e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } on ServerException catch (e) {
      _logger.error('Logout failed with server exception', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } catch (e) {
      _logger.error('Logout failed with unknown exception', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during logout',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      _logger.info('Checking auth status');

      // Try to get cached user first
      final cachedUser = await _localDatasource.getUser();
      final token = await _localDatasource.getToken();

      if (cachedUser != null && token != null) {
        _logger.info('User found in cache: ${cachedUser.id}');
        return Right(cachedUser.toEntity());
      }

      _logger.info('No cached user found');
      return const Right(null);
    } on CacheException catch (e) {
      _logger.error('Check auth status failed with cache exception', e);
      return Left(CacheFailure(
        message: e.message,
        code: e.code,
        operation: e.operation,
        key: e.key,
        originalError: e.originalError,
      ));
    } catch (e) {
      _logger.error('Check auth status failed with unknown exception', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while checking auth status',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      _logger.info('Token refresh attempt');

      // Call remote datasource
      final userModel = await _remoteDatasource.refreshToken();

      // Update local cache
      await _localDatasource.saveUser(userModel);

      _logger.info('Token refresh successful for user: ${userModel.id}');

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      _logger.error('Token refresh failed with auth exception', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      _logger.error('Token refresh failed with network exception', e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } on ServerException catch (e) {
      _logger.error('Token refresh failed with server exception', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        originalError: e.originalError,
      ));
    } catch (e) {
      _logger.error('Token refresh failed with unknown exception', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during token refresh',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Password reset attempt for email: $email');

      // Call remote datasource
      await _remoteDatasource.forgotPassword(email);

      _logger.info('Password reset email sent successfully');
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Password reset attempt with token');

      // Call remote datasource
      await _remoteDatasource.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      _logger.info('Password reset successful');
    });
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Password change attempt');

      // Call remote datasource
      await _remoteDatasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _logger.info('Password change successful');
    });
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? profilePicture,
  }) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Profile update attempt');

      // Call remote datasource
      final userModel = await _remoteDatasource.updateProfile(
        name: name,
        profilePicture: profilePicture,
      );

      // Update local cache
      await _localDatasource.saveUser(userModel);

      _logger.info('Profile update successful for user: ${userModel.id}');

      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Email verification attempt with token');

      // Call remote datasource
      await _remoteDatasource.verifyEmail(token);

      // Update cached user verification status
      final cachedUserModel = await _localDatasource.getUser();
      if (cachedUserModel != null) {
        final updatedUserModel = cachedUserModel.copyWith(isEmailVerified: true);
        await _localDatasource.saveUser(UserModel.fromEntity(updatedUserModel));
      }

      _logger.info('Email verification successful');
    });
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Resend verification email attempt');

      // Call remote datasource
      await _remoteDatasource.resendVerificationEmail();

      _logger.info('Verification email resent successfully');
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Account deletion attempt');

      // Call remote datasource
      await _remoteDatasource.deleteAccount();

      // Clear all local data
      await _localDatasource.clearAllAuthData();

      _logger.info('Account deletion successful');
    });
  }
}