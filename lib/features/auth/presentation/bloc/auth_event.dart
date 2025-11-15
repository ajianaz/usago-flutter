import 'package:equatable/equatable.dart';
import '../../../../core/blocs/base_bloc.dart';

/// Abstract class for all auth events
abstract class AuthEvent extends BaseEvent {
  const AuthEvent();
}

/// Login event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const LoginEvent({
    required this.email,
    required this.password,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [email, password, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Register event
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [email, password, name, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Logout event
class LogoutEvent extends AuthEvent {
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const LogoutEvent({
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [_correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Check auth status event
class CheckAuthStatusEvent extends AuthEvent {
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const CheckAuthStatusEvent({
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [_correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Update profile event
class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? profilePicture;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const UpdateProfileEvent({
    this.name,
    this.profilePicture,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [name, profilePicture, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Change password event
class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props =>
      [currentPassword, newPassword, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Forgot password event
class ForgotPasswordEvent extends AuthEvent {
  final String email;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const ForgotPasswordEvent({
    required this.email,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [email, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Reset password event
class ResetPasswordEvent extends AuthEvent {
  final String token;
  final String newPassword;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const ResetPasswordEvent({
    required this.token,
    required this.newPassword,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [token, newPassword, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Verify email event
class VerifyEmailEvent extends AuthEvent {
  final String token;
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const VerifyEmailEvent({
    required this.token,
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [token, _correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Resend verification email event
class ResendVerificationEmailEvent extends AuthEvent {
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const ResendVerificationEmailEvent({
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [_correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}

/// Delete account event
class DeleteAccountEvent extends AuthEvent {
  final String? _correlationId;
  final Map<String, dynamic>? _metadata;

  const DeleteAccountEvent({
    String? correlationId,
    Map<String, dynamic>? metadata,
  })  : _correlationId = correlationId,
        _metadata = metadata;

  @override
  List<Object?> get props => [_correlationId, _metadata];

  @override
  String? get correlationId => _correlationId;

  @override
  Map<String, dynamic>? get metadata => _metadata;
}
