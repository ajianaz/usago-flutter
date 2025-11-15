import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'core_mocks.dart';
import 'core_test_helpers.dart';
import 'test_constants.dart';
import '../../../lib/core/errors/failure.dart';
import '../../../lib/core/errors/exceptions.dart';
import '../../../lib/core/performance/performance_tracker.dart';
import '../../../lib/core/network/dio_client.dart';
import '../../../lib/core/services/secure_storage_service.dart';
import '../../../lib/core/utils/logger.dart';
import '../../../lib/core/platform/platform_detector.dart';
import '../../../lib/core/config/env_config.dart';
import '../../../lib/core/config/app_config.dart';
import '../../../lib/core/errors/error_handler.dart';

/// Base test class for core module tests
/// Provides common setup, teardown, and utility methods
abstract class CoreTestBase {
  // Mock instances
  late MockDioClient mockDioClient;
  late MockSecureStorageService mockSecureStorageService;
  late MockEnhancedSecureStorageService mockEnhancedSecureStorageService;
  late MockPerformanceTracker mockPerformanceTracker;
  late MockAppLogger mockAppLogger;
  late MockPlatformDetector mockPlatformDetector;
  late MockEnvConfig mockEnvConfig;
  late MockAppConfig mockAppConfig;
  late MockErrorHandler mockErrorHandler;

  // Common test data
  late Map<String, dynamic> successResponse;
  late Map<String, dynamic> errorResponse;
  late Map<String, dynamic> validationErrorResponse;
  late PerformanceMetric testPerformanceMetric;
  late DioException testDioException;

  // Common test failures
  late NetworkFailure networkFailure;
  late ServerFailure serverFailure;
  late ValidationFailure validationFailure;
  late TimeoutFailure timeoutFailure;

  /// Setup method called before each test
  void setUp() {
    // Initialize mocks
    mockDioClient = MockDioClient();
    mockSecureStorageService = MockSecureStorageService();
    mockEnhancedSecureStorageService = MockEnhancedSecureStorageService();
    mockPerformanceTracker = MockPerformanceTracker();
    mockAppLogger = MockAppLogger();
    mockPlatformDetector = MockPlatformDetector();
    mockEnvConfig = MockEnvConfig();
    mockAppConfig = MockAppConfig();
    mockErrorHandler = MockErrorHandler();

    // Initialize test data
    successResponse = CoreTestConstants.successResponseData;
    errorResponse = CoreTestConstants.errorResponseData;
    validationErrorResponse = CoreTestConstants.validationErrorResponseData;
    testPerformanceMetric = CoreTestHelpers.createTestPerformanceMetric();
    testDioException = CoreTestHelpers.createTestDioException();

    // Initialize test failures
    networkFailure = CoreTestHelpers.createNetworkFailure();
    serverFailure = CoreTestHelpers.createServerFailure();
    validationFailure = CoreTestHelpers.createValidationFailure();
    timeoutFailure = CoreTestHelpers.createTimeoutFailure();

    // Setup default mock behaviors
    _setupDefaultMockBehaviors();
  }

  /// Teardown method called after each test
  void tearDown() {
    // Reset all mocks to clean state
    reset(mockDioClient);
    reset(mockSecureStorageService);
    reset(mockEnhancedSecureStorageService);
    reset(mockPerformanceTracker);
    reset(mockAppLogger);
    reset(mockPlatformDetector);
    reset(mockEnvConfig);
    reset(mockAppConfig);
    reset(mockErrorHandler);
  }

  /// Setup default mock behaviors
  void _setupDefaultMockBehaviors() {
    // Setup successful network responses
    CoreMockSetupHelpers.setupSuccessResponse(mockDioClient, successResponse);

    // Setup successful storage operations
    CoreMockSetupHelpers.setupStorageSuccess(
      mockSecureStorageService,
      CoreTestConstants.testStorageKey,
      CoreTestConstants.testStorageValue,
    );

    // Setup successful performance tracking
    CoreMockSetupHelpers.setupPerformanceTrackingSuccess(
      mockPerformanceTracker,
      CoreTestConstants.testOperationName,
    );

    // Setup successful logging
    CoreMockSetupHelpers.setupLoggingSuccess(mockAppLogger);

    // Setup platform detection
    CoreMockSetupHelpers.setupPlatformDetection(
      mockPlatformDetector,
      true, // isMobile
      false, // isWeb
      false, // isDesktop
      CoreTestConstants.testPlatform,
    );

    // Setup environment configuration
    CoreMockSetupHelpers.setupEnvConfig(
      mockEnvConfig,
      CoreTestConstants.testBaseUrl,
      CoreTestConstants.testEnvironment,
      true, // enableLogging
    );

    // Setup app configuration
    CoreMockSetupHelpers.setupAppConfig(
      mockAppConfig,
      CoreTestConstants.testAppName,
      CoreTestConstants.testAppVersion,
      true, // debugMode
    );

    // Setup error handler
    CoreMockSetupHelpers.setupErrorHandler(
      mockErrorHandler,
      CoreTestConstants.networkErrorMessage,
    );
  }

  /// Setup successful network scenario
  void setupNetworkSuccess() {
    CoreMockSetupHelpers.setupSuccessResponse(mockDioClient, successResponse);
  }

  /// Setup network error scenario
  void setupNetworkError([Exception? error]) {
    CoreMockSetupHelpers.setupNetworkError(
      mockDioClient,
      error ?? testDioException,
    );
  }

  /// Setup DioException scenario
  void setupDioException([DioException? error]) {
    CoreMockSetupHelpers.setupDioException(
      mockDioClient,
      error ?? testDioException,
    );
  }

  /// Setup storage success scenario
  void setupStorageSuccess({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
  }) {
    CoreMockSetupHelpers.setupStorageSuccess(mockSecureStorageService, key, value);
  }

  /// Setup storage error scenario
  void setupStorageError([Exception? error]) {
    final storageError = Exception('Storage operation failed');
    CoreMockSetupHelpers.setupStorageError(
      mockSecureStorageService,
      error ?? storageError,
    );
  }

  /// Setup performance tracking success
  void setupPerformanceSuccess({
    String trackingId = CoreTestConstants.testOperationName,
  }) {
    CoreMockSetupHelpers.setupPerformanceTrackingSuccess(mockPerformanceTracker, trackingId);
  }

  /// Setup performance tracking error
  void setupPerformanceError([Exception? error]) {
    final perfError = Exception('Performance tracking failed');
    CoreMockSetupHelpers.setupPerformanceTrackingError(
      mockPerformanceTracker,
      error ?? perfError,
    );
  }

  /// Setup logging success
  void setupLoggingSuccess() {
    CoreMockSetupHelpers.setupLoggingSuccess(mockAppLogger);
  }

  /// Setup platform detection
  void setupPlatformDetection({
    bool isMobile = true,
    bool isWeb = false,
    bool isDesktop = false,
    String platformName = CoreTestConstants.testPlatform,
  }) {
    CoreMockSetupHelpers.setupPlatformDetection(
      mockPlatformDetector,
      isMobile,
      isWeb,
      isDesktop,
      platformName,
    );
  }

  /// Setup environment configuration
  void setupEnvConfig({
    String baseUrl = CoreTestConstants.testBaseUrl,
    String environment = CoreTestConstants.testEnvironment,
    bool enableLogging = true,
  }) {
    CoreMockSetupHelpers.setupEnvConfig(
      mockEnvConfig,
      baseUrl,
      environment,
      enableLogging,
    );
  }

  /// Setup app configuration
  void setupAppConfig({
    String appName = CoreTestConstants.testAppName,
    String appVersion = CoreTestConstants.testAppVersion,
    bool debugMode = true,
  }) {
    CoreMockSetupHelpers.setupAppConfig(
      mockAppConfig,
      appName,
      appVersion,
      debugMode,
    );
  }

  /// Setup error handler
  void setupErrorHandler({
    String errorMessage = CoreTestConstants.networkErrorMessage,
  }) {
    CoreMockSetupHelpers.setupErrorHandler(mockErrorHandler, errorMessage);
  }

  /// Verify mock was called exactly once
  void verifyCalledOnce(Mock mock) {
    CoreTestHelpers.verifyCalledOnce(mock);
  }

  /// Verify mock was never called
  void verifyNeverCalled(Mock mock) {
    CoreTestHelpers.verifyNeverCalled(mock);
  }

  /// Verify mock was called specific number of times
  void verifyCalledTimes(Mock mock, int count) {
    CoreTestHelpers.verifyCalledTimes(mock, count);
  }

  /// Verify no more interactions
  void verifyNoMoreInteractions() {
    verifyNoMoreInteractions([
      mockDioClient,
      mockSecureStorageService,
      mockEnhancedSecureStorageService,
      mockPerformanceTracker,
      mockAppLogger,
      mockPlatformDetector,
      mockEnvConfig,
      mockAppConfig,
      mockErrorHandler,
    ]);
  }

  /// Create test response data
  Map<String, dynamic> createTestResponseData({
    String? message,
    Map<String, dynamic>? data,
    bool success = true,
  }) {
    return {
      'success': success,
      'message': message ?? 'Test operation successful',
      'data': data ?? {'id': 1, 'name': 'Test Data'},
    };
  }

  /// Create test error data
  Map<String, dynamic> createTestErrorData({
    String? message,
    String? error,
    Map<String, dynamic>? errors,
  }) {
    return {
      'success': false,
      'message': message ?? 'Test operation failed',
      'error': error ?? 'TEST_ERROR',
      if (errors != null) 'errors': errors,
    };
  }

  /// Create test performance metric
  PerformanceMetric createTestPerformanceMetric({
    String name = CoreTestConstants.testOperationName,
    String category = CoreTestConstants.testPerformanceCategory,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) {
    return CoreTestHelpers.createTestPerformanceMetric(
      name: name,
      category: category,
      duration: duration,
      metadata: metadata ?? CoreTestHelpers.createTestMetadata(),
    );
  }

  /// Create test timeout
  Duration createTestTimeout({
    int seconds = 30,
  }) {
    return Duration(seconds: seconds);
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
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (active != null) 'active': active,
    };
  }

  /// Wait for async operations
  Future<void> waitForAsyncOperations([Duration? duration]) {
    return Future.delayed(duration ?? CoreTestConstants.testTimeout);
  }

  /// Create test exception
  Exception createTestException({
    String message = 'Test exception',
  }) {
    return Exception(message);
  }

  /// Create test DioException
  DioException createTestDioException({
    DioExceptionType type = DioExceptionType.connectionTimeout,
    String? message,
  }) {
    return CoreTestHelpers.createTestDioException(
      type: type,
      message: message,
    );
  }
}