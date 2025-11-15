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

  // Performance Configuration
  static bool get enablePerformanceMonitoring => EnvConfig.getBool('ENABLE_PERFORMANCE_MONITORING', defaultValue: kDebugMode);
  static bool get enableMemoryMonitoring => EnvConfig.getBool('ENABLE_MEMORY_MONITORING', defaultValue: kDebugMode);
  static bool get enableBlocMonitoring => EnvConfig.getBool('ENABLE_BLOC_MONITORING', defaultValue: kDebugMode);
  static bool get enableAutoOptimization => EnvConfig.getBool('ENABLE_AUTO_OPTIMIZATION', defaultValue: !kDebugMode);
  static bool get enablePerformanceReporting => EnvConfig.getBool('ENABLE_PERFORMANCE_REPORTING', defaultValue: kDebugMode);
  static bool get enablePerformanceExport => EnvConfig.getBool('ENABLE_PERFORMANCE_EXPORT', defaultValue: kDebugMode);

  // Memory Configuration
  static double get memoryWarningThreshold => EnvConfig.getDouble('MEMORY_WARNING_THRESHOLD', defaultValue: 70.0);
  static double get memoryCriticalThreshold => EnvConfig.getDouble('MEMORY_CRITICAL_THRESHOLD', defaultValue: 85.0);
  static int get maxMetricsHistory => EnvConfig.getInt('MAX_METRICS_HISTORY', defaultValue: 1000);
  static Duration get memoryMonitoringInterval => Duration(
    seconds: EnvConfig.getInt('MEMORY_MONITORING_INTERVAL_SECONDS', defaultValue: 30)
  );

  // BLoC Performance Configuration
  static Duration get slowBlocEventWarning => Duration(
    milliseconds: EnvConfig.getInt('SLOW_BLOC_EVENT_WARNING_MS', defaultValue: 100)
  );
  static Duration get slowBlocEventCritical => Duration(
    milliseconds: EnvConfig.getInt('SLOW_BLOC_EVENT_CRITICAL_MS', defaultValue: 500)
  );
  static int get maxActiveBlocs => EnvConfig.getInt('MAX_ACTIVE_BLOCS', defaultValue: 20);
  static Duration get blocCleanupInterval => Duration(
    minutes: EnvConfig.getInt('BLOC_CLEANUP_INTERVAL_MINUTES', defaultValue: 5)
  );

  // Performance Tracking Configuration
  static Duration get performanceMonitoringInterval => Duration(
    seconds: EnvConfig.getInt('PERFORMANCE_MONITORING_INTERVAL_SECONDS', defaultValue: 60)
  );
  static Duration get performanceCleanupInterval => Duration(
    minutes: EnvConfig.getInt('PERFORMANCE_CLEANUP_INTERVAL_MINUTES', defaultValue: 10)
  );
  static Duration get slowOperationWarning => Duration(
    milliseconds: EnvConfig.getInt('SLOW_OPERATION_WARNING_MS', defaultValue: 500)
  );
  static Duration get slowOperationCritical => Duration(
    seconds: EnvConfig.getInt('SLOW_OPERATION_CRITICAL_SECONDS', defaultValue: 2)
  );

  // Performance Reporting Configuration
  static Duration get performanceReportingInterval => Duration(
    minutes: EnvConfig.getInt('PERFORMANCE_REPORTING_INTERVAL_MINUTES', defaultValue: 2)
  );
  static String get performanceExportPath => EnvConfig.get('PERFORMANCE_EXPORT_PATH', defaultValue: '/tmp/performance_logs');

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

  // Performance validation
  static List<String> validatePerformanceVariables() {
    final issues = <String>[];

    // Memory validation
    if (memoryWarningThreshold >= memoryCriticalThreshold) {
      issues.add('MEMORY_WARNING_THRESHOLD should be less than MEMORY_CRITICAL_THRESHOLD');
    }

    if (memoryWarningThreshold < 0 || memoryWarningThreshold > 100) {
      issues.add('MEMORY_WARNING_THRESHOLD should be between 0 and 100');
    }

    if (memoryCriticalThreshold < 0 || memoryCriticalThreshold > 100) {
      issues.add('MEMORY_CRITICAL_THRESHOLD should be between 0 and 100');
    }

    // Metrics validation
    if (maxMetricsHistory < 100) {
      issues.add('MAX_METRICS_HISTORY should be at least 100');
    }

    // Performance monitoring validation
    if (performanceMonitoringInterval.inSeconds < 10) {
      issues.add('PERFORMANCE_MONITORING_INTERVAL_SECONDS should be at least 10');
    }

    if (performanceCleanupInterval.inMinutes < 1) {
      issues.add('PERFORMANCE_CLEANUP_INTERVAL_MINUTES should be at least 1');
    }

    // Memory monitoring validation
    if (memoryMonitoringInterval.inSeconds < 5) {
      issues.add('MEMORY_MONITORING_INTERVAL_SECONDS should be at least 5');
    }

    // BLoC performance validation
    if (slowBlocEventWarning.inMilliseconds >= slowBlocEventCritical.inMilliseconds) {
      issues.add('SLOW_BLOC_EVENT_WARNING_MS should be less than SLOW_BLOC_EVENT_CRITICAL_MS');
    }

    if (maxActiveBlocs < 5) {
      issues.add('MAX_ACTIVE_BLOCS should be at least 5');
    }

    if (blocCleanupInterval.inMinutes < 1) {
      issues.add('BLOC_CLEANUP_INTERVAL_MINUTES should be at least 1');
    }

    // Operation performance validation
    if (slowOperationWarning.inMilliseconds >= slowOperationCritical.inMilliseconds) {
      issues.add('SLOW_OPERATION_WARNING_MS should be less than SLOW_OPERATION_CRITICAL_SECONDS');
    }

    // Performance reporting validation
    if (performanceReportingInterval.inMinutes < 1) {
      issues.add('PERFORMANCE_REPORTING_INTERVAL_MINUTES should be at least 1');
    }

    return issues;
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
      print('');
      print('=== Performance Config ===');
      print('Enable Performance Monitoring: $enablePerformanceMonitoring');
      print('Enable Memory Monitoring: $enableMemoryMonitoring');
      print('Enable BLoC Monitoring: $enableBlocMonitoring');
      print('Enable Auto Optimization: $enableAutoOptimization');
      print('Enable Performance Reporting: $enablePerformanceReporting');
      print('Enable Performance Export: $enablePerformanceExport');
      print('');
      print('=== Memory Config ===');
      print('Memory Warning Threshold: $memoryWarningThreshold%');
      print('Memory Critical Threshold: $memoryCriticalThreshold%');
      print('Memory Monitoring Interval: ${memoryMonitoringInterval.inSeconds}s');
      print('');
      print('=== BLoC Performance Config ===');
      print('Slow BLoC Event Warning: ${slowBlocEventWarning.inMilliseconds}ms');
      print('Slow BLoC Event Critical: ${slowBlocEventCritical.inMilliseconds}ms');
      print('Max Active BLoCs: $maxActiveBlocs');
      print('BLoC Cleanup Interval: ${blocCleanupInterval.inMinutes}m');
      print('');
      print('=== Operation Performance Config ===');
      print('Slow Operation Warning: ${slowOperationWarning.inMilliseconds}ms');
      print('Slow Operation Critical: ${slowOperationCritical.inSeconds}s');
      print('');
      print('=== Performance Reporting Config ===');
      print('Performance Reporting Interval: ${performanceReportingInterval.inMinutes}m');
      print('Performance Export Path: $performanceExportPath');
      print('');
      print('=== General Performance Config ===');
      print('Max Metrics History: $maxMetricsHistory');
      print('Performance Monitoring Interval: ${performanceMonitoringInterval.inSeconds}s');
      print('Performance Cleanup Interval: ${performanceCleanupInterval.inMinutes}m');
      print('=============================');
    }
  }

  // Check if all required variables are set
  static bool get isConfigValid {
    final missingVars = validateRequiredVariables();
    return missingVars.isEmpty;
  }

  // Check if performance configuration is valid
  static bool get isPerformanceConfigValid {
    final issues = validatePerformanceVariables();
    return issues.isEmpty;
  }

  // Get all configuration issues
  static List<String> getAllConfigIssues() {
    final issues = <String>[];
    issues.addAll(validateRequiredVariables());
    issues.addAll(validatePerformanceVariables());
    return issues;
  }

  // Check if performance monitoring should be enabled
  static bool get shouldEnablePerformanceMonitoring {
    return enableLogging && enablePerformanceMonitoring;
  }

  // Check if memory monitoring should be enabled
  static bool get shouldEnableMemoryMonitoring {
    return enableLogging && enableMemoryMonitoring;
  }

  // Check if BLoC monitoring should be enabled
  static bool get shouldEnableBlocMonitoring {
    return enableLogging && enableBlocMonitoring;
  }

  // Check if performance reporting should be enabled
  static bool get shouldEnablePerformanceReporting {
    return enableLogging && enablePerformanceReporting;
  }

  // Check if performance export should be enabled
  static bool get shouldEnablePerformanceExport {
    return kDebugMode && enableLogging && enablePerformanceExport;
  }

  // Get performance thresholds as a map for easy access
  static Map<String, dynamic> get performanceThresholds {
    return {
      'memory': {
        'warning': memoryWarningThreshold,
        'critical': memoryCriticalThreshold,
      },
      'bloc': {
        'eventWarning': slowBlocEventWarning.inMilliseconds,
        'eventCritical': slowBlocEventCritical.inMilliseconds,
        'maxActive': maxActiveBlocs,
      },
      'operation': {
        'warning': slowOperationWarning.inMilliseconds,
        'critical': slowOperationCritical.inMilliseconds,
      },
    };
  }

  // Get performance intervals as a map for easy access
  static Map<String, dynamic> get performanceIntervals {
    return {
      'monitoring': performanceMonitoringInterval.inSeconds,
      'cleanup': performanceCleanupInterval.inMinutes,
      'memory': memoryMonitoringInterval.inSeconds,
      'blocCleanup': blocCleanupInterval.inMinutes,
      'reporting': performanceReportingInterval.inMinutes,
    };
  }
}