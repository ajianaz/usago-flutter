import 'package:equatable/equatable.dart';

/// Abstract class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

/// Login event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Logout event
class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

/// Check auth status event
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();

  @override
  List<Object?> get props => [];
}

/// Update profile event
class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? profilePicture;

  const UpdateProfileEvent({
    this.name,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [name, profilePicture];
}

/// Change password event
class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Forgot password event
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

/// Reset password event
class ResetPasswordEvent extends AuthEvent {
  final String token;
  final String newPassword;

  const ResetPasswordEvent({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

/// Verify email event
class VerifyEmailEvent extends AuthEvent {
  final String token;

  const VerifyEmailEvent({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

/// Resend verification email event
class ResendVerificationEmailEvent extends AuthEvent {
  const ResendVerificationEmailEvent();

  @override
  List<Object?> get props => [];
}

/// Delete account event
class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}