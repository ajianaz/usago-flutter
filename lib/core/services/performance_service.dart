import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import '../performance/performance_tracker.dart';
import '../performance/memory_manager.dart';
import '../performance/bloc_monitor.dart';
import '../performance/performance_utils.dart';

/// Performance service configuration
class PerformanceServiceConfig {
  final bool enableMemoryMonitoring;
  final bool enableBlocMonitoring;
  final bool enablePerformanceTracking;
  final bool enableAutoOptimization;
  final Duration monitoringInterval;
  final Duration cleanupInterval;
  final double memoryWarningThreshold;
  final double memoryCriticalThreshold;
  final int maxMetricsHistory;

  const PerformanceServiceConfig({
    this.enableMemoryMonitoring = true,
    this.enableBlocMonitoring = true,
    this.enablePerformanceTracking = true,
    this.enableAutoOptimization = true,
    this.monitoringInterval = const Duration(minutes: 1),
    this.cleanupInterval = const Duration(minutes: 10),
    this.memoryWarningThreshold = 70.0,
    this.memoryCriticalThreshold = 85.0,
    this.maxMetricsHistory = 1000,
  });

  /// Create config based on environment
  factory PerformanceServiceConfig.forEnvironment() {
    if (kDebugMode) {
      return PerformanceServiceConfig(
        enableMemoryMonitoring: true,
        enableBlocMonitoring: true,
        enablePerformanceTracking: true,
        enableAutoOptimization: false,
        monitoringInterval: const Duration(seconds: 30),
        cleanupInterval: const Duration(minutes: 5),
        memoryWarningThreshold: 60.0,
        memoryCriticalThreshold: 80.0,
        maxMetricsHistory: 500,
      );
    } else if (kProfileMode) {
      return PerformanceServiceConfig(
        enableMemoryMonitoring: true,
        enableBlocMonitoring: true,
        enablePerformanceTracking: true,
        enableAutoOptimization: true,
        monitoringInterval: const Duration(minutes: 2),
        cleanupInterval: const Duration(minutes: 15),
        memoryWarningThreshold: 70.0,
        memoryCriticalThreshold: 85.0,
        maxMetricsHistory: 1000,
      );
    } else {
      return PerformanceServiceConfig(
        enableMemoryMonitoring: false,
        enableBlocMonitoring: false,
        enablePerformanceTracking: false,
        enableAutoOptimization: true,
        monitoringInterval: const Duration(minutes: 5),
        cleanupInterval: const Duration(minutes: 30),
        memoryWarningThreshold: 75.0,
        memoryCriticalThreshold: 90.0,
        maxMetricsHistory: 200,
      );
    }
  }
}

/// Performance service for centralized performance management
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final AppLogger _logger = AppLogger();
  PerformanceServiceConfig _config = PerformanceServiceConfig.forEnvironment();

  Timer? _monitoringTimer;
  Timer? _cleanupTimer;
  StreamController<Map<String, dynamic>>? _performanceStreamController;

  bool _isInitialized = false;
  bool _isDisposed = false;

  /// Initialize performance service
  Future<void> initialize({
    PerformanceServiceConfig? config,
  }) async {
    if (_isInitialized || _isDisposed) return;
    if (!AppConfig.enableLogging) return;

    _logger.info('Initializing Performance Service...');

    // Apply custom config if provided
    if (config != null) {
      _config = config;
    }

    try {
      // Initialize individual components
      if (_config.enablePerformanceTracking) {
        PerformanceTracker().initialize();
      }

      if (_config.enableMemoryMonitoring) {
        MemoryManager().initialize();
      }

      if (_config.enableBlocMonitoring) {
        BlocMonitor().initialize();
      }

      // Start periodic monitoring
      _startPeriodicMonitoring();

      // Start periodic cleanup
      _startPeriodicCleanup();

      // Initialize performance stream
      _performanceStreamController =
          StreamController<Map<String, dynamic>>.broadcast(
        onListen: () => _logger.debug('Performance stream listener added'),
        onCancel: () => _logger.debug('Performance stream listener removed'),
      );

      _isInitialized = true;
      _logger.info('Performance Service initialized successfully');

      // Log initial performance state
      _logInitialPerformanceState();
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize Performance Service', e, stackTrace);
      rethrow;
    }
  }

  /// Dispose performance service
  Future<void> dispose() async {
    if (_isDisposed || !_isInitialized) return;

    _logger.info('Disposing Performance Service...');

    // Cancel timers
    _monitoringTimer?.cancel();
    _cleanupTimer?.cancel();

    // Dispose individual components
    if (_config.enablePerformanceTracking) {
      PerformanceTracker().dispose();
    }

    if (_config.enableMemoryMonitoring) {
      MemoryManager().dispose();
    }

    if (_config.enableBlocMonitoring) {
      BlocMonitor().dispose();
    }

    // Close stream controller
    await _performanceStreamController?.close();

    _isDisposed = true;
    _isInitialized = false;

    _logger.info('Performance Service disposed');
  }

  /// Get current performance configuration
  PerformanceServiceConfig get config => _config;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if service is disposed
  bool get isDisposed => _isDisposed;

  /// Get performance stream for real-time monitoring
  Stream<Map<String, dynamic>> get performanceStream {
    if (_performanceStreamController == null) {
      return Stream.empty();
    }
    return _performanceStreamController!.stream;
  }

  /// Get comprehensive performance report
  Map<String, dynamic> getPerformanceReport() {
    if (!_isInitialized) return {};

    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'config': {
        'enableMemoryMonitoring': _config.enableMemoryMonitoring,
        'enableBlocMonitoring': _config.enableBlocMonitoring,
        'enablePerformanceTracking': _config.enablePerformanceTracking,
        'enableAutoOptimization': _config.enableAutoOptimization,
        'monitoringInterval': _config.monitoringInterval.inSeconds,
        'memoryWarningThreshold': _config.memoryWarningThreshold,
        'memoryCriticalThreshold': _config.memoryCriticalThreshold,
      },
      'isHealthy': PerformanceUtils.isPerformanceHealthy(),
      'recommendations': PerformanceUtils.getPerformanceRecommendations(),
    };

    // Add component reports if enabled
    if (_config.enableMemoryMonitoring) {
      report['memory'] = MemoryManager().getDetailedReport();
    }

    if (_config.enableBlocMonitoring) {
      report['bloc'] = BlocMonitor().getDetailedReport();
    }

    if (_config.enablePerformanceTracking) {
      report['performance'] = PerformanceTracker().getDetailedReport();
    }

    // Add device profile
    report['device'] = PerformanceUtils.getDevicePerformanceProfile();

    return report;
  }

  /// Force performance optimization
  Future<void> optimizePerformance() async {
    if (!_isInitialized) return;

    _logger.info('Starting forced performance optimization...');

    try {
      await PerformanceUtils.optimizePerformance();

      // Notify listeners
      _performanceStreamController?.add({
        'type': 'optimization_completed',
        'timestamp': DateTime.now().toIso8601String(),
      });

      _logger.info('Performance optimization completed');
    } catch (e, stackTrace) {
      _logger.error('Performance optimization failed', e, stackTrace);
    }
  }

  /// Export performance data
  Future<void> exportPerformanceData(String filePath) async {
    if (!_isInitialized || kReleaseMode) return;

    try {
      final report = getPerformanceReport();

      // Validate file path to prevent empty expressions
      if (filePath.trim().isEmpty) {
        filePath = '/tmp/performance_export.json';
      }

      // In a real implementation, you would write this to a file
      // For now, we'll just log it
      _logger.info('Performance data exported to: $filePath');
      _logger.debug('Report: ${report.toString()}');
    } catch (e, stackTrace) {
      _logger.error('Failed to export performance data', e, stackTrace);
    }
  }

  /// Update configuration
  void updateConfig(PerformanceServiceConfig newConfig) {
    if (!_isInitialized) return;

    _config = newConfig;
    _logger.info('Performance service configuration updated');

    // Restart timers with new intervals
    _restartPeriodicMonitoring();
    _restartPeriodicCleanup();
  }

  /// Enable/disable specific monitoring features
  void enableMemoryMonitoring(bool enable) {
    if (!_isInitialized) return;

    _config = PerformanceServiceConfig(
      enableMemoryMonitoring: enable,
      enableBlocMonitoring: _config.enableBlocMonitoring,
      enablePerformanceTracking: _config.enablePerformanceTracking,
      enableAutoOptimization: _config.enableAutoOptimization,
      monitoringInterval: _config.monitoringInterval,
      cleanupInterval: _config.cleanupInterval,
      memoryWarningThreshold: _config.memoryWarningThreshold,
      memoryCriticalThreshold: _config.memoryCriticalThreshold,
      maxMetricsHistory: _config.maxMetricsHistory,
    );

    if (enable && !_config.enableMemoryMonitoring) {
      MemoryManager().initialize();
    } else if (!enable && _config.enableMemoryMonitoring) {
      MemoryManager().dispose();
    }
  }

  void enableBlocMonitoring(bool enable) {
    if (!_isInitialized) return;

    _config = PerformanceServiceConfig(
      enableMemoryMonitoring: _config.enableMemoryMonitoring,
      enableBlocMonitoring: enable,
      enablePerformanceTracking: _config.enablePerformanceTracking,
      enableAutoOptimization: _config.enableAutoOptimization,
      monitoringInterval: _config.monitoringInterval,
      cleanupInterval: _config.cleanupInterval,
      memoryWarningThreshold: _config.memoryWarningThreshold,
      memoryCriticalThreshold: _config.memoryCriticalThreshold,
      maxMetricsHistory: _config.maxMetricsHistory,
    );

    if (enable && !_config.enableBlocMonitoring) {
      BlocMonitor().initialize();
    } else if (!enable && _config.enableBlocMonitoring) {
      BlocMonitor().dispose();
    }
  }

  void enablePerformanceTracking(bool enable) {
    if (!_isInitialized) return;

    _config = PerformanceServiceConfig(
      enableMemoryMonitoring: _config.enableMemoryMonitoring,
      enableBlocMonitoring: _config.enableBlocMonitoring,
      enablePerformanceTracking: enable,
      enableAutoOptimization: _config.enableAutoOptimization,
      monitoringInterval: _config.monitoringInterval,
      cleanupInterval: _config.cleanupInterval,
      memoryWarningThreshold: _config.memoryWarningThreshold,
      memoryCriticalThreshold: _config.memoryCriticalThreshold,
      maxMetricsHistory: _config.maxMetricsHistory,
    );

    if (enable && !_config.enablePerformanceTracking) {
      PerformanceTracker().initialize();
    } else if (!enable && _config.enablePerformanceTracking) {
      PerformanceTracker().dispose();
    }
  }

  void _startPeriodicMonitoring() {
    _monitoringTimer = Timer.periodic(
      _config.monitoringInterval,
      (_) => _performPeriodicMonitoring(),
    );
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(
      _config.cleanupInterval,
      (_) => _performPeriodicCleanup(),
    );
  }

  void _restartPeriodicMonitoring() {
    _monitoringTimer?.cancel();
    _startPeriodicMonitoring();
  }

  void _restartPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _startPeriodicCleanup();
  }

  void _performPeriodicMonitoring() {
    if (!_isInitialized) return;

    try {
      // Get current performance data
      final performanceData = PerformanceUtils.getDevicePerformanceProfile();

      // Check for performance issues
      final warnings = <String>[];

      if (_config.enableMemoryMonitoring) {
        final memoryInfo = MemoryManager().getCurrentMemoryInfo();
        if (memoryInfo.usagePercentage > _config.memoryCriticalThreshold) {
          warnings.add(
              'Critical memory usage: ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
        } else if (memoryInfo.usagePercentage >
            _config.memoryWarningThreshold) {
          warnings.add(
              'High memory usage: ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
        }
      }

      // Log warnings if any
      if (warnings.isNotEmpty) {
        for (final warning in warnings) {
          _logger.warning(warning);
        }
      }

      // Auto-optimize if enabled and needed
      if (_config.enableAutoOptimization &&
          !PerformanceUtils.isPerformanceHealthy()) {
        _logger.info('Auto-optimization triggered');
        optimizePerformance();
      }

      // Send performance data to stream
      _performanceStreamController?.add({
        'type': 'performance_update',
        'timestamp': DateTime.now().toIso8601String(),
        'data': performanceData,
        'warnings': warnings,
        'isHealthy': PerformanceUtils.isPerformanceHealthy(),
      });
    } catch (e, stackTrace) {
      _logger.error('Error during periodic monitoring', e, stackTrace);
    }
  }

  void _performPeriodicCleanup() {
    if (!_isInitialized) return;

    try {
      _logger.debug('Performing periodic cleanup...');

      // Clear old metrics if needed
      if (_config.enablePerformanceTracking) {
        final summary = PerformanceTracker().getPerformanceSummary();
        if (summary['totalMetrics'] > _config.maxMetricsHistory) {
          PerformanceTracker().clearMetrics();
          _logger.info('Cleared old performance metrics');
        }
      }

      // Note: MemoryManager and BlocMonitor handle their own cleanup internally
    } catch (e, stackTrace) {
      _logger.error('Error during periodic cleanup', e, stackTrace);
    }
  }

  void _logInitialPerformanceState() {
    if (!AppConfig.debugMode) return;

    final deviceProfile = PerformanceUtils.getDevicePerformanceProfile();
    _logger.info('=== Initial Performance State ===');
    _logger.info('Platform: ${deviceProfile['platform']}');
    if (_config.enableMemoryMonitoring) {
      _logger.info('Memory: ${deviceProfile['memory']}');
    }
    if (_config.enableBlocMonitoring) {
      _logger.info('BLoC: ${deviceProfile['bloc']}');
    }
    if (_config.enablePerformanceTracking) {
      _logger.info('Performance: ${deviceProfile['performance']}');
    }
    _logger.info(
        'Health: ${PerformanceUtils.isPerformanceHealthy() ? 'Good' : 'Warning'}');
    _logger.info('=== End Initial State ===');
  }
}

/// Performance service helper for easier access
class PerformanceServiceHelper {
  static final PerformanceService _service = PerformanceService();

  /// Initialize performance service with default config
  static Future<void> initialize() async {
    await _service.initialize();
  }

  /// Get performance service instance
  static PerformanceService get instance => _service;

  /// Quick performance check
  static bool isPerformanceHealthy() {
    return _service.isInitialized && PerformanceUtils.isPerformanceHealthy();
  }

  /// Get memory usage display
  static String getMemoryDisplay() {
    if (!_service.isInitialized) return 'N/A';
    return PerformanceMonitorHelper.getMemoryDisplay();
  }

  /// Get performance recommendations
  static List<String> getRecommendations() {
    if (!_service.isInitialized) return [];
    return PerformanceUtils.getPerformanceRecommendations();
  }
}
