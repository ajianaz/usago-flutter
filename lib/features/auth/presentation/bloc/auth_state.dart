import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Abstract class for all auth states
abstract class AuthState extends Equatable {
  const AuthState();
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

/// Authenticated state
class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();

  @override
  List<Object?> get props => [];
}

/// Authentication failure state
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Password reset email sent state
class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Password reset successful state
class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();

  @override
  List<Object?> get props => [];
}

/// Email verification successful state
class EmailVerificationSuccess extends AuthState {
  const EmailVerificationSuccess();

  @override
  List<Object?> get props => [];
}

/// Profile update successful state
class ProfileUpdateSuccess extends AuthState {
  final User user;

  const ProfileUpdateSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Token refresh successful state
class TokenRefreshSuccess extends AuthState {
  final User user;

  const TokenRefreshSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}