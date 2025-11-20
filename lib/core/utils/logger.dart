import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../config/logging_config.dart';
import 'log_sanitizer.dart';

/// Custom output that does nothing (for disabled logging)
class EmptyOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Do nothing - logging is disabled
  }
}

/// Application logger wrapper
/// Provides centralized logging with different levels and environment control
@singleton
class AppLogger {
  late final Logger _logger;
  late final LoggingConfig _config;
  final Map<String, DateTime> _performanceTimers = {};

  AppLogger([LoggingConfig? config]) {
    _config = config ?? LoggingConfig.fromEnvironment();
    _initializeLogger();
  }

  void _initializeLogger() {
    if (!_config.isActive) {
      _logger = Logger(
        output: EmptyOutput(),
      );
      return;
    }

    _logger = Logger(
      level: _mapLogLevelToLoggerLevel(_config.level),
      printer: PrettyPrinter(
        methodCount: _config.methodCount,
        errorMethodCount: _config.errorMethodCount,
        lineLength: _config.lineLength,
        colors: _config.enableColors,
        printEmojis: _config.enableEmojis,
        printTime: _config.enableTimestamps,
      ),
      output: MultiOutput([
        if (kDebugMode) ConsoleOutput(),
      ]),
    );
  }

  Level _mapLogLevelToLoggerLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.verbose:
        return Level.verbose;
      case LogLevel.wtf:
        return Level.wtf;
    }
  }

  /// Update logging configuration at runtime
  void updateConfig(LoggingConfig newConfig) {
    _config = newConfig;
    _initializeLogger();
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

  /// Platform-aware logging with developer.log for web/desktop
  void _logWithPlatform(LogLevel level, dynamic message, dynamic error, StackTrace? stackTrace) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] ${level.name}: $message';

    // Use developer.log for web and desktop compatibility
    developer.log(
      logMessage,
      time: DateTime.now(),
      level: _mapLogLevelToInt(level),
      name: 'UsagoApp',
      error: error,
      stackTrace: stackTrace,
    );

    // Also use logger package for console output
    switch (level) {
      case LogLevel.debug:
        _logger.d(message, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.info:
        _logger.i(message, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.warning:
        _logger.w(message, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.error:
        _logger.e(message, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.verbose:
        _logger.t(message, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.wtf:
        _logger.f(message, error: error, stackTrace: stackTrace);
        break;
    }
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

  /// Performance logging - start timer
  void startPerformanceTimer(String key) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    _performanceTimers[key] = DateTime.now();
    debug('⏱️ Performance timer started: $key');
  }

  /// Performance logging - end timer and log duration
  void endPerformanceTimer(String key) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    final startTime = _performanceTimers[key];
    if (startTime == null) {
      warning('⏱️ Performance timer not found: $key');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _performanceTimers.remove(key);

    debug('⏱️ Performance timer ended: $key - ${duration.inMilliseconds}ms');
  }

  /// Structured logging with context
  void logStructured(
    LogLevel level,
    String message, {
    Map<String, dynamic>? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_config.isLogEnabled(level)) return;

    // Sanitize context data to remove sensitive information
    final sanitizedContext = LogSanitizer.sanitizeMap(context);

    final structuredMessage = sanitizedContext != null
        ? '$message | Context: ${sanitizedContext.toString()}'
        : message;

    _logWithPlatform(level, structuredMessage, error, stackTrace);
  }

  /// Network request logging
  void logRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    // Sanitize headers and body to remove sensitive information
    final sanitizedHeaders = LogSanitizer.sanitizeHeaders(headers);
    final sanitizedBody = _sanitizeBody(body);

    logStructured(
      LogLevel.debug,
      '🌐 $method $url',
      context: {
        'method': method,
        'url': url,
        'headers': sanitizedHeaders,
        'body': sanitizedBody,
      },
    );
  }

  /// Network response logging
  void logResponse(
    String method,
    String url,
    int statusCode, {
    Map<String, dynamic>? headers,
    dynamic body,
    int? duration,
  }) {
    if (!_config.isLogEnabled(LogLevel.debug)) return;

    // Sanitize headers and body to remove sensitive information
    final sanitizedHeaders = LogSanitizer.sanitizeHeaders(headers);
    final sanitizedBody = _sanitizeBody(body);

    logStructured(
      LogLevel.debug,
      '🌐 $method $url - $statusCode${duration != null ? ' (${duration}ms)' : ''}',
      context: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'headers': sanitizedHeaders,
        'body': sanitizedBody,
        'duration': duration,
      },
    );
  }

  /// User action logging
  void logUserAction(String action, {Map<String, dynamic>? properties}) {
    if (!_config.isLogEnabled(LogLevel.info)) return;

    // Sanitize properties to remove sensitive information
    final sanitizedProperties = LogSanitizer.sanitizeMap(properties);

    logStructured(
      LogLevel.info,
      '👤 User action: $action',
      context: sanitizedProperties,
    );
  }

  /// Clear all performance timers
  void clearPerformanceTimers() {
    _performanceTimers.clear();
  }

  /// Helper method to sanitize body data based on its type
  dynamic _sanitizeBody(dynamic body) {
    if (body == null) {
      return null;
    }

    if (body is Map<String, dynamic>) {
      return LogSanitizer.sanitizeMap(body);
    } else if (body is String) {
      // Try to parse as JSON first, otherwise sanitize as string
      try {
        return LogSanitizer.sanitizeJsonString(body);
      } catch (e) {
        return LogSanitizer.sanitizeString(body);
      }
    } else if (body is List) {
      return body.map((item) {
        if (item is Map<String, dynamic>) {
          return LogSanitizer.sanitizeMap(item);
        } else if (item is String) {
          return LogSanitizer.sanitizeString(item);
        } else {
          return item;
        }
      }).toList();
    }

    return body;
  }
}