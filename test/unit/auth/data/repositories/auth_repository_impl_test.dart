import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import '../../../../fixtures/auth_fixtures.dart';
import '../../../../mocks/auth_mocks.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDatasource mockRemoteDatasource;
    late MockAuthLocalDatasource mockLocalDatasource;
    late MockErrorHandler mockErrorHandler;
    late MockAppLogger mockLogger;

    setUpAll(() {
      registerFallbackValue(AuthFixtures.testUserModel);
    });

    setUp(() {
      mockRemoteDatasource = MockAuthRemoteDatasource();
      mockLocalDatasource = MockAuthLocalDatasource();
      mockErrorHandler = MockErrorHandler();
      mockLogger = MockAppLogger();

      // Setup default mock behaviors
      MockSetup.setupRemoteDatasourceMocks(mockRemoteDatasource);
      MockSetup.setupLocalDatasourceMocks(mockLocalDatasource);

      repository = AuthRepositoryImpl(
        remoteDatasource: mockRemoteDatasource,
        localDatasource: mockLocalDatasource,
        errorHandler: mockErrorHandler,
        logger: mockLogger,
      );
    });

    group('login', () {
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;

      test('should return User when login is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.login(email: email, password: password))
            .thenAnswer((_) async => AuthFixtures.testUserModel);

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user, AuthFixtures.testUser),
        );

        verify(() => mockRemoteDatasource.login(email: email, password: password)).called(1);
        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockLocalDatasource.saveLastLoginTime(any())).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when login fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Login failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.saveUser(any()));
        verifyNever(() => mockLocalDatasource.saveLastLoginTime(any()));
      });
    });

    group('register', () {
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;
      const name = AuthFixtures.testUserName;

      test('should return User when registration is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.register(
          email: email,
          password: password,
          name: name,
        )).thenAnswer((_) async => AuthFixtures.testUserModel);

        // Act
        final result = await repository.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user, AuthFixtures.testUser),
        );

        verify(() => mockRemoteDatasource.register(
          email: email,
          password: password,
          name: name,
        )).called(1);
        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockLocalDatasource.saveLastLoginTime(any())).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when registration fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Registration failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.saveUser(any()));
        verifyNever(() => mockLocalDatasource.saveLastLoginTime(any()));
      });
    });

    group('logout', () {
      test('should return void when logout is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.logout()).called(1);
        verify(() => mockLocalDatasource.clearAllAuthData()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when logout fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Logout failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.clearAllAuthData());
      });
    });

    group('checkAuthStatus', () {
      test('should return User when user is cached', () async {
        // Arrange
        when(() => mockLocalDatasource.getUser())
            .thenAnswer((_) async => AuthFixtures.testUserModel);
        when(() => mockLocalDatasource.getToken())
            .thenAnswer((_) async => AuthFixtures.testToken);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result, isA<Right<Failure, User?>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user, AuthFixtures.testUser),
        );

        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.getToken()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return null when no cached user exists', () async {
        // Arrange
        when(() => mockLocalDatasource.getUser()).thenAnswer((_) async => null);
        when(() => mockLocalDatasource.getToken()).thenAnswer((_) async => null);

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result, isA<Right<Failure, User?>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user, null),
        );

        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.getToken()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when check fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Auth check failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.checkAuthStatus();

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('refreshToken', () {
      test('should return User when token refresh is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.refreshToken())
            .thenAnswer((_) async => AuthFixtures.testUserModel);

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user, AuthFixtures.testUser),
        );

        verify(() => mockRemoteDatasource.refreshToken()).called(1);
        verify(() => mockLocalDatasource.saveUser(AuthFixtures.testUserModel)).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when token refresh fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Token refresh failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.refreshToken();

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.saveUser(any()));
      });
    });

    group('forgotPassword', () {
      const email = AuthFixtures.validEmail;

      test('should return void when forgot password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.forgotPassword(email))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.forgotPassword(email);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.forgotPassword(email)).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when forgot password fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Forgot password failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.forgotPassword(email);

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('resetPassword', () {
      const token = AuthFixtures.testResetToken;
      const newPassword = 'newPassword123';

      test('should return void when reset password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.resetPassword(
          token: token,
          newPassword: newPassword,
        )).thenAnswer((_) async {});

        // Act
        final result = await repository.resetPassword(
          token: token,
          newPassword: newPassword,
        );

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.resetPassword(
          token: token,
          newPassword: newPassword,
        )).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when reset password fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Reset password failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.resetPassword(
          token: token,
          newPassword: newPassword,
        );

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('changePassword', () {
      const currentPassword = 'oldPassword123';
      const newPassword = 'newPassword123';

      test('should return void when change password is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        )).thenAnswer((_) async {});

        // Act
        final result = await repository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        )).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when change password fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Change password failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('updateProfile', () {
      const newName = 'Updated Name';
      const newProfilePicture = 'https://example.com/new-avatar.jpg';

      test('should return User when update profile is successful', () async {
        // Arrange
        final updatedUserModel = AuthFixtures.testUserModel.copyWith(name: newName);
        when(() => mockRemoteDatasource.updateProfile(
          name: newName,
          profilePicture: newProfilePicture,
        )).thenAnswer((_) async => updatedUserModel);

        // Act
        final result = await repository.updateProfile(
          name: newName,
          profilePicture: newProfilePicture,
        );

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (user) => expect(user.name, newName),
        );

        verify(() => mockRemoteDatasource.updateProfile(
          name: newName,
          profilePicture: newProfilePicture,
        )).called(1);
        verify(() => mockLocalDatasource.saveUser(updatedUserModel)).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when update profile fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Update profile failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.updateProfile(
          name: newName,
          profilePicture: newProfilePicture,
        );

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.saveUser(any()));
      });
    });

    group('verifyEmail', () {
      const token = AuthFixtures.testVerificationToken;

      test('should return void when verify email is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.verifyEmail(token))
            .thenAnswer((_) async {});
        when(() => mockLocalDatasource.getUser())
            .thenAnswer((_) async => AuthFixtures.testUserModel);

        // Act
        final result = await repository.verifyEmail(token);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.verifyEmail(token)).called(1);
        verify(() => mockLocalDatasource.getUser()).called(1);
        verify(() => mockLocalDatasource.saveUser(any())).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when verify email fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Verify email failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.verifyEmail(token);

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.saveUser(any()));
      });

      test('should handle null cached user when verifying email', () async {
        // Arrange
        when(() => mockRemoteDatasource.verifyEmail(token))
            .thenAnswer((_) async {});
        when(() => mockLocalDatasource.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await repository.verifyEmail(token);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.verifyEmail(token)).called(1);
        verify(() => mockLocalDatasource.getUser()).called(1);
        verifyNever(() => mockLocalDatasource.saveUser(any()));
      });
    });

    group('resendVerificationEmail', () {
      test('should return void when resend verification email is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.resendVerificationEmail())
            .thenAnswer((_) async {});

        // Act
        final result = await repository.resendVerificationEmail();

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.resendVerificationEmail()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when resend verification email fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Resend verification email failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.resendVerificationEmail();

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('deleteAccount', () {
      test('should return void when delete account is successful', () async {
        // Arrange
        when(() => mockRemoteDatasource.deleteAccount()).thenAnswer((_) async {});

        // Act
        final result = await repository.deleteAccount();

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected success but got failure'),
          (_) => null, // void success, nothing to assert
        );

        verify(() => mockRemoteDatasource.deleteAccount()).called(1);
        verify(() => mockLocalDatasource.clearAllAuthData()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      });

      test('should return Failure when delete account fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Delete account failed');
        when(() => mockErrorHandler.safeExecute(any()))
            .thenAnswer((invocation) async => const Left(failure));

        // Act
        final result = await repository.deleteAccount();

        // Assert
        expect(result, const Left(failure));
        verifyNever(() => mockLocalDatasource.clearAllAuthData());
      });
    });
  });
}