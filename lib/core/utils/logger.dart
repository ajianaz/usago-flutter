import 'dart:developer' as developer;
import 'package:injectable/injectable.dart';
import '../config/logging_config.dart';

/// Application logger wrapper
/// Provides centralized logging with different levels and environment control
@singleton
class AppLogger {
  late final LoggingConfig _config;

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
