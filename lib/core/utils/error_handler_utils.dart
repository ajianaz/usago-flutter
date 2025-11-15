import 'package:dio/dio.dart';
import '../errors/failure.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';
import 'dart:math';

/// Utility class for comprehensive error handling
/// Provides centralized error conversion and logging with correlation tracking
class ErrorHandlerUtils {
  static final AppLogger _logger = AppLogger();
  static final Random _random = Random();

  /// Generate correlation ID for tracking related operations
  static String generateCorrelationId({int length = 8}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  /// Convert DioException to specific Failure types
  ///
  /// [exception] - The DioException to convert
  /// [correlationId] - Optional correlation ID for tracking
  /// [operation] - Optional operation name for context
  /// Returns [Failure] - Appropriate failure type
  static Failure handleDioException(
    DioException exception, {
    String? correlationId,
    String? operation,
  }) {
    final opName = operation ?? 'UnknownOperation';
    final corrId = correlationId ?? generateCorrelationId();

    final metadata = {
      'correlationId': corrId,
      'operation': opName,
      'exceptionType': exception.type.toString(),
      'statusCode': exception.response?.statusCode,
      'endpoint': exception.requestOptions.path,
      'method': exception.requestOptions.method,
    };

    _logger.error('DioException occurred in $opName | ${metadata.toString()}', exception);

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Connection timeout. Please check your internet connection.',
          timeout: exception.requestOptions.receiveTimeout ?? exception.requestOptions.sendTimeout,
          operation: opName,
          code: 'CONNECTION_TIMEOUT',
          originalError: exception,
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(exception, corrId, opName);

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled',
          code: 'CANCELLED',
          originalError: exception,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection. Please check your network.',
          code: 'CONNECTION_ERROR',
          originalError: exception,
        );

      case DioExceptionType.unknown:
        return NetworkFailure(
          message: 'An unknown network error occurred: ${exception.message}',
          code: 'UNKNOWN_NETWORK_ERROR',
          originalError: exception,
        );

      default:
        return NetworkFailure(
          message: 'An unexpected error occurred: ${exception.message}',
          code: 'UNEXPECTED_ERROR',
          originalError: exception,
        );
    }
  }

  /// Handle HTTP error responses and convert to specific failures
  ///
  /// [exception] - The DioException with bad response
  /// [correlationId] - Correlation ID for tracking
  /// [operation] - Operation name for context
  /// Returns [Failure] - Appropriate failure type
  static Failure _handleHttpError(
    DioException exception,
    String correlationId,
    String operation,
  ) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;
    final endpoint = exception.requestOptions.path;

    String message = 'Unknown error';
    Map<String, String>? fieldErrors;
    String? userFriendlyMessage;

    // Extract error information from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? 'Unknown error';
      userFriendlyMessage = data['userMessage'] ?? data['user_friendly_message'];

      // Extract field errors for validation failures
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        fieldErrors = <String, String>{};
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            fieldErrors![key] = value.first.toString();
          } else if (value is String) {
            fieldErrors![key] = value;
          }
        });
      }
    } else if (data != null) {
      message = data.toString();
    }

    final metadata = {
      'correlationId': correlationId,
      'operation': operation,
      'statusCode': statusCode,
      'endpoint': endpoint,
      'message': message,
      'fieldErrors': fieldErrors,
    };

    _logger.error('HTTP error occurred in $operation | ${metadata.toString()}');

    switch (statusCode) {
      case 400:
      case 422:
        return ValidationFailure(
          message: message,
          fieldErrors: fieldErrors,
          code: statusCode == 400 ? 'BAD_REQUEST' : 'VALIDATION_ERROR',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage,
        );

      case 401:
        return AuthFailure(
          message: message,
          type: AuthExceptionType.unauthorized,
          code: 'UNAUTHORIZED',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage ?? 'Please log in to continue',
        );

      case 403:
        return AuthFailure(
          message: message,
          type: AuthExceptionType.forbidden,
          code: 'FORBIDDEN',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage ?? 'You don\'t have permission to perform this action',
        );

      case 404:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'NOT_FOUND',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage ?? 'The requested resource was not found',
        );

      case 429:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'RATE_LIMIT_EXCEEDED',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage ?? 'Too many requests. Please try again later',
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'SERVER_ERROR',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage ?? 'Server error. Please try again later',
        );

      default:
        return ServerFailure(
          message: 'HTTP $statusCode: $message',
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'HTTP_ERROR',
          originalError: exception,
          userFriendlyMessage: userFriendlyMessage,
        );
    }
  }

  /// Convert any Exception to Failure
  ///
  /// [exception] - The exception to convert
  /// [correlationId] - Optional correlation ID for tracking
  /// [operation] - Optional operation name for context
  /// Returns [Failure] - Appropriate failure type
  static Failure convertToFailure(
    Exception exception, {
    String? correlationId,
    String? operation,
  }) {
    final opName = operation ?? 'UnknownOperation';
    final corrId = correlationId ?? generateCorrelationId();

    final metadata = {
      'correlationId': corrId,
      'operation': opName,
      'exceptionType': exception.runtimeType.toString(),
      'exceptionMessage': exception.toString(),
    };

    _logger.error('Exception converted to failure in $opName | ${metadata.toString()}', exception);

    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        endpoint: exception.endpoint,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        type: exception.type,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        fieldErrors: exception.fieldErrors,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        operation: exception.operation,
        key: exception.key,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        timeout: exception.timeout,
        operation: exception.operation,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is DioException) {
      return handleDioException(exception, correlationId: corrId, operation: opName);
    } else {
      return UnknownFailure(
        message: 'An unexpected error occurred during $opName',
        code: 'UNKNOWN_ERROR',
        originalError: exception,
      );
    }
  }

  /// Log error with structured format and correlation ID
  ///
  /// [error] - The error to log
  /// [stackTrace] - Optional stack trace
  /// [correlationId] - Correlation ID for tracking
  /// [operation] - Operation name for context
  /// [metadata] - Additional metadata for logging
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? correlationId,
    String? operation,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final opName = operation ?? 'UnknownOperation';

    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'operation': opName,
      'errorType': error.runtimeType.toString(),
      'errorMessage': error.toString(),
      ...?metadata,
    };

    _logger.error('Error in $opName [CID: $corrId] | ${logMetadata.toString()}', error, stackTrace);
  }

  /// Log warning with structured format and correlation ID
  ///
  /// [message] - Warning message
  /// [correlationId] - Correlation ID for tracking
  /// [operation] - Operation name for context
  /// [metadata] - Additional metadata for logging
  static void logWarning(
    String message, {
    String? correlationId,
    String? operation,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final opName = operation ?? 'UnknownOperation';

    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'operation': opName,
      ...?metadata,
    };

    _logger.warning('Warning in $opName [CID: $corrId]: $message | ${logMetadata.toString()}');
  }

  /// Log info with structured format and correlation ID
  ///
  /// [message] - Info message
  /// [correlationId] - Correlation ID for tracking
  /// [operation] - Operation name for context
  /// [metadata] - Additional metadata for logging
  static void logInfo(
    String message, {
    String? correlationId,
    String? operation,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final opName = operation ?? 'UnknownOperation';

    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'operation': opName,
      ...?metadata,
    };

    _logger.info('Info in $opName [CID: $corrId]: $message | ${logMetadata.toString()}');
  }

  /// Create user-friendly error message from failure
  ///
  /// [failure] - The failure to convert
  /// [context] - Optional context for better messaging
  /// Returns [String] - User-friendly error message
  static String createUserFriendlyMessage(Failure failure, {String? context}) {
    // If failure already has user-friendly message, use it
    if (failure.userFriendlyMessage != null) {
      return failure.userFriendlyMessage!;
    }

    // Create context-specific messages
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Please check your internet connection and try again.';
      case AuthFailure:
        final authFailure = failure as AuthFailure;
        switch (authFailure.type) {
          case AuthExceptionType.unauthorized:
            return 'Please log in to continue.';
          case AuthExceptionType.forbidden:
            return 'You don\'t have permission to perform this action.';
          case AuthExceptionType.tokenExpired:
            return 'Your session has expired. Please log in again.';
          case AuthExceptionType.invalidCredentials:
            return 'Invalid email or password. Please try again.';
          case AuthExceptionType.accountLocked:
            return 'Your account has been locked. Please contact support.';
          case AuthExceptionType.accountNotVerified:
            return 'Please verify your email address before continuing.';
          default:
            return 'Authentication error. Please try again.';
        }
      case ValidationFailure:
        final validationFailure = failure as ValidationFailure;
        if (validationFailure.fieldErrors != null && validationFailure.fieldErrors!.isNotEmpty) {
          final firstError = validationFailure.fieldErrors!.values.first;
          return firstError;
        }
        return 'Please check your input and try again.';
      case ServerFailure:
        return 'Server error. Please try again later.';
      case TimeoutFailure:
        return 'Request timed out. Please check your connection and try again.';
      case CacheFailure:
        return 'Data storage error. Please try again.';
      default:
        return context != null
            ? 'An error occurred while $context. Please try again.'
            : 'An error occurred. Please try again.';
    }
  }

  /// Check if failure is recoverable (can be retried)
  ///
  /// [failure] - The failure to check
  /// Returns [bool] - True if failure is recoverable
  static bool isRecoverableFailure(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
      case ServerFailure:
      case TimeoutFailure:
        return true;
      case AuthFailure:
        final authFailure = failure as AuthFailure;
        return authFailure.type == AuthExceptionType.tokenExpired;
      case ValidationFailure:
      case CacheFailure:
      case PermissionFailure:
      case ConfigurationFailure:
      case ParseFailure:
        return false;
      default:
        return false;
    }
  }

  /// Get suggested retry delay for recoverable failures
  ///
  /// [failure] - The failure to check
  /// [attemptNumber] - Current attempt number (starting from 1)
  /// Returns [Duration] - Suggested delay before retry
  static Duration getRetryDelay(Failure failure, int attemptNumber) {
    if (!isRecoverableFailure(failure)) {
      return Duration.zero;
    }

    // Base delay with exponential backoff
    final baseDelay = switch (failure.runtimeType) {
      NetworkFailure => const Duration(seconds: 2),
      ServerFailure => const Duration(seconds: 3),
      TimeoutFailure => const Duration(seconds: 1),
      AuthFailure => const Duration(seconds: 1),
      _ => const Duration(seconds: 2),
    };

    // Exponential backoff with jitter
    final exponentialDelay = baseDelay * pow(1.5, attemptNumber - 1);
    final jitter = Random().nextInt(1000);

    return Duration(milliseconds: exponentialDelay.inMilliseconds + jitter);
  }
}

/// Extension to provide additional error handling functionality
extension ErrorHandlingExtensions on Failure {
  /// Get user-friendly message
  String get userMessage => ErrorHandlerUtils.createUserFriendlyMessage(this);

  /// Check if this failure is recoverable
  bool get isRecoverable => ErrorHandlerUtils.isRecoverableFailure(this);

  /// Get retry delay for this failure
  Duration getRetryDelay(int attemptNumber) => ErrorHandlerUtils.getRetryDelay(this, attemptNumber);
}

/// Example usage:
///
/// try {
///   final response = await dio.get('/api/data');
///   return Right(response.data);
/// } on DioException catch (e) {
///   final correlationId = ErrorHandlerUtils.generateCorrelationId();
///   final failure = ErrorHandlerUtils.handleDioException(
///     e,
///     correlationId: correlationId,
///     operation: 'FetchData',
///   );
///
///   ErrorHandlerUtils.logError(
///     e,
///     correlationId: correlationId,
///     operation: 'FetchData',
///     metadata: {'endpoint': '/api/data'},
///   );
///
///   return Left(failure);
/// }