import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usago/core/services/secure_storage_service.dart';
import 'package:usago/core/utils/logger.dart';

// Mock classes for testing
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockAppLogger extends Mock implements AppLogger {}

/// Test setup helper for consistent test configuration
/// Provides unified setup for all test files with proper initialization
class TestSetup {
  /// Initialize test environment with proper bindings and fallbacks
  static Future<void> initTestEnvironment() async {
    // Initialize Flutter bindings for testing
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register fallbacks for mocktail
    registerFallbackValue(MockFlutterSecureStorage());
    registerFallbackValue(MockSharedPreferences());
    registerFallbackValue(MockAppLogger());

    // Create mock instances for fallback
    final mockPrefs = MockSharedPreferences();
    final mockSecureStorage = MockFlutterSecureStorage();
    final mockLogger = MockAppLogger();

    registerFallbackValue(SecureStorageService(
      secureStorage: mockSecureStorage,
      prefs: mockPrefs,
      logger: mockLogger,
    ));
  }

  /// Create configured SecureStorageService for testing
  static Future<SecureStorageService> createSecureStorageService() async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    return SecureStorageService(
      secureStorage: MockFlutterSecureStorage(),
      prefs: prefs,
      logger: MockAppLogger(),
    );
  }

  /// Setup common test dependencies
  static Future<void> setupCommonTestDependencies() async {
    await initTestEnvironment();

    // Set up mock initial values
    SharedPreferences.setMockInitialValues({});
  }
}