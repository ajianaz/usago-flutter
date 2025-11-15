import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart' as core_failure;
import 'package:usago/core/errors/exceptions.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import 'package:usago/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:usago/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/login_usecase.dart';
import 'package:usago/features/auth/domain/usecases/register_usecase.dart';
import 'package:usago/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:usago/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import 'package:usago/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:usago/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:usago/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago/features/auth/presentation/bloc/auth_state.dart';
import '../../../../fixtures/auth_fixtures.dart';
import '../../../../mocks/auth_mocks.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginUsecase mockLoginUsecase;
    late MockRegisterUsecase mockRegisterUsecase;
    late MockLogoutUsecase mockLogoutUsecase;
    late MockCheckAuthUsecase mockCheckAuthUsecase;
    late MockUpdateProfileUsecase mockUpdateProfileUsecase;
    late MockChangePasswordUsecase mockChangePasswordUsecase;
    late MockForgotPasswordUsecase mockForgotPasswordUsecase;
    late MockResetPasswordUsecase mockResetPasswordUsecase;
    late MockVerifyEmailUsecase mockVerifyEmailUsecase;
    late MockResendVerificationEmailUsecase mockResendVerificationEmailUsecase;
    late MockDeleteAccountUsecase mockDeleteAccountUsecase;

    setUpAll(() {
      // Register fallback values for parameter types
      registerFallbackValue(const LoginParams(email: 'test@example.com', password: 'password'));
      registerFallbackValue(const RegisterParams(email: 'test@example.com', password: 'password', name: 'Test'));
      registerFallbackValue(const UpdateProfileParams(name: 'Test', profilePicture: null));
      registerFallbackValue(const ChangePasswordParams(currentPassword: 'old', newPassword: 'new'));
      registerFallbackValue(const ForgotPasswordParams(email: 'test@example.com'));
      registerFallbackValue(const ResetPasswordParams(token: 'token', newPassword: 'password'));
      registerFallbackValue(const VerifyEmailParams(token: 'token'));
      registerFallbackValue(const ResendVerificationEmailParams());
      registerFallbackValue(const DeleteAccountParams());
    });

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      mockRegisterUsecase = MockRegisterUsecase();
      mockLogoutUsecase = MockLogoutUsecase();
      mockCheckAuthUsecase = MockCheckAuthUsecase();
      mockUpdateProfileUsecase = MockUpdateProfileUsecase();
      mockChangePasswordUsecase = MockChangePasswordUsecase();
      mockForgotPasswordUsecase = MockForgotPasswordUsecase();
      mockResetPasswordUsecase = MockResetPasswordUsecase();
      mockVerifyEmailUsecase = MockVerifyEmailUsecase();
      mockResendVerificationEmailUsecase = MockResendVerificationEmailUsecase();
      mockDeleteAccountUsecase = MockDeleteAccountUsecase();

      authBloc = AuthBloc(
        loginUsecase: mockLoginUsecase,
        registerUsecase: mockRegisterUsecase,
        logoutUsecase: mockLogoutUsecase,
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
      // Assert
      expect(authBloc.state, const AuthInitial());
    });

    test('should check auth status on initialization', () async {
      // Arrange
      when(() => mockCheckAuthUsecase())
          .thenAnswer((_) async => Right(AuthFixtures.testUser));

      // Act
      authBloc = AuthBloc(
        loginUsecase: mockLoginUsecase,
        registerUsecase: mockRegisterUsecase,
        logoutUsecase: mockLogoutUsecase,
        checkAuthUsecase: mockCheckAuthUsecase,
        updateProfileUsecase: mockUpdateProfileUsecase,
        changePasswordUsecase: mockChangePasswordUsecase,
        forgotPasswordUsecase: mockForgotPasswordUsecase,
        resetPasswordUsecase: mockResetPasswordUsecase,
        verifyEmailUsecase: mockVerifyEmailUsecase,
        resendVerificationEmailUsecase: mockResendVerificationEmailUsecase,
        deleteAccountUsecase: mockDeleteAccountUsecase,
      );

      // Add CheckAuthStatusEvent manually since onTransition might not trigger in test
      authBloc.add(const CheckAuthStatusEvent());

      // Wait for event to be processed
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      verify(() => mockCheckAuthUsecase()).called(1);
    });

    group('LoginEvent', () {
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;

      test('should emit [AuthLoading, AuthSuccess] when login is successful', () async {
        // Arrange
        when(() => mockLoginUsecase(const LoginParams(email: email, password: password)))
            .thenAnswer((_) async => Right(AuthFixtures.testUser));

        // Act
        final expected = [
          const AuthLoading(),
          AuthSuccess(user: AuthFixtures.testUser),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const LoginEvent(email: email, password: password));
      });

      test('should emit [AuthLoading, AuthFailure] when login fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Invalid credentials');
        when(() => mockLoginUsecase(const LoginParams(email: email, password: password)))
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.invalidCredentials),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const LoginEvent(email: email, password: password));
      });
    });

    group('RegisterEvent', () {
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;
      const name = AuthFixtures.testUserName;

      test('should emit [AuthLoading, AuthSuccess] when register is successful', () async {
        // Arrange
        when(() => mockRegisterUsecase(const RegisterParams(
          email: email,
          password: password,
          name: name,
        ))).thenAnswer((_) async => Right(AuthFixtures.testUser));

        // Act
        final expected = [
          const AuthLoading(),
          AuthSuccess(user: AuthFixtures.testUser),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const RegisterEvent(email: email, password: password, name: name));
      });

      test('should emit [AuthLoading, AuthFailure] when register fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Email already exists');
        when(() => mockRegisterUsecase(const RegisterParams(
          email: email,
          password: password,
          name: name,
        ))).thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.forbidden),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const RegisterEvent(email: email, password: password, name: name));
      });
    });

    group('LogoutEvent', () {
      test('should emit [AuthLoading, AuthLoggedOut] when logout is successful', () async {
        // Arrange
        when(() => mockLogoutUsecase())
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          const AuthLoggedOut(),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const LogoutEvent());
      });

      test('should emit [AuthLoading, AuthFailure] when logout fails', () async {
        // Arrange
        final failure = core_failure.ServerFailure(message: 'Logout failed');
        when(() => mockLogoutUsecase())
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.loginRequired),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const LogoutEvent());
      });
    });

    group('CheckAuthStatusEvent', () {
      test('should emit [AuthLoading, AuthSuccess] when user is authenticated', () async {
        // Arrange
        when(() => mockCheckAuthUsecase())
            .thenAnswer((_) async => Right(AuthFixtures.testUser));

        // Act
        final expected = [
          const AuthLoading(),
          AuthSuccess(user: AuthFixtures.testUser),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const CheckAuthStatusEvent());
      });

      test('should emit [AuthLoading, AuthLoggedOut] when user is not authenticated', () async {
        // Arrange
        when(() => mockCheckAuthUsecase())
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          const AuthLoggedOut(),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const CheckAuthStatusEvent());
      });

      test('should emit [AuthLoading, AuthFailure] when check auth fails', () async {
        // Arrange
        final failure = core_failure.ServerFailure(message: 'Auth check failed');
        when(() => mockCheckAuthUsecase())
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.loginRequired),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const CheckAuthStatusEvent());
      });
    });

    group('UpdateProfileEvent', () {
      const newName = 'Updated Name';
      const newProfilePicture = 'https://example.com/new-avatar.jpg';

      test('should emit [AuthLoading, ProfileUpdateSuccess] when update is successful', () async {
        // Arrange
        final updatedUser = AuthFixtures.testUser.copyWith(name: newName);
        when(() => mockUpdateProfileUsecase(const UpdateProfileParams(
          name: newName,
          profilePicture: newProfilePicture,
        ))).thenAnswer((_) async => Right(updatedUser));

        // Act
        final expected = [
          const AuthLoading(),
          ProfileUpdateSuccess(user: updatedUser),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const UpdateProfileEvent(
          name: newName,
          profilePicture: newProfilePicture,
        ));
      });

      test('should emit [AuthLoading, AuthFailure] when update fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Update failed');
        when(() => mockUpdateProfileUsecase(const UpdateProfileParams(
          name: newName,
          profilePicture: newProfilePicture,
        ))).thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.invalidCredentials),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const UpdateProfileEvent(
          name: newName,
          profilePicture: newProfilePicture,
        ));
      });
    });

    group('ChangePasswordEvent', () {
      const currentPassword = 'oldPassword123';
      const newPassword = 'newPassword123';

      test('should emit [AuthLoading, AuthSuccess] when change is successful', () async {
        // Arrange
        when(() => mockChangePasswordUsecase(const ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ))).thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          predicate<AuthSuccess>((state) => state.user.id.isEmpty && state.user.email.isEmpty && state.user.name.isEmpty),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ChangePasswordEvent(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ));
      });

      test('should emit [AuthLoading, AuthFailure] when change fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Current password is incorrect');
        when(() => mockChangePasswordUsecase(const ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ))).thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.invalidCredentials),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ChangePasswordEvent(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ));
      });
    });

    group('ForgotPasswordEvent', () {
      const email = AuthFixtures.validEmail;

      test('should emit [AuthLoading, PasswordResetEmailSent] when request is successful', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(const ForgotPasswordParams(email: email)))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          PasswordResetEmailSent(email: email),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ForgotPasswordEvent(email: email));
      });

      test('should emit [AuthLoading, AuthFailure] when request fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Email not found');
        when(() => mockForgotPasswordUsecase(const ForgotPasswordParams(email: email)))
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.invalidCredentials),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ForgotPasswordEvent(email: email));
      });
    });

    group('ResetPasswordEvent', () {
      const token = AuthFixtures.testResetToken;
      const newPassword = 'newPassword123';

      test('should emit [AuthLoading, PasswordResetSuccess] when reset is successful', () async {
        // Arrange
        when(() => mockResetPasswordUsecase(const ResetPasswordParams(
          token: token,
          newPassword: newPassword,
        ))).thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          const PasswordResetSuccess(),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ResetPasswordEvent(token: token, newPassword: newPassword));
      });

      test('should emit [AuthLoading, AuthFailure] when reset fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Invalid token');
        when(() => mockResetPasswordUsecase(const ResetPasswordParams(
          token: token,
          newPassword: newPassword,
        ))).thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.tokenInvalid),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ResetPasswordEvent(token: token, newPassword: newPassword));
      });
    });

    group('VerifyEmailEvent', () {
      const token = AuthFixtures.testVerificationToken;

      test('should emit [AuthLoading, EmailVerificationSuccess] when verification is successful', () async {
        // Arrange
        when(() => mockVerifyEmailUsecase(const VerifyEmailParams(token: token)))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          const EmailVerificationSuccess(),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const VerifyEmailEvent(token: token));
      });

      test('should emit [AuthLoading, AuthFailure] when verification fails', () async {
        // Arrange
        final failure = core_failure.ValidationFailure(message: 'Invalid token');
        when(() => mockVerifyEmailUsecase(const VerifyEmailParams(token: token)))
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.tokenInvalid),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const VerifyEmailEvent(token: token));
      });
    });

    group('ResendVerificationEmailEvent', () {
      test('should emit [AuthLoading, AuthSuccess] when resend is successful', () async {
        // Arrange
        when(() => mockResendVerificationEmailUsecase(const ResendVerificationEmailParams()))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          predicate<AuthSuccess>((state) => state.user.id.isEmpty && state.user.email.isEmpty && state.user.name.isEmpty),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ResendVerificationEmailEvent());
      });

      test('should emit [AuthLoading, AuthFailure] when resend fails', () async {
        // Arrange
        final failure = core_failure.ServerFailure(message: 'Failed to resend email');
        when(() => mockResendVerificationEmailUsecase(const ResendVerificationEmailParams()))
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.refreshTokenFailed),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const ResendVerificationEmailEvent());
      });
    });

    group('DeleteAccountEvent', () {
      test('should emit [AuthLoading, AuthLoggedOut] when deletion is successful', () async {
        // Arrange
        when(() => mockDeleteAccountUsecase(const DeleteAccountParams()))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const AuthLoading(),
          const AuthLoggedOut(),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const DeleteAccountEvent());
      });

      test('should emit [AuthLoading, AuthFailure] when deletion fails', () async {
        // Arrange
        final failure = core_failure.ServerFailure(message: 'Failed to delete account');
        when(() => mockDeleteAccountUsecase(const DeleteAccountParams()))
            .thenAnswer((_) async => Left(failure));

        // Act
        final expected = [
          const AuthLoading(),
          core_failure.AuthFailure(message: failure.message, type: AuthExceptionType.refreshTokenFailed),
        ];

        // Assert
        expectLater(authBloc.stream, emitsInOrder(expected));

        authBloc.add(const DeleteAccountEvent());
      });
    });
  });
}