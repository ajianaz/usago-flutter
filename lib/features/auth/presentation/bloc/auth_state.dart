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

/// Create refresh token successful state
class CreateRefreshTokenSuccess extends AuthState {
  final Map<String, dynamic> tokenData;

  const CreateRefreshTokenSuccess({required this.tokenData});

  @override
  List<Object?> get props => [tokenData];
}

/// Get refresh tokens successful state
class GetRefreshTokensSuccess extends AuthState {
  final List<Map<String, dynamic>> tokens;

  const GetRefreshTokensSuccess({required this.tokens});

  @override
  List<Object?> get props => [tokens];
}

/// Revoke token successful state
class RevokeTokenSuccess extends AuthState {
  final String tokenId;

  const RevokeTokenSuccess({required this.tokenId});

  @override
  List<Object?> get props => [tokenId];
}

/// Revoke all tokens successful state
class RevokeAllTokensSuccess extends AuthState {
  const RevokeAllTokensSuccess();

  @override
  List<Object?> get props => [];
}
