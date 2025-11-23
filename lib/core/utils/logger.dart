import 'dart:developer' as developer;
import 'package:injectable/injectable.dart';
import '../config/logging_config.dart';

/// Application logger wrapper
/// Provides centralized logging with different levels and environment control
@singleton
class AppLogger {
  late LoggingConfig _config;
  final Map<String, DateTime> _performanceTimers = {};

  AppLogger([LoggingConfig? config]) {
    _config = config ?? LoggingConfig.fromEnvironment();
  }

  /// Update logging configuration at runtime
  void updateConfig(LoggingConfig newConfig) {
    _config = newConfig;
  }

  /// Get current logging configuration
  LoggingConfig get config => _config;

  /// Debug level logging
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;
    _logWithPlatform(LogLevel.debug, message, error, stackTrace);
  }

  /// Info level logging
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.info)) return;
    _logWithPlatform(LogLevel.info, message, error, stackTrace);
  }

  /// Warning level logging
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.warning)) return;
    _logWithPlatform(LogLevel.warning, message, error, stackTrace);
  }

  /// Error level logging
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.error)) return;
    _logWithPlatform(LogLevel.error, message, error, stackTrace);
  }

  /// Verbose level logging
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.verbose)) return;
    _logWithPlatform(LogLevel.verbose, message, error, stackTrace);
  }

  /// WTF level logging (What a Terrible Failure)
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_config.isLogEnabled(LogLevel.wtf)) return;
    _logWithPlatform(LogLevel.wtf, message, error, stackTrace);
  }

  /// Start a performance timer
  void startPerformanceTimer(String name) {
    _performanceTimers[name] = DateTime.now();
    debug('⏱️ Performance timer started: $name');
  }

  /// End a performance timer and log the duration
  void endPerformanceTimer(String name) {
    final startTime = _performanceTimers[name];
    if (startTime == null) {
      warning('⏱️ Performance timer not found: $name');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _performanceTimers.remove(name);
    info('⏱️ Performance timer [$name]: ${duration.inMilliseconds}ms');
  }

  /// Clear all performance timers
  void clearPerformanceTimers() {
    _performanceTimers.clear();
    debug('⏱️ All performance timers cleared');
  }

  /// Log structured data with context
  void logStructured(
    LogLevel level,
    String message, {
    Map<String, dynamic>? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_config.isLogEnabled(level)) return;

    final contextStr = context != null ? ' | Context: $context' : '';
    final fullMessage = '$message$contextStr';
    _logWithPlatform(level, fullMessage, error, stackTrace);
  }

  /// Log HTTP request
  void logRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    final buffer = StringBuffer('🌐 HTTP Request: $method $url');
    if (headers != null && headers.isNotEmpty) {
      buffer.write(' | Headers: $headers');
    }
    if (body != null) {
      buffer.write(' | Body: $body');
    }

    debug(buffer.toString());
  }

  /// Log HTTP response
  void logResponse(
    String method,
    String url,
    int statusCode, {
    dynamic body,
    int? duration,
  }) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    final buffer =
        StringBuffer('🌐 HTTP Response: $method $url | Status: $statusCode');
    if (duration != null) {
      buffer.write(' | Duration: ${duration}ms');
    }
    if (body != null) {
      buffer.write(' | Body: $body');
    }

    debug(buffer.toString());
  }

  /// Log user action
  void logUserAction(
    String action, {
    Map<String, dynamic>? properties,
  }) {
    if (!_config.isLogEnabled(LogLevel.info)) return;

    final propertiesStr =
        properties != null ? ' | Properties: $properties' : '';
    info('👤 User Action: $action$propertiesStr');
  }

  /// Platform-aware logging with developer.log for clean output
  void _logWithPlatform(
      LogLevel level, dynamic message, dynamic error, StackTrace? stackTrace) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] ${level.name.toUpperCase()}: $message';

    // Use developer.log for clean output
    developer.log(
      logMessage,
      time: DateTime.now(),
      level: _mapLogLevelToInt(level),
      name: 'UsagoApp',
      error: error,
      stackTrace: stackTrace,
    );
  }

  int _mapLogLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.verbose:
        return 400;
      case LogLevel.wtf:
        return 1200;
    }
  }
}
