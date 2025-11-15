import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import '../../../lib/core/network/dio_client.dart';
import '../../../lib/core/services/secure_storage_service.dart';
import '../../../lib/core/services/enhanced_secure_storage_service.dart';
import '../../../lib/core/performance/performance_tracker.dart';
import '../../../lib/core/utils/logger.dart';
import '../../../lib/core/platform/platform_detector.dart';
import '../../../lib/core/config/env_config.dart';
import '../../../lib/core/config/app_config.dart';
import '../../../lib/core/errors/error_handler.dart';

/// Mock implementation of DioClient
class MockDioClient extends Mock implements DioClient {}

/// Mock implementation of SecureStorageService
class MockSecureStorageService extends Mock implements SecureStorageService {}

/// Mock implementation of EnhancedSecureStorageService
class MockEnhancedSecureStorageService extends Mock implements EnhancedSecureStorageService {}

/// Mock implementation of PerformanceTracker
class MockPerformanceTracker extends Mock implements PerformanceTracker {}

/// Mock implementation of AppLogger
class MockAppLogger extends Mock implements AppLogger {}

/// Mock implementation of PlatformDetector
class MockPlatformDetector extends Mock implements PlatformDetector {}

/// Mock implementation of EnvConfig
class MockEnvConfig extends Mock implements EnvConfig {}

/// Mock implementation of AppConfig
class MockAppConfig extends Mock implements AppConfig {}

/// Mock implementation of ErrorHandler
class MockErrorHandler extends Mock implements ErrorHandler {}

/// Helper class for setting up common mock scenarios
class CoreMockSetupHelpers {
  /// Setup successful network response
  static void setupSuccessResponse(
    MockDioClient mockClient,
    Map<String, dynamic> responseData,
  ) {
    when(mockClient.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);

    when(mockClient.post(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);

    when(mockClient.put(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);

    when(mockClient.delete(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);
  }

  /// Setup successful network response with headers
  static void setupSuccessResponseWithHeaders(
    MockDioClient mockClient,
    Map<String, dynamic> responseData,
    Map<String, String> headers,
  ) {
    when(mockClient.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);

    when(mockClient.post(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenAnswer((_) async => responseData);
  }

  /// Setup network error response
  static void setupNetworkError(
    MockDioClient mockClient,
    Exception error,
  ) {
    when(mockClient.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.post(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.put(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.delete(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);
  }

  /// Setup DioException error
  static void setupDioException(
    MockDioClient mockClient,
    DioException error,
  ) {
    when(mockClient.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.post(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.put(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);

    when(mockClient.delete(any, data: anyNamed('data'), queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
        .thenThrow(error);
  }

  /// Setup successful storage operations
  static void setupStorageSuccess(
    MockSecureStorageService mockStorage,
    String key,
    String value,
  ) {
    when(mockStorage.saveSecureData(key, value))
        .thenAnswer((_) async {});

    when(mockStorage.getSecureData(key))
        .thenAnswer((_) async => value);

    when(mockStorage.removeSecureData(key))
        .thenAnswer((_) async {});

    when(mockStorage.saveNonSecureData(key, value))
        .thenAnswer((_) async {});

    when(mockStorage.getNonSecureData(key))
        .thenAnswer((_) async => value);

    when(mockStorage.removeNonSecureData(key))
        .thenAnswer((_) async {});
  }

  /// Setup storage error
  static void setupStorageError(
    MockSecureStorageService mockStorage,
    Exception error,
  ) {
    when(mockStorage.saveSecureData(any, any))
        .thenThrow(error);

    when(mockStorage.getSecureData(any))
        .thenThrow(error);

    when(mockStorage.removeSecureData(any))
        .thenThrow(error);

    when(mockStorage.saveNonSecureData(any, any))
        .thenThrow(error);

    when(mockStorage.getNonSecureData(any))
        .thenThrow(error);

    when(mockStorage.removeNonSecureData(any))
        .thenThrow(error);
  }

  /// Setup successful performance tracking
  static void setupPerformanceTrackingSuccess(
    MockPerformanceTracker mockTracker,
    String trackingId,
  ) {
    when(mockTracker.startTracking(any, category: anyNamed('category')))
        .thenReturn(trackingId);

    when(mockTracker.stopTracking(trackingId, metadata: anyNamed('metadata'), stackTrace: anyNamed('stackTrace')))
        .thenReturn(null);
  }

  /// Setup performance tracking error
  static void setupPerformanceTrackingError(
    MockPerformanceTracker mockTracker,
    Exception error,
  ) {
    when(mockTracker.startTracking(any, category: anyNamed('category')))
        .thenThrow(error);
  }

  /// Setup successful logging
  static void setupLoggingSuccess(MockAppLogger mockLogger) {
    when(mockLogger.debug(any, any, any))
        .thenReturn(null);

    when(mockLogger.info(any, any, any))
        .thenReturn(null);

    when(mockLogger.warning(any, any, any))
        .thenReturn(null);

    when(mockLogger.error(any, any, any))
        .thenReturn(null);

    when(mockLogger.verbose(any, any, any))
        .thenReturn(null);

    when(mockLogger.wtf(any, any, any))
        .thenReturn(null);
  }

  /// Setup platform detection
  static void setupPlatformDetection(
    MockPlatformDetector mockDetector,
    bool isMobile,
    bool isWeb,
    bool isDesktop,
    String platformName,
  ) {
    when(mockDetector.isMobile)
        .thenReturn(isMobile);

    when(mockDetector.isWeb)
        .thenReturn(isWeb);

    when(mockDetector.isDesktop)
        .thenReturn(isDesktop);

    when(mockDetector.platformName)
        .thenReturn(platformName);

    when(mockDetector.isFeatureSupported(any))
        .thenReturn(true);
  }

  /// Setup environment configuration
  static void setupEnvConfig(
    MockEnvConfig mockConfig,
    String baseUrl,
    String environment,
    bool enableLogging,
  ) {
    when(mockConfig.apiBaseUrl)
        .thenReturn(baseUrl);

    when(mockConfig.environment)
        .thenReturn(environment);

    when(mockConfig.enableLogging)
        .thenReturn(enableLogging);

    when(mockConfig.isDevelopment)
        .thenReturn(environment == 'development');

    when(mockConfig.isProduction)
        .thenReturn(environment == 'production');

    when(mockConfig.isStaging)
        .thenReturn(environment == 'staging');
  }

  /// Setup app configuration
  static void setupAppConfig(
    MockAppConfig mockConfig,
    String appName,
    String appVersion,
    bool debugMode,
  ) {
    when(mockConfig.appName)
        .thenReturn(appName);

    when(mockConfig.appVersion)
        .thenReturn(appVersion);

    when(mockConfig.debugMode)
        .thenReturn(debugMode);

    when(mockConfig.enableLogging)
        .thenReturn(true);
  }

  /// Setup error handler
  static void setupErrorHandler(
    MockErrorHandler mockHandler,
    String errorMessage,
  ) {
    when(mockHandler.handleError(any, any))
        .thenReturn(errorMessage);

    when(mockHandler.logError(any, any))
        .thenReturn(null);
  }
}