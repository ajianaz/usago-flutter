import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../lib/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../../lib/features/auth/presentation/bloc/auth_event.dart';
import '../../../../../lib/features/auth/presentation/bloc/auth_state.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/features/auth/domain/usecases/login_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/register_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/logout_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/update_profile_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/change_password_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/reset_password_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/verify_email_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../../../../lib/features/auth/domain/usecases/delete_account_usecase.dart';
import '../../../../../lib/core/errors/failure.dart';

import '../../helpers/auth_test_helpers.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/mocks.dart';

// Generate mocks
@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  CheckAuthUsecase,
  UpdateProfileUsecase,
  ChangePasswordUsecase,
  ForgotPasswordUsecase,
  ResetPasswordUsecase,
  VerifyEmailUsecase,
  ResendVerificationEmailUsecase,
  DeleteAccountUsecase,
])
import 'auth_bloc_test.mocks.dart';

void main() {
  group('AuthBloc', () {
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockCheckAuthUsecase mockCheckAuthUsecase;
    late MockUpdateProfileUsecase mockUpdateProfileUsecase;
    late MockChangePasswordUsecase mockChangePasswordUsecase;
    late MockForgotPasswordUsecase mockForgotPasswordUsecase;
    late MockResetPasswordUsecase mockResetPasswordUsecase;
    late MockVerifyEmailUsecase mockVerifyEmailUsecase;
    late MockResendVerificationEmailUsecase mockResendVerificationEmailUsecase;
    late MockDeleteAccountUsecase mockDeleteAccountUsecase;

    late AuthBloc authBloc;
    late User testUser;

    setUp(() {
      // Initialize mocks
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockCheckAuthUsecase = MockCheckAuthUsecase();
      mockUpdateProfileUsecase = MockUpdateProfileUsecase();
      mockChangePasswordUsecase = MockChangePasswordUsecase();
      mockForgotPasswordUsecase = MockForgotPasswordUsecase();
      mockResetPasswordUsecase = MockResetPasswordUsecase();
      mockVerifyEmailUsecase = MockVerifyEmailUsecase();
      mockResendVerificationEmailUsecase = MockResendVerificationEmailUsecase();
      mockDeleteAccountUsecase = MockDeleteAccountUsecase();

      // Create test user
      testUser = AuthTestHelpers.createTestUser();

      // Create AuthBloc
      authBloc = AuthBloc(
        loginUsecase: mockLoginUseCase,
        registerUsecase: mockRegisterUseCase,
        logoutUsecase: mockLogoutUseCase,
        checkAuthUsecase: mockCheckAuthUsecase,
        updateProfileUsecase: mockUpdateProfileUsecase,
        changePasswordUsecase: mockChangePasswordUsecase,
        forgotPasswordUsecase: mockForgotPasswordUsecase,
        resetPasswordUsecase: mockResetPasswordUsecase,
        verifyEmailUsecase: mockVerifyEmailUsecase,
        resendVerificationEmailUsecase: mockResendVerificationEmailUsecase,
        deleteAccountUsecase: mockDeleteAccountUsecase,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('LoginEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          LoginEvent(
            email: AuthTestConstants.testUserEmail,
            password: AuthTestConstants.testUserPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          AuthSuccess(user: testUser),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupLoginSuccess(mockLoginUseCase, testUser);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          LoginEvent(
            email: AuthTestConstants.invalidEmail,
            password: AuthTestConstants.testUserPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.invalidCredentialsMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupLoginFailure(
            mockLoginUseCase,
            const AuthFailure(message: AuthTestConstants.invalidCredentialsMessage),
          );
        },
      );

      blocTest<AuthBloc, AuthState>(
        'handles empty email and password',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: '',
            password: '',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.validationErrorMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupLoginFailure(
            mockLoginUseCase,
            const ValidationFailure(message: AuthTestConstants.validationErrorMessage),
          );
        },
      );
    });

    group('RegisterEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when register succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          RegisterEvent(
            name: AuthTestConstants.testUserName,
            email: AuthTestConstants.testUserEmail,
            password: AuthTestConstants.testUserPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          AuthSuccess(user: testUser),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupRegisterSuccess(mockRegisterUseCase, testUser);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when register fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          RegisterEvent(
            name: AuthTestConstants.testUserName,
            email: AuthTestConstants.testUserEmail,
            password: AuthTestConstants.weakPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.weakPasswordMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupRegisterFailure(
            mockRegisterUseCase,
            const ValidationFailure(message: AuthTestConstants.weakPasswordMessage),
          );
        },
      );
    });

    group('LogoutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when logout succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(const LogoutEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupLogoutSuccess(mockLogoutUseCase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when logout fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const LogoutEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.networkErrorMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupLogoutFailure(
            mockLogoutUseCase,
            const NetworkFailure(message: AuthTestConstants.networkErrorMessage),
          );
        },
      );
    });

    group('CheckAuthStatusEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when user is authenticated',
        build: () => authBloc,
        act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
        expect: () => [
          const AuthLoading(),
          AuthSuccess(user: testUser),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupCheckAuthSuccess(mockCheckAuthUsecase, testUser);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when user is not authenticated',
        build: () => authBloc,
        act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupCheckAuthSuccess(mockCheckAuthUsecase, null);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when check auth fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const CheckAuthStatusEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.networkErrorMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupCheckAuthFailure(
            mockCheckAuthUsecase,
            const NetworkFailure(message: AuthTestConstants.networkErrorMessage),
          );
        },
      );
    });

    group('UpdateProfileEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, ProfileUpdateSuccess] when update succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          UpdateProfileEvent(
            name: AuthTestConstants.testUserName,
            profilePicture: AuthTestConstants.testUserProfilePicture,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          ProfileUpdateSuccess(user: testUser),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupUpdateProfileSuccess(mockUpdateProfileUsecase, testUser);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when update fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const UpdateProfileEvent(
            name: '',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.validationErrorMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupUpdateProfileFailure(
            mockUpdateProfileUsecase,
            const ValidationFailure(message: AuthTestConstants.validationErrorMessage),
          );
        },
      );
    });

    group('ChangePasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when change password succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ChangePasswordEvent(
            currentPassword: AuthTestConstants.testUserPassword,
            newPassword: AuthTestConstants.validPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupChangePasswordSuccess(mockChangePasswordUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when change password fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ChangePasswordEvent(
            currentPassword: 'wrong-password',
            newPassword: AuthTestConstants.validPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.currentPasswordIncorrectMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupChangePasswordFailure(
            mockChangePasswordUsecase,
            const AuthFailure(message: AuthTestConstants.currentPasswordIncorrectMessage),
          );
        },
      );
    });

    group('ForgotPasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when forgot password succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ForgotPasswordEvent(email: AuthTestConstants.testUserEmail),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupForgotPasswordSuccess(mockForgotPasswordUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when forgot password fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ForgotPasswordEvent(email: AuthTestConstants.invalidEmail),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.userNotFoundMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupForgotPasswordFailure(
            mockForgotPasswordUsecase,
            const AuthFailure(message: AuthTestConstants.userNotFoundMessage),
          );
        },
      );
    });

    group('ResetPasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, PasswordResetSuccess] when reset password succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ResetPasswordEvent(
            token: AuthTestConstants.testAccessToken,
            newPassword: AuthTestConstants.validPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const PasswordResetSuccess(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupResetPasswordSuccess(mockResetPasswordUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when reset password fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          ResetPasswordEvent(
            token: AuthTestConstants.expiredToken,
            newPassword: AuthTestConstants.validPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.passwordResetTokenExpiredMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupResetPasswordFailure(
            mockResetPasswordUsecase,
            const AuthFailure(message: AuthTestConstants.passwordResetTokenExpiredMessage),
          );
        },
      );
    });

    group('VerifyEmailEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, EmailVerificationSuccess] when verify email succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          VerifyEmailEvent(token: AuthTestConstants.testAccessToken),
        ),
        expect: () => [
          const AuthLoading(),
          const EmailVerificationSuccess(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupVerifyEmailSuccess(mockVerifyEmailUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when verify email fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          VerifyEmailEvent(token: AuthTestConstants.invalidToken),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.invalidTokenMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupVerifyEmailFailure(
            mockVerifyEmailUsecase,
            const AuthFailure(message: AuthTestConstants.invalidTokenMessage),
          );
        },
      );
    });

    group('ResendVerificationEmailEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when resend verification email succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(const ResendVerificationEmailEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupResendVerificationEmailSuccess(mockResendVerificationEmailUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when resend verification email fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const ResendVerificationEmailEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.rateLimitMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupResendVerificationEmailFailure(
            mockResendVerificationEmailUsecase,
            const NetworkFailure(message: AuthTestConstants.rateLimitMessage),
          );
        },
      );
    });

    group('DeleteAccountEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when delete account succeeds',
        build: () => authBloc,
        act: (bloc) => bloc.add(const DeleteAccountEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupDeleteAccountSuccess(mockDeleteAccountUsecase);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when delete account fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const DeleteAccountEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure(message: AuthTestConstants.forbiddenMessage),
        ],
        verify: (bloc) {
          MockSetupHelpers.setupDeleteAccountFailure(
            mockDeleteAccountUsecase,
            const ServerFailure(
              message: AuthTestConstants.forbiddenMessage,
              statusCode: 403,
            ),
          );
        },
      );
    });
  });
}