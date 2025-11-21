import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Log levels enumeration
enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warning(2, 'WARNING'),
  error(3, 'ERROR'),
  verbose(4, 'VERBOSE'),
  wtf(5, 'WTF');

  const LogLevel(this.value, this.name);

  final int value;
  final String name;

  static LogLevel fromString(String? level) {
    switch (level?.toLowerCase()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warning':
      case 'warn':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'verbose':
        return LogLevel.verbose;
      case 'wtf':
        return LogLevel.wtf;
      default:
        return kDebugMode ? LogLevel.debug : LogLevel.info;
    }
  }
}

/// Logging configuration class
class LoggingConfig {
  final bool isActive;
  final LogLevel level;
  final bool enableColors;
  final bool enableEmojis;
  final bool enableTimestamps;
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;

  const LoggingConfig({
    this.isActive = true,
    this.level = LogLevel.debug,
    this.enableColors = true,
    this.enableEmojis = true,
    this.enableTimestamps = true,
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
  });

  /// Create logging config from environment variables
  factory LoggingConfig.fromEnvironment() {
    // For testing, use compile-time constants to avoid dotenv issues
    final enableLogging =
        const String.fromEnvironment('ENABLE_LOGGING', defaultValue: 'true');
    final logLevel =
        const String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');

    return LoggingConfig(
      isActive: enableLogging == 'true',
      level: LogLevel.fromString(logLevel),
      enableColors: !kReleaseMode,
      enableEmojis: !kReleaseMode,
      enableTimestamps: !kReleaseMode,
      methodCount: kReleaseMode ? 0 : 2,
      errorMethodCount: kReleaseMode ? 0 : 8,
      lineLength: 120,
    );
  }

  /// Initialize dotenv for environment variables
  static Future<void> initialize() async {
    try {
      // Try loading from assets first
      await dotenv.load(fileName: 'assets/.env');
    } catch (e) {
      try {
        // Fallback to root directory
        await dotenv.load(fileName: '.env');
      } catch (e2) {
        // Fallback to compile-time environment if .env file not found
        if (kDebugMode) {
          print(
              'Warning: .env file not found, using compile-time environment variables');
        }
      }
    }
  }

  /// Check if logging is enabled for specific level
  bool isLogEnabled(LogLevel level) {
    if (!isActive) return false;
    return level.value >= this.level.value;
  }

  LoggingConfig copyWith({
    bool? isActive,
    LogLevel? level,
    bool? enableColors,
    bool? enableEmojis,
    bool? enableTimestamps,
    int? methodCount,
    int? errorMethodCount,
    int? lineLength,
  }) {
    return LoggingConfig(
      isActive: isActive ?? this.isActive,
      level: level ?? this.level,
      enableColors: enableColors ?? this.enableColors,
      enableEmojis: enableEmojis ?? this.enableEmojis,
      enableTimestamps: enableTimestamps ?? this.enableTimestamps,
      methodCount: methodCount ?? this.methodCount,
      errorMethodCount: errorMethodCount ?? this.errorMethodCount,
      lineLength: lineLength ?? this.lineLength,
    );
  }
}
