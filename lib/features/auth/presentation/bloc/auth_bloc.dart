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
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/create_refresh_token_usecase.dart';
import '../../domain/usecases/get_refresh_tokens_usecase.dart';
import '../../domain/usecases/revoke_token_usecase.dart';
import '../../domain/usecases/revoke_all_tokens_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
/// Handles all authentication state management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final CheckAuthUsecase _checkAuthUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final VerifyEmailUsecase _verifyEmailUsecase;
  final ResendVerificationEmailUsecase _resendVerificationEmailUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final CreateRefreshTokenUsecase _createRefreshTokenUsecase;
  final GetRefreshTokensUsecase _getRefreshTokensUsecase;
  final RevokeTokenUsecase _revokeTokenUsecase;
  final RevokeAllTokensUsecase _revokeAllTokensUsecase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required CheckAuthUsecase checkAuthUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required ChangePasswordUsecase changePasswordUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required VerifyEmailUsecase verifyEmailUsecase,
    required ResendVerificationEmailUsecase resendVerificationEmailUsecase,
    required DeleteAccountUsecase deleteAccountUsecase,
    required RefreshTokenUsecase refreshTokenUsecase,
    required CreateRefreshTokenUsecase createRefreshTokenUsecase,
    required GetRefreshTokensUsecase getRefreshTokensUsecase,
    required RevokeTokenUsecase revokeTokenUsecase,
    required RevokeAllTokensUsecase revokeAllTokensUsecase,
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
        _refreshTokenUsecase = refreshTokenUsecase,
        _createRefreshTokenUsecase = createRefreshTokenUsecase,
        _getRefreshTokensUsecase = getRefreshTokensUsecase,
        _revokeTokenUsecase = revokeTokenUsecase,
        _revokeAllTokensUsecase = revokeAllTokensUsecase,
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
    on<RefreshTokenEvent>(_onRefreshTokenEvent);
    on<CreateRefreshTokenEvent>(_onCreateRefreshTokenEvent);
    on<GetRefreshTokensEvent>(_onGetRefreshTokensEvent);
    on<RevokeTokenEvent>(_onRevokeTokenEvent);
    on<RevokeAllTokensEvent>(_onRevokeAllTokensEvent);

    // Check auth status on initialization
    add(CheckAuthStatusEvent());
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => AuthSuccess(user: user),
    ));
  }

  Future<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _registerUsecase(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => AuthSuccess(user: user),
    ));
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _logoutUsecase();

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const AuthLoggedOut(),
    ));
  }

  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _checkAuthUsecase();

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) {
        if (user != null) {
          return AuthSuccess(user: user);
        } else {
          return const AuthLoggedOut();
        }
      },
    ));
  }

  Future<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
          name: event.name, profilePicture: event.profilePicture),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => ProfileUpdateSuccess(user: user),
    ));
  }

  Future<void> _onChangePasswordEvent(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _changePasswordUsecase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => AuthSuccess(user: User.empty()), // Return current user
    ));
  }

  Future<void> _onForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result =
        await _forgotPasswordUsecase(ForgotPasswordParams(email: event.email));

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => PasswordResetEmailSent(email: event.email),
    ));
  }

  Future<void> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _resetPasswordUsecase(
      ResetPasswordParams(token: event.token, newPassword: event.newPassword),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => PasswordResetSuccess(),
    ));
  }

  Future<void> _onVerifyEmailEvent(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result =
        await _verifyEmailUsecase(VerifyEmailParams(token: event.token));

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => EmailVerificationSuccess(),
    ));
  }

  Future<void> _onResendVerificationEmailEvent(
      ResendVerificationEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _resendVerificationEmailUsecase(
        const ResendVerificationEmailParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => AuthSuccess(user: User.empty()), // Return current user
    ));
  }

  Future<void> _onDeleteAccountEvent(
      DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _deleteAccountUsecase(const DeleteAccountParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const AuthLoggedOut(),
    ));
  }

  Future<void> _onRefreshTokenEvent(
      RefreshTokenEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _refreshTokenUsecase(const RefreshTokenParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => TokenRefreshSuccess(user: user),
    ));
  }

  Future<void> _onCreateRefreshTokenEvent(
      CreateRefreshTokenEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result =
        await _createRefreshTokenUsecase(const CreateRefreshTokenParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (tokenData) => CreateRefreshTokenSuccess(tokenData: tokenData),
    ));
  }

  Future<void> _onGetRefreshTokensEvent(
      GetRefreshTokensEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result =
        await _getRefreshTokensUsecase(const GetRefreshTokensParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (tokens) => GetRefreshTokensSuccess(tokens: tokens),
    ));
  }

  Future<void> _onRevokeTokenEvent(
      RevokeTokenEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _revokeTokenUsecase(
      RevokeTokenParams(refreshToken: event.refreshToken),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => RevokeTokenSuccess(tokenId: event.refreshToken),
    ));
  }

  Future<void> _onRevokeAllTokensEvent(
      RevokeAllTokensEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _revokeAllTokensUsecase(const RevokeAllTokensParams());

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const RevokeAllTokensSuccess(),
    ));
  }
}
