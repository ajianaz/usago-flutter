import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  static bool _isInitialized = false;
  static late Environment _currentEnvironment;
  static late Map<String, String> _envMap;

  /// Initialize environment configuration
  static Future<void> initialize({String? envFileName}) async {
    if (_isInitialized) return;

    try {
      // Determine which .env file to load
      String fileName = envFileName ?? _getEnvFileName();

      // Load the appropriate .env file
      await dotenv.load(fileName: fileName);
      _envMap = dotenv.env;

      // Set current environment
      final envString = _envMap['FLUTTER_ENV'] ?? 'development';
      _currentEnvironment = _parseEnvironment(envString);

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading environment: $e');
      }
      // Fallback to development environment
      _currentEnvironment = Environment.development;
      _envMap = {};
      _isInitialized = true;
    }
  }

  /// Get the appropriate .env file name based on build mode
  static String _getEnvFileName() {
    if (kReleaseMode) {
      return '.env.production';
    } else if (kProfileMode) {
      return '.env.staging';
    } else {
      return '.env.development';
    }
  }

  /// Parse environment string to enum
  static Environment _parseEnvironment(String envString) {
    switch (envString.toLowerCase()) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      case 'development':
      default:
        return Environment.development;
    }
  }

  /// Get current environment
  static Environment get currentEnvironment {
    if (!_isInitialized) {
      throw Exception('EnvConfig not initialized. Call initialize() first.');
    }
    return _currentEnvironment;
  }

  /// Check if current environment is development
  static bool get isDevelopment => currentEnvironment == Environment.development;

  /// Check if current environment is staging
  static bool get isStaging => currentEnvironment == Environment.staging;

  /// Check if current environment is production
  static bool get isProduction => currentEnvironment == Environment.production;

  /// Get environment variable with optional default value
  static String get(String key, {String? defaultValue}) {
    if (!_isInitialized) {
      throw Exception('EnvConfig not initialized. Call initialize() first.');
    }
    return _envMap[key] ?? defaultValue ?? '';
  }

  /// Get environment variable as boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Get environment variable as integer
  static int getInt(String key, {int defaultValue = 0}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return int.tryParse(value) ?? defaultValue;
  }

  /// Get environment variable as double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return double.tryParse(value) ?? defaultValue;
  }

  /// Validate required environment variables
  static List<String> validateRequired(List<String> requiredKeys) {
    final missingKeys = <String>[];

    for (final key in requiredKeys) {
      final value = get(key);
      if (value.isEmpty) {
        missingKeys.add(key);
      }
    }

    return missingKeys;
  }

  /// Get all environment variables (for debugging)
  static Map<String, String> get all {
    if (!_isInitialized) {
      throw Exception('EnvConfig not initialized. Call initialize() first.');
    }
    return Map.unmodifiable(_envMap);
  }

  /// Check if environment variable exists
  static bool contains(String key) {
    if (!_isInitialized) {
      throw Exception('EnvConfig not initialized. Call initialize() first.');
    }
    return _envMap.containsKey(key) && _envMap[key]!.isNotEmpty;
  }
}