import 'package:dio/dio.dart';
import '../helpers/test_constants.dart';

/// Network response fixtures for testing
class NetworkFixtures {
  /// Successful GET response
  static Map<String, dynamic> successGetResponse({
    Map<String, dynamic>? data,
    String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'GET request successful',
      'data': data ?? {'id': 1, 'name': 'Test Data'},
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Successful POST response
  static Map<String, dynamic> successPostResponse({
    Map<String, dynamic>? data,
    String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'POST request successful',
      'data': data ?? {'id': 2, 'name': 'Created Data'},
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Successful PUT response
  static Map<String, dynamic> successPutResponse({
    Map<String, dynamic>? data,
    String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'PUT request successful',
      'data': data ?? {'id': 3, 'name': 'Updated Data'},
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Successful DELETE response
  static Map<String, dynamic> successDeleteResponse({
    String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'DELETE request successful',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Network error response
  static Map<String, dynamic> networkErrorResponse({
    String? message,
    String? error,
    int? statusCode,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.networkErrorMessage,
      'error': error ?? 'NETWORK_ERROR',
      'statusCode': statusCode ?? 0,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Timeout error response
  static Map<String, dynamic> timeoutErrorResponse({
    String? message,
    String? error,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.timeoutErrorMessage,
      'error': error ?? 'TIMEOUT_ERROR',
      'timeout': CoreTestConstants.testTimeout.inSeconds,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Validation error response
  static Map<String, dynamic> validationErrorResponse({
    String? message,
    Map<String, dynamic>? errors,
    String? error,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.validationErrorMessage,
      'error': error ?? 'VALIDATION_ERROR',
      'errors': errors ?? {
        'email': ['Invalid email format'],
        'password': ['Password too weak'],
        'name': ['Name is required'],
      },
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Unauthorized error response
  static Map<String, dynamic> unauthorizedErrorResponse({
    String? message,
    String? error,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.unauthorizedMessage,
      'error': error ?? 'UNAUTHORIZED',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Forbidden error response
  static Map<String, dynamic> forbiddenErrorResponse({
    String? message,
    String? error,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.forbiddenMessage,
      'error': error ?? 'FORBIDDEN',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Not found error response
  static Map<String, dynamic> notFoundErrorResponse({
    String? message,
    String? error,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.notFoundMessage,
      'error': error ?? 'NOT_FOUND',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Server error response
  static Map<String, dynamic> serverErrorResponse({
    String? message,
    String? error,
    int statusCode = 500,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.serverErrorMessage,
      'error': error ?? 'SERVER_ERROR',
      'statusCode': statusCode,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Rate limit error response
  static Map<String, dynamic> rateLimitErrorResponse({
    String? message,
    String? error,
    int? retryAfter,
  }) {
    return {
      'success': false,
      'message': message ?? CoreTestConstants.rateLimitMessage,
      'error': error ?? 'RATE_LIMIT_EXCEEDED',
      'retryAfter': retryAfter ?? 60,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create DioException for timeout
  static DioException createTimeoutException({
    String? message,
  Duration? timeout,
  }) {
    return DioException(
      type: DioExceptionType.connectionTimeout,
      message: message ?? 'Connection timeout',
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      connectTimeout: timeout ?? CoreTestConstants.testTimeout,
      receiveTimeout: timeout ?? CoreTestConstants.testTimeout,
      sendTimeout: timeout ?? CoreTestConstants.testTimeout,
      ),
    );
  }

  /// Create DioException for connection error
  static DioException createConnectionException({
    String? message,
  }) {
    return DioException(
      type: DioExceptionType.connectionError,
      message: message ?? 'No internet connection',
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
    );
  }

  /// Create DioException for bad response
  static DioException createBadResponseException({
    int statusCode = 400,
    String? message,
    Map<String, dynamic>? response,
  }) {
    return DioException(
      type: DioExceptionType.badResponse,
      message: message ?? 'Bad response',
      response: Response(
        statusCode: statusCode,
        data: response ?? networkErrorResponse(),
        requestOptions: RequestOptions(
          path: CoreTestConstants.testEndpoint,
        ),
      ),
    );
  }

  /// Create DioException for cancel
  static DioException createCancelException({
    String? message,
  }) {
    return DioException(
      type: DioExceptionType.cancel,
      message: message ?? 'Request cancelled',
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
    );
  }

  /// Create DioException for unknown error
  static DioException createUnknownException({
    String? message,
  }) {
    return DioException(
      type: DioExceptionType.unknown,
      message: message ?? 'Unknown error occurred',
      requestOptions: RequestOptions(
        path: CoreTestConstants.testEndpoint,
      ),
    );
  }

  /// Create test headers
  static Map<String, String> createHeaders({
    String? contentType,
    String? authorization,
    String? userAgent,
    Map<String, String>? additional,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': contentType ?? 'application/json',
      if (authorization != null) 'Authorization': authorization,
      if (userAgent != null) 'User-Agent': userAgent,
      ...?additional,
    };
    return headers;
  }

  /// Create test query parameters
  static Map<String, dynamic> createQueryParams({
    int? page,
    int? limit,
    String? search,
    String? sort,
    String? order,
    Map<String, dynamic>? additional,
  }) {
    final params = <String, dynamic>{
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (search != null) 'search': search,
      if (sort != null) 'sort': sort,
      if (order != null) 'order': order,
      ...?additional,
    };
    return params;
  }

  /// Create test request body
  static Map<String, dynamic> createRequestBody({
    String? name,
    String? email,
    String? password,
    bool? active,
    Map<String, dynamic>? additional,
  }) {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (active != null) 'active': active,
      ...?additional,
    };
    return body;
  }

  /// Create paginated response
  static Map<String, dynamic> createPaginatedResponse({
    List<Map<String, dynamic>>? data,
    int currentPage = 1,
    int totalPages = 1,
    int totalItems = 0,
  String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'Data retrieved successfully',
      'data': data ?? [],
      'pagination': {
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalItems': totalItems,
        'itemsPerPage': data?.length ?? 10,
      },
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create empty response
  static Map<String, dynamic> createEmptyResponse({
    String? message,
  }) {
    return {
      'success': true,
      'message': message ?? 'No data available',
      'data': [],
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }
}