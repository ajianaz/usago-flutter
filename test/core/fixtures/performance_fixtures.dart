import '../helpers/test_constants.dart';
import '../../../lib/core/performance/performance_tracker.dart';

/// Performance metric fixtures for testing
class PerformanceFixtures {
  /// Create test performance metric
  static PerformanceMetric createTestMetric({
    String name = CoreTestConstants.testOperationName,
    String category = CoreTestConstants.testPerformanceCategory,
    Duration duration = CoreTestConstants.testTimeout,
    Map<String, dynamic>? metadata,
    String? stackTrace,
  }) {
    return PerformanceMetric(
      name: name,
      category: category,
      duration: duration,
      timestamp: CoreTestConstants.testTimestamp,
      metadata: metadata ?? CoreTestConstants.testPerformanceMetric,
      stackTrace: stackTrace,
    );
  }

  /// Create fast performance metric (under threshold)
  static PerformanceMetric createFastMetric({
    String name = 'fast_operation',
    String category = 'ui',
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: const Duration(milliseconds: 50), // Under warning threshold
    );
  }

  /// Create slow performance metric (warning threshold)
  static PerformanceMetric createSlowMetric({
    String name = 'slow_operation',
    String category = 'network',
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: const Duration(milliseconds: 600), // Above warning threshold
    );
  }

  /// Create critical performance metric (critical threshold)
  static PerformanceMetric createCriticalMetric({
    String name = 'critical_operation',
    String category = 'database',
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: const Duration(seconds: 3), // Above critical threshold
    );
  }

  /// Create BLoC event metric
  static PerformanceMetric createBlocMetric({
    String name = 'bloc_event',
    String category = 'bloc_event',
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create UI render metric
  static PerformanceMetric createRenderMetric({
    String name = 'ui_render',
    String category = 'ui',
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create database query metric
  static PerformanceMetric createDatabaseMetric({
    String name = 'database_query',
    String category = 'database',
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create API call metric
  static PerformanceMetric createApiMetric({
    String name = 'api_call',
    String category = 'network',
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create file I/O metric
  static PerformanceMetric createFileIOMetric({
    String name = 'file_io',
    String category = 'storage',
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create encryption metric
  static PerformanceMetric createEncryptionMetric({
    String name = 'encryption',
    String category = 'security',
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return createTestMetric(
      name: name,
      category: category,
      duration: duration,
    );
  }

  /// Create test transition metric
  static TransitionMetric createTestTransition({
    String blocType = 'TestBloc',
    String eventType = 'TestEvent',
    String fromState = 'InitialState',
    String toState = 'LoadedState',
    Duration? processingTime,
  }) {
    return TransitionMetric(
      blocType: blocType,
      eventType: eventType,
      fromState: fromState,
      toState: toState,
      timestamp: CoreTestConstants.testTimestamp,
      processingTime: processingTime,
    );
  }

  /// Create fast transition metric
  static TransitionMetric createFastTransition({
    String blocType = 'TestBloc',
    String eventType = 'FastEvent',
    String fromState = 'LoadingState',
    String toState = 'LoadedState',
  }) {
    return createTestTransition(
      blocType: blocType,
      eventType: eventType,
      fromState: fromState,
      toState: toState,
      processingTime: const Duration(milliseconds: 25),
    );
  }

  /// Create slow transition metric
  static TransitionMetric createSlowTransition({
    String blocType = 'TestBloc',
    String eventType = 'SlowEvent',
    String fromState = 'LoadingState',
    String toState = 'LoadedState',
  }) {
    return createTestTransition(
      blocType: blocType,
      eventType: eventType,
      fromState: fromState,
      toState: toState,
      processingTime: const Duration(milliseconds: 600), // Above warning threshold
    );
  }

  /// Create test error metric
  static ErrorMetric createTestError({
    String blocType = 'TestBloc',
    String error = 'Test error message',
    String stackTrace = 'Test stack trace',
  }) {
    return ErrorMetric(
      blocType: blocType,
      error: error,
      stackTrace: stackTrace,
      timestamp: CoreTestConstants.testTimestamp,
    );
  }

  /// Create critical error metric
  static ErrorMetric createCriticalError({
    String blocType = 'TestBloc',
    String error = 'Critical error occurred',
    String stackTrace = 'Critical stack trace',
  }) {
    return createTestError(
      blocType: blocType,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Create performance metrics list
  static List<PerformanceMetric> createMetricsList({
    int count = 5,
    String category = 'test',
  }) {
    return List.generate(count, (index) {
      return createTestMetric(
        name: 'operation_$index',
        category: category,
        duration: Duration(milliseconds: 100 * (index + 1)),
      );
    });
  }

  /// Create transition metrics list
  static List<TransitionMetric> createTransitionsList({
    int count = 3,
  }) {
    return List.generate(count, (index) {
      return createTestTransition(
        blocType: 'TestBloc',
        eventType: 'Event$index',
        fromState: 'State$index',
        toState: 'State${index + 1}',
        processingTime: Duration(milliseconds: 50 * (index + 1)),
      );
    });
  }

  /// Create error metrics list
  static List<ErrorMetric> createErrorsList({
    int count = 2,
  }) {
    return List.generate(count, (index) {
      return createTestError(
        blocType: 'TestBloc',
        error: 'Error $index',
        stackTrace: 'Stack trace $index',
      );
    });
  }

  /// Create performance summary data
  static Map<String, dynamic> createPerformanceSummary({
    int totalMetrics = 10,
    double averageTime = 150.0,
    int slowOperations = 2,
    int criticalOperations = 1,
  }) {
    return {
      'totalMetrics': totalMetrics,
      'averageTime': averageTime,
      'slowOperations': slowOperations,
      'criticalOperations': criticalOperations,
      'categories': {
        'network': 4,
        'ui': 3,
        'database': 2,
        'storage': 1,
      },
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create performance thresholds data
  static Map<String, dynamic> createThresholdsData({
    Duration slowWarning = CoreTestConstants.slowOperationThreshold,
    Duration slowCritical = CoreTestConstants.criticalOperationThreshold,
    Duration blocWarning = CoreTestConstants.testTimeout,
    Duration blocCritical = const Duration(milliseconds: 500),
  }) {
    return {
      'slowOperationWarning': slowWarning.inMilliseconds,
      'slowOperationCritical': slowCritical.inMilliseconds,
      'blocEventWarning': blocWarning.inMilliseconds,
      'blocEventCritical': blocCritical.inMilliseconds,
      'maxMetricsHistory': 1000,
      'memoryLeakWarning': const Duration(minutes: 5).inMilliseconds,
    };
  }

  /// Create performance report data
  static Map<String, dynamic> createPerformanceReport({
    List<PerformanceMetric>? metrics,
    List<TransitionMetric>? transitions,
    List<ErrorMetric>? errors,
    Map<String, dynamic>? thresholds,
  }) {
    return {
      'summary': createPerformanceSummary(),
      'thresholds': thresholds ?? createThresholdsData(),
      'metrics': metrics?.map((m) => m.toJson()).toList(),
      'transitions': transitions?.map((t) => t.toJson()).toList(),
      'errors': errors?.map((e) => e.toJson()).toList(),
      'generatedAt': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }
}