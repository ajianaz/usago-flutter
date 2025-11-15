import 'package:equatable/equatable.dart';

/// Base exception class for all application exceptions
abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, originalError, stackTrace];

  @override
  String toString() {
    return 'AppException{message: $message, code: $code}';
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  final int? statusCode;
  final String? endpoint;

  const NetworkException({
    required String message,
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, statusCode, endpoint, originalError, stackTrace];

  @override
  String toString() {
    return 'NetworkException{message: $message, code: $code, statusCode: $statusCode, endpoint: $endpoint}';
  }
}

/// Authentication-related exceptions
class AuthException extends AppException {
  final AuthExceptionType type;

  const AuthException({
    required String message,
    required this.type,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, type, originalError, stackTrace];

  @override
  String toString() {
    return 'AuthException{message: $message, code: $code, type: $type}';
  }
}

/// Types of authentication exceptions
enum AuthExceptionType {
  unauthorized,
  forbidden,
  tokenExpired,
  tokenInvalid,
  invalidCredentials,
  accountLocked,
  accountNotVerified,
  sessionExpired,
  refreshTokenFailed,
  loginRequired,
}

/// Validation-related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required String message,
    this.fieldErrors,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, fieldErrors, originalError, stackTrace];

  @override
  String toString() {
    return 'ValidationException{message: $message, code: $code, fieldErrors: $fieldErrors}';
  }
}

/// Server-related exceptions
class ServerException extends AppException {
  final int? statusCode;
  final String? endpoint;

  const ServerException({
    required String message,
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, statusCode, endpoint, originalError, stackTrace];

  @override
  String toString() {
    return 'ServerException{message: $message, code: $code, statusCode: $statusCode, endpoint: $endpoint}';
  }
}

/// Cache-related exceptions
class CacheException extends AppException {
  final String? operation;
  final String? key;

  const CacheException({
    required String message,
    this.operation,
    this.key,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, operation, key, originalError, stackTrace];

  @override
  String toString() {
    return 'CacheException{message: $message, code: $code, operation: $operation, key: $key}';
  }
}

/// Permission-related exceptions
class PermissionException extends AppException {
  final String? permission;

  const PermissionException({
    required String message,
    this.permission,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, permission, originalError, stackTrace];

  @override
  String toString() {
    return 'PermissionException{message: $message, code: $code, permission: $permission}';
  }
}

/// Configuration-related exceptions
class ConfigurationException extends AppException {
  final String? configKey;

  const ConfigurationException({
    required String message,
    this.configKey,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, configKey, originalError, stackTrace];

  @override
  String toString() {
    return 'ConfigurationException{message: $message, code: $code, configKey: $configKey}';
  }
}

/// Timeout-related exceptions
class TimeoutException extends AppException {
  final Duration? timeout;
  final String? operation;

  const TimeoutException({
    required String message,
    this.timeout,
    this.operation,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, timeout, operation, originalError, stackTrace];

  @override
  String toString() {
    return 'TimeoutException{message: $message, code: $code, timeout: $timeout, operation: $operation}';
  }
}

/// Parsing/Serialization exceptions
class ParseException extends AppException {
  final String? dataType;
  final String? expectedFormat;

  const ParseException({
    required String message,
    this.dataType,
    this.expectedFormat,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  List<Object?> get props => [message, code, dataType, expectedFormat, originalError, stackTrace];

  @override
  String toString() {
    return 'ParseException{message: $message, code: $code, dataType: $dataType, expectedFormat: $expectedFormat}';
  }
}