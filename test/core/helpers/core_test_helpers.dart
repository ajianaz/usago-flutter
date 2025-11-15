import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../lib/core/errors/failure.dart';
import '../../../lib/core/errors/exceptions.dart';
import '../../../lib/core/performance/performance_tracker.dart';
import 'test_constants.dart';

/// Helper utilities for core module testing
class CoreTestHelpers {
  /// Create a test performance metric
  static PerformanceMetric createTestPerformanceMetric({
    String name = 'test_operation',
    String category = 'test',
    Duration? duration,
    DateTime? timestamp,
    Map<String, dynamic> metadata = const {},
  }) {
    return PerformanceMetric(
      name: name,
      category: category,
      duration: duration ?? const Duration(milliseconds: 100),
      timestamp: timestamp ?? DateTime.now(),
      metadata: metadata,
    );
  }

  /// Create a slow performance metric for testing thresholds
  static PerformanceMetric createSlowPerformanceMetric({
    String name = 'slow_operation',
    String category = 'test',
  }) {
    return PerformanceMetric(
      name: name,
      category: category,
      duration: const Duration(seconds: 3), // Slow operation
      timestamp: DateTime.now(),
    );
  }

  /// Create a test network response
  static Response createTestResponse({
    dynamic data,
    int statusCode = 200,
    Map<String, dynamic>? headers,
    String? statusMessage,
  }) {
    return Response(
      data: data ?? CoreTestConstants.successResponseData,
      statusCode: statusCode,
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
      headers: null,
      statusMessage: statusMessage,
    );
  }

  /// Create a test error response
  static Response createErrorResponse({
    int statusCode = 400,
    String message = 'Error occurred',
    Map<String, dynamic>? errors,
  }) {
    return Response(
      data: {
        'error': message,
        'code': 'ERROR_CODE',
        if (errors != null) 'errors': errors,
      },
      statusCode: statusCode,
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
    );
  }

  /// Create a test DioException
  static DioException createTestDioException({
    DioExceptionType type = DioExceptionType.connectionTimeout,
    Response? response,
    String? message,
  }) {
    return DioException(
      type: type,
      response: response,
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
      message: message ?? 'Test error',
    );
  }

  /// Create a successful Either result
  static Either<Failure, T> createSuccessResult<T>(T data) {
    return Right(data);
  }

  /// Create a failure Either result
  static Either<Failure, T> createFailureResult<T>(Failure failure) {
    return Left(failure);
  }

  /// Create a network failure
  static NetworkFailure createNetworkFailure({
    String message = CoreTestConstants.networkErrorMessage,
    String code = 'NETWORK_ERROR',
  }) {
    return NetworkFailure(
      message: message,
      code: code,
    );
  }

  /// Create a server failure
  static ServerFailure createServerFailure({
    String message = CoreTestConstants.serverErrorMessage,
    int statusCode = 500,
    String? endpoint,
    String code = 'SERVER_ERROR',
  }) {
    return ServerFailure(
      message: message,
      statusCode: statusCode,
      endpoint: endpoint ?? CoreTestConstants.testEndpoint,
      code: code,
    );
  }

  /// Create a validation failure
  static ValidationFailure createValidationFailure({
    String message = CoreTestConstants.validationErrorMessage,
    Map<String, String>? fieldErrors,
    String code = 'VALIDATION_ERROR',
  }) {
    return ValidationFailure(
      message: message,
      fieldErrors: fieldErrors ?? {},
      code: code,
    );
  }

  /// Create a timeout failure
  static TimeoutFailure createTimeoutFailure({
    String message = CoreTestConstants.timeoutErrorMessage,
    Duration? timeout,
    String? operation,
    String code = 'TIMEOUT_ERROR',
  }) {
    return TimeoutFailure(
      message: message,
      timeout: timeout ?? CoreTestConstants.testTimeout,
      operation: operation ?? 'test_operation',
      code: code,
    );
  }

  /// Verify mock interaction was called exactly once
  static void verifyCalledOnce(Mock mock) {
    verify(mock).called(1);
  }

  /// Verify mock interaction was never called
  static void verifyNeverCalled(Mock mock) {
    verifyNever(mock);
  }

  /// Verify mock interaction was called specific number of times
  static void verifyCalledTimes(Mock mock, int count) {
    verify(mock).called(count);
  }

  /// Create test HTTP methods list
  static List<String> get testHttpMethods => [
    'GET',
    'POST',
    'PUT',
    'DELETE',
    'PATCH',
    'HEAD',
    'OPTIONS',
  ];

  /// Create test status codes
  static List<int> get testStatusCodes => [
    200, // OK
    201, // Created
    204, // No Content
    400, // Bad Request
    401, // Unauthorized
    403, // Forbidden
    404, // Not Found
    422, // Unprocessable Entity
    429, // Too Many Requests
    500, // Internal Server Error
    502, // Bad Gateway
    503, // Service Unavailable
  ];

  /// Create test content types
  static List<String> get testContentTypes => [
    'application/json',
    'text/html',
    'text/plain',
    'application/xml',
    'multipart/form-data',
    'application/x-www-form-urlencoded',
  ];

  /// Create test timeout durations
  static List<Duration> get testTimeouts => [
    const Duration(seconds: 5),
    const Duration(seconds: 10),
    const Duration(seconds: 30),
    const Duration(minutes: 1),
    const Duration(minutes: 5),
  ];

  /// Create test performance categories
  static List<String> get testPerformanceCategories => [
    'network',
    'database',
    'ui',
    'bloc_event',
    'storage',
    'authentication',
    'general',
  ];

  /// Create test platform names
  static List<String> get testPlatformNames => [
    'iOS',
    'Android',
    'Web',
    'Windows',
    'macOS',
    'Linux',
  ];

  /// Create test storage keys
  static List<String> get testStorageKeys => [
    'access_token',
    'refresh_token',
    'user_data',
    'app_settings',
    'cache_data',
    'session_data',
  ];

  /// Create test log levels
  static List<String> get testLogLevels => [
    'debug',
    'info',
    'warning',
    'error',
    'verbose',
    'wtf',
  ];

  /// Create test environment names
  static List<String> get testEnvironments => [
    'development',
    'staging',
    'production',
    'test',
  ];

  /// Generate test metadata for performance metrics
  static Map<String, dynamic> createTestMetadata({
    String? operation,
    String? endpoint,
    Map<String, dynamic>? additional,
  }) {
    return {
      'operation': operation ?? 'test_operation',
      'endpoint': endpoint ?? CoreTestConstants.testEndpoint,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additional,
    };
  }

  /// Create test headers for HTTP requests
  static Map<String, String> createTestHeaders({
    String contentType = 'application/json',
    String? authorization,
    Map<String, String>? additional,
  }) {
    return {
      'Content-Type': contentType,
      'Accept': 'application/json',
      if (authorization != null) 'Authorization': authorization,
      ...?additional,
    };
  }

  /// Create test query parameters
  static Map<String, dynamic> createTestQueryParams({
    int page = 1,
    int limit = 10,
    String? search,
    Map<String, dynamic>? additional,
  }) {
    return {
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
      ...?additional,
    };
  }
}