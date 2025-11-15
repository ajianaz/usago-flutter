import 'package:flutter/foundation.dart';
import 'env_config.dart';

class AppConfig {
  // API Configuration
  static String get apiBaseUrl => EnvConfig.get('API_BASE_URL');
  static Duration get apiTimeout => Duration(
    milliseconds: EnvConfig.getInt('API_TIMEOUT', defaultValue: 30000)
  );
  static String get apiVersion => EnvConfig.get('API_VERSION', defaultValue: 'v1');

  // Headers
  static String get contentTypeHeader => EnvConfig.get('CONTENT_TYPE_HEADER', defaultValue: 'application/json');
  static String get acceptHeader => EnvConfig.get('ACCEPT_HEADER', defaultValue: 'application/json');
  static String get bearerTokenHeader => EnvConfig.get('BEARER_TOKEN_HEADER', defaultValue: 'Authorization');

  // Response Codes
  static int get successCode => EnvConfig.getInt('SUCCESS_CODE', defaultValue: 200);
  static int get unauthorizedCode => EnvConfig.getInt('UNAUTHORIZED_CODE', defaultValue: 401);
  static int get forbiddenCode => EnvConfig.getInt('FORBIDDEN_CODE', defaultValue: 403);
  static int get notFoundCode => EnvConfig.getInt('NOT_FOUND_CODE', defaultValue: 404);
  static int get serverErrorCode => EnvConfig.getInt('SERVER_ERROR_CODE', defaultValue: 500);

  // Feature Flags
  static bool get enableLogging => EnvConfig.getBool('ENABLE_LOGGING', defaultValue: kDebugMode);
  static bool get enableCrashReporting => EnvConfig.getBool('ENABLE_CRASH_REPORTING', defaultValue: !kDebugMode);
  static bool get enableAnalytics => EnvConfig.getBool('ENABLE_ANALYTICS', defaultValue: !kDebugMode);

  // Security
  static String get encryptionKey => EnvConfig.get('ENCRYPTION_KEY');
  static String get jwtSecret => EnvConfig.get('JWT_SECRET');

  // External Services
  static String get sentryDsn => EnvConfig.get('SENTRY_DSN');
  static String get firebaseApiKey => EnvConfig.get('FIREBASE_API_KEY');

  // Debug Settings
  static bool get debugMode => EnvConfig.getBool('DEBUG_MODE', defaultValue: kDebugMode);
  static String get logLevel => EnvConfig.get('LOG_LEVEL', defaultValue: kDebugMode ? 'debug' : 'error');

  // Environment Information
  static String get environment => EnvConfig.currentEnvironment.name;
  static bool get isDevelopment => EnvConfig.isDevelopment;
  static bool get isStaging => EnvConfig.isStaging;
  static bool get isProduction => EnvConfig.isProduction;

  // Validation
  static List<String> validateRequiredVariables() {
    return EnvConfig.validateRequired([
      'API_BASE_URL',
      'API_VERSION',
      'CONTENT_TYPE_HEADER',
      'ACCEPT_HEADER',
      'BEARER_TOKEN_HEADER',
      'ENCRYPTION_KEY',
      'JWT_SECRET',
    ]);
  }

  // Debug helper to print current configuration (only in debug mode)
  static void debugPrintConfig() {
    if (!debugMode) return;

    if (kDebugMode) {
      print('=== AppConfig Debug Info ===');
      print('Environment: $environment');
      print('API Base URL: $apiBaseUrl');
      print('API Version: $apiVersion');
      print('API Timeout: ${apiTimeout.inMilliseconds}ms');
      print('Enable Logging: $enableLogging');
      print('Enable Crash Reporting: $enableCrashReporting');
      print('Enable Analytics: $enableAnalytics');
      print('Debug Mode: $debugMode');
      print('Log Level: $logLevel');
      print('=============================');
    }
  }

  // Check if all required variables are set
  static bool get isConfigValid {
    final missingVars = validateRequiredVariables();
    return missingVars.isEmpty;
  }
}