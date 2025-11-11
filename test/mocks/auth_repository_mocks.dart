import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import 'package:usago/features/auth/domain/repositories/auth_repository.dart';
import '../fixtures/auth_fixtures.dart';

/// Mock AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) {
    return super.noSuchMethod(
      Invocation.method(#login, [], {
        #email: email,
        #password: password,
      }),
    );
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) {
    return super.noSuchMethod(
      Invocation.method(#register, [], {
        #email: email,
        #password: password,
        #name: name,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> logout() {
    return super.noSuchMethod(Invocation.method(#logout, []));
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() {
    return super.noSuchMethod(Invocation.method(#checkAuthStatus, []));
  }

  @override
  Future<Either<Failure, User>> refreshToken() {
    return super.noSuchMethod(Invocation.method(#refreshToken, []));
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) {
    return super.noSuchMethod(
      Invocation.method(#forgotPassword, [email]),
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return super.noSuchMethod(
      Invocation.method(#resetPassword, [], {
        #token: token,
        #newPassword: newPassword,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return super.noSuchMethod(
      Invocation.method(#changePassword, [], {
        #currentPassword: currentPassword,
        #newPassword: newPassword,
      }),
    );
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? profilePicture,
  }) {
    return super.noSuchMethod(
      Invocation.method(#updateProfile, [], {
        #name: name,
        #profilePicture: profilePicture,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) {
    return super.noSuchMethod(
      Invocation.method(#verifyEmail, [token]),
    );
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() {
    return super.noSuchMethod(Invocation.method(#resendVerificationEmail, []));
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    return super.noSuchMethod(Invocation.method(#deleteAccount, []));
  }
}

/// Mock setup utilities for AuthRepository
class MockAuthRepositorySetup {
  /// Setup common mock behaviors for AuthRepository
  static void setupAuthRepositoryMocks(MockAuthRepository mock) {
    // Login
    when(() => mock.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => Right(AuthFixtures.testUser));

    // Register
    when(() => mock.register(
      email: any(named: 'email'),
      password: any(named: 'password'),
      name: any(named: 'name'),
    )).thenAnswer((_) async => Right(AuthFixtures.testUser));

    // Logout
    when(() => mock.logout()).thenAnswer((_) async => const Right(null));

    // Check auth status
    when(() => mock.checkAuthStatus()).thenAnswer((_) async => Right(AuthFixtures.testUser));

    // Refresh token
    when(() => mock.refreshToken()).thenAnswer((_) async => Right(AuthFixtures.testUser));

    // Forgot password
    when(() => mock.forgotPassword(any(named: 'email'))).thenAnswer((_) async => const Right(null));

    // Reset password
    when(() => mock.resetPassword(
      token: any(named: 'token'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async => const Right(null));

    // Change password
    when(() => mock.changePassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async => const Right(null));

    // Update profile
    when(() => mock.updateProfile(
      name: any(named: 'name'),
      profilePicture: any(named: 'profilePicture'),
    )).thenAnswer((_) async => Right(AuthFixtures.testUser));

    // Verify email
    when(() => mock.verifyEmail(any(named: 'token'))).thenAnswer((_) async => const Right(null));

    // Resend verification email
    when(() => mock.resendVerificationEmail()).thenAnswer((_) async => const Right(null));

    // Delete account
    when(() => mock.deleteAccount()).thenAnswer((_) async => const Right(null));
  }
}