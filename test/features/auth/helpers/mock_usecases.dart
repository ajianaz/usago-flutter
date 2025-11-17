import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/usecases/login_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/register_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/logout_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/update_profile_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/change_password_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/reset_password_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/verify_email_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../../../lib/features/auth/domain/usecases/delete_account_usecase.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/core/errors/failure.dart';
import 'auth_test_helpers.dart';

/// Mock implementation of LoginUseCase
class MockLoginUseCase extends Mock implements LoginUseCase {}

/// Mock implementation of RegisterUseCase
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

/// Mock implementation of LogoutUseCase
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Mock implementation of CheckAuthUsecase
class MockCheckAuthUseCase extends Mock implements CheckAuthUsecase {}

/// Mock implementation of UpdateProfileUsecase
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUsecase {}

/// Mock implementation of ChangePasswordUsecase
class MockChangePasswordUseCase extends Mock implements ChangePasswordUsecase {}

/// Mock implementation of ForgotPasswordUsecase
class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUsecase {}

/// Mock implementation of ResetPasswordUsecase
class MockResetPasswordUseCase extends Mock implements ResetPasswordUsecase {}

/// Mock implementation of VerifyEmailUsecase
class MockVerifyEmailUseCase extends Mock implements VerifyEmailUsecase {}

/// Mock implementation of ResendVerificationEmailUsecase
class MockResendVerificationEmailUseCase extends Mock implements ResendVerificationEmailUsecase {}

/// Mock implementation of DeleteAccountUsecase
class MockDeleteAccountUseCase extends Mock implements DeleteAccountUsecase {}

/// Helper class to setup common mock behaviors
class MockUseCaseSetup {
  /// Setup mock login use case to return success
  static void setupMockLoginSuccess(MockLoginUseCase mockLoginUseCase) {
    when(mockLoginUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createSuccessResult());
  }

  /// Setup mock login use case to return failure
  static void setupMockLoginFailure(MockLoginUseCase mockLoginUseCase) {
    when(mockLoginUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createFailureResult());
  }

  /// Setup mock register use case to return success
  static void setupMockRegisterSuccess(MockRegisterUseCase mockRegisterUseCase) {
    when(mockRegisterUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createSuccessResult());
  }

  /// Setup mock register use case to return failure
  static void setupMockRegisterFailure(MockRegisterUseCase mockRegisterUseCase) {
    when(mockRegisterUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createFailureResult());
  }

  /// Setup mock logout use case to return success
  static void setupMockLogoutSuccess(MockLogoutUseCase mockLogoutUseCase) {
    when(mockLogoutUseCase.call())
        .thenAnswer((_) async => AuthTestHelpers.createVoidSuccessResult());
  }

  /// Setup mock logout use case to return failure
  static void setupMockLogoutFailure(MockLogoutUseCase mockLogoutUseCase) {
    when(mockLogoutUseCase.call())
        .thenAnswer((_) async => AuthTestHelpers.createVoidFailureResult());
  }

  /// Setup mock check auth use case to return success
  static void setupMockCheckAuthSuccess(MockCheckAuthUseCase mockCheckAuthUseCase) {
    when(mockCheckAuthUseCase.call())
        .thenAnswer((_) async => AuthTestHelpers.createSuccessResult());
  }

  /// Setup mock check auth use case to return failure
  static void setupMockCheckAuthFailure(MockCheckAuthUseCase mockCheckAuthUseCase) {
    when(mockCheckAuthUseCase.call())
        .thenAnswer((_) async => AuthTestHelpers.createFailureResult());
  }

  /// Setup mock forgot password use case to return success
  static void setupMockForgotPasswordSuccess(MockForgotPasswordUseCase mockForgotPasswordUseCase) {
    when(mockForgotPasswordUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createVoidSuccessResult());
  }

  /// Setup mock forgot password use case to return failure
  static void setupMockForgotPasswordFailure(MockForgotPasswordUseCase mockForgotPasswordUseCase) {
    when(mockForgotPasswordUseCase.call(any))
        .thenAnswer((_) async => AuthTestHelpers.createVoidFailureResult());
  }
}