/// Test constants and fixtures for core module testing
class CoreTestConstants {
  // Network test data
  static const String testBaseUrl = 'https://api.test.com';
  static const String testEndpoint = '/test/endpoint';
  static const String testAuthToken = 'Bearer test_auth_token_12345';
  static const String testApiKey = 'test_api_key_67890';

  // Test responses
  static const Map<String, dynamic> successResponseData = {
    'success': true,
    'message': 'Operation successful',
    'data': {'id': 1, 'name': 'Test Data'},
  };

  static const Map<String, dynamic> errorResponseData = {
    'success': false,
    'message': 'Operation failed',
    'error': 'TEST_ERROR',
  };

  static const Map<String, dynamic> validationErrorResponseData = {
    'success': false,
    'message': 'Validation failed',
    'error': 'VALIDATION_ERROR',
    'errors': {
      'field1': ['Error message 1'],
      'field2': ['Error message 2'],
    },
  };

  // Error messages
  static const String networkErrorMessage = 'Network error occurred';
  static const String serverErrorMessage = 'Internal server error';
  static const String validationErrorMessage = 'Validation failed';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String unauthorizedMessage = 'Unauthorized access';
  static const String forbiddenMessage = 'Access forbidden';
  static const String notFoundMessage = 'Resource not found';

  // Test timeouts
  static const Duration testTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(minutes: 2);

  // Performance test constants
  static const String testOperationName = 'test_operation';
  static const String testPerformanceCategory = 'test';
  static const Duration slowOperationThreshold = Duration(seconds: 1);
  static const Duration criticalOperationThreshold = Duration(seconds: 5);

  // Storage test constants
  static const String testStorageKey = 'test_key';
  static const String testStorageValue = 'test_value';
  static const String testSecureKey = 'secure_test_key';
  static const String testSecureValue = 'secure_test_value';

  // Platform test constants
  static const String testPlatform = 'TestPlatform';
  static const String testPlatformVersion = '1.0.0';
  static const String testDeviceId = 'test_device_123';

  // Test platform names
  static const List<String> testPlatformNames = [
    'iOS',
    'Android',
    'Web',
    'Windows',
    'macOS',
    'Linux',
  ];

  // Logging test constants
  static const String testLogMessage = 'Test log message';
  static const String testLogTag = 'TestTag';
  static const String testErrorStackTrace = 'Test stack trace';

  // HTTP test constants
  static const Map<String, String> testHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'TestApp/1.0',
  };

  static const Map<String, dynamic> testQueryParams = {
    'page': 1,
    'limit': 10,
    'sort': 'created_at',
    'order': 'desc',
  };

  static const Map<String, dynamic> testRequestBody = {
    'name': 'Test Name',
    'email': 'test@example.com',
    'active': true,
  };

  // Performance metrics test data
  static const Map<String, dynamic> testPerformanceMetric = {
    'name': 'test_operation',
    'category': 'test',
    'duration': 100000, // microseconds
    'timestamp': '2023-12-15T10:30:00.000Z',
    'metadata': {'test': true},
  };

  static const Map<String, dynamic> testTransitionMetric = {
    'blocType': 'TestBloc',
    'eventType': 'TestEvent',
    'fromState': 'InitialState',
    'toState': 'LoadedState',
    'timestamp': '2023-12-15T10:30:00.000Z',
    'processingTime': 50000, // microseconds
  };

  static const Map<String, dynamic> testErrorMetric = {
    'blocType': 'TestBloc',
    'error': 'Test error message',
    'stackTrace': 'Test stack trace',
    'timestamp': '2023-12-15T10:30:00.000Z',
  };

  // Environment test constants
  static const String testEnvironment = 'test';
  static const String testAppName = 'TestApp';
  static const String testAppVersion = '1.0.0';
  static const String testBuildNumber = '1';

  // Security test constants
  static const String testEncryptionKey = 'test_encryption_key_32_chars';
  static const String testEncryptedData = 'encrypted_data_here';
  static const String testDecryptedData = 'decrypted_data_here';

  // Configuration test constants
  static const Map<String, dynamic> testConfig = {
    'apiBaseUrl': testBaseUrl,
    'timeout': 30,
    'retryAttempts': 3,
    'enableLogging': true,
    'debugMode': true,
  };

  // Test data variations
  static const List<String> testEmails = [
    'valid@example.com',
    'user.name+tag@domain.co.uk',
    'user123@test-domain.com',
    'invalid-email',
    '',
    '@missing-local.com',
    'missing-domain@',
  ];

  static const List<String> testPasswords = [
    'ValidPass123!',
    'short',
    'longenoughbutnonumber',
    'longenoughbutnouppercase',
    'longenoughbutnolowercase',
    '12345678',
    '',
  ];

  static const List<String> testUrls = [
    'https://example.com',
    'http://localhost:3000',
    'ftp://files.example.com',
    'invalid-url',
    '',
    'not-a-url',
  ];

  static const List<int> testStatusCodes = [
    200, 201, 204, 400, 401, 403, 404, 422, 429, 500, 502, 503,
  ];

  // Test timestamps
  static final DateTime testTimestamp = DateTime(2023, 12, 15, 10, 30, 0);
  static final DateTime testFutureTimestamp = DateTime.now().add(const Duration(days: 1));
  static final DateTime testPastTimestamp = DateTime.now().subtract(const Duration(days: 1));

  // Test file paths
  static const String testFilePath = '/test/path/file.txt';
  static const String testFileName = 'test_file.txt';
  static const String testDirectoryPath = '/test/path';

  // Test memory sizes (in bytes)
  static const int testMemorySize = 1024 * 1024; // 1MB
  static const int testLargeMemorySize = 10 * 1024 * 1024; // 10MB
  static const int testSmallMemorySize = 1024; // 1KB

  // Test identifiers
  static const String testId = 'test_id_12345';
  static const String testUuid = '550e8400-e29b-41d4-a716-446655440000';
  static const String testHash = 'a1b2c3d4e5f6';

  // Test limits and thresholds
  static const int maxRetryAttempts = 3;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxRequestSize = 1024 * 1024; // 1MB
  static const Duration maxCacheAge = Duration(hours: 24);

  // Feature flags for testing
  static const bool testFeatureEnabled = true;
  static const bool testFeatureDisabled = false;
  static const Map<String, bool> testFeatureFlags = {
    'feature1': true,
    'feature2': false,
    'feature3': true,
  };

  // Test locale and language
  static const String testLocale = 'en_US';
  static const String testLanguage = 'en';
  static const String testCountry = 'US';
  static const List<String> testSupportedLocales = ['en_US', 'id_ID'];

  // Test theme and UI constants
  static const String testTheme = 'light';
  static const String testColorScheme = 'blue';
  static const double testFontSize = 16.0;
  static const double testScreenDensity = 2.0;

  // Test device information
  static const Map<String, dynamic> testDeviceInfo = {
    'platform': testPlatform,
    'version': testPlatformVersion,
    'deviceId': testDeviceId,
    'isPhysicalDevice': true,
    'isDebugMode': true,
  };

  // Test network information
  static const Map<String, dynamic> testNetworkInfo = {
    'isConnected': true,
    'connectionType': 'wifi',
    'signalStrength': 'excellent',
    'ipAddress': '192.168.1.100',
  };

  // Test battery information
  static const Map<String, dynamic> testBatteryInfo = {
    'level': 85,
    'isCharging': false,
    'isPowerSaveMode': false,
  };

  // Test application state
  static const Map<String, dynamic> testAppState = {
    'isForeground': true,
    'isPaused': false,
    'isDetached': false,
    'isResumed': true,
    'isInactive': false,
  };
}
