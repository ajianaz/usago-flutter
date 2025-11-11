import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'failure.dart';
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

    return ServerFailure(
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
        return NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
          originalError: exception,
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(exception);

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled',
          originalError: exception,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection. Please check your network.',
          originalError: exception,
        );

      case DioExceptionType.unknown:
        return NetworkFailure(
          message: 'An unknown network error occurred: ${exception.message}',
          originalError: exception,
        );

      default:
        return NetworkFailure(
          message: 'An unexpected network error occurred',
          originalError: exception,
        );
    }
  }

  /// Handle HTTP error responses
  Failure _handleHttpError(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    String message = 'Unknown error';

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? 'Unknown error';
    } else if (data != null) {
      message = data.toString();
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message,
          originalError: exception,
        );

      case 401:
        return ServerFailure(
          message: 'Unauthorized: $message',
          statusCode: statusCode,
          originalError: exception,
        );

      case 403:
        return ServerFailure(
          message: 'Forbidden: $message',
          statusCode: statusCode,
          originalError: exception,
        );

      case 404:
        return ServerFailure(
          message: 'Not found: $message',
          statusCode: statusCode,
          originalError: exception,
        );

      case 422:
        return ValidationFailure(
          message: message,
          originalError: exception,
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: 'Server error: $message',
          statusCode: statusCode,
          originalError: exception,
        );

      default:
        return ServerFailure(
          message: 'HTTP $statusCode: $message',
          statusCode: statusCode,
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