import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';

/// Performance metric data class
class PerformanceMetric {
  final String name;
  final String category;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final String? stackTrace;

  const PerformanceMetric({
    required this.name,
    required this.category,
    required this.duration,
    required this.timestamp,
    this.metadata = const {},
    this.stackTrace,
  });

  /// Create metric from stopwatch
  factory PerformanceMetric.fromStopwatch(
    String name,
    String category,
    Stopwatch stopwatch, {
    Map<String, dynamic> metadata = const {},
    String? stackTrace,
  }) {
    return PerformanceMetric(
      name: name,
      category: category,
      duration: stopwatch.elapsed,
      timestamp: DateTime.now(),
      metadata: metadata,
      stackTrace: stackTrace,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'duration': duration.inMicroseconds,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'stackTrace': stackTrace,
    };
  }

  @override
  String toString() {
    return 'PerformanceMetric(name: $name, category: $category, '
           'duration: ${duration.inMilliseconds}ms, '
           'timestamp: ${timestamp.toIso8601String()})';
  }
}

/// Transition tracking data
class TransitionMetric {
  final String blocType;
  final String eventType;
  final String fromState;
  final String toState;
  final DateTime timestamp;
  final Duration? processingTime;

  const TransitionMetric({
    required this.blocType,
    required this.eventType,
    required this.fromState,
    required this.toState,
    required this.timestamp,
    this.processingTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'blocType': blocType,
      'eventType': eventType,
      'fromState': fromState,
      'toState': toState,
      'timestamp': timestamp.toIso8601String(),
      'processingTime': processingTime?.inMicroseconds,
    };
  }

  @override
  String toString() {
    return 'TransitionMetric(bloc: $blocType, event: $eventType, '
           '${fromState} -> $toState, '
           'duration: ${processingTime?.inMilliseconds ?? 0}ms)';
  }
}

/// Error tracking data
class ErrorMetric {
  final String blocType;
  final String error;
  final String stackTrace;
  final DateTime timestamp;

  const ErrorMetric({
    required this.blocType,
    required this.error,
    required this.stackTrace,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'blocType': blocType,
      'error': error,
      'stackTrace': stackTrace,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ErrorMetric(bloc: $blocType, error: $error, '
           'timestamp: ${timestamp.toIso8601String()})';
  }
}

/// Performance thresholds configuration
class PerformanceThresholds {
  final Duration slowOperationWarning;
  final Duration slowOperationCritical;
  final Duration blocEventWarning;
  final Duration blocEventCritical;
  final Duration memoryLeakWarning;
  final int maxMetricsHistory;

  const PerformanceThresholds({
    this.slowOperationWarning = const Duration(milliseconds: 500),
    this.slowOperationCritical = const Duration(seconds: 2),
    this.blocEventWarning = const Duration(milliseconds: 100),
    this.blocEventCritical = const Duration(milliseconds: 500),
    this.memoryLeakWarning = const Duration(minutes: 5),
    this.maxMetricsHistory = 1000,
  });

  /// Create thresholds based on build mode
  factory PerformanceThresholds.forEnvironment() {
    if (kDebugMode) {
      return const PerformanceThresholds(
        slowOperationWarning: Duration(milliseconds: 200),
        slowOperationCritical: Duration(milliseconds: 1000),
        blocEventWarning: Duration(milliseconds: 50),
        blocEventCritical: Duration(milliseconds: 200),
        maxMetricsHistory: 500,
      );
    } else {
      return const PerformanceThresholds();
    }
  }
}

/// Performance Tracker for collecting and analyzing performance metrics
class PerformanceTracker {
  static final PerformanceTracker _instance = PerformanceTracker._internal();
  factory PerformanceTracker() => _instance;
  PerformanceTracker._internal();

  final AppLogger _logger = AppLogger();
  final List<PerformanceMetric> _metrics = [];
  final List<TransitionMetric> _transitions = [];
  final List<ErrorMetric> _errors = [];
  final Map<String, Stopwatch> _activeStopwatches = {};
  final PerformanceThresholds _thresholds = PerformanceThresholds.forEnvironment();
  Timer? _cleanupTimer;

  /// Initialize performance tracker
  void initialize() {
    if (!AppConfig.enableLogging) return;

    _logger.info('Initializing Performance Tracker...');

    // Start periodic cleanup
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _cleanupOldData(),
    );

    _logger.info('Performance Tracker initialized successfully');
  }

  /// Dispose performance tracker
  void dispose() {
    _cleanupTimer?.cancel();
    _activeStopwatches.clear();
    _logger.info('Performance Tracker disposed');
  }

  /// Start tracking a performance operation
  String startTracking(String name, {String category = 'general'}) {
    if (!AppConfig.enableLogging) return '';

    final trackingId = '${name}_${DateTime.now().millisecondsSinceEpoch}';
    _activeStopwatches[trackingId] = Stopwatch()..start();

    if (AppConfig.debugMode) {
      _logger.debug('Started tracking: $name (ID: $trackingId)');
    }

    return trackingId;
  }

  /// Stop tracking and record the metric
  void stopTracking(
    String trackingId, {
    Map<String, dynamic> metadata = const {},
    String? stackTrace,
  }) {
    if (!AppConfig.enableLogging || !_activeStopwatches.containsKey(trackingId)) {
      return;
    }

    final stopwatch = _activeStopwatches.remove(trackingId)!;
    stopwatch.stop();

    // Extract name from tracking ID
    final name = trackingId.split('_').sublist(0, -1).join('_');
    final category = metadata['category'] ?? 'general';

    final metric = PerformanceMetric.fromStopwatch(
      name,
      category,
      stopwatch,
      metadata: metadata,
      stackTrace: stackTrace,
    );

    _metrics.add(metric);

    // Check thresholds and log warnings
    _checkThresholds(metric);

    if (AppConfig.debugMode) {
      _logger.debug('Stopped tracking: $name (${metric.duration.inMilliseconds}ms)');
    }
  }

  /// Track a BLoC transition
  void trackTransition(
    String blocType,
    String eventType,
    String fromState,
    String toState, {
    Duration? processingTime,
  }) {
    if (!AppConfig.enableLogging) return;

    final transition = TransitionMetric(
      blocType: blocType,
      eventType: eventType,
      fromState: fromState,
      toState: toState,
      timestamp: DateTime.now(),
      processingTime: processingTime,
    );

    _transitions.add(transition);

    // Check for slow transitions
    if (processingTime != null) {
      if (processingTime > _thresholds.blocEventCritical) {
        _logger.error('CRITICAL: Slow BLoC transition detected: ${transition.toString()}');
      } else if (processingTime > _thresholds.blocEventWarning) {
        _logger.warning('WARNING: Slow BLoC transition detected: ${transition.toString()}');
      }
    }

    if (AppConfig.debugMode) {
      _logger.debug('BLoC transition: ${transition.toString()}');
    }
  }

  /// Track an error
  void trackError(
    String blocType,
    String error,
    String stackTrace,
  ) {
    if (!AppConfig.enableLogging) return;

    final errorMetric = ErrorMetric(
      blocType: blocType,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _errors.add(errorMetric);

    _logger.error('BLoC error tracked: ${errorMetric.toString()}');
  }

  /// Get performance metrics by category
  List<PerformanceMetric> getMetricsByCategory(String category) {
    return _metrics.where((metric) => metric.category == category).toList();
  }

  /// Get slow operations
  List<PerformanceMetric> getSlowOperations({Duration? threshold}) {
    final slowThreshold = threshold ?? _thresholds.slowOperationWarning;
    return _metrics.where((metric) => metric.duration > slowThreshold).toList();
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final totalMetrics = _metrics.length;
    final totalTransitions = _transitions.length;
    final totalErrors = _errors.length;

    // Calculate averages
    final avgOperationTime = totalMetrics > 0
        ? _metrics.fold<Duration>(
            Duration.zero,
            (sum, metric) => sum + metric.duration,
          ) ~/ totalMetrics
        : Duration.zero;

    final avgTransitionTime = totalTransitions > 0
        ? _transitions.where((t) => t.processingTime != null).fold<Duration>(
            Duration.zero,
            (sum, transition) => sum + transition.processingTime!,
          ) ~/ _transitions.where((t) => t.processingTime != null).length
        : Duration.zero;

    // Get slow operations count
    final slowOperationsCount = getSlowOperations().length;

    return {
      'totalMetrics': totalMetrics,
      'totalTransitions': totalTransitions,
      'totalErrors': totalErrors,
      'averageOperationTime': avgOperationTime.inMicroseconds,
      'averageTransitionTime': avgTransitionTime.inMicroseconds,
      'slowOperationsCount': slowOperationsCount,
      'activeStopwatches': _activeStopwatches.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get detailed performance report
  Map<String, dynamic> getDetailedReport() {
    return {
      'summary': getPerformanceSummary(),
      'metrics': _metrics.map((m) => m.toJson()).toList(),
      'transitions': _transitions.map((t) => t.toJson()).toList(),
      'errors': _errors.map((e) => e.toJson()).toList(),
      'thresholds': {
        'slowOperationWarning': _thresholds.slowOperationWarning.inMicroseconds,
        'slowOperationCritical': _thresholds.slowOperationCritical.inMicroseconds,
        'blocEventWarning': _thresholds.blocEventWarning.inMicroseconds,
        'blocEventCritical': _thresholds.blocEventCritical.inMicroseconds,
      },
    };
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _transitions.clear();
    _errors.clear();
    _logger.info('Performance metrics cleared');
  }

  /// Export metrics to file (debug only)
  Future<void> exportMetricsToFile(String filePath) async {
    if (!kDebugMode) return;

    try {
      final report = getDetailedReport();
      // In a real implementation, you would write this to a file
      // For now, we'll just log it
      _logger.info('Performance report exported to: $filePath');
      _logger.debug('Report: ${report.toString()}');
    } catch (e) {
      _logger.error('Failed to export metrics: $e');
    }
  }

  void _checkThresholds(PerformanceMetric metric) {
    // Check based on category
    switch (metric.category) {
      case 'bloc_event':
        if (metric.duration > _thresholds.blocEventCritical) {
          _logger.error('CRITICAL: Slow BLoC event: ${metric.toString()}');
        } else if (metric.duration > _thresholds.blocEventWarning) {
          _logger.warning('WARNING: Slow BLoC event: ${metric.toString()}');
        }
        break;
      default:
        if (metric.duration > _thresholds.slowOperationCritical) {
          _logger.error('CRITICAL: Slow operation: ${metric.toString()}');
        } else if (metric.duration > _thresholds.slowOperationWarning) {
          _logger.warning('WARNING: Slow operation: ${metric.toString()}');
        }
    }
  }

  void _cleanupOldData() {
    // Keep only recent metrics (based on max history size)
    if (_metrics.length > _thresholds.maxMetricsHistory) {
      _metrics.removeRange(0, _metrics.length - _thresholds.maxMetricsHistory);
    }

    if (_transitions.length > _thresholds.maxMetricsHistory) {
      _transitions.removeRange(0, _transitions.length - _thresholds.maxMetricsHistory);
    }

    if (_errors.length > _thresholds.maxMetricsHistory) {
      _errors.removeRange(0, _errors.length - _thresholds.maxMetricsHistory);
    }

    // Clean up orphaned stopwatches (older than 5 minutes)
    final cutoffTime = DateTime.now().subtract(const Duration(minutes: 5));
    _activeStopwatches.removeWhere((id, stopwatch) {
      final timestamp = int.tryParse(id.split('_').last) ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(timestamp).isBefore(cutoffTime);
    });
  }
}

/// Performance tracking helper for easier usage
class PerformanceTrackerHelper {
  static final PerformanceTracker _tracker = PerformanceTracker();

  /// Track a synchronous operation
  static T trackOperation<T>(
    String name,
    T Function() operation, {
    String category = 'general',
    Map<String, dynamic> metadata = const {},
  }) {
    if (!AppConfig.enableLogging) return operation();

    final trackingId = _tracker.startTracking(name, category: category);
    try {
      final result = operation();
      _tracker.stopTracking(trackingId, metadata: metadata);
      return result;
    } catch (e, stackTrace) {
      _tracker.stopTracking(
        trackingId,
        metadata: {...metadata, 'error': e.toString()},
        stackTrace: stackTrace.toString(),
      );
      rethrow;
    }
  }

  /// Track an asynchronous operation
  static Future<T> trackAsyncOperation<T>(
    String name,
    Future<T> Function() operation, {
    String category = 'general',
    Map<String, dynamic> metadata = const {},
  }) async {
    if (!AppConfig.enableLogging) return await operation();

    final trackingId = _tracker.startTracking(name, category: category);
    try {
      final result = await operation();
      _tracker.stopTracking(trackingId, metadata: metadata);
      return result;
    } catch (e, stackTrace) {
      _tracker.stopTracking(
        trackingId,
        metadata: {...metadata, 'error': e.toString()},
        stackTrace: stackTrace.toString(),
      );
      rethrow;
    }
  }
}