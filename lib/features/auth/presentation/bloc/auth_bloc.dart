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
import '../../../../core/performance/performance_tracker.dart';
import '../../../../core/config/app_config.dart';

/// Authentication BLoC
/// Handles all authentication state management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginUseCase? _loginUsecase;
  RegisterUseCase? _registerUsecase;
  LogoutUseCase? _logoutUsecase;
  CheckAuthUsecase? _checkAuthUsecase;
  UpdateProfileUsecase? _updateProfileUsecase;
  ChangePasswordUsecase? _changePasswordUsecase;
  ForgotPasswordUsecase? _forgotPasswordUsecase;
  ResetPasswordUsecase? _resetPasswordUsecase;
  VerifyEmailUsecase? _verifyEmailUsecase;
  ResendVerificationEmailUsecase? _resendVerificationEmailUsecase;
  DeleteAccountUsecase? _deleteAccountUsecase;

  // Performance monitoring
  final PerformanceTracker _performanceTracker;
  String? _blocTrackingId;

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
    PerformanceTracker? performanceTracker,
  }) : _loginUsecase = loginUsecase,
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
        _performanceTracker = performanceTracker ?? PerformanceTracker(),
        super(const AuthInitial()) {
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

    // Initialize performance tracking
    _initializePerformanceTracking();
  }

  // Initialize performance tracking
  void _initializePerformanceTracking() {
    if (!AppConfig.enablePerformanceMonitoring) return;

    _blocTrackingId = _performanceTracker.startTracking(
      'AuthBloc',
      category: 'bloc_lifecycle',
    );
  }

  // Check auth status on initialization
  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    // Track performance if enabled
    if (AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.trackTransition(
        'AuthBloc',
        transition.event.runtimeType.toString(),
        transition.currentState.runtimeType.toString(),
        transition.nextState.runtimeType.toString(),
      );
    }

    // Check auth status when BLoC is first created
    if (transition.currentState == const AuthInitial() && transition.nextState is! AuthLoading) {
      add(CheckAuthStatusEvent());
    }
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.trackError(
        'AuthBloc',
        error.toString(),
        stackTrace.toString(),
      );
    }
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    // Stop performance tracking and clean up resources
    if (_blocTrackingId != null && AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.stopTracking(_blocTrackingId!);
    }

    // Clean up event handlers to prevent memory leaks
    _loginUsecase = null;
    _registerUsecase = null;
    _logoutUsecase = null;
    _checkAuthUsecase = null;
    _updateProfileUsecase = null;
    _changePasswordUsecase = null;
    _forgotPasswordUsecase = null;
    _resetPasswordUsecase = null;
    _verifyEmailUsecase = null;
    _resendVerificationEmailUsecase = null;
    _deleteAccountUsecase = null;

    return super.close();
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final trackingId = _performanceTracker.startTracking('login_operation', category: 'auth');

    try {
      final result = await _loginUsecase?.call(
        LoginParams(email: event.email, password: event.password),
      );

      emit(result?.fold(
        (failure) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': false,
            'error': failure.message,
            'email': event.email,
          });
          return AuthFailure(message: failure.message);
        },
        (user) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': true,
            'userId': user.id,
            'email': event.email,
          });
          return AuthSuccess(user: user);
        },
      ) ?? const AuthFailure(message: 'Login service unavailable'));
    } catch (e, stackTrace) {
      _performanceTracker.stopTracking(trackingId, metadata: {
        'success': false,
        'error': e.toString(),
        'email': event.email,
      });

      _performanceTracker.trackError(
        'AuthBloc',
        e.toString(),
        stackTrace.toString(),
      );

      emit(AuthFailure(message: 'An unexpected error occurred during login'));
    }
  }

  Future<void> _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final trackingId = _performanceTracker.startTracking('register_operation', category: 'auth');

    try {
      final result = await _registerUsecase?.call(
        RegisterParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );

      emit(result?.fold(
        (failure) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': false,
            'error': failure.message,
            'email': event.email,
            'name': event.name,
          });
          return AuthFailure(message: failure.message);
        },
        (user) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': true,
            'userId': user.id,
            'email': event.email,
            'name': event.name,
          });
          return AuthSuccess(user: user);
        },
      ) ?? const AuthFailure(message: 'Registration service unavailable'));
    } catch (e, stackTrace) {
      _performanceTracker.stopTracking(trackingId, metadata: {
        'success': false,
        'error': e.toString(),
        'email': event.email,
        'name': event.name,
      });

      _performanceTracker.trackError(
        'AuthBloc',
        e.toString(),
        stackTrace.toString(),
      );

      emit(AuthFailure(message: 'An unexpected error occurred during registration'));
    }
  }

  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _logoutUsecase?.call();

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const AuthLoggedOut(),
    ) ?? const AuthFailure(message: 'Logout service unavailable'));
  }

  Future<void> _onCheckAuthStatusEvent(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _checkAuthUsecase?.call();

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) {
        if (user != null) {
          return AuthSuccess(user: user);
        } else {
          return const AuthLoggedOut();
        }
      },
    ) ?? const AuthFailure(message: 'Auth check service unavailable'));
  }

  Future<void> _onUpdateProfileEvent(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _updateProfileUsecase?.call(
      UpdateProfileParams(name: event.name, profilePicture: event.profilePicture),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => ProfileUpdateSuccess(user: user),
    ) ?? const AuthFailure(message: 'Profile update service unavailable'));
  }

  Future<void> _onChangePasswordEvent(ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _changePasswordUsecase?.call(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => AuthSuccess(user: User.empty()),
    ) ?? const AuthFailure(message: 'Change password service unavailable'));
  }

  Future<void> _onForgotPasswordEvent(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _forgotPasswordUsecase?.call(
      ForgotPasswordParams(email: event.email),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => PasswordResetEmailSent(email: event.email),
    ) ?? const AuthFailure(message: 'Forgot password service unavailable'));
  }

  Future<void> _onResetPasswordEvent(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _resetPasswordUsecase?.call(
      ResetPasswordParams(
        token: event.token,
        newPassword: event.newPassword,
      ),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const PasswordResetSuccess(),
    ) ?? const AuthFailure(message: 'Reset password service unavailable'));
  }

  Future<void> _onVerifyEmailEvent(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _verifyEmailUsecase?.call(
      VerifyEmailParams(token: event.token),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const EmailVerificationSuccess(),
    ) ?? const AuthFailure(message: 'Verify email service unavailable'));
  }

  Future<void> _onResendVerificationEmailEvent(ResendVerificationEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _resendVerificationEmailUsecase?.call(
      const ResendVerificationEmailParams(),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => AuthSuccess(user: User.empty()),
    ) ?? const AuthFailure(message: 'Resend verification email service unavailable'));
  }

  Future<void> _onDeleteAccountEvent(DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _deleteAccountUsecase?.call(
      const DeleteAccountParams(),
    );

    emit(result?.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const AuthLoggedOut(),
    ) ?? const AuthFailure(message: 'Delete account service unavailable'));
  }
}