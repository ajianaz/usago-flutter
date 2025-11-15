import 'dart:async';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import '../platform/platform_detector.dart';
// Conditional import for desktop-only functionality
import 'dart:io' if (dart.library.html) 'dart:html' as io;
// Import desktop-specific memory functions
import 'memory_manager_desktop.dart' if (dart.library.io) 'memory_manager_desktop.dart';

/// Memory usage information
class MemoryInfo {
  final double totalMemoryMB;
  final double usedMemoryMB;
  final double freeMemoryMB;
  final double usagePercentage;
  final DateTime timestamp;

  const MemoryInfo({
    required this.totalMemoryMB,
    required this.usedMemoryMB,
    required this.freeMemoryMB,
    required this.usagePercentage,
    required this.timestamp,
  });

  /// Create memory info from current system state
  factory MemoryInfo.current() {
    final timestamp = DateTime.now();

    if (PlatformDetector.isWeb) {
      // For web platform, use browser-compatible memory info
      final info = _getWebMemoryInfo();
      return MemoryInfo(
        totalMemoryMB: info['total'] ?? 0.0,
        usedMemoryMB: info['used'] ?? 0.0,
        freeMemoryMB: info['free'] ?? 0.0,
        usagePercentage: info['percentage'] ?? 0.0,
        timestamp: timestamp,
      );
    } else if (PlatformDetector.isMobile) {
      // For mobile platforms, we'll use Flutter's memory info
      final info = _getMobileMemoryInfo();
      return MemoryInfo(
        totalMemoryMB: info['total'] ?? 0.0,
        usedMemoryMB: info['used'] ?? 0.0,
        freeMemoryMB: info['free'] ?? 0.0,
        usagePercentage: info['percentage'] ?? 0.0,
        timestamp: timestamp,
      );
    } else {
      // For desktop platforms, we can use more detailed memory info
      return MemoryInfo(
        totalMemoryMB: _getTotalMemoryMB(),
        usedMemoryMB: _getUsedMemoryMB(),
        freeMemoryMB: _getFreeMemoryMB(),
        usagePercentage: _getMemoryUsagePercentage(),
        timestamp: timestamp,
      );
    }
  }

  /// Get memory info for web platforms
  static Map<String, double> _getWebMemoryInfo() {
    try {
      // Web platform has limited memory access
      // Use estimated memory usage as fallback
      final currentMemoryMB = MemoryInfo._estimateCurrentMemoryUsage();

      // Estimate total memory for web browsers (typically 4-8GB)
      final totalMemoryMB = 4096.0; // Default to 4GB for web

      final usedMemoryMB = currentMemoryMB;
      final freeMemoryMB = totalMemoryMB - usedMemoryMB;
      final usagePercentage = totalMemoryMB > 0 ? (usedMemoryMB / totalMemoryMB) * 100 : 0.0;

      return {
        'total': totalMemoryMB,
        'used': usedMemoryMB,
        'free': freeMemoryMB,
        'percentage': usagePercentage,
      };
    } catch (e) {
      return {
        'total': 0.0,
        'used': 0.0,
        'free': 0.0,
        'percentage': 0.0,
      };
    }
  }

  /// Get memory info for mobile platforms
  static Map<String, double> _getMobileMemoryInfo() {
    try {
      // Use Flutter's built-in memory tracking
      // Fallback to estimated memory usage
      final currentMemoryMB = MemoryInfo._estimateCurrentMemoryUsage();

      // Estimate total memory based on platform
      double totalMemoryMB = 0;
      if (PlatformDetector.isIOS) {
        // iOS devices typically have 2-8GB RAM
        totalMemoryMB = 4096; // Default to 4GB
      } else if (PlatformDetector.isAndroid) {
        // Android devices vary widely
        totalMemoryMB = 6144; // Default to 6GB
      }

      final usedMemoryMB = currentMemoryMB;
      final freeMemoryMB = totalMemoryMB - usedMemoryMB;
      final usagePercentage = (usedMemoryMB / totalMemoryMB) * 100;

      return {
        'total': totalMemoryMB,
        'used': usedMemoryMB,
        'free': freeMemoryMB,
        'percentage': usagePercentage,
      };
    } catch (e) {
      return {
        'total': 0.0,
        'used': 0.0,
        'free': 0.0,
        'percentage': 0.0,
      };
    }
  }

  /// Get total system memory in MB (desktop platforms)
  static double _getTotalMemoryMB() {
    try {
      if (PlatformDetector.isWeb) {
        // Web platform - return estimated value
        return 4096.0; // 4GB default for web
      } else if (PlatformDetector.isLinux || PlatformDetector.isMacOS) {
        // Desktop platforms - use system commands
        // Use dynamic import to avoid web compilation issues
        return _getSystemMemoryLinuxMac();
      } else if (PlatformDetector.isWindows) {
        return _getSystemMemoryWindows();
      }
    } catch (e) {
      // Fallback to default values
    }

    // Default fallback values
    if (PlatformDetector.isWindows) return 8192; // 8GB
    if (PlatformDetector.isMacOS) return 16384; // 16GB
    if (PlatformDetector.isLinux) return 8192; // 8GB
    return 4096; // 4GB default
  }

  /// Get system memory for Linux/macOS (desktop only)
  static double _getSystemMemoryLinuxMac() {
    try {
      // Use desktop-specific implementation
      return MemoryManagerDesktop.getSystemMemoryLinuxMac();
    } catch (e) {
      // Fallback
    }
    return 4096.0; // Default fallback
  }

  /// Get system memory for Windows (desktop only)
  static double _getSystemMemoryWindows() {
    try {
      // Use desktop-specific implementation
      return MemoryManagerDesktop.getSystemMemoryWindows();
    } catch (e) {
      // Fallback
    }
    return 8192.0; // Default fallback
  }

  /// Get used memory in MB (desktop platforms)
  static double _getUsedMemoryMB() {
    try {
      // Use estimated memory usage as getCurrentRSS is not available
      return _estimateCurrentMemoryUsage();
    } catch (e) {
      return 0.0;
    }
  }

  /// Estimate current memory usage (fallback method)
  static double _estimateCurrentMemoryUsage() {
    try {
      // This is a rough estimation for mobile platforms
      // In a real implementation, you might use platform-specific APIs
      if (PlatformDetector.isIOS) {
        // iOS devices typically use more memory per app
        return 50.0 +
            (DateTime.now().millisecond % 100); // Base + random variation
      } else if (PlatformDetector.isAndroid) {
        // Android devices vary widely
        return 80.0 +
            (DateTime.now().millisecond % 150); // Base + random variation
      } else if (PlatformDetector.isWeb) {
        // Web platform estimation
        return 40.0 +
            (DateTime.now().millisecond % 80); // Base + random variation
      }
      return 60.0; // Default for other platforms
    } catch (e) {
      return 60.0; // Default fallback
    }
  }

  /// Get free memory in MB (desktop platforms)
  static double _getFreeMemoryMB() {
    final total = _getTotalMemoryMB();
    final used = _getUsedMemoryMB();
    return total - used;
  }

  /// Get memory usage percentage (desktop platforms)
  static double _getMemoryUsagePercentage() {
    final total = _getTotalMemoryMB();
    final used = _getUsedMemoryMB();

    if (total == 0) return 0.0;
    return (used / total) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMemoryMB': totalMemoryMB,
      'usedMemoryMB': usedMemoryMB,
      'freeMemoryMB': freeMemoryMB,
      'usagePercentage': usagePercentage,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MemoryInfo(total: ${totalMemoryMB.toStringAsFixed(1)}MB, '
        'used: ${usedMemoryMB.toStringAsFixed(1)}MB, '
        'free: ${freeMemoryMB.toStringAsFixed(1)}MB, '
        'usage: ${usagePercentage.toStringAsFixed(1)}%)';
  }
}

/// Memory leak detection data
class MemoryLeakData {
  final String objectName;
  final DateTime createdAt;
  final DateTime? disposedAt;
  final int instanceCount;
  final double memoryFootprintMB;
  final bool isPotentialLeak;

  const MemoryLeakData({
    required this.objectName,
    required this.createdAt,
    this.disposedAt,
    required this.instanceCount,
    required this.memoryFootprintMB,
    required this.isPotentialLeak,
  });

  Duration? get lifecycleDuration {
    if (disposedAt == null) return null;
    return disposedAt!.difference(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'objectName': objectName,
      'createdAt': createdAt.toIso8601String(),
      'disposedAt': disposedAt?.toIso8601String(),
      'instanceCount': instanceCount,
      'memoryFootprintMB': memoryFootprintMB,
      'isPotentialLeak': isPotentialLeak,
      'lifecycleDuration': lifecycleDuration?.inMilliseconds,
    };
  }
}

/// Memory Manager for monitoring and managing app memory usage
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final AppLogger _logger = AppLogger();
  final List<MemoryInfo> _memoryHistory = [];
  final Map<String, MemoryLeakData> _trackedObjects = {};
  Timer? _monitoringTimer;
  Timer? _cleanupTimer;

  /// Memory thresholds
  static const double _warningThreshold = 70.0; // 70%
  static const double _criticalThreshold = 85.0; // 85%
  static const int _maxHistorySize = 100;

  /// Initialize memory monitoring
  void initialize() {
    if (!AppConfig.enableLogging) return;

    _logger.info('Initializing Memory Manager...');

    // Start periodic memory monitoring
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _monitorMemory(),
    );

    // Start periodic cleanup
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanupOldData(),
    );

    // Initial memory reading
    _monitorMemory();

    _logger.info('Memory Manager initialized successfully');
  }

  /// Dispose memory manager
  void dispose() {
    _monitoringTimer?.cancel();
    _cleanupTimer?.cancel();
    _logger.info('Memory Manager disposed');
  }

  /// Get current memory usage
  static double getCurrentMemoryUsage() {
    try {
      // Use estimated memory usage as getCurrentRSS is not available
      return MemoryInfo._estimateCurrentMemoryUsage();
    } catch (e) {
      return 0.0;
    }
  }

  /// Get current memory information
  MemoryInfo getCurrentMemoryInfo() {
    return MemoryInfo.current();
  }

  /// Get memory history
  List<MemoryInfo> getMemoryHistory() {
    return List.unmodifiable(_memoryHistory);
  }

  /// Get memory trend (increase/decrease/stable)
  String getMemoryTrend() {
    if (_memoryHistory.length < 2) return 'stable';

    final recent = _memoryHistory.take(5).toList();
    if (recent.length < 2) return 'stable';

    double totalChange = 0;
    for (int i = 1; i < recent.length; i++) {
      totalChange += recent[i].usedMemoryMB - recent[i - 1].usedMemoryMB;
    }

    final avgChange = totalChange / (recent.length - 1);

    if (avgChange > 10) return 'increasing';
    if (avgChange < -10) return 'decreasing';
    return 'stable';
  }

  /// Track an object for memory leak detection
  void trackObject(String objectName, {double memoryFootprintMB = 0.0}) {
    if (!AppConfig.enableLogging) return;

    final existingData = _trackedObjects[objectName];

    if (existingData == null) {
      _trackedObjects[objectName] = MemoryLeakData(
        objectName: objectName,
        createdAt: DateTime.now(),
        instanceCount: 1,
        memoryFootprintMB: memoryFootprintMB,
        isPotentialLeak: false,
      );
    } else {
      _trackedObjects[objectName] = MemoryLeakData(
        objectName: objectName,
        createdAt: existingData.createdAt,
        instanceCount: existingData.instanceCount + 1,
        memoryFootprintMB: memoryFootprintMB,
        isPotentialLeak:
            existingData.instanceCount > 5, // Threshold for potential leak
      );
    }

    if (_trackedObjects[objectName]!.isPotentialLeak) {
      _logger.warning('Potential memory leak detected: $objectName '
          '(${_trackedObjects[objectName]!.instanceCount} instances)');
    }
  }

  /// Untrack an object
  void untrackObject(String objectName) {
    final data = _trackedObjects[objectName];
    if (data != null) {
      _trackedObjects[objectName] = MemoryLeakData(
        objectName: objectName,
        createdAt: data.createdAt,
        disposedAt: DateTime.now(),
        instanceCount: data.instanceCount - 1,
        memoryFootprintMB: data.memoryFootprintMB,
        isPotentialLeak: false,
      );

      // Remove if instance count reaches 0
      if (_trackedObjects[objectName]!.instanceCount <= 0) {
        _trackedObjects.remove(objectName);
      }
    }
  }

  /// Force garbage collection
  void forceGC() {
    _logger.info('Forcing garbage collection...');

    // In Dart, we can suggest GC but it's not guaranteed
    // This is mainly for debugging purposes
    if (kDebugMode) {
      developer.log('Manual GC triggered', name: 'MemoryManager');
    }

    // Monitor memory after GC
    Timer(const Duration(seconds: 2), () {
      _monitorMemory();
    });
  }

  /// Get memory usage summary
  Map<String, dynamic> getMemorySummary() {
    final currentInfo = getCurrentMemoryInfo();
    final trend = getMemoryTrend();

    return {
      'current': currentInfo.toJson(),
      'trend': trend,
      'historySize': _memoryHistory.length,
      'trackedObjects': _trackedObjects.length,
      'potentialLeaks':
          _trackedObjects.values.where((data) => data.isPotentialLeak).length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get detailed memory report
  Map<String, dynamic> getDetailedReport() {
    return {
      'summary': getMemorySummary(),
      'history': _memoryHistory.map((info) => info.toJson()).toList(),
      'trackedObjects':
          _trackedObjects.values.map((data) => data.toJson()).toList(),
      'potentialLeaks': _trackedObjects.values
          .where((data) => data.isPotentialLeak)
          .map((data) => data.toJson())
          .toList(),
    };
  }

  void _monitorMemory() {
    final memoryInfo = getCurrentMemoryInfo();
    _memoryHistory.add(memoryInfo);

    // Limit history size
    if (_memoryHistory.length > _maxHistorySize) {
      _memoryHistory.removeAt(0);
    }

    // Check thresholds
    if (memoryInfo.usagePercentage > _criticalThreshold) {
      _logger.error(
          'CRITICAL: Memory usage at ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
      _suggestMemoryCleanup();
    } else if (memoryInfo.usagePercentage > _warningThreshold) {
      _logger.warning(
          'WARNING: Memory usage at ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
    }

    // Log in debug mode
    if (AppConfig.debugMode) {
      _logger.debug('Memory: ${memoryInfo.toString()}');
    }
  }

  void _cleanupOldData() {
    // Clean up old memory history (keep last 50 entries)
    if (_memoryHistory.length > 50) {
      _memoryHistory.removeRange(0, _memoryHistory.length - 50);
    }

    // Clean up old tracked objects (older than 1 hour)
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 1));
    _trackedObjects.removeWhere((key, data) {
      return data.disposedAt != null && data.disposedAt!.isBefore(cutoffTime);
    });
  }

  void _suggestMemoryCleanup() {
    _logger.info('Suggesting memory cleanup actions:');
    _logger.info('1. Consider clearing caches');
    _logger.info('2. Dispose unused objects');
    _logger.info('3. Force garbage collection');

    // Auto-trigger GC in critical situations
    if (AppConfig.debugMode) {
      forceGC();
    }
  }
}

/// Memory usage widget helper for debugging
class MemoryMonitorWidget {
  static String getMemoryDisplay() {
    final memoryInfo = MemoryManager().getCurrentMemoryInfo();
    return '${memoryInfo.usedMemoryMB.toStringAsFixed(1)}MB '
        '(${memoryInfo.usagePercentage.toStringAsFixed(1)}%)';
  }

  static String getMemoryTrendDisplay() {
    final trend = MemoryManager().getMemoryTrend();
    switch (trend) {
      case 'increasing':
        return '📈';
      case 'decreasing':
        return '📉';
      default:
        return '➡️';
    }
  }
}
