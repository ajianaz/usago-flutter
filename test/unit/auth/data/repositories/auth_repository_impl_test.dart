import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/core/errors/error_handler.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../fixtures/auth_fixtures.dart';
import '../../../../mocks/auth_datasource_mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDatasource mockRemoteDatasource;
    late MockAuthLocalDatasource mockLocalDatasource;
    late MockErrorHandler mockErrorHandler;
    late MockAppLogger mockLogger;

    setUp(() {
      TestHelpers.setUpMocktailFallbacks();

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
      test('should return User when login is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => AuthFixtures.testUserModel);

        when(() => mockLocalDatasource.saveUser(any())).thenAnswer((_) async {});
        when(() => mockLocalDatasource.saveLastLoginTime(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User>> Function();
          return await function();
        });

        // Act
        final result = await repository.login(
          email: AuthFixtures.testUserEmail,
          password: AuthFixtures.testUserPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) {
            expect(user.id, equals(AuthFixtures.testUserId));
            expect(user.email, equals(AuthFixtures.testUserEmail));
          },
        );

        verify(() => mockRemoteDatasource.login(
          email: AuthFixtures.testUserEmail,
          password: AuthFixtures.testUserPassword,
        )).called(1);

        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockLocalDatasource.saveLastLoginTime(any())).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when login fails', () async {
        // Arrange
        final failure = ServerFailure(message: 'Invalid credentials');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.login(
          email: AuthFixtures.invalidEmail,
          password: AuthFixtures.invalidPassword,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Invalid credentials')),
          (user) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('register', () {
      test('should return User when registration is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        )).thenAnswer((_) async => AuthFixtures.testUserModel);

        when(() => mockLocalDatasource.saveUser(any())).thenAnswer((_) async {});
        when(() => mockLocalDatasource.saveLastLoginTime(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User>> Function();
          return await function();
        });

        // Act
        final result = await repository.register(
          email: AuthFixtures.testUserEmail,
          password: AuthFixtures.testUserPassword,
          name: AuthFixtures.testUserName,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) {
            expect(user.id, equals(AuthFixtures.testUserId));
            expect(user.email, equals(AuthFixtures.testUserEmail));
            expect(user.name, equals(AuthFixtures.testUserName));
          },
        );

        verify(() => mockRemoteDatasource.register(
          email: AuthFixtures.testUserEmail,
          password: AuthFixtures.testUserPassword,
          name: AuthFixtures.testUserName,
        )).called(1);

        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockLocalDatasource.saveLastLoginTime(any())).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when registration fails', () async {
        // Arrange
        final failure = ValidationFailure(message: 'Email already exists');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.register(
          email: AuthFixtures.testUserEmail,
          password: AuthFixtures.testUserPassword,
          name: AuthFixtures.testUserName,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Email already exists')),
          (user) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('logout', () {
      test('should return success when logout is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.logout()).thenAnswer((_) async {});
        when(() => mockLocalDatasource.clearAllAuthData()).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.logout()).called(1);
        verify(() => mockLocalDatasource.clearAllAuthData()).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when logout fails', () async {
        // Arrange
        final failure = NetworkFailure(message: 'Network error');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Network error')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('checkAuthStatus', () {
      test('should return User when user is cached', () async {
        // Arrange
        when(() => mockLocalDatasource.getUser()).thenAnswer((_) async => AuthFixtures.testUserModel);
        when(() => mockLocalDatasource.getToken()).thenAnswer((_) async => AuthFixtures.testToken);

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User?>> Function();
          return await function();
        });

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) {
            expect(user, isNotNull);
            expect(user!.id, equals(AuthFixtures.testUserId));
            expect(user.email, equals(AuthFixtures.testUserEmail));
          },
        );

        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.getToken()).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return null when no user is cached', () async {
        // Arrange
        when(() => mockLocalDatasource.getUser()).thenAnswer((_) async => null);
        when(() => mockLocalDatasource.getToken()).thenAnswer((_) async => null);

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User?>> Function();
          return await function();
        });

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) => expect(user, isNull),
        );

        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.getToken()).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when check auth status fails', () async {
        // Arrange
        final failure = CacheFailure(message: 'Cache error');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Cache error')),
          (user) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('refreshToken', () {
      test('should return User when token refresh is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.refreshToken()).thenAnswer((_) async => AuthFixtures.testUserModel);
        when(() => mockLocalDatasource.saveUser(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User>> Function();
          return await function();
        });

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) {
            expect(user.id, equals(AuthFixtures.testUserId));
            expect(user.email, equals(AuthFixtures.testUserEmail));
          },
        );

        verify(() => mockRemoteDatasource.refreshToken()).called(1);
        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when token refresh fails', () async {
        // Arrange
        final failure = ServerFailure(message: 'Invalid token');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Invalid token')),
          (user) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('forgotPassword', () {
      test('should return success when forgot password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.forgotPassword(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.forgotPassword(AuthFixtures.testUserEmail);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.forgotPassword(AuthFixtures.testUserEmail)).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when forgot password fails', () async {
        // Arrange
        final failure = NetworkFailure(message: 'Network error');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.forgotPassword(AuthFixtures.testUserEmail);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Network error')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('resetPassword', () {
      test('should return success when reset password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.resetPassword(
          token: AuthFixtures.testResetToken,
          newPassword: AuthFixtures.validPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.resetPassword(
          token: AuthFixtures.testResetToken,
          newPassword: AuthFixtures.validPassword,
        )).called(1);

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when reset password fails', () async {
        // Arrange
        final failure = ValidationFailure(message: 'Invalid token');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.resetPassword(
          token: AuthFixtures.testResetToken,
          newPassword: AuthFixtures.validPassword,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Invalid token')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('changePassword', () {
      test('should return success when change password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.changePassword(
          currentPassword: 'old-password',
          newPassword: AuthFixtures.validPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.changePassword(
          currentPassword: 'old-password',
          newPassword: AuthFixtures.validPassword,
        )).called(1);

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when change password fails', () async {
        // Arrange
        final failure = ValidationFailure(message: 'Invalid current password');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.changePassword(
          currentPassword: 'wrong-password',
          newPassword: AuthFixtures.validPassword,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Invalid current password')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('updateProfile', () {
      test('should return User when profile update is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.updateProfile(
          name: any(named: 'name'),
          profilePicture: any(named: 'profilePicture'),
        )).thenAnswer((_) async => AuthFixtures.testUserModel);

        when(() => mockLocalDatasource.saveUser(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, User>> Function();
          return await function();
        });

        // Act
        final result = await repository.updateProfile(
          name: 'Updated Name',
          profilePicture: 'https://example.com/new-avatar.jpg',
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (user) {
            expect(user.id, equals(AuthFixtures.testUserId));
            expect(user.email, equals(AuthFixtures.testUserEmail));
          },
        );

        verify(() => mockRemoteDatasource.updateProfile(
          name: 'Updated Name',
          profilePicture: 'https://example.com/new-avatar.jpg',
        )).called(1);

        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when profile update fails', () async {
        // Arrange
        final failure = ServerFailure(message: 'Update failed');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.updateProfile(
          name: 'Updated Name',
          profilePicture: 'https://example.com/new-avatar.jpg',
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Update failed')),
          (user) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('verifyEmail', () {
      test('should return success when email verification is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.verifyEmail(any())).thenAnswer((_) async {});
        when(() => mockLocalDatasource.getUser()).thenAnswer((_) async => AuthFixtures.testUserModel);
        when(() => mockLocalDatasource.saveUser(any())).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.verifyEmail(AuthFixtures.testVerificationToken);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.verifyEmail(AuthFixtures.testVerificationToken)).called(1);
        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.saveUser(any())).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when email verification fails', () async {
        // Arrange
        final failure = ValidationFailure(message: 'Invalid token');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.verifyEmail(AuthFixtures.testVerificationToken);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Invalid token')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('resendVerificationEmail', () {
      test('should return success when resend verification is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.resendVerificationEmail()).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.resendVerificationEmail();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.resendVerificationEmail()).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when resend verification fails', () async {
        // Arrange
        final failure = NetworkFailure(message: 'Network error');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.resendVerificationEmail();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Network error')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });

    group('deleteAccount', () {
      test('should return success when account deletion is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.deleteAccount()).thenAnswer((_) async {});
        when(() => mockLocalDatasource.clearAllAuthData()).thenAnswer((_) async {});

        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((invocation) async {
          final function = invocation.positionalArguments[0] as Future<Either<Failure, void>> Function();
          return await function();
        });

        // Act
        final result = await repository.deleteAccount();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: ${failure.message}'),
          (value) => expect(value, isNull),
        );

        verify(() => mockRemoteDatasource.deleteAccount()).called(1);
        verify(() => mockLocalDatasource.clearAllAuthData()).called(1);
        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });

      test('should return Failure when account deletion fails', () async {
        // Arrange
        final failure = ServerFailure(message: 'Deletion failed');
        when(() => mockErrorHandler.safeExecute(any())).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.deleteAccount();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, equals('Deletion failed')),
          (value) => fail('Expected failure but got success'),
        );

        verify(() => mockErrorHandler.safeExecute(any())).called(1);
      });
    });
  });
}

/// Mock ErrorHandler for testing
class MockErrorHandler extends Mock implements ErrorHandler {
  @override
  Future<Either<Failure, T>> safeExecute<T>(Future<T> Function() operation) {
    return super.noSuchMethod(
      Invocation.method(#safeExecute, [operation]),
    );
  }
}

/// Mock AppLogger for testing
class MockAppLogger extends Mock implements AppLogger {
  @override
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    super.noSuchMethod(
      Invocation.method(#info, [message, error, stackTrace]),
    );
  }

  @override
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    super.noSuchMethod(
      Invocation.method(#error, [message, error, stackTrace]),
    );
  }
}