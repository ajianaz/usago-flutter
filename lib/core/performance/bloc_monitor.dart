import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import 'performance_tracker.dart';
import 'memory_manager.dart';

/// BLoC monitoring data class
class BlocMetrics {
  final String blocType;
  final DateTime createdAt;
  final DateTime? disposedAt;
  final int eventCount;
  final int stateCount;
  final int transitionCount;
  final Duration totalEventProcessingTime;
  final Duration maxEventProcessingTime;
  final Duration minEventProcessingTime;
  final double averageMemoryUsage;
  final double maxMemoryUsage;
  final bool isActive;

  const BlocMetrics({
    required this.blocType,
    required this.createdAt,
    this.disposedAt,
    required this.eventCount,
    required this.stateCount,
    required this.transitionCount,
    required this.totalEventProcessingTime,
    required this.maxEventProcessingTime,
    required this.minEventProcessingTime,
    required this.averageMemoryUsage,
    required this.maxMemoryUsage,
    required this.isActive,
  });

  /// Get duration of BLoC lifecycle
  Duration? get lifecycleDuration {
    if (disposedAt == null) return null;
    return disposedAt!.difference(createdAt);
  }

  /// Get average event processing time
  Duration get averageEventProcessingTime {
    if (eventCount == 0) return Duration.zero;
    return Duration(
      microseconds: totalEventProcessingTime.inMicroseconds ~/ eventCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blocType': blocType,
      'createdAt': createdAt.toIso8601String(),
      'disposedAt': disposedAt?.toIso8601String(),
      'eventCount': eventCount,
      'stateCount': stateCount,
      'transitionCount': transitionCount,
      'totalEventProcessingTime': totalEventProcessingTime.inMicroseconds,
      'maxEventProcessingTime': maxEventProcessingTime.inMicroseconds,
      'minEventProcessingTime': minEventProcessingTime.inMicroseconds,
      'averageMemoryUsage': averageMemoryUsage,
      'maxMemoryUsage': maxMemoryUsage,
      'isActive': isActive,
      'lifecycleDuration': lifecycleDuration?.inMicroseconds,
      'averageEventProcessingTime': averageEventProcessingTime.inMicroseconds,
    };
  }

  @override
  String toString() {
    return 'BlocMetrics(blocType: $blocType, eventCount: $eventCount, '
        'stateCount: $stateCount, isActive: $isActive, '
        'avgProcessingTime: ${averageEventProcessingTime.inMilliseconds}ms, '
        'avgMemory: ${averageMemoryUsage.toStringAsFixed(2)}MB)';
  }
}

/// Event processing data
class EventProcessingData {
  final String eventType;
  final DateTime timestamp;
  final Duration processingTime;
  final double memoryBefore;
  final double memoryAfter;

  const EventProcessingData({
    required this.eventType,
    required this.timestamp,
    required this.processingTime,
    required this.memoryBefore,
    required this.memoryAfter,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventType': eventType,
      'timestamp': timestamp.toIso8601String(),
      'processingTime': processingTime.inMicroseconds,
      'memoryBefore': memoryBefore,
      'memoryAfter': memoryAfter,
    };
  }
}

/// BLoC Monitor for performance tracking and memory management
class BlocMonitor {
  static final BlocMonitor _instance = BlocMonitor._internal();
  factory BlocMonitor() => _instance;
  BlocMonitor._internal();

  final AppLogger _logger = AppLogger();
  final Map<String, BlocMetrics> _blocMetrics = {};
  final Map<String, List<EventProcessingData>> _eventHistory = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  Timer? _cleanupTimer;
  Timer? _reportingTimer;

  /// Initialize BLoC monitoring
  void initialize() {
    if (!AppConfig.enableLogging) return;

    _logger.info('Initializing BLoC Monitor...');

    // Setup BLoC observer
    Bloc.observer = _BlocObserverWrapper();

    // Start periodic cleanup
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanupDisposedBlocs(),
    );

    // Start periodic reporting (only in debug mode)
    if (AppConfig.debugMode) {
      _reportingTimer = Timer.periodic(
        const Duration(minutes: 2),
        (_) => _logPerformanceReport(),
      );
    }

    _logger.info('BLoC Monitor initialized successfully');
  }

  /// Dispose BLoC monitor
  void dispose() {
    _cleanupTimer?.cancel();
    _reportingTimer?.cancel();

    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    _logger.info('BLoC Monitor disposed');
  }

  /// Register a BLoC for monitoring
  void registerBloc<B extends BlocBase>(B bloc) {
    if (!AppConfig.enableLogging) return;

    final blocType = B.toString();
    final blocHash = bloc.hashCode.toString();

    _logger.debug('Registering BLoC: $blocType (hash: $blocHash)');

    // Create initial metrics
    _blocMetrics[blocHash] = BlocMetrics(
      blocType: blocType,
      createdAt: DateTime.now(),
      eventCount: 0,
      stateCount: 0,
      transitionCount: 0,
      totalEventProcessingTime: Duration.zero,
      maxEventProcessingTime: Duration.zero,
      minEventProcessingTime: Duration.zero,
      averageMemoryUsage: MemoryManager.getCurrentMemoryUsage(),
      maxMemoryUsage: MemoryManager.getCurrentMemoryUsage(),
      isActive: true,
    );

    _eventHistory[blocHash] = [];

    // Subscribe to BLoC stream for performance tracking
    _subscriptions[blocHash] = bloc.stream.listen(
      (_) => _onStateChange(blocHash),
      onError: (error) => _onBlocError(blocHash, error),
    );
  }

  /// Unregister a BLoC
  void unregisterBloc<B extends BlocBase>(B bloc) {
    if (!AppConfig.enableLogging) return;

    final blocHash = bloc.hashCode.toString();
    final metrics = _blocMetrics[blocHash];

    if (metrics != null) {
      _logger
          .debug('Unregistering BLoC: ${metrics.blocType} (hash: $blocHash)');

      // Update disposal time
      _blocMetrics[blocHash] = BlocMetrics(
        blocType: metrics.blocType,
        createdAt: metrics.createdAt,
        disposedAt: DateTime.now(),
        eventCount: metrics.eventCount,
        stateCount: metrics.stateCount,
        transitionCount: metrics.transitionCount,
        totalEventProcessingTime: metrics.totalEventProcessingTime,
        maxEventProcessingTime: metrics.maxEventProcessingTime,
        minEventProcessingTime: metrics.minEventProcessingTime,
        averageMemoryUsage: metrics.averageMemoryUsage,
        maxMemoryUsage: metrics.maxMemoryUsage,
        isActive: false,
      );

      // Cancel subscription
      _subscriptions[blocHash]?.cancel();
      _subscriptions.remove(blocHash);

      // Log final metrics
      _logger.info('BLoC disposed: ${metrics.blocType}');
      _logger.debug('Final metrics: ${metrics.toString()}');
    }
  }

  /// Track event processing
  void trackEventProcessing<B extends BlocBase>(
    B bloc,
    String eventType,
    Duration processingTime,
  ) {
    if (!AppConfig.enableLogging) return;

    final blocHash = bloc.hashCode.toString();
    final memoryBefore = MemoryManager.getCurrentMemoryUsage();

    // Simulate memory after processing (in real implementation, this would be measured)
    final memoryAfter = MemoryManager.getCurrentMemoryUsage();

    final eventData = EventProcessingData(
      eventType: eventType,
      timestamp: DateTime.now(),
      processingTime: processingTime,
      memoryBefore: memoryBefore,
      memoryAfter: memoryAfter,
    );

    _eventHistory[blocHash]?.add(eventData);

    // Update metrics
    final metrics = _blocMetrics[blocHash];
    if (metrics != null) {
      _blocMetrics[blocHash] = BlocMetrics(
        blocType: metrics.blocType,
        createdAt: metrics.createdAt,
        disposedAt: metrics.disposedAt,
        eventCount: metrics.eventCount + 1,
        stateCount: metrics.stateCount,
        transitionCount: metrics.transitionCount,
        totalEventProcessingTime:
            metrics.totalEventProcessingTime + processingTime,
        maxEventProcessingTime: processingTime > metrics.maxEventProcessingTime
            ? processingTime
            : metrics.maxEventProcessingTime,
        minEventProcessingTime: metrics.eventCount == 0
            ? processingTime
            : (processingTime < metrics.minEventProcessingTime
                ? processingTime
                : metrics.minEventProcessingTime),
        averageMemoryUsage: (metrics.averageMemoryUsage + memoryAfter) / 2,
        maxMemoryUsage: memoryAfter > metrics.maxMemoryUsage
            ? memoryAfter
            : metrics.maxMemoryUsage,
        isActive: metrics.isActive,
      );
    }
  }

  /// Get metrics for a specific BLoC
  BlocMetrics? getBlocMetrics(String blocHash) {
    return _blocMetrics[blocHash];
  }

  /// Get all active BLoC metrics
  List<BlocMetrics> getActiveBlocs() {
    return _blocMetrics.values.where((metrics) => metrics.isActive).toList();
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final activeBlocs = getActiveBlocs();
    final totalBlocs = _blocMetrics.length;

    return {
      'totalBlocs': totalBlocs,
      'activeBlocs': activeBlocs.length,
      'disposedBlocs': totalBlocs - activeBlocs.length,
      'totalEvents':
          _blocMetrics.values.fold(0, (sum, m) => sum + m.eventCount),
      'totalTransitions':
          _blocMetrics.values.fold(0, (sum, m) => sum + m.transitionCount),
      'averageMemoryUsage': activeBlocs.isEmpty
          ? 0.0
          : activeBlocs.fold(0.0, (sum, m) => sum + m.averageMemoryUsage) /
              activeBlocs.length,
      'maxMemoryUsage': activeBlocs.isEmpty
          ? 0.0
          : activeBlocs.fold(
              0.0, (max, m) => m.maxMemoryUsage > max ? m.maxMemoryUsage : max),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get detailed report
  Map<String, dynamic> getDetailedReport() {
    return {
      'summary': getPerformanceSummary(),
      'blocs': _blocMetrics.values.map((m) => m.toJson()).toList(),
      'eventHistory': _eventHistory.map(
        (key, events) => MapEntry(
          key,
          events.map((e) => e.toJson()).toList(),
        ),
      ),
    };
  }

  void _onStateChange(String blocHash) {
    final metrics = _blocMetrics[blocHash];
    if (metrics != null) {
      _blocMetrics[blocHash] = BlocMetrics(
        blocType: metrics.blocType,
        createdAt: metrics.createdAt,
        disposedAt: metrics.disposedAt,
        eventCount: metrics.eventCount,
        stateCount: metrics.stateCount + 1,
        transitionCount: metrics.transitionCount + 1,
        totalEventProcessingTime: metrics.totalEventProcessingTime,
        maxEventProcessingTime: metrics.maxEventProcessingTime,
        minEventProcessingTime: metrics.minEventProcessingTime,
        averageMemoryUsage: metrics.averageMemoryUsage,
        maxMemoryUsage: metrics.maxMemoryUsage,
        isActive: metrics.isActive,
      );
    }
  }

  void _onBlocError(String blocHash, dynamic error) {
    final metrics = _blocMetrics[blocHash];
    if (metrics != null) {
      _logger.error('BLoC error in ${metrics.blocType}: $error');
    }
  }

  void _cleanupDisposedBlocs() {
    final disposedHashes = _blocMetrics.entries
        .where((entry) => !entry.value.isActive)
        .map((entry) => entry.key)
        .toList();

    // Keep disposed metrics for 30 minutes
    final cutoffTime = DateTime.now().subtract(const Duration(minutes: 30));

    for (final hash in disposedHashes) {
      final metrics = _blocMetrics[hash];
      if (metrics != null &&
          metrics.disposedAt != null &&
          metrics.disposedAt!.isBefore(cutoffTime)) {
        _blocMetrics.remove(hash);
        _eventHistory.remove(hash);
        _logger.debug('Cleaned up disposed BLoC: ${metrics.blocType}');
      }
    }
  }

  void _logPerformanceReport() {
    final summary = getPerformanceSummary();
    final activeBlocs = getActiveBlocs();

    _logger.info('=== BLoC Performance Report ===');
    _logger.info(
        'Active BLoCs: ${summary['activeBlocs']}/${summary['totalBlocs']}');
    _logger.info('Total Events: ${summary['totalEvents']}');
    _logger.info('Total Transitions: ${summary['totalTransitions']}');
    _logger.info(
        'Average Memory: ${summary['averageMemoryUsage']?.toStringAsFixed(2)}MB');
    _logger
        .info('Max Memory: ${summary['maxMemoryUsage']?.toStringAsFixed(2)}MB');

    if (activeBlocs.isNotEmpty) {
      _logger.info('Active BLoCs:');
      for (final bloc in activeBlocs.take(5)) {
        // Show top 5
        _logger.info('  - ${bloc.blocType}: ${bloc.eventCount} events, '
            '${bloc.averageEventProcessingTime.inMilliseconds}ms avg');
      }
    }

    _logger.info('=== End Report ===');
  }
}

/// Wrapper for BLoC observer to integrate with our monitoring
class _BlocObserverWrapper extends BlocObserver {
  final AppLogger _logger = AppLogger();
  final PerformanceTracker _tracker = PerformanceTracker();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    BlocMonitor().registerBloc(bloc);

    if (AppConfig.debugMode) {
      _logger.debug('BLoC created: ${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    final stopwatch = Stopwatch()..start();

    // Measure event processing time
    Future.microtask(() {
      stopwatch.stop();
      BlocMonitor().trackEventProcessing(
        bloc,
        event.runtimeType.toString(),
        stopwatch.elapsed,
      );
    });

    if (AppConfig.debugMode) {
      _logger.debug('Event: ${event.runtimeType} in ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    if (AppConfig.debugMode) {
      _logger.debug('State change in ${bloc.runtimeType}: '
          '${change.currentState.runtimeType} -> ${change.nextState.runtimeType}');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    _tracker.trackTransition(
      bloc.runtimeType.toString(),
      transition.event.runtimeType.toString(),
      transition.currentState.runtimeType.toString(),
      transition.nextState.runtimeType.toString(),
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    _logger.error(
        'BLoC error in ${bloc.runtimeType}: $error', error, stackTrace);

    _tracker.trackError(
      bloc.runtimeType.toString(),
      error.toString(),
      stackTrace.toString(),
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    BlocMonitor().unregisterBloc(bloc);

    if (AppConfig.debugMode) {
      _logger.debug('BLoC closed: ${bloc.runtimeType}');
    }
  }
}
