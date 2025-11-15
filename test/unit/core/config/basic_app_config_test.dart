import 'package:flutter_test/flutter_test.dart';
import 'package:usago/core/config/app_config.dart';
import 'package:usago/core/config/env_config.dart';

void main() {
  group('AppConfig Basic Tests', () {
    setUpAll(() async {
      // Initialize EnvConfig with empty map for testing
      await EnvConfig.initialize();
    });
    test('should return default values when environment is not initialized', () {
      // Test that AppConfig doesn't crash when environment is not set
      expect(() => AppConfig.apiBaseUrl, returnsNormally);
      expect(() => AppConfig.apiVersion, returnsNormally);
      expect(() => AppConfig.apiTimeout, returnsNormally);
    });

    test('should return correct default values', () {
      // Test default values that should be hardcoded in AppConfig
      expect(AppConfig.apiVersion, equals('v1')); // Default value
      expect(AppConfig.contentTypeHeader, equals('application/json')); // Default value
      expect(AppConfig.acceptHeader, equals('application/json')); // Default value
      expect(AppConfig.bearerTokenHeader, equals('Authorization')); // Default value
    });

    test('should return correct default response codes', () {
      expect(AppConfig.successCode, equals(200));
      expect(AppConfig.unauthorizedCode, equals(401));
      expect(AppConfig.forbiddenCode, equals(403));
      expect(AppConfig.notFoundCode, equals(404));
      expect(AppConfig.serverErrorCode, equals(500));
    });

    test('should have environment information methods', () {
      // Test that environment methods exist and return boolean values
      expect(AppConfig.isDevelopment, isA<bool>());
      expect(AppConfig.isStaging, isA<bool>());
      expect(AppConfig.isProduction, isA<bool>());
      expect(AppConfig.environment, isA<String>());
    });

    test('should have feature flag methods', () {
      // Test that feature flag methods exist and return boolean values
      expect(AppConfig.enableLogging, isA<bool>());
      expect(AppConfig.enableCrashReporting, isA<bool>());
      expect(AppConfig.enableAnalytics, isA<bool>());
    });

    test('should have security methods', () {
      // Test that security methods exist and return string values
      expect(AppConfig.encryptionKey, isA<String>());
      expect(AppConfig.jwtSecret, isA<String>());
    });

    test('should have debug methods', () {
      // Test that debug methods exist
      expect(AppConfig.debugMode, isA<bool>());
      expect(AppConfig.logLevel, isA<String>());
    });

    test('should validate required variables method exists', () {
      // Test that validation method exists and returns list
      final missingVars = AppConfig.validateRequiredVariables();
      expect(missingVars, isA<List<String>>());
    });

    test('should have configuration validation method', () {
      // Test that configuration validation method exists
      expect(AppConfig.isConfigValid, isA<bool>());
    });

    test('should have debug print method', () {
      // Test that debug print method exists and doesn't crash
      expect(() => AppConfig.debugPrintConfig(), returnsNormally);
    });
  });
}