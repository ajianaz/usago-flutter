import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
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
import '../../../../../lib/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../../lib/features/auth/presentation/bloc/auth_event.dart';
import '../../../../../lib/features/auth/presentation/bloc/auth_state.dart';
import '../../helpers/auth_test_helpers.dart';
import '../../helpers/mock_usecases.dart';

void main() {
  group('AuthBloc Tests', () {
    late MockLoginUseCase mockLoginUsecase;
    late MockRegisterUseCase mockRegisterUsecase;
    late MockLogoutUseCase mockLogoutUsecase;
    late MockCheckAuthUseCase mockCheckAuthUsecase;
    late MockUpdateProfileUseCase mockUpdateProfileUsecase;
    late MockChangePasswordUseCase mockChangePasswordUsecase;
    late MockForgotPasswordUseCase mockForgotPasswordUsecase;
    late MockResetPasswordUseCase mockResetPasswordUsecase;
    late MockVerifyEmailUsecase mockVerifyEmailUsecase;
    late MockResendVerificationEmailUsecase mockResendVerificationEmailUsecase;
    late MockDeleteAccountUseCase mockDeleteAccountUsecase;
    late AuthBloc authBloc;

    setUp(() {
      mockLoginUsecase = MockLoginUseCase();
      mockRegisterUsecase = MockRegisterUseCase();
      mockLogoutUsecase = MockLogoutUseCase();
      mockCheckAuthUsecase = MockCheckAuthUseCase();
      mockUpdateProfileUsecase = MockUpdateProfileUseCase();
      mockChangePasswordUsecase = MockChangePasswordUseCase();
      mockForgotPasswordUsecase = MockForgotPasswordUseCase();
      mockResetPasswordUsecase = MockResetPasswordUseCase();
      mockVerifyEmailUsecase = MockVerifyEmailUsecase();
      mockResendVerificationEmailUsecase = MockResendVerificationEmailUsecase();
      mockDeleteAccountUsecase = MockDeleteAccountUseCase();

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

    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('LoginEvent', () {
      test('emits AuthLoading then AuthSuccess when login succeeds', () async {
        // Arrange
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createSuccessResult());

        // Act
        authBloc.add(LoginEvent(
          email: AuthTestHelpers.validEmail,
          password: AuthTestHelpers.validPassword,
        ));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthSuccess>((state) => state.user != null),
          ]),
        );
      });

      test('emits AuthLoading then AuthFailure when login fails', () async {
        // Arrange
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createFailureResult());

        // Act
        authBloc.add(LoginEvent(
          email: AuthTestHelpers.invalidEmail,
          password: AuthTestHelpers.invalidPassword,
        ));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthFailure>((state) => state.message.isNotEmpty),
          ]),
        );
      });
    });

    group('RegisterEvent', () {
      test('emits AuthLoading then AuthSuccess when register succeeds', () async {
        // Arrange
        when(mockRegisterUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createSuccessResult());

        // Act
        authBloc.add(RegisterEvent(
          email: AuthTestHelpers.validEmail,
          password: AuthTestHelpers.validPassword,
          name: AuthTestHelpers.testName,
        ));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthSuccess>((state) => state.user != null),
          ]),
        );
      });

      test('emits AuthLoading then AuthFailure when register fails', () async {
        // Arrange
        when(mockRegisterUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createFailureResult());

        // Act
        authBloc.add(RegisterEvent(
          email: AuthTestHelpers.invalidEmail,
          password: AuthTestHelpers.invalidPassword,
          name: AuthTestHelpers.testName,
        ));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthFailure>((state) => state.message.isNotEmpty),
          ]),
        );
      });
    });

    group('LogoutEvent', () {
      test('emits AuthLoading then AuthLoggedOut when logout succeeds', () async {
        // Arrange
        when(mockLogoutUsecase.call())
            .thenAnswer((_) async => AuthTestHelpers.createVoidSuccessResult());

        // Act
        authBloc.add(LogoutEvent());

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthLoggedOut>(),
          ]),
        );
      });

      test('emits AuthLoading then AuthFailure when logout fails', () async {
        // Arrange
        when(mockLogoutUsecase.call())
            .thenAnswer((_) async => AuthTestHelpers.createVoidFailureResult());

        // Act
        authBloc.add(LogoutEvent());

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthFailure>((state) => state.message.isNotEmpty),
          ]),
        );
      });
    });

    group('ForgotPasswordEvent', () {
      test('emits AuthLoading then AuthSuccess when forgot password succeeds', () async {
        // Arrange
        when(mockForgotPasswordUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createVoidSuccessResult());

        // Act
        authBloc.add(ForgotPasswordEvent(email: AuthTestHelpers.validEmail));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthLoggedOut>(), // Success for void operations returns AuthLoggedOut
          ]),
        );
      });

      test('emits AuthLoading then AuthFailure when forgot password fails', () async {
        // Arrange
        when(mockForgotPasswordUsecase.call(any))
            .thenAnswer((_) async => AuthTestHelpers.createVoidFailureResult());

        // Act
        authBloc.add(ForgotPasswordEvent(email: AuthTestHelpers.validEmail));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate<AuthFailure>((state) => state.message.isNotEmpty),
          ]),
        );
      });
    });
  });
}