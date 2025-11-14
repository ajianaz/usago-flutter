import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
/// Handles all authentication state management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final CheckAuthUsecase _checkAuthUsecase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required CheckAuthUsecase checkAuthUsecase,
  }) : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _checkAuthUsecase = checkAuthUsecase,
        super(const AuthInitial()) {
    // Register event handlers
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  // Check auth status on initialization
  @override
  void onTransition(Transition<AuthState> transition) {
    // Check auth status when BLoC is first created
    if (transition.from == const AuthInitial() && transition.to is! AuthLoading) {
      add(CheckAuthStatusEvent());
    }
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

  Future<void> _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
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

  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _logoutUsecase();

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (_) => const AuthLoggedOut(),
    ));
  }

  Future<void> _onCheckAuthStatusEvent(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
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

  Future<void> _onUpdateProfileEvent(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _updateProfileUsecase(
      UpdateProfileParams(name: event.name, profilePicture: event.profilePicture),
    );

    emit(result.fold(
      (failure) => AuthFailure(message: failure.message),
      (user) => ProfileUpdateSuccess(user: user),
    ));
  }
}