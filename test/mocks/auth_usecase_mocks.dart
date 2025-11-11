import 'package:mocktail/mocktail.dart';
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