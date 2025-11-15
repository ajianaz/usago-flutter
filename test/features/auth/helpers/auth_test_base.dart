import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.dart';
import 'test_constants.dart';
import 'auth_test_helpers.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../lib/core/errors/failure.dart';
import '../../../../lib/core/errors/exceptions.dart';

/// Base test class for auth feature tests
/// Provides common setup, teardown, and utility methods
abstract class AuthTestBase {
  late MockAuthRepository mockAuthRepository;
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockAuthLocalDatasource mockLocalDatasource;
  late MockSecureStorageService mockSecureStorageService;
  late MockDioClient mockDioClient;

  /// Common test user
  late User testUser;
  late User unverifiedUser;
  late User newUser;

  /// Common test failures
  late AuthFailure networkFailure;
  late AuthFailure authFailure;
  late ValidationFailure validationFailure;
  late ServerFailure serverFailure;

  /// Setup method called before each test
  void setUp() {
    // Initialize mocks
    mockAuthRepository = MockAuthRepository();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockLocalDatasource = MockAuthLocalDatasource();
    mockSecureStorageService = MockSecureStorageService();
    mockDioClient = MockDioClient();

    // Initialize test users
    testUser = AuthTestHelpers.createTestUser();
    unverifiedUser = AuthTestHelpers.createUnverifiedTestUser();
    newUser = AuthTestHelpers.createNewTestUser();

    // Initialize test failures
    networkFailure = const AuthFailure(
      message: AuthTestConstants.networkErrorMessage,
      type: AuthExceptionType.loginRequired,
      code: 'NETWORK_ERROR',
    );

    authFailure = const AuthFailure(
      message: AuthTestConstants.invalidCredentialsMessage,
      type: AuthExceptionType.invalidCredentials,
      code: 'INVALID_CREDENTIALS',
    );

    validationFailure = const ValidationFailure(
      message: AuthTestConstants.validationErrorMessage,
      fieldErrors: {
        'email': AuthTestConstants.invalidEmailMessage,
        'password': AuthTestConstants.weakPasswordMessage,
      },
      code: 'VALIDATION_ERROR',
    );

    serverFailure = const ServerFailure(
      message: AuthTestConstants.serverErrorMessage,
      statusCode: 500,
      endpoint: AuthTestConstants.loginEndpoint,
      code: 'SERVER_ERROR',
    );
  }

  /// Teardown method called after each test
  void tearDown() {
    // Reset all mocks to clean state
    reset(mockAuthRepository);
    reset(mockRemoteDatasource);
    reset(mockLocalDatasource);
    reset(mockSecureStorageService);
    reset(mockDioClient);
  }

  /// Setup successful login scenario
  void setupLoginSuccess() {
    MockSetupHelpers.setupLoginSuccess(
      mockAuthRepository,
      UserModel.fromEntity(AuthTestHelpers.createTestUser()),
    );
  }

  /// Setup failed login scenario
  void setupLoginFailure([Failure? failure]) {
    MockSetupHelpers.setupLoginFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful register scenario
  void setupRegisterSuccess() {
    MockSetupHelpers.setupRegisterSuccess(
      mockAuthRepository,
      UserModel.fromEntity(AuthTestHelpers.createTestUser()),
    );
  }

  /// Setup failed register scenario
  void setupRegisterFailure([Failure? failure]) {
    MockSetupHelpers.setupRegisterFailure(
      mockAuthRepository,
      failure ?? validationFailure,
    );
  }

  /// Setup successful logout scenario
  void setupLogoutSuccess() {
    MockSetupHelpers.setupLogoutSuccess(mockAuthRepository);
  }

  /// Setup failed logout scenario
  void setupLogoutFailure([Failure? failure]) {
    MockSetupHelpers.setupLogoutFailure(
      mockAuthRepository,
      failure ?? networkFailure,
    );
  }

  /// Setup successful check auth status scenario
  void setupCheckAuthSuccess([User? user]) {
    MockSetupHelpers.setupCheckAuthSuccess(
      mockAuthRepository,
      UserModel.fromEntity(user ?? testUser),
    );
  }

  /// Setup failed check auth status scenario
  void setupCheckAuthFailure([Failure? failure]) {
    MockSetupHelpers.setupCheckAuthFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful refresh token scenario
  void setupRefreshTokenSuccess() {
    MockSetupHelpers.setupRefreshTokenSuccess(
      mockAuthRepository,
      UserModel.fromEntity(AuthTestHelpers.createTestUser()),
    );
  }

  /// Setup failed refresh token scenario
  void setupRefreshTokenFailure([Failure? failure]) {
    MockSetupHelpers.setupRefreshTokenFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful forgot password scenario
  void setupForgotPasswordSuccess() {
    MockSetupHelpers.setupForgotPasswordSuccess(mockAuthRepository);
  }

  /// Setup failed forgot password scenario
  void setupForgotPasswordFailure([Failure? failure]) {
    MockSetupHelpers.setupForgotPasswordFailure(
      mockAuthRepository,
      failure ?? validationFailure,
    );
  }

  /// Setup successful reset password scenario
  void setupResetPasswordSuccess() {
    MockSetupHelpers.setupResetPasswordSuccess(mockAuthRepository);
  }

  /// Setup failed reset password scenario
  void setupResetPasswordFailure([Failure? failure]) {
    MockSetupHelpers.setupResetPasswordFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful change password scenario
  void setupChangePasswordSuccess() {
    MockSetupHelpers.setupChangePasswordSuccess(mockAuthRepository);
  }

  /// Setup failed change password scenario
  void setupChangePasswordFailure([Failure? failure]) {
    MockSetupHelpers.setupChangePasswordFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful update profile scenario
  void setupUpdateProfileSuccess() {
    MockSetupHelpers.setupUpdateProfileSuccess(
      mockAuthRepository,
      UserModel.fromEntity(AuthTestHelpers.createTestUser()),
    );
  }

  /// Setup failed update profile scenario
  void setupUpdateProfileFailure([Failure? failure]) {
    MockSetupHelpers.setupUpdateProfileFailure(
      mockAuthRepository,
      failure ?? validationFailure,
    );
  }

  /// Setup successful verify email scenario
  void setupVerifyEmailSuccess() {
    MockSetupHelpers.setupVerifyEmailSuccess(mockAuthRepository);
  }

  /// Setup failed verify email scenario
  void setupVerifyEmailFailure([Failure? failure]) {
    MockSetupHelpers.setupVerifyEmailFailure(
      mockAuthRepository,
      failure ?? authFailure,
    );
  }

  /// Setup successful resend verification email scenario
  void setupResendVerificationEmailSuccess() {
    MockSetupHelpers.setupResendVerificationEmailSuccess(mockAuthRepository);
  }

  /// Setup failed resend verification email scenario
  void setupResendVerificationEmailFailure([Failure? failure]) {
    MockSetupHelpers.setupResendVerificationEmailFailure(
      mockAuthRepository,
      failure ?? networkFailure,
    );
  }

  /// Setup successful delete account scenario
  void setupDeleteAccountSuccess() {
    MockSetupHelpers.setupDeleteAccountSuccess(mockAuthRepository);
  }

  /// Setup failed delete account scenario
  void setupDeleteAccountFailure([Failure? failure]) {
    MockSetupHelpers.setupDeleteAccountFailure(
      mockAuthRepository,
      failure ?? serverFailure,
    );
  }

  /// Verify mock was called exactly once
  void verifyCalledOnce(Mock mock) {
    verify(mock).called(1);
  }

  /// Verify mock was never called
  void verifyNeverCalled(Mock mock) {
    verifyNever(mock);
  }

  /// Verify mock was called specific number of times
  void verifyCalledTimes(Mock mock, int count) {
    verify(mock).called(count);
  }

  /// Verify no more interactions
  void verifyNoMoreInteractions() {
    verifyNoMoreInteractions();
  }
}