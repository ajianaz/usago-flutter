import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/data/repositories/auth_repository_impl.dart';
import '../../../../../lib/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../../../lib/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../../../../lib/core/errors/error_handler.dart';
import '../../../../../lib/core/utils/logger.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';

import 'auth_repository_impl_test.mocks.dart';

/// Test suite for AuthRepositoryImpl
/// Tests the repository implementation for authentication
void main() {
  group('AuthRepositoryImpl Tests', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDatasource mockRemoteDatasource;
    late MockAuthLocalDatasource mockLocalDatasource;
    late MockErrorHandler mockErrorHandler;
    late MockAppLogger mockLogger;

    setUp(() {
      mockRemoteDatasource = MockAuthRemoteDatasource();
      mockLocalDatasource = MockAuthLocalDatasource();
      mockErrorHandler = MockErrorHandler();
      mockLogger = MockAppLogger();
      repository = AuthRepositoryImpl(
        remoteDatasource: mockRemoteDatasource,
        localDatasource: mockLocalDatasource,
        errorHandler: mockErrorHandler,
        logger: mockLogger,
      );
    });

    group('login', () {
      test('should return User on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final userModel = UserModel(
          id: 'test-id',
          email: email,
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        when(mockRemoteDatasource.login(email: email, password: password))
            .thenAnswer((_) async => Right(userModel));
        when(mockLocalDatasource.saveUser(any))
            .thenAnswer((_) async {});
        when(mockLocalDatasource.saveLastLoginTime(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
            expect(user.name, equals(userModel.name));
          },
        );
        verify(mockLocalDatasource.saveUser(userModel)).called(1);
        verify(mockLocalDatasource.saveLastLoginTime(any)).called(1);
        verify(mockLogger.info('Login attempt for email: $email')).called(1);
        verify(mockLogger.info('Login successful for user: ${userModel.id}')).called(1);
      });

      test('should return failure on login error', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';
        final failure = AuthFailure(
          message: 'Invalid credentials',
          code: 'INVALID_CREDENTIALS',
          type: AuthExceptionType.invalidCredentials,
        );

        when(mockRemoteDatasource.login(email: email, password: password))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Login attempt for email: $email')).called(1);
        verify(mockLogger.error('Login failed with failure', failure)).called(1);
        verifyNever(mockLocalDatasource.saveUser(any));
        verifyNever(mockLocalDatasource.saveLastLoginTime(any));
      });

      test('should return UnknownFailure on unexpected error', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final exception = Exception('Unexpected error');

        when(mockRemoteDatasource.login(email: email, password: password))
            .thenThrow(exception);

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, equals('An unexpected error occurred during login'));
          },
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Login attempt for email: $email')).called(1);
        verify(mockLogger.error('Login failed with unknown exception', exception)).called(1);
      });
    });

    group('register', () {
      test('should return User on successful registration', () async {
        // Arrange
        const email = 'newuser@example.com';
        const password = 'password123';
        const name = 'New User';
        final userModel = UserModel(
          id: 'new-user-id',
          email: email,
          name: name,
          isEmailVerified: false,
          createdAt: DateTime.now(),
        );

        when(mockRemoteDatasource.register(email: email, password: password, name: name))
            .thenAnswer((_) async => Right(userModel));
        when(mockLocalDatasource.saveUser(any))
            .thenAnswer((_) async {});
        when(mockLocalDatasource.saveLastLoginTime(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
            expect(user.name, equals(userModel.name));
            expect(user.isEmailVerified, isFalse);
          },
        );
        verify(mockLocalDatasource.saveUser(userModel)).called(1);
        verify(mockLocalDatasource.saveLastLoginTime(any)).called(1);
        verify(mockLogger.info('Registration attempt for email: $email')).called(1);
        verify(mockLogger.info('Registration successful for user: ${userModel.id}')).called(1);
      });

      test('should return failure on registration error', () async {
        // Arrange
        const email = 'existing@example.com';
        const password = 'password123';
        const name = 'Existing User';
        final failure = AuthFailure(
          message: 'Email already exists',
          code: 'EMAIL_ALREADY_EXISTS',
          type: AuthExceptionType.forbidden,
        );

        when(mockRemoteDatasource.register(email: email, password: password, name: name))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Registration attempt for email: $email')).called(1);
        verify(mockLogger.error('Registration failed with failure', failure)).called(1);
        verifyNever(mockLocalDatasource.saveUser(any));
        verifyNever(mockLocalDatasource.saveLastLoginTime(any));
      });
    });

    group('logout', () {
      test('should return void on successful logout', () async {
        // Arrange
        when(mockRemoteDatasource.logout())
            .thenAnswer((_) async => const Right(null));
        when(mockLocalDatasource.clearAllAuthData())
            .thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockLocalDatasource.clearAllAuthData()).called(1);
        verify(mockLogger.info('Logout attempt')).called(1);
        verify(mockLogger.info('Logout successful')).called(1);
      });

      test('should return failure on logout error', () async {
        // Arrange
        final failure = ServerFailure(
          message: 'Server error',
          code: 'SERVER_ERROR',
        );

        when(mockRemoteDatasource.logout())
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (value) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Logout attempt')).called(1);
        verify(mockLogger.error('Logout failed with failure', failure)).called(1);
        verifyNever(mockLocalDatasource.clearAllAuthData());
      });
    });

    group('checkAuthStatus', () {
      test('should return User when cached user exists', () async {
        // Arrange
        final userModel = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );
        const token = 'Bearer test-token';

        when(mockLocalDatasource.getUser())
            .thenAnswer((_) async => userModel);
        when(mockLocalDatasource.getToken())
            .thenAnswer((_) async => token);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
          },
        );
        verify(mockLogger.info('Checking auth status')).called(1);
        verify(mockLogger.info('User found in cache: ${userModel.id}')).called(1);
      });

      test('should return null when no cached user', () async {
        // Arrange
        when(mockLocalDatasource.getUser())
            .thenAnswer((_) async => null);
        when(mockLocalDatasource.getToken())
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) => expect(user, isNull),
        );
        verify(mockLogger.info('Checking auth status')).called(1);
        verify(mockLogger.info('No cached user found')).called(1);
      });

      test('should return CacheFailure on cache error', () async {
        // Arrange
        final exception = CacheException(
          message: 'Cache error',
          code: 'CACHE_ERROR',
          operation: 'getUser',
          key: 'user',
        );

        when(mockLocalDatasource.getUser())
            .thenThrow(exception);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, equals('Cache error'));
          },
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Checking auth status')).called(1);
        verify(mockLogger.error('Check auth status failed with cache exception', exception)).called(1);
      });
    });

    group('refreshToken', () {
      test('should return User on successful token refresh', () async {
        // Arrange
        final userModel = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        when(mockRemoteDatasource.refreshToken())
            .thenAnswer((_) async => Right(userModel));
        when(mockLocalDatasource.saveUser(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
          },
        );
        verify(mockLocalDatasource.saveUser(userModel)).called(1);
        verify(mockLogger.info('Token refresh attempt')).called(1);
        verify(mockLogger.info('Token refresh successful for user: ${userModel.id}')).called(1);
      });

      test('should return failure on refresh error', () async {
        // Arrange
        final failure = AuthFailure(
          message: 'Invalid token',
          code: 'INVALID_TOKEN',
          type: AuthExceptionType.tokenInvalid,
        );

        when(mockRemoteDatasource.refreshToken())
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Token refresh attempt')).called(1);
        verify(mockLogger.error('Token refresh failed with failure', failure)).called(1);
        verifyNever(mockLocalDatasource.saveUser(any));
      });
    });

    group('forgotPassword', () {
      test('should return void on successful password reset', () async {
        // Arrange
        const email = 'test@example.com';
        when(mockErrorHandler.safeExecute(captureAny))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });

        // Act
        final result = await repository.forgotPassword(email);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.forgotPassword(email)).called(1);
        verify(mockLogger.info('Password reset attempt for email: $email')).called(1);
        verify(mockLogger.info('Password reset email sent successfully')).called(1);
      });

      test('should return failure on password reset error', () async {
        // Arrange
        const email = 'test@example.com';
        final failure = AuthFailure(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
          type: AuthExceptionType.unauthorized,
        );

        when(mockErrorHandler.safeExecute(captureAny))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return Left(failure);
            });

        // Act
        final result = await repository.forgotPassword(email);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (value) => fail('Expected failure but got success'),
        );
        verify(mockRemoteDatasource.forgotPassword(email)).called(1);
        verify(mockLogger.info('Password reset attempt for email: $email')).called(1);
      });
    });

    group('resetPassword', () {
      test('should return void on successful password reset', () async {
        // Arrange
        const token = 'reset-token-123';
        const newPassword = 'newpassword123';
        when(mockErrorHandler.safeExecute(captureAny()))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });

        // Act
        final result = await repository.resetPassword(
          token: token,
          newPassword: newPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.resetPassword(token: token, newPassword: newPassword)).called(1);
        verify(mockLogger.info('Password reset attempt with token')).called(1);
        verify(mockLogger.info('Password reset successful')).called(1);
      });
    });

    group('changePassword', () {
      test('should return void on successful password change', () async {
        // Arrange
        const currentPassword = 'oldpassword123';
        const newPassword = 'newpassword123';
        when(mockErrorHandler.safeExecute(captureAny()))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });

        // Act
        final result = await repository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        )).called(1);
        verify(mockLogger.info('Password change attempt')).called(1);
        verify(mockLogger.info('Password change successful')).called(1);
      });
    });

    group('updateProfile', () {
      test('should return updated User on successful profile update', () async {
        // Arrange
        const name = 'Updated Name';
        const profilePicture = 'https://example.com/new-avatar.jpg';
        final userModel = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: name,
          profilePicture: profilePicture,
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        when(mockRemoteDatasource.updateProfile(name: name, profilePicture: profilePicture))
            .thenAnswer((_) async => Right(userModel));
        when(mockLocalDatasource.saveUser(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.updateProfile(
          name: name,
          profilePicture: profilePicture,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.name, equals(name));
            expect(user.profilePicture, equals(profilePicture));
          },
        );
        verify(mockLocalDatasource.saveUser(userModel)).called(1);
        verify(mockLogger.info('Profile update attempt')).called(1);
        verify(mockLogger.info('Profile update successful for user: ${userModel.id}')).called(1);
      });

      test('should return failure on profile update error', () async {
        // Arrange
        const name = 'Updated Name';
        final failure = ServerFailure(
          message: 'Update failed',
          code: 'UPDATE_ERROR',
        );

        when(mockRemoteDatasource.updateProfile(name: name, profilePicture: null))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.updateProfile(name: name);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(failure)),
          (user) => fail('Expected failure but got success'),
        );
        verify(mockLogger.info('Profile update attempt')).called(1);
        verify(mockLogger.error('Profile update failed with failure', failure)).called(1);
        verifyNever(mockLocalDatasource.saveUser(any));
      });
    });

    group('verifyEmail', () {
      test('should return void on successful email verification', () async {
        // Arrange
        const token = 'verification-token-123';
        final cachedUser = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: false,
          createdAt: DateTime.now(),
        );
        final updatedUser = cachedUser.copyWith(isEmailVerified: true);

        when(mockErrorHandler.safeExecute(captureAny()))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });
        when(mockLocalDatasource.getUser())
            .thenAnswer((_) async => cachedUser);
        when(mockLocalDatasource.saveUser(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.verifyEmail(token);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.verifyEmail(token)).called(1);
        verify(mockLocalDatasource.getUser()).called(1);
        verify(mockLocalDatasource.saveUser(updatedUser)).called(1);
        verify(mockLogger.info('Email verification attempt with token')).called(1);
        verify(mockLogger.info('Email verification successful')).called(1);
      });
    });

    group('resendVerificationEmail', () {
      test('should return void on successful resend', () async {
        // Arrange
        when(mockErrorHandler.safeExecute(captureAny()))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });

        // Act
        final result = await repository.resendVerificationEmail();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.resendVerificationEmail()).called(1);
        verify(mockLogger.info('Resend verification email attempt')).called(1);
        verify(mockLogger.info('Verification email resent successfully')).called(1);
      });
    });

    group('deleteAccount', () {
      test('should return void on successful account deletion', () async {
        // Arrange
        when(mockErrorHandler.safeExecute(captureAny()))
            .thenAnswer((invocation) async {
              final function = invocation.positionalArguments[0] as Function();
              await function();
              return const Right(null);
            });
        when(mockLocalDatasource.clearAllAuthData())
            .thenAnswer((_) async {});

        // Act
        final result = await repository.deleteAccount();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
        verify(mockRemoteDatasource.deleteAccount()).called(1);
        verify(mockLocalDatasource.clearAllAuthData()).called(1);
        verify(mockLogger.info('Account deletion attempt')).called(1);
        verify(mockLogger.info('Account deletion successful')).called(1);
      });
    });
  });
}

/// Helper function to capture any argument for mock verification
captureAny() => anyNamed('arg');