import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../domain/usecases/resend_verification_email_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../core/blocs/base_bloc.dart';
import '../../../../core/errors/failure.dart' as core_failure;

/// Authentication BLoC
/// Handles all authentication state management
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUsecase;
  final RegisterUseCase _registerUsecase;
  final LogoutUseCase _logoutUsecase;
  final CheckAuthUsecase _checkAuthUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final VerifyEmailUsecase _verifyEmailUsecase;
  final ResendVerificationEmailUsecase _resendVerificationEmailUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;

  AuthBloc({
    required LoginUseCase loginUsecase,
    required RegisterUseCase registerUsecase,
    required LogoutUseCase logoutUsecase,
    required CheckAuthUsecase checkAuthUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required ChangePasswordUsecase changePasswordUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required VerifyEmailUsecase verifyEmailUsecase,
    required ResendVerificationEmailUsecase resendVerificationEmailUsecase,
    required DeleteAccountUsecase deleteAccountUsecase,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _checkAuthUsecase = checkAuthUsecase,
        _updateProfileUsecase = updateProfileUsecase,
        _changePasswordUsecase = changePasswordUsecase,
        _forgotPasswordUsecase = forgotPasswordUsecase,
        _resetPasswordUsecase = resetPasswordUsecase,
        _verifyEmailUsecase = verifyEmailUsecase,
        _resendVerificationEmailUsecase = resendVerificationEmailUsecase,
        _deleteAccountUsecase = deleteAccountUsecase,
        super(initialState: const AuthInitial()) {
    // Register event handlers
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<VerifyEmailEvent>(_onVerifyEmailEvent);
    on<ResendVerificationEmailEvent>(_onResendVerificationEmailEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    // Check auth status when BLoC is first created
    if (transition.currentState == const AuthInitial() &&
        transition.nextState is! AuthLoading) {
      add(CheckAuthStatusEvent());
    }
    super.onTransition(transition);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    await executeUseCase<User, LoginParams>(
      _loginUsecase.call,
      LoginParams(email: event.email, password: event.password),
      loadingMessage: 'Logging in...',
      successMessage: 'Login successful',
      eventName: 'login_operation',
      metadata: {'email': event.email},
    );
  }

  Future<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    await executeUseCase<User, RegisterParams>(
      _registerUsecase.call,
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
      loadingMessage: 'Registering...',
      successMessage: 'Registration successful',
      eventName: 'register_operation',
      metadata: {
        'email': event.email,
        'name': event.name,
      },
    );
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase(
      (_) => _logoutUsecase.call(),
      null,
      loadingMessage: 'Logging out...',
      successMessage: 'Logout successful',
      eventName: 'logout_operation',
    );
  }

  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    await executeUseCase<User?, void>(
      (_) => _checkAuthUsecase.call(),
      null,
      loadingMessage: 'Checking auth status...',
      eventName: 'check_auth_operation',
    );
  }

  Future<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<AuthState> emit) async {
    await executeUseCase<User, UpdateProfileParams>(
      _updateProfileUsecase.call,
      UpdateProfileParams(
          name: event.name, profilePicture: event.profilePicture),
      loadingMessage: 'Updating profile...',
      successMessage: 'Profile updated successfully',
      eventName: 'update_profile_operation',
    );
  }

  Future<void> _onChangePasswordEvent(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<ChangePasswordParams>(
      _changePasswordUsecase.call,
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
      loadingMessage: 'Changing password...',
      successMessage: 'Password changed successfully',
      eventName: 'change_password_operation',
    );
  }

  Future<void> _onForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<ForgotPasswordParams>(
      _forgotPasswordUsecase.call,
      ForgotPasswordParams(email: event.email),
      loadingMessage: 'Sending password reset email...',
      successMessage: 'Password reset email sent',
      eventName: 'forgot_password_operation',
      metadata: {'email': event.email},
    );
  }

  Future<void> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<ResetPasswordParams>(
      _resetPasswordUsecase.call,
      ResetPasswordParams(
        token: event.token,
        newPassword: event.newPassword,
      ),
      loadingMessage: 'Resetting password...',
      successMessage: 'Password reset successful',
      eventName: 'reset_password_operation',
    );
  }

  Future<void> _onVerifyEmailEvent(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<VerifyEmailParams>(
      _verifyEmailUsecase.call,
      VerifyEmailParams(token: event.token),
      loadingMessage: 'Verifying email...',
      successMessage: 'Email verified successfully',
      eventName: 'verify_email_operation',
    );
  }

  Future<void> _onResendVerificationEmailEvent(
      ResendVerificationEmailEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<ResendVerificationEmailParams>(
      _resendVerificationEmailUsecase.call,
      const ResendVerificationEmailParams(),
      loadingMessage: 'Resending verification email...',
      successMessage: 'Verification email resent',
      eventName: 'resend_verification_operation',
    );
  }

  Future<void> _onDeleteAccountEvent(
      DeleteAccountEvent event, Emitter<AuthState> emit) async {
    await executeVoidUseCase<DeleteAccountParams>(
      _deleteAccountUsecase.call,
      const DeleteAccountParams(),
      loadingMessage: 'Deleting account...',
      successMessage: 'Account deleted successfully',
      eventName: 'delete_account_operation',
    );
  }

  @override
  AuthState _createLoadingState(String? message, Map<String, dynamic>? metadata) {
    return const AuthLoading();
  }

  @override
  AuthState _createSuccessState<T>(
      T? data, String? message, Map<String, dynamic>? metadata) {
    if (data is User) {
      return AuthSuccess(user: data);
    }
    // For void operations or non-User data, return appropriate success states
    // based on the operation metadata or context
    if (metadata != null) {
      final eventName = metadata['eventName'] as String?;
      switch (eventName) {
        case 'reset_password_operation':
          return const PasswordResetSuccess();
        case 'verify_email_operation':
          return const EmailVerificationSuccess();
        case 'update_profile_operation':
          if (data is User) {
            return ProfileUpdateSuccess(user: data);
          }
          break;
      }
    }
    // Default success state for auth operations
    return const AuthLoggedOut();
  }

  @override
  AuthState _createErrorState(
      core_failure.Failure failure, Map<String, dynamic>? metadata) {
    return AuthFailure(message: failure.message);
  }

  @override
  void _cleanup() {
    // Clean up resources if needed
  }
}
