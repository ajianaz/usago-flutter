import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../lib/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../../lib/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../lib/core/services/secure_storage_service.dart';
import '../../../../lib/core/network/dio_client.dart';
import '../../../../lib/core/errors/failure.dart';

/// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([
  AuthRepository,
  AuthRemoteDatasource,
  AuthLocalDatasource,
  SecureStorageService,
  DioClient,
])
void main() {}

/// Custom mock implementations with common setup methods
class MockAuthRepositoryHelper {
  late MockAuthRepository mockAuthRepository;

  MockAuthRepositoryHelper() {
    mockAuthRepository = MockAuthRepository();
  }

  /// Setup successful login response
  void setupLoginSuccess(UserModel user) {
    when(mockAuthRepository.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed login response
  void setupLoginFailure(Failure failure) {
    when(mockAuthRepository.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful register response
  void setupRegisterSuccess(UserModel user) {
    when(mockAuthRepository.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed register response
  void setupRegisterFailure(Failure failure) {
    when(mockAuthRepository.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful logout response
  void setupLogoutSuccess() {
    when(mockAuthRepository.logout())
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed logout response
  void setupLogoutFailure(Failure failure) {
    when(mockAuthRepository.logout())
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful check auth status response
  void setupCheckAuthSuccess(UserModel? user) {
    when(mockAuthRepository.checkAuthStatus())
        .thenAnswer((_) async => Right(user?.toEntity()));
  }

  /// Setup failed check auth status response
  void setupCheckAuthFailure(Failure failure) {
    when(mockAuthRepository.checkAuthStatus())
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful refresh token response
  void setupRefreshTokenSuccess(UserModel user) {
    when(mockAuthRepository.refreshToken())
        .thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed refresh token response
  void setupRefreshTokenFailure(Failure failure) {
    when(mockAuthRepository.refreshToken())
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful forgot password response
  void setupForgotPasswordSuccess() {
    when(mockAuthRepository.forgotPassword(anyNamed('email')))
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed forgot password response
  void setupForgotPasswordFailure(Failure failure) {
    when(mockAuthRepository.forgotPassword(anyNamed('email')))
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful reset password response
  void setupResetPasswordSuccess() {
    when(mockAuthRepository.resetPassword(
      token: anyNamed('token'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed reset password response
  void setupResetPasswordFailure(Failure failure) {
    when(mockAuthRepository.resetPassword(
      token: anyNamed('token'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful change password response
  void setupChangePasswordSuccess() {
    when(mockAuthRepository.changePassword(
      currentPassword: anyNamed('currentPassword'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => const Right(null));
  }

  /// Setup failed change password response
  void setupChangePasswordFailure(Failure failure) {
    when(mockAuthRepository.changePassword(
      currentPassword: anyNamed('currentPassword'),
      newPassword: anyNamed('newPassword'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful update profile response
  void setupUpdateProfileSuccess(UserModel user) {
    when(mockAuthRepository.updateProfile(
      name: anyNamed('name'),
      profilePicture: anyNamed('profilePicture'),
    )).thenAnswer((_) async => Right(user.toEntity()));
  }

  /// Setup failed update profile response
  void setupUpdateProfileFailure(Failure failure) {
    when(mockAuthRepository.updateProfile(
      name: anyNamed('name'),
      profilePicture: anyNamed('profilePicture'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful verify email response
  void setupVerifyEmailSuccess() {
    when(mockAuthRepository.verifyEmail(anyNamed('token')))
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed verify email response
  void setupVerifyEmailFailure(Failure failure) {
    when(mockAuthRepository.verifyEmail(anyNamed('token')))
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful resend verification email response
  void setupResendVerificationEmailSuccess() {
    when(mockAuthRepository.resendVerificationEmail())
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed resend verification email response
  void setupResendVerificationEmailFailure(Failure failure) {
    when(mockAuthRepository.resendVerificationEmail())
        .thenAnswer((_) async => Left(failure));
  }

  /// Setup successful delete account response
  void setupDeleteAccountSuccess() {
    when(mockAuthRepository.deleteAccount())
        .thenAnswer((_) async => const Right(null));
  }

  /// Setup failed delete account response
  void setupDeleteAccountFailure(Failure failure) {
    when(mockAuthRepository.deleteAccount())
        .thenAnswer((_) async => Left(failure));
  }
}

/// Custom mock helper for remote datasource
class MockAuthRemoteDatasourceHelper {
  late MockAuthRemoteDatasource mockRemoteDatasource;

  MockAuthRemoteDatasourceHelper() {
    mockRemoteDatasource = MockAuthRemoteDatasource();
  }

  /// Setup successful login response
  void setupLoginSuccess(UserModel user) {
    when(mockRemoteDatasource.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(user));
  }

  /// Setup failed login response
  void setupLoginFailure(Failure failure) {
    when(mockRemoteDatasource.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Left(failure));
  }

  /// Setup successful register response
  void setupRegisterSuccess(UserModel user) {
    when(mockRemoteDatasource.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Right(user));
  }

  /// Setup failed register response
  void setupRegisterFailure(Failure failure) {
    when(mockRemoteDatasource.register(
      email: anyNamed('email'),
      password: anyNamed('password'),
      name: anyNamed('name'),
    )).thenAnswer((_) async => Left(failure));
  }
}

/// Custom mock helper for local datasource
class MockAuthLocalDatasourceHelper {
  late MockAuthLocalDatasource mockLocalDatasource;

  MockAuthLocalDatasourceHelper() {
    mockLocalDatasource = MockAuthLocalDatasource();
  }

  /// Setup successful save user
  void setupSaveUserSuccess() {
    when(mockLocalDatasource.saveUser(any))
        .thenAnswer((_) async {});
  }

  /// Setup successful get user
  void setupGetUserSuccess(UserModel user) {
    when(mockLocalDatasource.getUser())
        .thenAnswer((_) async => user);
  }

  /// Setup successful get user returns null
  void setupGetUserReturnsNull() {
    when(mockLocalDatasource.getUser())
        .thenAnswer((_) async => null);
  }

  /// Setup successful clear user
  void setupClearUserSuccess() {
    when(mockLocalDatasource.clearUser())
        .thenAnswer((_) async {});
  }

  /// Setup successful save token
  void setupSaveTokenSuccess() {
    when(mockLocalDatasource.saveToken(any))
        .thenAnswer((_) async {});
  }

  /// Setup successful get token
  void setupGetTokenSuccess(String token) {
    when(mockLocalDatasource.getToken())
        .thenAnswer((_) async => token);
  }

  /// Setup successful get token returns null
  void setupGetTokenReturnsNull() {
    when(mockLocalDatasource.getToken())
        .thenAnswer((_) async => null);
  }

  /// Setup successful clear token
  void setupClearTokenSuccess() {
    when(mockLocalDatasource.clearToken())
        .thenAnswer((_) async {});
  }
}