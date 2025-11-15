import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import '../platform/platform_detector.dart';
import 'performance_tracker.dart';
import 'memory_manager.dart';
import 'bloc_monitor.dart';

/// Performance utility functions for common operations
class PerformanceUtils {
  static final AppLogger _logger = AppLogger();
  static final PerformanceTracker _tracker = PerformanceTracker();

  /// Measure execution time of a function
  static T measureTime<T>(
    String name,
    T Function() function, {
    String category = 'general',
    Map<String, dynamic> metadata = const {},
  }) {
    if (!AppConfig.enableLogging) return function();

    final stopwatch = Stopwatch()..start();
    try {
      final result = function();
      stopwatch.stop();

      final trackingId = _tracker.startTracking(name, category: category);
      _tracker.stopTracking(trackingId, metadata: metadata);

      if (AppConfig.debugMode) {
        _logger.debug(
            'Performance: $name completed in ${stopwatch.elapsedMilliseconds}ms');
      }

      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();

      _logger.error(
          'Performance: $name failed after ${stopwatch.elapsedMilliseconds}ms',
          e,
          stackTrace);
      rethrow;
    }
  }

  /// Measure execution time of an async function
  static Future<T> measureTimeAsync<T>(
    String name,
    Future<T> Function() function, {
    String category = 'general',
    Map<String, dynamic> metadata = const {},
  }) async {
    if (!AppConfig.enableLogging) return await function();

    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();

      final trackingId = _tracker.startTracking(name, category: category);
      _tracker.stopTracking(trackingId, metadata: metadata);

      if (AppConfig.debugMode) {
        _logger.debug(
            'Performance: $name completed in ${stopwatch.elapsedMilliseconds}ms');
      }

      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();

      _logger.error(
          'Performance: $name failed after ${stopwatch.elapsedMilliseconds}ms',
          e,
          stackTrace);
      rethrow;
    }
  }

  /// Check if device is low on memory
  static bool isLowMemory({double threshold = 80.0}) {
    if (!AppConfig.enableLogging) return false;

    try {
      final memoryInfo = MemoryManager().getCurrentMemoryInfo();
      return memoryInfo.usagePercentage > threshold;
    } catch (e) {
      _logger.error('Failed to check memory status', e);
      return false;
    }
  }

  /// Get device performance profile
  static Map<String, dynamic> getDevicePerformanceProfile() {
    if (!AppConfig.enableLogging) return {};

    final profile = <String, dynamic>{};

    // Memory information
    final memoryInfo = MemoryManager().getCurrentMemoryInfo();
    profile['memory'] = {
      'totalMB': memoryInfo.totalMemoryMB,
      'usedMB': memoryInfo.usedMemoryMB,
      'freeMB': memoryInfo.freeMemoryMB,
      'usagePercentage': memoryInfo.usagePercentage,
      'isLowMemory': isLowMemory(),
    };

    // Platform information
    profile['platform'] = {
      'isIOS': PlatformDetector.isIOS,
      'isAndroid': PlatformDetector.isAndroid,
      'isWeb': PlatformDetector.isWeb,
      'isWindows': PlatformDetector.isWindows,
      'isMacOS': PlatformDetector.isMacOS,
      'isLinux': PlatformDetector.isLinux,
      'isDesktop': PlatformDetector.isDesktop,
      'isMobile': PlatformDetector.isMobile,
      'platformName': PlatformDetector.platformName,
      'debugMode': kDebugMode,
      'profileMode': kProfileMode,
      'releaseMode': kReleaseMode,
    };

    // BLoC performance summary
    final blocSummary = BlocMonitor().getPerformanceSummary();
    profile['bloc'] = {
      'totalBlocs': blocSummary['totalBlocs'],
      'activeBlocs': blocSummary['activeBlocs'],
      'totalEvents': blocSummary['totalEvents'],
      'totalTransitions': blocSummary['totalTransitions'],
    };

    // Performance tracker summary
    final perfSummary = _tracker.getPerformanceSummary();
    profile['performance'] = {
      'totalMetrics': perfSummary['totalMetrics'],
      'averageOperationTime': perfSummary['averageOperationTime'],
      'slowOperationsCount': perfSummary['slowOperationsCount'],
    };

    return profile;
  }

  /// Log performance warnings based on current state
  static void logPerformanceWarnings() {
    if (!AppConfig.enableLogging) return;

    // Check memory usage
    if (isLowMemory()) {
      _logger.warning('Device is running low on memory');
    }

    // Check for slow operations
    final slowOps = _tracker.getSlowOperations();
    if (slowOps.isNotEmpty) {
      _logger.warning('Found ${slowOps.length} slow operations');
      for (final op in slowOps.take(3)) {
        _logger.warning('  - ${op.name}: ${op.duration.inMilliseconds}ms');
      }
    }

    // Check for active BLoCs
    final activeBlocs = BlocMonitor().getActiveBlocs();
    if (activeBlocs.length > 10) {
      _logger.warning('High number of active BLoCs: ${activeBlocs.length}');
    }

    // Check for memory leaks
    final memorySummary = MemoryManager().getMemorySummary();
    if (memorySummary['potentialLeaks'] > 0) {
      _logger.warning(
          'Potential memory leaks detected: ${memorySummary['potentialLeaks']}');
    }
  }

  /// Optimize app performance based on current state
  static Future<void> optimizePerformance() async {
    if (!AppConfig.enableLogging) return;

    _logger.info('Starting performance optimization...');

    // Force garbage collection if memory is high
    if (isLowMemory(threshold: 75.0)) {
      _logger.info('High memory usage detected, forcing garbage collection');
      MemoryManager().forceGC();
    }

    // Clear old performance metrics
    final summary = _tracker.getPerformanceSummary();
    if (summary['totalMetrics'] > 500) {
      _logger.info('Clearing old performance metrics');
      _tracker.clearMetrics();
    }

    // Note: BlocMonitor and MemoryManager cleanup is handled internally by their timers

    _logger.info('Performance optimization completed');
  }

  /// Create performance report for debugging
  static Map<String, dynamic> createPerformanceReport() {
    if (!AppConfig.enableLogging) return {};

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'deviceProfile': getDevicePerformanceProfile(),
      'memoryReport': MemoryManager().getDetailedReport(),
      'blocReport': BlocMonitor().getDetailedReport(),
      'performanceReport': _tracker.getDetailedReport(),
    };
  }

  /// Export performance report to file (debug only)
  static Future<void> exportPerformanceReport(String filePath) async {
    if (!kDebugMode || !AppConfig.enableLogging) return;

    try {
      final report = createPerformanceReport();
      // In a real implementation, you would write this to a file
      // For now, we'll just log it
      _logger.info('Performance report exported to: $filePath');
      _logger.debug('Report: ${report.toString()}');
    } catch (e) {
      _logger.error('Failed to export performance report: $e');
    }
  }

  /// Monitor performance continuously
  static Stream<Map<String, dynamic>> startPerformanceMonitoring({
    Duration interval = const Duration(minutes: 1),
  }) {
    if (!AppConfig.enableLogging) return Stream.empty();

    return Stream.periodic(interval, (_) {
      return getDevicePerformanceProfile();
    });
  }

  /// Check if app is in a healthy performance state
  static bool isPerformanceHealthy() {
    if (!AppConfig.enableLogging) return true;

    try {
      // Check memory usage
      if (isLowMemory(threshold: 90.0)) return false;

      // Check for too many slow operations
      final slowOps = _tracker.getSlowOperations(
        threshold: const Duration(seconds: 1),
      );
      if (slowOps.length > 5) return false;

      // Check for too many active BLoCs
      final activeBlocs = BlocMonitor().getActiveBlocs();
      if (activeBlocs.length > 20) return false;

      // Check for memory leaks
      final memorySummary = MemoryManager().getMemorySummary();
      if (memorySummary['potentialLeaks'] > 3) return false;

      return true;
    } catch (e) {
      _logger.error('Failed to check performance health', e);
      return false;
    }
  }

  /// Get performance recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];

    if (!AppConfig.enableLogging) return recommendations;

    try {
      // Memory recommendations
      if (isLowMemory()) {
        recommendations.add('Consider clearing caches and unused data');
        recommendations.add('Close unused features or tabs');
      }

      // BLoC recommendations
      final activeBlocs = BlocMonitor().getActiveBlocs();
      if (activeBlocs.length > 10) {
        recommendations.add('Consider reducing the number of active BLoCs');
        recommendations.add('Implement proper BLoC disposal');
      }

      // Performance recommendations
      final slowOps = _tracker.getSlowOperations();
      if (slowOps.isNotEmpty) {
        recommendations.add('Optimize slow operations');
        recommendations
            .add('Consider implementing caching for expensive operations');
      }

      // General recommendations
      if (!isPerformanceHealthy()) {
        recommendations
            .add('Restart the app if performance continues to degrade');
        recommendations
            .add('Check for memory leaks in long-running operations');
      }
    } catch (e) {
      _logger.error('Failed to generate performance recommendations', e);
    }

    return recommendations;
  }
}

/// Performance monitoring widget helper for UI integration
class PerformanceMonitorHelper {
  /// Get memory usage display text
  static String getMemoryDisplay() {
    if (!AppConfig.enableLogging) return 'N/A';

    final memoryInfo = MemoryManager().getCurrentMemoryInfo();
    return '${memoryInfo.usedMemoryMB.toStringAsFixed(1)}MB '
        '(${memoryInfo.usagePercentage.toStringAsFixed(1)}%)';
  }

  /// Get memory usage color based on threshold
  static String getMemoryColor() {
    if (!AppConfig.enableLogging) return 'grey';

    final memoryInfo = MemoryManager().getCurrentMemoryInfo();
    if (memoryInfo.usagePercentage > 85) return 'red';
    if (memoryInfo.usagePercentage > 70) return 'orange';
    return 'green';
  }

  /// Get BLoC count display
  static String getBlocCountDisplay() {
    if (!AppConfig.enableLogging) return 'N/A';

    final summary = BlocMonitor().getPerformanceSummary();
    return '${summary['activeBlocs']}/${summary['totalBlocs']}';
  }

  /// Get performance health indicator
  static String getPerformanceHealthIndicator() {
    if (!AppConfig.enableLogging) return 'unknown';

    return PerformanceUtils.isPerformanceHealthy() ? 'healthy' : 'warning';
  }

  /// Get performance recommendations count
  static int getRecommendationsCount() {
    if (!AppConfig.enableLogging) return 0;

    return PerformanceUtils.getPerformanceRecommendations().length;
  }
}
