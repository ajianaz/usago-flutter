import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  final String? userFriendlyMessage;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.userFriendlyMessage,
  });

  @override
  List<Object?> get props => [message, code, originalError, userFriendlyMessage];

  /// Get the user-friendly message for display
  String get displayMessage => userFriendlyMessage ?? message;

  /// Convert to AppException if needed
  AppException? toException() {
    if (this is NetworkFailure) {
      final networkFailure = this as NetworkFailure;
      return NetworkException(
        message: message,
        statusCode: networkFailure.statusCode,
        endpoint: networkFailure.endpoint,
        code: code,
        originalError: originalError,
      );
    } else if (this is AuthFailure) {
      final authFailure = this as AuthFailure;
      return AuthException(
        message: message,
        type: authFailure.type,
        code: code,
        originalError: originalError,
      );
    } else if (this is ValidationFailure) {
      final validationFailure = this as ValidationFailure;
      return ValidationException(
        message: message,
        fieldErrors: validationFailure.fieldErrors,
        code: code,
        originalError: originalError,
      );
    } else if (this is ServerFailure) {
      final serverFailure = this as ServerFailure;
      return ServerException(
        message: message,
        statusCode: serverFailure.statusCode,
        endpoint: serverFailure.endpoint,
        code: code,
        originalError: originalError,
      );
    } else if (this is CacheFailure) {
      final cacheFailure = this as CacheFailure;
      return CacheException(
        message: message,
        operation: cacheFailure.operation,
        key: cacheFailure.key,
        code: code,
        originalError: originalError,
      );
    }
    return null;
  }
}

class NetworkFailure extends Failure {
  final int? statusCode;
  final String? endpoint;

  const NetworkFailure({
    required String message,
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, statusCode, endpoint, originalError, userFriendlyMessage];
}

class AuthFailure extends Failure {
  final AuthExceptionType type;

  const AuthFailure({
    required String message,
    required this.type,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, type, originalError, userFriendlyMessage];
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required String message,
    this.fieldErrors,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, fieldErrors, originalError, userFriendlyMessage];
}

class ServerFailure extends Failure {
  final int? statusCode;
  final String? endpoint;

  const ServerFailure({
    required String message,
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, statusCode, endpoint, originalError, userFriendlyMessage];
}

class CacheFailure extends Failure {
  final String? operation;
  final String? key;

  const CacheFailure({
    required String message,
    this.operation,
    this.key,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, operation, key, originalError, userFriendlyMessage];
}

class PermissionFailure extends Failure {
  final String? permission;

  const PermissionFailure({
    required String message,
    this.permission,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, permission, originalError, userFriendlyMessage];
}

class ConfigurationFailure extends Failure {
  final String? configKey;

  const ConfigurationFailure({
    required String message,
    this.configKey,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, configKey, originalError, userFriendlyMessage];
}

class TimeoutFailure extends Failure {
  final Duration? timeout;
  final String? operation;

  const TimeoutFailure({
    required String message,
    this.timeout,
    this.operation,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, timeout, operation, originalError, userFriendlyMessage];
}

class ParseFailure extends Failure {
  final String? dataType;
  final String? expectedFormat;

  const ParseFailure({
    required String message,
    this.dataType,
    this.expectedFormat,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, dataType, expectedFormat, originalError, userFriendlyMessage];
}

class BetterAuthFailure extends Failure {
  const BetterAuthFailure({
    required String message,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, originalError, userFriendlyMessage];
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
    String? code,
    dynamic originalError,
    String? userFriendlyMessage,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          userFriendlyMessage: userFriendlyMessage,
        );

  @override
  List<Object?> get props => [message, code, originalError, userFriendlyMessage];
}