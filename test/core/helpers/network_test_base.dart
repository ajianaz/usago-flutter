import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'core_test_base.dart';
import 'core_test_helpers.dart';
import 'test_constants.dart';
import '../../../lib/core/network/dio_client.dart';
import '../../../lib/core/errors/failure.dart';
import '../../../lib/core/errors/exceptions.dart';

/// Base test class for network-related tests
/// Provides common setup and utilities for testing network components
abstract class NetworkTestBase extends CoreTestBase {
  // Network-specific test data
  late Map<String, String> testHeaders;
  late Map<String, dynamic> testQueryParams;
  late Map<String, dynamic> testRequestBody;
  late Response successResponse;
  late Response errorResponse;
  late DioException timeoutException;
  late DioException connectionException;
  late DioException serverException;

  @override
  void setUp() {
    super.setUp();

    // Initialize network-specific test data
    testHeaders = createTestHeaders();
    testQueryParams = createTestQueryParams();
    testRequestBody = createTestRequestBody();
    successResponse = createTestResponse();
    errorResponse = createErrorResponse();
    timeoutException = createTimeoutException();
    connectionException = createConnectionException();
    serverException = createServerException();
  }

  /// Create test headers
  Map<String, String> createTestHeaders({
    String contentType = 'application/json',
    String? authorization,
  }) {
    return CoreTestHelpers.createTestHeaders(
      contentType: contentType,
      authorization: authorization,
    );
  }

  /// Create test query parameters
  Map<String, dynamic> createTestQueryParams({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    return CoreTestHelpers.createTestQueryParams(
      page: page,
      limit: limit,
      search: search,
    );
  }

  /// Create test request body
  Map<String, dynamic> createTestRequestBody({
    String? name,
    String? email,
    bool? active,
  }) {
    return CoreTestHelpers.createTestRequestBody(
      name: name,
      email: email,
      active: active,
    );
  }

  /// Create test success response
  Response createTestResponse({
    Map<String, dynamic>? data,
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    return CoreTestHelpers.createTestResponse(
      data: data ?? CoreTestConstants.successResponseData,
      statusCode: statusCode,
      headers: headers ?? testHeaders,
    );
  }

  /// Create test error response
  Response createErrorResponse({
    int statusCode = 400,
    String message = CoreTestConstants.networkErrorMessage,
    Map<String, dynamic>? errors,
  }) {
    return CoreTestHelpers.createTestResponse(
      data: {
        'success': false,
        'message': message,
        'error': 'NETWORK_ERROR',
        if (errors != null) 'errors': errors,
      },
      statusCode: statusCode,
      headers: testHeaders,
    );
  }

  /// Create timeout exception
  DioException createTimeoutException({
    Duration? timeout,
  }) {
    return CoreTestHelpers.createTestDioException(
      type: DioExceptionType.connectionTimeout,
      message: 'Connection timeout after ${timeout?.inSeconds ?? 30} seconds',
    );
  }

  /// Create connection exception
  DioException createConnectionException({
    String? message,
  }) {
    return CoreTestHelpers.createTestDioException(
      type: DioExceptionType.connectionError,
      message: message ?? 'No internet connection',
    );
  }

  /// Create server exception
  DioException createServerException({
    int statusCode = 500,
    String? message,
  }) {
    return CoreTestHelpers.createTestDioException(
      type: DioExceptionType.badResponse,
      message: message ?? 'Internal server error',
    );
  }

  /// Setup successful GET request
  void setupGetSuccess({
    String path = CoreTestConstants.testEndpoint,
    Map<String, dynamic>? response,
  }) {
    when(mockDioClient.get(
      path,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => response ?? successResponse.data);
  }

  /// Setup successful POST request
  void setupPostSuccess({
    String path = CoreTestConstants.testEndpoint,
    Map<String, dynamic>? response,
  }) {
    when(mockDioClient.post(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => response ?? successResponse.data);
  }

  /// Setup successful PUT request
  void setupPutSuccess({
    String path = CoreTestConstants.testEndpoint,
    Map<String, dynamic>? response,
  }) {
    when(mockDioClient.put(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => response ?? successResponse.data);
  }

  /// Setup successful DELETE request
  void setupDeleteSuccess({
    String path = CoreTestConstants.testEndpoint,
    Map<String, dynamic>? response,
  }) {
    when(mockDioClient.delete(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => response ?? successResponse.data);
  }

  /// Setup GET request error
  void setupGetError({
    String path = CoreTestConstants.testEndpoint,
    Exception? error,
  }) {
    when(mockDioClient.get(
      path,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(error ?? timeoutException);
  }

  /// Setup POST request error
  void setupPostError({
    String path = CoreTestConstants.testEndpoint,
    Exception? error,
  }) {
    when(mockDioClient.post(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(error ?? connectionException);
  }

  /// Setup PUT request error
  void setupPutError({
    String path = CoreTestConstants.testEndpoint,
    Exception? error,
  }) {
    when(mockDioClient.put(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(error ?? serverException);
  }

  /// Setup DELETE request error
  void setupDeleteError({
    String path = CoreTestConstants.testEndpoint,
    Exception? error,
  }) {
    when(mockDioClient.delete(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(error ?? timeoutException);
  }

  /// Verify GET request was called
  void verifyGetCalled({
    String path = CoreTestConstants.testEndpoint,
    int times = 1,
  }) {
    verify(mockDioClient.get(
      path,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).called(times);
  }

  /// Verify POST request was called
  void verifyPostCalled({
    String path = CoreTestConstants.testEndpoint,
    int times = 1,
  }) {
    verify(mockDioClient.post(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).called(times);
  }

  /// Verify PUT request was called
  void verifyPutCalled({
    String path = CoreTestConstants.testEndpoint,
    int times = 1,
  }) {
    verify(mockDioClient.put(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).called(times);
  }

  /// Verify DELETE request was called
  void verifyDeleteCalled({
    String path = CoreTestConstants.testEndpoint,
    int times = 1,
  }) {
    verify(mockDioClient.delete(
      path,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).called(times);
  }

  /// Verify no network requests were made
  void verifyNoNetworkRequests() {
    verifyNeverCalled(mockDioClient);
  }

  /// Create test HTTP status codes
  List<int> get testStatusCodes => CoreTestHelpers.testStatusCodes;

  /// Create test content types
  List<String> get testContentTypes => CoreTestHelpers.testContentTypes;

  /// Create test timeout durations
  List<Duration> get testTimeouts => CoreTestHelpers.testTimeouts;

  /// Test network success scenario
  Future<void> testNetworkSuccess(
    String description,
    Future<Map<String, dynamic>> Function() operation,
  ) async {
    // Arrange
    setupNetworkSuccess();

    // Act
    final result = await operation();

    // Assert
    expect(result, isA<Map<String, dynamic>>());
    expect(result['success'], isTrue);
    verifyGetCalled();

    // Cleanup
    tearDown();
  }

  /// Test network error scenario
  Future<void> testNetworkError(
    String description,
    Future<Map<String, dynamic>> Function() operation,
    Exception? expectedError,
  ) async {
    // Arrange
    setupGetError(error: expectedError);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(expectedError ?? timeoutException),
    );
    verifyGetCalled();

    // Cleanup
    tearDown();
  }

  /// Test network timeout scenario
  Future<void> testNetworkTimeout(
    String description,
    Future<Map<String, dynamic>> Function() operation,
  ) async {
    // Arrange
    setupGetError(error: timeoutException);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(isA<DioException>()
          .having((e) => e.type, 'type', 'equals', DioExceptionType.connectionTimeout)),
    );
    verifyGetCalled();

    // Cleanup
    tearDown();
  }

  /// Test network connection error scenario
  Future<void> testNetworkConnectionError(
    String description,
    Future<Map<String, dynamic>> Function() operation,
  ) async {
    // Arrange
    setupGetError(error: connectionException);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(isA<DioException>()
          .having((e) => e.type, 'type', 'equals', DioExceptionType.connectionError)),
    );
    verifyGetCalled();

    // Cleanup
    tearDown();
  }

  /// Test server error scenario
  Future<void> testServerError(
    String description,
    Future<Map<String, dynamic>> Function() operation,
  ) async {
    // Arrange
    setupGetError(error: serverException);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(isA<DioException>()
          .having((e) => e.type, 'type', 'equals', DioExceptionType.badResponse)),
    );
    verifyGetCalled();

    // Cleanup
    tearDown();
  }
}