import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import '../../../lib/core/config/logging_config.dart';
import '../../../lib/core/utils/logger.dart';

void main() {
  group('Enhanced Logging System Tests', () {
    late LoggingConfig testConfig;
    late AppLogger testLogger;

    setUpAll(() async {
      // Initialize dotenv for all tests
      await LoggingConfig.initialize();
    });

    setUp(() {
      testConfig = LoggingConfig(
        isActive: true,
        level: LogLevel.debug,
        enableColors: false,
        enableEmojis: false,
        enableTimestamps: true,
      );
      testLogger = AppLogger(testConfig);
    });

    test('Should create logger with default configuration', () {
      final defaultLogger = AppLogger();
      expect(defaultLogger.config.isActive, isTrue);
    });

    test('Should respect log level filtering', () {
      // Create logger with INFO level
      final infoLogger = AppLogger(LoggingConfig(
        isActive: true,
        level: LogLevel.info,
      ));

      // These should not log (below INFO level)
      expect(() => infoLogger.debug('Debug message'), returnsNormally);
      expect(() => infoLogger.verbose('Verbose message'), returnsNormally);

      // These should log (INFO level and above)
      expect(() => infoLogger.info('Info message'), returnsNormally);
      expect(() => infoLogger.warning('Warning message'), returnsNormally);
      expect(() => infoLogger.error('Error message'), returnsNormally);
    });

    test('Should disable logging when inactive', () {
      final disabledLogger = AppLogger(LoggingConfig(
        isActive: false,
        level: LogLevel.debug,
      ));

      expect(disabledLogger.config.isActive, isFalse);
      expect(() => disabledLogger.debug('Should not log'), returnsNormally);
      expect(() => disabledLogger.error('Should not log'), returnsNormally);
    });

    test('Should handle performance timers', () {
      testLogger.startPerformanceTimer('test_timer');

      // Should handle ending timer gracefully
      expect(() => testLogger.endPerformanceTimer('test_timer'), returnsNormally);

      // Should handle missing timer gracefully
      expect(() => testLogger.endPerformanceTimer('missing_timer'), returnsNormally);
    });

    test('Should handle structured logging', () {
      final context = {'user_id': '123', 'action': 'login'};

      expect(() => testLogger.logStructured(
        LogLevel.info,
        'User action performed',
        context: context,
      ), returnsNormally);
    });

    test('Should handle network logging', () {
      expect(() => testLogger.logRequest(
        'GET',
        'https://api.example.com/users',
        headers: {'Authorization': 'Bearer token'},
      ), returnsNormally);

      expect(() => testLogger.logResponse(
        'GET',
        'https://api.example.com/users',
        200,
        body: {'users': []},
        duration: 150,
      ), returnsNormally);
    });

    test('Should handle user action logging', () {
      expect(() => testLogger.logUserAction(
        'button_clicked',
        properties: {'button_id': 'login_btn'},
      ), returnsNormally);
    });

    test('Should update configuration at runtime', () {
      // Create a new logger instance to test config update
      final newLogger = AppLogger();
      final newConfig = LoggingConfig(
        isActive: false,
        level: LogLevel.error,
      );

      newLogger.updateConfig(newConfig);

      expect(newLogger.config.isActive, isFalse);
      expect(newLogger.config.level, equals(LogLevel.error));
    });

    test('Should create configuration from environment', () {
      final envConfig = LoggingConfig.fromEnvironment();

      expect(envConfig, isA<LoggingConfig>());
      expect(envConfig.isActive, isA<bool>());
      expect(envConfig.level, isA<LogLevel>());
    });

    test('Should parse log levels correctly', () {
      expect(LogLevel.fromString('debug'), equals(LogLevel.debug));
      expect(LogLevel.fromString('info'), equals(LogLevel.info));
      expect(LogLevel.fromString('warning'), equals(LogLevel.warning));
      expect(LogLevel.fromString('warn'), equals(LogLevel.warning));
      expect(LogLevel.fromString('error'), equals(LogLevel.error));
      expect(LogLevel.fromString('verbose'), equals(LogLevel.verbose));
      expect(LogLevel.fromString('wtf'), equals(LogLevel.wtf));

      // Should default to debug in debug mode or info in release
      final defaultLevel = kDebugMode ? LogLevel.debug : LogLevel.info;
      expect(LogLevel.fromString('invalid'), equals(defaultLevel));
      expect(LogLevel.fromString(null), equals(defaultLevel));
    });

    test('Should copy configuration correctly', () {
      final originalConfig = LoggingConfig(
        isActive: true,
        level: LogLevel.warning,
        enableColors: true,
      );

      final copiedConfig = originalConfig.copyWith(
        isActive: false,
        level: LogLevel.error,
      );

      expect(copiedConfig.isActive, isFalse);
      expect(copiedConfig.level, equals(LogLevel.error));
      expect(copiedConfig.enableColors, isTrue); // Should preserve original value
    });

    test('Should clear performance timers', () {
      testLogger.startPerformanceTimer('timer1');
      testLogger.startPerformanceTimer('timer2');

      expect(() => testLogger.clearPerformanceTimers(), returnsNormally);

      // Should handle ending cleared timers gracefully
      expect(() => testLogger.endPerformanceTimer('timer1'), returnsNormally);
    });
  });
}