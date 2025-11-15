import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../lib/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../../lib/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../lib/core/services/secure_storage_service.dart';
import '../../../../lib/core/network/dio_client.dart';
import '../../../../lib/core/errors/failure.dart';

/// Mock implementation of AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock implementation of AuthRemoteDatasource
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

/// Mock implementation of AuthLocalDatasource
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

/// Mock implementation of SecureStorageService
class MockSecureStorageService extends Mock implements SecureStorageService {}

/// Mock implementation of DioClient
class MockDioClient extends Mock implements DioClient {}

/// Helper class for setting up common mock scenarios
class MockSetupHelpers {
  /// Setup successful login response
  static void setupLoginSuccess(
    MockAuthRepository mockRepo,
    UserModel user,
  ) {
    when(mockRepo.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed login response
  static void setupLoginFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful register response
  static void setupRegisterSuccess(
    MockAuthRepository mockRepo,
    UserModel user,
  ) {
    when(mockRepo.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed register response
  static void setupRegisterFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful logout response
  static void setupLogoutSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.logout()).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed logout response
  static void setupLogoutFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.logout()).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful check auth status response
  static void setupCheckAuthSuccess(
    MockAuthRepository mockRepo,
    UserModel? user,
  ) {
    when(mockRepo.checkAuthStatus())
        .thenAnswer((_) async => Right(user?.toEntity()));
  }

  /// Setup failed check auth status response
  static void setupCheckAuthFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.checkAuthStatus()).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful refresh token response
  static void setupRefreshTokenSuccess(
    MockAuthRepository mockRepo,
    UserModel user,
  ) {
    when(mockRepo.refreshToken()).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed refresh token response
  static void setupRefreshTokenFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.refreshToken()).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful forgot password response
  static void setupForgotPasswordSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.forgotPassword(anyNamed('email')))
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed forgot password response
  static void setupForgotPasswordFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.forgotPassword(anyNamed('email')))
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful reset password response
  static void setupResetPasswordSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.resetPassword(
      token: anyNamed('token'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed reset password response
  static void setupResetPasswordFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.resetPassword(
      token: anyNamed('token'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful change password response
  static void setupChangePasswordSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.changePassword(
      currentPassword: anyNamed('currentPassword'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed change password response
  static void setupChangePasswordFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.changePassword(
      currentPassword: anyNamed('currentPassword'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful update profile response
  static void setupUpdateProfileSuccess(
    MockAuthRepository mockRepo,
    UserModel user,
  ) {
    when(mockRepo.updateProfile(
      name: anyNamed('name'),
      profilePicture: anyNamed('profilePicture'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed update profile response
  static void setupUpdateProfileFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.updateProfile(
      name: anyNamed('name'),
      profilePicture: anyNamed('profilePicture'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful verify email response
  static void setupVerifyEmailSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.verifyEmail(anyNamed('token')))
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed verify email response
  static void setupVerifyEmailFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.verifyEmail(anyNamed('token')))
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful resend verification email response
  static void setupResendVerificationEmailSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.resendVerificationEmail())
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed resend verification email response
  static void setupResendVerificationEmailFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.resendVerificationEmail())
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful delete account response
  static void setupDeleteAccountSuccess(MockAuthRepository mockRepo) {
    when(mockRepo.deleteAccount()).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed delete account response
  static void setupDeleteAccountFailure(
    MockAuthRepository mockRepo,
    Failure failure,
  ) {
    when(mockRepo.deleteAccount()).thenAnswer((_) async => Left(failure));
  }
}