import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../utils/logger.dart';
import '../utils/error_handler_utils.dart';
import '../errors/exceptions.dart';
import '../errors/failure.dart';

/// Mixin that provides common datasource functionality
/// Includes correlation ID generation, logging, and response handling
mixin DataSourceMixin {
  AppLogger get logger => AppLogger();

  /// Generate correlation ID for tracking related operations
  String generateCorrelationId({int length = 8}) {
    return ErrorHandlerUtils.generateCorrelationId(length: length);
  }

  /// Log API call before execution
  ///
  /// [method] - HTTP method
  /// [endpoint] - API endpoint
  /// [correlationId] - Correlation ID for tracking
  /// [metadata] - Additional metadata for logging
  void logApiCallStart(
    String method,
    String endpoint, {
    String? correlationId,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'method': method,
      'endpoint': endpoint,
      ...?metadata,
    };

    logger.info(
        'API Call Started: $method $endpoint [CID: $corrId] | ${logMetadata.toString()}');
  }

  /// Log API call after successful completion
  ///
  /// [method] - HTTP method
  /// [endpoint] - API endpoint
  /// [statusCode] - HTTP status code
  /// [correlationId] - Correlation ID for tracking
  /// [metadata] - Additional metadata for logging
  void logApiCallSuccess(
    String method,
    String endpoint,
    int statusCode, {
    String? correlationId,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'method': method,
      'endpoint': endpoint,
      'statusCode': statusCode,
      ...?metadata,
    };

    logger.info(
        'API Call Success: $method $endpoint -> $statusCode [CID: $corrId] | ${logMetadata.toString()}');
  }

  /// Log API call after failure
  ///
  /// [method] - HTTP method
  /// [endpoint] - API endpoint
  /// [error] - Error that occurred
  /// [correlationId] - Correlation ID for tracking
  /// [metadata] - Additional metadata for logging
  void logApiCallFailure(
    String method,
    String endpoint,
    Object error, {
    String? correlationId,
    Map<String, dynamic>? metadata,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final logMetadata = <String, dynamic>{
      'correlationId': corrId,
      'method': method,
      'endpoint': endpoint,
      'errorType': error.runtimeType.toString(),
      ...?metadata,
    };

    logger.error(
        'API Call Failed: $method $endpoint [CID: $corrId] | ${logMetadata.toString()}',
        error);
  }

  /// Extract relevant headers from response
  ///
  /// [response] - HTTP response
  /// Returns [Map<String, String>] - Extracted headers
  Map<String, String> extractResponseHeaders(Response response) {
    final headers = <String, String>{};

    // Extract commonly useful headers
    final usefulHeaders = [
      'content-type',
      'content-length',
      'cache-control',
      'etag',
      'last-modified',
      'x-request-id',
      'x-correlation-id',
      'authorization',
      'set-cookie',
      'location',
      'retry-after',
      'x-rate-limit-remaining',
      'x-rate-limit-reset',
    ];

    for (final headerName in usefulHeaders) {
      final value = response.headers[headerName];
      if (value != null && value.isNotEmpty) {
        headers[headerName] = value.first;
      }
    }

    return headers;
  }

  /// Safe execution wrapper for API calls
  ///
  /// [apiCall] - The API call to execute
  /// [method] - HTTP method for logging
  /// [endpoint] - API endpoint for logging
  /// [correlationId] - Optional correlation ID for tracking
  /// [metadata] - Additional metadata for logging
  /// Returns [Either<Exception, T>] - Result or error
  Future<Either<Exception, T>> safeApiCall<T>(
    Future<T> Function() apiCall, {
    required String method,
    required String endpoint,
    String? correlationId,
    Map<String, dynamic>? metadata,
  }) async {
    final corrId = correlationId ?? generateCorrelationId();

    try {
      // Log API call start
      logApiCallStart(method, endpoint,
          correlationId: corrId, metadata: metadata);

      // Execute API call
      final result = await apiCall();

      // Log success (for Response objects, we can get status code)
      if (result is Response) {
        logApiCallSuccess(method, endpoint, result.statusCode ?? 0,
            correlationId: corrId, metadata: metadata);
      } else {
        logApiCallSuccess(method, endpoint, 200,
            correlationId: corrId, metadata: metadata);
      }

      return Right(result);
    } on DioException catch (e) {
      // Log failure
      logApiCallFailure(method, endpoint, e,
          correlationId: corrId, metadata: metadata);

      // Convert to appropriate exception
      final failure = ErrorHandlerUtils.handleDioException(
        e,
        correlationId: corrId,
        operation: '${method}_$endpoint',
      );

      return Left(failure.toException()!);
    } catch (e, stackTrace) {
      // Log failure
      logApiCallFailure(method, endpoint, e,
          correlationId: corrId, metadata: metadata);

      // Convert to unknown exception
      final failure = UnknownFailure(
        message: 'An unexpected error occurred during ${method}_$endpoint',
        originalError: e,
      );

      return Left(failure.toException()!);
    }
  }

  /// Safe execution wrapper for API calls that return Response objects
  ///
  /// [apiCall] - The API call to execute
  /// [method] - HTTP method for logging
  /// [endpoint] - API endpoint for logging
  /// [correlationId] - Optional correlation ID for tracking
  /// [metadata] - Additional metadata for logging
  /// Returns [Either<Exception, Response>] - Response or error
  Future<Either<Exception, Response>> safeApiCallWithResponse(
    Future<Response> Function() apiCall, {
    required String method,
    required String endpoint,
    String? correlationId,
    Map<String, dynamic>? metadata,
  }) async {
    final corrId = correlationId ?? generateCorrelationId();

    try {
      // Log API call start
      logApiCallStart(method, endpoint,
          correlationId: corrId, metadata: metadata);

      // Execute API call
      final response = await apiCall();

      // Extract headers for logging
      final responseHeaders = extractResponseHeaders(response);

      // Log success with headers
      logApiCallSuccess(
        method,
        endpoint,
        response.statusCode ?? 0,
        correlationId: corrId,
        metadata: {
          'responseHeaders': responseHeaders,
          ...?metadata,
        },
      );

      return Right(response);
    } on DioException catch (e) {
      // Log failure
      logApiCallFailure(method, endpoint, e,
          correlationId: corrId, metadata: metadata);

      // Convert to appropriate exception
      final failure = ErrorHandlerUtils.handleDioException(
        e,
        correlationId: corrId,
        operation: '${method}_$endpoint',
      );

      return Left(failure.toException()!);
    } catch (e, stackTrace) {
      // Log failure
      logApiCallFailure(method, endpoint, e,
          correlationId: corrId, metadata: metadata);

      // Convert to unknown exception
      final failure = UnknownFailure(
        message: 'An unexpected error occurred during ${method}_$endpoint',
        originalError: e,
      );

      return Left(failure.toException()!);
    }
  }

  /// Parse response data with error handling
  ///
  /// [response] - HTTP response
  /// [parser] - Function to parse response data
  /// [correlationId] - Optional correlation ID for tracking
  /// Returns [Either<Exception, T>] - Parsed data or error
  Either<Exception, T> parseResponse<T>(
    Response response,
    T Function(dynamic) parser, {
    String? correlationId,
  }) {
    final corrId = correlationId ?? generateCorrelationId();

    try {
      final data = parser(response.data);
      return Right(data);
    } catch (e, stackTrace) {
      logger.error(
        'Failed to parse response data [CID: $corrId] | ${{
          'correlationId': corrId,
          'statusCode': response.statusCode,
          'endpoint': response.requestOptions.path,
          'dataType': T.toString(),
        }.toString()}',
        e,
        stackTrace,
      );

      final failure = ParseFailure(
        message: 'Failed to parse response data',
        dataType: T.toString(),
        expectedFormat: 'Expected ${T.toString()}',
        originalError: e,
      );

      return Left(failure.toException()!);
    }
  }

  /// Validate response status code
  ///
  /// [response] - HTTP response
  /// [expectedCodes] - List of expected status codes (default: [200, 201, 204])
  /// [correlationId] - Optional correlation ID for tracking
  /// Returns [Either<Exception, Response>] - Response if valid, error if not
  Either<Exception, Response> validateResponse(
    Response response, {
    List<int> expectedCodes = const [200, 201, 204],
    String? correlationId,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final statusCode = response.statusCode ?? 0;

    if (expectedCodes.contains(statusCode)) {
      return Right(response);
    }

    logger.warning(
      'Unexpected status code [CID: $corrId] | ${{
        'correlationId': corrId,
        'statusCode': statusCode,
        'expectedCodes': expectedCodes,
        'endpoint': response.requestOptions.path,
      }.toString()}',
    );

    final failure = ServerFailure(
      message: 'Unexpected status code: $statusCode',
      statusCode: statusCode,
      endpoint: response.requestOptions.path,
      code: 'UNEXPECTED_STATUS_CODE',
    );

    return Left(failure.toException()!);
  }

  /// Extract pagination information from response
  ///
  /// [response] - HTTP response
  /// Returns [Map<String, dynamic>] - Pagination metadata
  Map<String, dynamic> extractPaginationInfo(Response response) {
    final pagination = <String, dynamic>{};
    final headers = response.headers;

    // Extract pagination headers
    final paginationHeaders = [
      'x-pagination-total',
      'x-pagination-page',
      'x-pagination-limit',
      'x-pagination-pages',
      'x-total-count',
      'x-page-count',
      'x-current-page',
      'x-per-page',
    ];

    for (final header in paginationHeaders) {
      final value = headers[header];
      if (value != null && value.isNotEmpty) {
        final headerValue = value.first;
        // Try to parse as number
        if (int.tryParse(headerValue) != null) {
          pagination[header.replaceAll('x-', '').replaceAll('-', '_')] =
              int.parse(headerValue);
        } else {
          pagination[header.replaceAll('x-', '').replaceAll('-', '_')] =
              headerValue;
        }
      }
    }

    // Also check response data for pagination info
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final paginationKeys = [
        'pagination',
        'meta',
        'page',
        'total',
        'limit',
        'offset'
      ];

      for (final key in paginationKeys) {
        if (data.containsKey(key)) {
          pagination[key] = data[key];
        }
      }
    }

    return pagination;
  }

  /// Create request options with correlation ID
  ///
  /// [correlationId] - Correlation ID to include
  /// [additionalHeaders] - Additional headers to include
  /// Returns [Options] - Request options with correlation ID
  Options createRequestOptions({
    String? correlationId,
    Map<String, String>? additionalHeaders,
    String? contentType,
    Duration? timeout,
  }) {
    final corrId = correlationId ?? generateCorrelationId();
    final headers = <String, String>{
      'X-Correlation-ID': corrId,
      if (contentType != null) 'Content-Type': contentType,
      ...?additionalHeaders,
    };

    return Options(
      headers: headers,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    );
  }
}

/// Extension to provide additional datasource functionality
extension DataSourceExtensions on DataSourceMixin {
  /// Retry API call with exponential backoff
  ///
  /// [apiCall] - The API call to retry
  /// [method] - HTTP method for logging
  /// [endpoint] - API endpoint for logging
  /// [maxRetries] - Maximum number of retries
  /// [initialDelay] - Initial delay between retries
  /// [correlationId] - Optional correlation ID for tracking
  /// Returns [Either<Exception, T>] - Result or error
  Future<Either<Exception, T>> retryApiCall<T>(
    Future<Either<Exception, T>> Function() apiCall, {
    required String method,
    required String endpoint,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    String? correlationId,
  }) async {
    final corrId = correlationId ?? generateCorrelationId();
    var delay = initialDelay;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      final result = await apiCall();

      if (result.isRight()) {
        if (attempt > 0) {
          logger.info(
            'API call succeeded after $attempt retries [CID: $corrId] | ${{
              'correlationId': corrId,
              'attempts': attempt + 1,
              'method': method,
              'endpoint': endpoint,
            }.toString()}',
          );
        }
        return result;
      }

      if (attempt == maxRetries) {
        logger.error(
          'API call failed after $maxRetries retries [CID: $corrId] | ${{
            'correlationId': corrId,
            'attempts': attempt + 1,
            'method': method,
            'endpoint': endpoint,
          }.toString()}',
          result.fold((l) => l, (r) => null),
        );
        return result;
      }

      logger.warning(
        'API call failed, retrying in ${delay.inSeconds}s (attempt ${attempt + 1}/$maxRetries) [CID: $corrId] | ${{
          'correlationId': corrId,
          'attempt': attempt + 1,
          'maxRetries': maxRetries,
          'delaySeconds': delay.inSeconds,
          'method': method,
          'endpoint': endpoint,
        }.toString()}',
      );

      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }

    return Left(ServerException(message: 'Retry API call failed unexpectedly'));
  }
}

/// Example usage:
///
/// class AuthRemoteDatasourceImpl with DataSourceMixin implements AuthRemoteDatasource {
///   final DioClient _dioClient;
///
///   @override
///   Future<Either<Exception, User>> login({required String email, required String password}) async {
///     final correlationId = generateCorrelationId();
///
///     return await safeApiCall<User>(
///       () async {
///         final response = await _dioClient.post(
///           '/auth/login',
///           data: {'email': email, 'password': password},
///           options: createRequestOptions(correlationId: correlationId),
///         );
///
///         return parseResponse(response, (data) => UserModel.fromJson(data));
///       },
///       method: 'POST',
///       endpoint: '/auth/login',
///       correlationId: correlationId,
///       metadata: {'email': email},
///     );
///   }
/// }
