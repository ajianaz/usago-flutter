import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/core/errors/error_handler.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:usago/features/auth/data/models/user_model.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import 'package:usago/features/auth/domain/repositories/auth_repository.dart';
import 'package:usago/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:usago/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:usago/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/login_usecase.dart';
import 'package:usago/features/auth/domain/usecases/logout_usecase.dart';
import 'package:usago/features/auth/domain/usecases/register_usecase.dart';
import 'package:usago/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import 'package:usago/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:usago/features/auth/domain/usecases/verify_email_usecase.dart';
import '../fixtures/auth_fixtures.dart';

/// Mock AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
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
  }) async {
    return super.noSuchMethod(
      Invocation.method(#register, [], {
        #email: email,
        #password: password,
        #name: name,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return super.noSuchMethod(Invocation.method(#logout, []));
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    return super.noSuchMethod(Invocation.method(#checkAuthStatus, []));
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    return super.noSuchMethod(Invocation.method(#refreshToken, []));
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    return super.noSuchMethod(
      Invocation.method(#forgotPassword, [email]),
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
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
  }) async {
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
  }) async {
    return super.noSuchMethod(
      Invocation.method(#updateProfile, [], {
        #name: name,
        #profilePicture: profilePicture,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    return super.noSuchMethod(
      Invocation.method(#verifyEmail, [token]),
    );
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    return super.noSuchMethod(Invocation.method(#resendVerificationEmail, []));
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return super.noSuchMethod(Invocation.method(#deleteAccount, []));
  }
}

/// Mock AuthRemoteDatasource
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

/// Mock AuthLocalDatasource
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

/// Mock ErrorHandler
class MockErrorHandler extends Mock implements ErrorHandler {
  @override
  Future<Either<Failure, T>> safeExecute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

/// Mock AppLogger
class MockAppLogger extends Mock implements AppLogger {}

/// Mock LoginUsecase
class MockLoginUsecase extends Mock implements LoginUsecase {}

/// Mock RegisterUsecase
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

/// Mock LogoutUsecase
class MockLogoutUsecase extends Mock implements LogoutUsecase {}

/// Mock CheckAuthUsecase
class MockCheckAuthUsecase extends Mock implements CheckAuthUsecase {}

/// Mock UpdateProfileUsecase
class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

/// Mock ChangePasswordUsecase
class MockChangePasswordUsecase extends Mock implements ChangePasswordUsecase {}

/// Mock ForgotPasswordUsecase
class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

/// Mock ResetPasswordUsecase
class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase {}

/// Mock VerifyEmailUsecase
class MockVerifyEmailUsecase extends Mock implements VerifyEmailUsecase {}

/// Mock ResendVerificationEmailUsecase
class MockResendVerificationEmailUsecase extends Mock implements ResendVerificationEmailUsecase {}

/// Mock DeleteAccountUsecase
class MockDeleteAccountUsecase extends Mock implements DeleteAccountUsecase {}

/// Mock setup utilities
class MockSetup {
  /// Setup common mock behaviors
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

  static void setupRemoteDatasourceMocks(MockAuthRemoteDatasource mock) {
    // Login
    when(() => mock.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Register
    when(() => mock.register(
      email: any(named: 'email'),
      password: any(named: 'password'),
      name: any(named: 'name'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Logout
    when(() => mock.logout()).thenAnswer((_) async {});

    // Refresh token
    when(() => mock.refreshToken()).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Forgot password
    when(() => mock.forgotPassword(any())).thenAnswer((_) async {});

    // Reset password
    when(() => mock.resetPassword(
      token: any(named: 'token'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async {});

    // Change password
    when(() => mock.changePassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async {});

    // Update profile
    when(() => mock.updateProfile(
      name: any(named: 'name'),
      profilePicture: any(named: 'profilePicture'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Verify email
    when(() => mock.verifyEmail(any())).thenAnswer((_) async {});

    // Resend verification email
    when(() => mock.resendVerificationEmail()).thenAnswer((_) async {});

    // Delete account
    when(() => mock.deleteAccount()).thenAnswer((_) async {});
  }

  static void setupLocalDatasourceMocks(MockAuthLocalDatasource mock) {
    // Save user
    when(() => mock.saveUser(any())).thenAnswer((_) async {});

    // Get user
    when(() => mock.getUser()).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Clear user
    when(() => mock.clearUser()).thenAnswer((_) async {});

    // Save token
    when(() => mock.saveToken(any())).thenAnswer((_) async {});

    // Get token
    when(() => mock.getToken()).thenAnswer((_) async => AuthFixtures.testToken);

    // Clear token
    when(() => mock.clearToken()).thenAnswer((_) async {});

    // Save session data
    when(() => mock.saveSessionData(any())).thenAnswer((_) async {});

    // Get session data
    when(() => mock.getSessionData()).thenAnswer((_) async => AuthFixtures.testSessionData);

    // Clear session data
    when(() => mock.clearSessionData()).thenAnswer((_) async {});

    // Check if user is logged in
    when(() => mock.isUserLoggedIn()).thenAnswer((_) async => true);

    // Get last login time
    when(() => mock.getLastLoginTime()).thenAnswer((_) async => AuthFixtures.testLastLoginAt);

    // Save last login time
    when(() => mock.saveLastLoginTime(any())).thenAnswer((_) async {});

    // Clear all auth data
    when(() => mock.clearAllAuthData()).thenAnswer((_) async {});
  }
}