import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'failure.dart';
import 'exceptions.dart';
import '../utils/logger.dart';

/// Global error handler utility
/// Converts exceptions to Failure objects
class ErrorHandler {
  final AppLogger _logger;

  ErrorHandler({AppLogger? logger}) : _logger = logger ?? AppLogger();

  /// Handle any exception and convert to Failure
  Failure handleException(dynamic exception) {
    _logger.error('Exception occurred', exception);

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is AppException) {
      return _handleAppException(exception);
    }

    return UnknownFailure(
      message: 'An unexpected error occurred',
      originalError: exception,
    );
  }

  /// Handle Dio specific exceptions
  Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Connection timeout. Please check your internet connection.',
          timeout: const Duration(seconds: 30), // Default timeout
          operation: 'network',
          originalError: exception,
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(exception);

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
          code: 'UNKNOWN',
          originalError: exception,
        );

      default:
        return NetworkFailure(
          message: 'An unexpected network error occurred',
          code: 'UNEXPECTED',
          originalError: exception,
        );
    }
  }

  /// Handle AppException and convert to Failure
  Failure _handleAppException(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        statusCode: exception.statusCode,
        endpoint: exception.endpoint,
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
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        statusCode: exception.statusCode,
        endpoint: exception.endpoint,
        originalError: exception.originalError,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        operation: exception.operation,
        key: exception.key,
        originalError: exception.originalError,
      );
    } else if (exception is PermissionException) {
      return PermissionFailure(
        message: exception.message,
        code: exception.code,
        permission: exception.permission,
        originalError: exception.originalError,
      );
    } else if (exception is ConfigurationException) {
      return ConfigurationFailure(
        message: exception.message,
        code: exception.code,
        configKey: exception.configKey,
        originalError: exception.originalError,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        timeout: exception.timeout,
        operation: exception.operation,
        originalError: exception.originalError,
      );
    } else if (exception is ParseException) {
      return ParseFailure(
        message: exception.message,
        code: exception.code,
        dataType: exception.dataType,
        expectedFormat: exception.expectedFormat,
        originalError: exception.originalError,
      );
    }

    // Fallback for unknown AppException
    return UnknownFailure(
      message: exception.message,
      code: exception.code,
      originalError: exception.originalError,
    );
  }

  /// Handle HTTP error responses
  Failure _handleHttpError(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;
    final endpoint = exception.requestOptions.path;

    String message = 'Unknown error';
    Map<String, String>? fieldErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? 'Unknown error';

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

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message,
          fieldErrors: fieldErrors,
          code: 'BAD_REQUEST',
          originalError: exception,
        );

      case 401:
        return AuthFailure(
          message: message,
          type: AuthExceptionType.unauthorized,
          code: 'UNAUTHORIZED',
          originalError: exception,
        );

      case 403:
        return AuthFailure(
          message: message,
          type: AuthExceptionType.forbidden,
          code: 'FORBIDDEN',
          originalError: exception,
        );

      case 404:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'NOT_FOUND',
          originalError: exception,
        );

      case 422:
        return ValidationFailure(
          message: message,
          fieldErrors: fieldErrors,
          code: 'VALIDATION_ERROR',
          originalError: exception,
        );

      case 429:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'RATE_LIMIT_EXCEEDED',
          originalError: exception,
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
        );

      default:
        return ServerFailure(
          message: 'HTTP $statusCode: $message',
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'HTTP_ERROR',
          originalError: exception,
        );
    }
  }

  /// Convert exception to Either<Failure, T>
  Future<Either<Failure, T>> safeExecute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (exception) {
      return Left(handleException(exception));
    }
  }
}