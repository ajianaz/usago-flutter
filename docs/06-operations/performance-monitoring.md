# Performance Monitoring Guide
# Panduan Pemantauan Kinerja

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-PERFORMANCE-MONITORING |
| **Version** | 1.0 |
| **Status** | Ready to Implement |
| **Category** | Technical Documentation |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Performance Team, Tech Lead |
| **Stakeholders** | Development Team, QA Team, DevOps Team |

---

## 🎯 **Purpose**

Dokumen ini menjelaskan sistem performance monitoring yang diimplementasikan dalam aplikasi Usago Mobile. Sistem ini dirancang untuk monitoring real-time performance metrics, memory usage, BLoC execution time, dan memberikan alerts untuk performance issues.

---

## 📚 **Table of Contents**

1. [Performance Monitoring Overview](#performance-monitoring-overview)
2. [BaseBloc Performance Tracking](#basebloc-performance-tracking)
3. [Memory Management](#memory-management)
4. [Performance Metrics](#performance-metrics)
5. [Thresholds and Alerts](#thresholds-and-alerts)
6. [Performance Optimization](#performance-optimization)
7. [Troubleshooting Guide](#troubleshooting-guide)
8. [Best Practices](#best-practices)

---

## 📊 **Performance Monitoring Overview**

### Arsitektur Monitoring

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PERFORMANCE MONITORING ARCHITECTURE          │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    PERFORMANCE TRACKER                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Metrics   │  │   Alerts    │  │  Reporting  │ │   │
│  │  │ Collection  │  │ Generation  │  │   System    │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    BASE BLOC TRACKING                        │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Event     │  │   State     │  │ Execution   │ │   │
│  │  │ Tracking    │  │ Tracking    │  │   Time      │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    MEMORY MANAGER                            │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Memory    │  │   Memory    │  │   Memory    │ │   │
│  │  │ Monitoring  │  │ Thresholds  │  │ Cleanup     │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    PERFORMANCE DASHBOARD                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Real-time │  │ Historical  │  │   Alert     │ │   │
│  │  │   Metrics   │  │   Trends     │  │   History    │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Komponen Utama

1. **PerformanceTracker**: Centralized performance tracking system
2. **BaseBloc Integration**: Built-in tracking untuk BLoC lifecycle
3. **MemoryManager**: Memory usage monitoring dan management
4. **PerformanceDashboard**: Real-time performance visualization
5. **AlertSystem**: Automatic alerts untuk performance issues

---

## 🎭 **BaseBloc Performance Tracking**

### Built-in Performance Tracking

[`BaseBloc`](../lib/core/blocs/base_bloc.dart:94) memiliki built-in performance tracking:

```dart
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState> extends Bloc<Event, State> {
  final PerformanceTracker _performanceTracker;
  String? _blocTrackingId;

  BaseBloc({
    required State initialState,
    PerformanceTracker? performanceTracker,
  }) : _performanceTracker = performanceTracker ?? PerformanceTracker(),
       super(initialState) {
    // Initialize performance tracking
    _initializePerformanceTracking();
  }

  void _initializePerformanceTracking() {
    if (!AppConfig.enablePerformanceMonitoring) return;

    _blocTrackingId = _performanceTracker.startTracking(
      blocName,
      category: 'bloc_lifecycle',
    );
  }
}
```

### Event Execution Tracking

Setiap BLoC event execution di-track:

```dart
@override
void onTransition(Transition<Event, State> transition) {
  // Track performance if enabled
  if (AppConfig.enablePerformanceMonitoring) {
    _performanceTracker.trackTransition(
      blocName,
      transition.event.runtimeType.toString(),
      transition.currentState.runtimeType.toString(),
      transition.nextState.runtimeType.toString(),
    );
  }

  // Log transition
  _logTransition(transition);

  super.onTransition(transition);
}
```

### Use Case Execution Tracking

Use case execution di-track dengan timing:

```dart
Future<void> executeUseCase<T, P>(
  Future<Either<Failure, T>> Function(P) useCase,
  P params, {
  String? loadingMessage,
  String? successMessage,
  String? eventName,
  Map<String, dynamic>? metadata,
}) async {
  final opName = eventName ?? 'UseCaseExecution';
  final trackingId = AppConfig.enablePerformanceMonitoring
      ? _performanceTracker.startTracking(opName, category: 'usecase')
      : null;

  try {
    // Emit loading state
    emit(_createLoadingState(loadingMessage, metadata));

    // Execute use case
    final result = await useCase(params);

    // Handle result
    emit(result.fold(
      (failure) {
        if (trackingId != null) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': false,
            'error': failure.message,
            ...?metadata,
          });
        }

        return _createErrorState(failure, metadata);
      },
      (data) {
        if (trackingId != null) {
          _performanceTracker.stopTracking(trackingId, metadata: {
            'success': true,
            'dataType': T.toString(),
            ...?metadata,
          });
        }

        return _createSuccessState(data, successMessage, metadata);
      },
    ));
  } catch (e, stackTrace) {
    _logger.error('Unexpected error in use case execution: $opName', e, stackTrace);

    if (trackingId != null) {
      _performanceTracker.stopTracking(trackingId, metadata: {
        'success': false,
        'error': e.toString(),
        ...?metadata,
      });
    }

    emit(_createErrorState(
      UnknownFailure(
        message: 'An unexpected error occurred during $opName',
        originalError: e,
      ),
      metadata,
    ));
  }
}
```

---

## 🧠 **Memory Management**

### Memory Monitoring

[`MemoryManager`](../lib/core/performance/memory_manager.dart) menyediakan memory monitoring:

```dart
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final List<MemorySnapshot> _memoryHistory = [];
  Timer? _monitoringTimer;
  bool _isMonitoring = false;

  // Start memory monitoring
  void startMonitoring() {
    if (_isMonitoring || !AppConfig.enableMemoryMonitoring) return;

    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(
      AppConfig.memoryMonitoringInterval,
      (_) => _captureMemorySnapshot(),
    );
  }

  // Capture memory snapshot
  void _captureMemorySnapshot() {
    final info = ProcessInfo.currentRss;
    final snapshot = MemorySnapshot(
      timestamp: DateTime.now(),
      totalMemory: info,
      usedMemory: _getUsedMemory(),
      freeMemory: _getFreeMemory(),
      memoryUsagePercentage: _calculateMemoryUsagePercentage(),
    );

    _memoryHistory.add(snapshot);
    _cleanupOldSnapshots();

    // Check thresholds
    _checkMemoryThresholds(snapshot);
  }

  // Check memory thresholds
  void _checkMemoryThresholds(MemorySnapshot snapshot) {
    if (snapshot.memoryUsagePercentage >= AppConfig.memoryCriticalThreshold) {
      _handleCriticalMemoryUsage(snapshot);
    } else if (snapshot.memoryUsagePercentage >= AppConfig.memoryWarningThreshold) {
      _handleWarningMemoryUsage(snapshot);
    }
  }
}
```

### Memory Thresholds

Memory thresholds didefinisikan dalam [`PerformanceConstants`](../lib/core/constants/performance_constants.dart:4):

```dart
class PerformanceConstants {
  /// Memory threshold untuk warning (70%)
  static const double memoryWarningThreshold = 0.7;

  /// Memory threshold untuk critical (85%)
  static const double memoryCriticalThreshold = 0.85;

  /// Memory threshold untuk alert (80%)
  static const double memoryAlertThreshold = 0.8;

  /// Memory threshold untuk very critical (90%)
  static const double memoryVeryCriticalThreshold = 0.9;
}
```

### Memory Cleanup

Automatic cleanup saat memory usage tinggi:

```dart
class MemoryManager {
  void _handleCriticalMemoryUsage(MemorySnapshot snapshot) {
    // Log critical memory usage
    ErrorHandlerUtils.logError(
      'Critical memory usage detected',
      correlationId: ErrorHandlerUtils.generateCorrelationId(),
      operation: 'MemoryManagement',
      metadata: {
        'memoryUsagePercentage': snapshot.memoryUsagePercentage,
        'usedMemory': snapshot.usedMemory,
        'totalMemory': snapshot.totalMemory,
      },
    );

    // Trigger cleanup
    _performMemoryCleanup();
  }

  void _performMemoryCleanup() {
    // Clear BLoC caches
    _clearBlocCaches();

    // Clear image caches
    _clearImageCaches();

    // Force garbage collection
    _forceGarbageCollection();

    // Notify memory cleanup completed
    _notifyMemoryCleanup();
  }

  void _clearBlocCaches() {
    // Clear BLoC state history
    for (final bloc in _activeBlocs) {
      if (bloc is BaseBloc) {
        (bloc as BaseBloc).clearStateHistory();
      }
    }
  }

  void _clearImageCaches() {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void _forceGarbageCollection() {
    // Force garbage collection
    // Note: Ini hanya untuk development/debug purposes
    if (AppConfig.isDevelopment) {
      System.gc();
    }
  }
}
```

---

## 📈 **Performance Metrics**

### Metrics Collection

[`PerformanceTracker`](../lib/core/performance/performance_tracker.dart) mengumpulkan berbagai metrics:

```dart
class PerformanceTracker {
  final List<PerformanceMetric> _metrics = [];
  final Map<String, TrackingSession> _activeSessions = {};

  // Track BLoC performance
  void trackBlocPerformance(String blocName, String eventType, Duration duration) {
    final metric = PerformanceMetric(
      timestamp: DateTime.now(),
      category: 'bloc',
      name: '$blocName.$eventType',
      duration: duration,
      success: true,
      metadata: {
        'blocName': blocName,
        'eventType': eventType,
        'durationMs': duration.inMilliseconds,
      },
    );

    _metrics.add(metric);
    _checkPerformanceThresholds(metric);
  }

  // Track API performance
  void trackApiPerformance(String method, String endpoint, Duration duration, bool success, {
    int? statusCode,
    String? error,
  }) {
    final metric = PerformanceMetric(
      timestamp: DateTime.now(),
      category: 'api',
      name: '${method}_$endpoint',
      duration: duration,
      success: success,
      metadata: {
        'method': method,
        'endpoint': endpoint,
        'statusCode': statusCode,
        'error': error,
        'durationMs': duration.inMilliseconds,
      },
    );

    _metrics.add(metric);
    _checkPerformanceThresholds(metric);
  }

  // Track use case performance
  void trackUseCasePerformance(String useCaseName, Duration duration, bool success, {
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    final metric = PerformanceMetric(
      timestamp: DateTime.now(),
      category: 'usecase',
      name: useCaseName,
      duration: duration,
      success: success,
      metadata: {
        'error': error,
        'durationMs': duration.inMilliseconds,
        ...?metadata,
      },
    );

    _metrics.add(metric);
    _checkPerformanceThresholds(metric);
  }
}
```

### Performance Categories

Metrics dikategorikan berdasarkan jenis operasi:

1. **BLoC Metrics**: BLoC event dan state transitions
2. **API Metrics**: HTTP request/response performance
3. **Use Case Metrics**: Business logic execution time
4. **UI Metrics**: Frame rendering dan widget rebuild times
5. **Memory Metrics**: Memory usage dan garbage collection

### Performance Data Model

```dart
class PerformanceMetric {
  final DateTime timestamp;
  final String category;
  final String name;
  final Duration duration;
  final bool success;
  final Map<String, dynamic>? metadata;

  const PerformanceMetric({
    required this.timestamp,
    required this.category,
    required this.name,
    required this.duration,
    required this.success,
    this.metadata,
  });

  // Check if metric is slow
  bool get isSlow {
    switch (category) {
      case 'bloc':
        return duration.inMilliseconds > PerformanceConstants.blocWarningThreshold.inMilliseconds;
      case 'api':
        return duration.inMilliseconds > 1000; // 1 second
      case 'usecase':
        return duration.inMilliseconds > 2000; // 2 seconds
      default:
        return false;
    }
  }

  // Check if metric is critical
  bool get isCritical {
    switch (category) {
      case 'bloc':
        return duration.inMilliseconds > PerformanceConstants.maxBlocExecutionTime.inMilliseconds;
      case 'api':
        return duration.inMilliseconds > 5000; // 5 seconds
      case 'usecase':
        return duration.inMilliseconds > 10000; // 10 seconds
      default:
        return false;
    }
  }

  // Get performance level
  String get performanceLevel {
    if (isCritical) return 'CRITICAL';
    if (isSlow) return 'SLOW';
    return 'NORMAL';
  }
}
```

---

## 🚨 **Thresholds and Alerts**

### Performance Thresholds

Thresholds didefinisikan dalam [`PerformanceConstants`](../lib/core/constants/performance_constants.dart:4):

```dart
class PerformanceConstants {
  // ==================== BLoC Performance ====================

  /// Maximum execution time untuk BLoC events (500ms)
  static const Duration maxBlocExecutionTime = Duration(milliseconds: 500);

  /// Warning threshold untuk BLoC execution time (200ms)
  static const Duration blocWarningThreshold = Duration(milliseconds: 200);

  /// Maximum BLoC events dalam queue
  static const int maxBlocEventQueueSize = 50;

  /// Maximum BLoC states dalam history
  static const int maxBlocStateHistory = 100;

  // ==================== Database Performance ====================

  /// Maximum query execution time (2 detik)
  static const Duration maxQueryExecutionTime = Duration(seconds: 2);

  /// Warning threshold untuk query execution time (1 detik)
  static const Duration queryWarningThreshold = Duration(seconds: 1);

  // ==================== Network Performance ====================

  /// Maximum concurrent network requests
  static const int maxConcurrentRequests = 5;

  /// Network request timeout (30 detik)
  static const Duration networkRequestTimeout = Duration(seconds: 30);

  /// Retry delay untuk failed requests (1 detik)
  static const Duration retryDelay = Duration(seconds: 1);

  // ==================== UI Performance ====================

  /// Maximum frame time untuk smooth animation (16ms untuk 60fps)
  static const Duration maxFrameTime = Duration(milliseconds: 16);

  /// Warning threshold untuk frame time (33ms untuk 30fps)
  static const Duration frameTimeWarning = Duration(milliseconds: 33);

  /// Maximum widgets dalam rebuild cycle
  static const int maxWidgetsInRebuild = 100;

  /// Debounce time untuk search input (300ms)
  static const Duration searchDebounceTime = Duration(milliseconds: 300);
}
```

### Alert System

Automatic alerts untuk performance issues:

```dart
class PerformanceAlertManager {
  static final PerformanceAlertManager _instance = PerformanceAlertManager._internal();
  factory PerformanceAlertManager() => _instance;
  PerformanceAlertManager._internal();

  final List<PerformanceAlert> _alerts = [];
  final StreamController<PerformanceAlert> _alertController = StreamController.broadcast();

  Stream<PerformanceAlert> get alertStream => _alertController.stream;

  // Check and generate alerts
  void checkMetrics(PerformanceMetric metric) {
    if (metric.isCritical) {
      _generateCriticalAlert(metric);
    } else if (metric.isSlow) {
      _generateSlowAlert(metric);
    }
  }

  // Generate critical alert
  void _generateCriticalAlert(PerformanceMetric metric) {
    final alert = PerformanceAlert(
      id: _generateAlertId(),
      timestamp: DateTime.now(),
      level: AlertLevel.critical,
      category: metric.category,
      title: 'Critical Performance Issue',
      message: '${metric.name} took ${metric.duration.inMilliseconds}ms',
      metric: metric,
      recommendations: _getRecommendations(metric),
    );

    _alerts.add(alert);
    _alertController.add(alert);
    _logAlert(alert);
  }

  // Generate slow alert
  void _generateSlowAlert(PerformanceMetric metric) {
    final alert = PerformanceAlert(
      id: _generateAlertId(),
      timestamp: DateTime.now(),
      level: AlertLevel.warning,
      category: metric.category,
      title: 'Slow Performance Detected',
      message: '${metric.name} took ${metric.duration.inMilliseconds}ms',
      metric: metric,
      recommendations: _getRecommendations(metric),
    );

    _alerts.add(alert);
    _alertController.add(alert);
    _logAlert(alert);
  }

  // Get recommendations for metric
  List<String> _getRecommendations(PerformanceMetric metric) {
    switch (metric.category) {
      case 'bloc':
        return [
          'Consider breaking down complex BLoC logic',
          'Optimize BLoC event handlers',
          'Reduce BLoC state complexity',
        ];
      case 'api':
        return [
          'Check network connectivity',
          'Implement request caching',
          'Optimize API response size',
        ];
      case 'usecase':
        return [
          'Optimize business logic',
          'Implement caching strategies',
          'Reduce use case complexity',
        ];
      default:
        return ['Investigate performance bottlenecks'];
    }
  }
}
```

### Alert Levels

```dart
enum AlertLevel {
  info,
  warning,
  critical,
}

class PerformanceAlert {
  final String id;
  final DateTime timestamp;
  final AlertLevel level;
  final String category;
  final String title;
  final String message;
  final PerformanceMetric metric;
  final List<String> recommendations;

  const PerformanceAlert({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.category,
    required this.title,
    required this.message,
    required this.metric,
    required this.recommendations,
  });

  // Get alert color for UI
  Color getAlertColor() {
    switch (level) {
      case AlertLevel.info:
        return Colors.blue;
      case AlertLevel.warning:
        return Colors.orange;
      case AlertLevel.critical:
        return Colors.red;
    }
  }

  // Get alert icon for UI
  IconData getAlertIcon() {
    switch (level) {
      case AlertLevel.info:
        return Icons.info;
      case AlertLevel.warning:
        return Icons.warning;
      case AlertLevel.critical:
        return Icons.error;
    }
  }
}
```

---

## ⚡ **Performance Optimization**

### Automatic Optimization

System otomatis melakukan optimasi saat performance issues terdeteksi:

```dart
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  // Optimize based on performance metrics
  void optimizePerformance(PerformanceMetric metric) {
    switch (metric.category) {
      case 'bloc':
        _optimizeBlocPerformance(metric);
        break;
      case 'api':
        _optimizeApiPerformance(metric);
        break;
      case 'usecase':
        _optimizeUseCasePerformance(metric);
        break;
      case 'ui':
        _optimizeUIPerformance(metric);
        break;
    }
  }

  // Optimize BLoC performance
  void _optimizeBlocPerformance(PerformanceMetric metric) {
    if (metric.duration.inMilliseconds > PerformanceConstants.blocWarningThreshold.inMilliseconds) {
      // Reduce BLoC state history
      _reduceBlocStateHistory();

      // Clear BLoC event queue
      _clearBlocEventQueue();

      // Optimize BLoC rebuild frequency
      _optimizeBlocRebuildFrequency();
    }
  }

  // Optimize API performance
  void _optimizeApiPerformance(PerformanceMetric metric) {
    if (metric.duration.inMilliseconds > 1000) {
      // Enable request caching
      _enableRequestCaching();

      // Reduce concurrent requests
      _reduceConcurrentRequests();

      // Implement request debouncing
      _implementRequestDebouncing();
    }
  }

  // Optimize use case performance
  void _optimizeUseCasePerformance(PerformanceMetric metric) {
    if (metric.duration.inMilliseconds > 2000) {
      // Enable use case caching
      _enableUseCaseCaching();

      // Implement lazy loading
      _implementLazyLoading();

      // Optimize data processing
      _optimizeDataProcessing();
    }
  }

  // Optimize UI performance
  void _optimizeUIPerformance(PerformanceMetric metric) {
    if (metric.duration.inMilliseconds > PerformanceConstants.frameTimeWarning.inMilliseconds) {
      // Reduce widget rebuilds
      _reduceWidgetRebuilds();

      // Optimize image loading
      _optimizeImageLoading();

      // Implement lazy loading for lists
      _implementLazyListLoading();
    }
  }
}
```

### Caching Strategies

Implementasi caching untuk performance improvement:

```dart
class PerformanceCache {
  static final PerformanceCache _instance = PerformanceCache._internal();
  factory PerformanceCache() => _instance;
  PerformanceCache._internal();

  final Map<String, CachedItem> _cache = {};

  // Cache BLoC states
  void cacheBlocState(String blocName, dynamic state) {
    final item = CachedItem(
      data: state,
      timestamp: DateTime.now(),
      expiry: DateTime.now().add(const Duration(minutes: 5)),
    );

    _cache[blocName] = item;
  }

  // Get cached BLoC state
  dynamic getCachedBlocState(String blocName) {
    final item = _cache[blocName];
    if (item == null || item.isExpired) {
      return null;
    }

    return item.data;
  }

  // Cache API responses
  void cacheApiResponse(String endpoint, dynamic response) {
    final item = CachedItem(
      data: response,
      timestamp: DateTime.now(),
      expiry: DateTime.now().add(PerformanceConstants.defaultCacheExpiry),
    );

    _cache['api:$endpoint'] = item;
  }

  // Get cached API response
  dynamic getCachedApiResponse(String endpoint) {
    final item = _cache['api:$endpoint'];
    if (item == null || item.isExpired) {
      return null;
    }

    return item.data;
  }

  // Clear expired cache items
  void clearExpiredCache() {
    _cache.removeWhere((key, item) => item.isExpired);
  }
}

class CachedItem {
  final dynamic data;
  final DateTime timestamp;
  final DateTime expiry;

  CachedItem({
    required this.data,
    required this.timestamp,
    required this.expiry,
  });

  bool get isExpired => DateTime.now().isAfter(expiry);
}
```

---

## 🔧 **Troubleshooting Guide**

### Common Performance Issues

#### 1. **Slow BLoC Execution**

**Symptoms:**
- BLoC events taking > 500ms
- UI freezing during BLoC operations
- BLoC event queue buildup

**Causes:**
- Complex business logic in use cases
- Heavy computations in BLoC event handlers
- Synchronous operations in BLoC

**Solutions:**
```dart
// ✅ GOOD: Break down complex operations
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // Break down into smaller operations
    emit(AuthLoading());

    // Validate input
    final validationResult = await _validateLoginInput(event);
    if (validationResult.isFailure) {
      emit(AuthFailure(failure: validationResult.failure!));
      return;
    }

    // Perform login
    final loginResult = await _performLogin(event);
    emit(loginResult.fold(
      (failure) => AuthFailure(failure: failure),
      (user) => AuthSuccess(user: user),
    ));
  }
}

// ❌ BAD: Complex single operation
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // Everything in one complex operation
    final validation = _validateInput(event);
    final sanitization = _sanitizeInput(event);
    final encryption = _encryptData(event);
    final networkCall = await _makeApiCall(event);
    final processing = _processResponse(networkCall);
    final caching = _cacheResponse(processing);
    emit(AuthSuccess(user: caching));
  }
}
```

#### 2. **High Memory Usage**

**Symptoms:**
- Memory usage > 85%
- Frequent garbage collection
- App crashes with out of memory

**Causes:**
- Memory leaks in BLoC subscriptions
- Large objects cached indefinitely
- Image caches not cleared

**Solutions:**
```dart
// ✅ GOOD: Proper memory management
class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  final Map<String, ui.Image> _cache = {};
  final int _maxCacheSize = 100;

  void cacheImage(String url, ui.Image image) {
    if (_cache.length >= _maxCacheSize) {
      _clearOldestImages();
    }

    _cache[url] = image;
  }

  void _clearOldestImages() {
    final keys = _cache.keys.toList();
    final keysToRemove = keys.take(20); // Remove oldest 20

    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }
}

// ❌ BAD: Unbounded memory usage
class ImageCacheManager {
  final Map<String, ui.Image> _cache = {};

  void cacheImage(String url, ui.Image image) {
    _cache[url] = image; // Never clears cache!
  }
}
```

#### 3. **Slow API Performance**

**Symptoms:**
- API calls taking > 5 seconds
- Frequent timeout errors
- Poor user experience

**Causes:**
- Large response payloads
- Unoptimized queries
- Network connectivity issues

**Solutions:**
```dart
// ✅ GOOD: Optimized API calls
class OptimizedApiService {
  Future<List<User>> getUsers() async {
    // Use pagination
    final response = await dio.get('/users', queryParameters: {
      'limit': 20,
      'offset': 0,
    });

    return List<User>.from(
      response.data['data'].map((json) => User.fromJson(json)),
    );
  }
}

// ❌ BAD: Unoptimized API calls
class UnoptimizedApiService {
  Future<List<User>> getUsers() async {
    // Fetch all users at once
    final response = await dio.get('/users'); // Could be thousands of records!

    return List<User>.from(
      response.data.map((json) => User.fromJson(json)),
    );
  }
}
```

### Performance Debugging Tools

#### 1. **Performance Overlay**

```dart
class PerformanceOverlay extends StatefulWidget {
  @override
  _PerformanceOverlayState createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> {
  late StreamSubscription<PerformanceAlert> _alertSubscription;

  @override
  void initState() {
    super.initState();

    _alertSubscription = PerformanceAlertManager().alertStream.listen((alert) {
      // Show performance alerts
      _showPerformanceAlert(alert);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FPS: ${_getCurrentFps()}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Memory: ${_getCurrentMemoryUsage()}%',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Active BLoCs: ${_getActiveBlocsCount()}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 2. **Performance Dashboard**

```dart
class PerformanceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Memory Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            MemoryUsageChart(),
            const SizedBox(height: 16),

            const Text('BLoC Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            BlocPerformanceChart(),
            const SizedBox(height: 16),

            const Text('API Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ApiPerformanceChart(),
            const SizedBox(height: 16),

            const Text('Performance Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            PerformanceAlertsList(),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ **Best Practices**

### 1. **Performance Monitoring Setup**

```dart
// ✅ GOOD: Proper setup in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  await EnvConfig.load();

  // Initialize performance monitoring
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceTracker().initialize();
    MemoryManager().startMonitoring();
    PerformanceAlertManager().initialize();
  }

  runApp(const MyApp());
}

// ❌ BAD: No performance monitoring
void main() {
  runApp(const MyApp()); // No performance visibility!
}
```

### 2. **BLoC Performance**

```dart
// ✅ GOOD: Efficient BLoC implementation
class EfficientBloc extends BaseBloc<EfficientEvent, EfficientState> {
  EfficientBloc() : super(const EfficientState()) {
    on<EfficientEvent>(_onEfficientEvent);
  }

  Future<void> _onEfficientEvent(EfficientEvent event, Emitter<EfficientState> emit) async {
    // Use built-in performance tracking
    await executeUseCase(
      _useCase.call,
      event.params,
      eventName: 'EfficientOperation',
      metadata: {'optimization': 'enabled'},
    );
  }
}

// ❌ BAD: Inefficient BLoC implementation
class InefficientBloc extends BaseBloc<InefficientEvent, InefficientState> {
  InefficientBloc() : super(const InefficientState()) {
    on<InefficientEvent>(_onInefficientEvent);
  }

  Future<void> _onInefficientEvent(InefficientEvent event, Emitter<InefficientState> emit) async {
    // Heavy computation in BLoC
    final result = await _heavyComputation(event.data);

    // No performance tracking
    emit(InefficientState(data: result));
  }
}
```

### 3. **Memory Management**

```dart
// ✅ GOOD: Proper memory management
class ProperMemoryManager {
  final List<StreamSubscription> _subscriptions = [];

  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

// ❌ BAD: Memory leaks
class LeakyMemoryManager {
  final List<StreamSubscription> _subscriptions = [];

  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
    // Never cancels subscriptions!
  }
}
```

### 4. **Performance Optimization**

```dart
// ✅ GOOD: Proactive optimization
class ProactiveOptimizer {
  void optimizeBasedOnMetrics() {
    final metrics = PerformanceTracker().getRecentMetrics();

    for (final metric in metrics) {
      if (metric.isSlow) {
        PerformanceOptimizer().optimizePerformance(metric);
      }
    }
  }
}

// ❌ BAD: Reactive optimization
class ReactiveOptimizer {
  void optimizeWhenUserComplains() {
    // Only optimize when users complain about performance
    // Too late!
  }
}
```

---

## 🔗 **Related Documentation**

- [`shared-utilities-guide.md`](./shared-utilities-guide.md) - Shared utilities documentation
- [`architecture-patterns.md`](./architecture-patterns.md) - Architecture patterns and data flow
- [`configuration-management.md`](./configuration-management.md) - Configuration and constants
- [`security-implementation.md`](./security-implementation.md) - Security best practices
- [`code-review-checklist.md`](./code-review-checklist.md) - Code review guidelines

---

## 📞 **Contact Information**

### **Development Team**

| Role | Name | Contact |
|-------|-------|----------|
| **Mobile Lead** | [Name] | [Email] |
| **Performance Team** | [Name] | [Email] |
| **Tech Lead** | [Name] | [Email] |

### **Support**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Performance Issue** | [Name] | 2 hours |
| **Memory Leak** | [Name] | 1 hour |
| **Optimization Request** | [Name] | 4 hours |

---

## 📝 **Notes**

### **Current Status (November 15, 2025)**
- ✅ **Performance Tracking**: Complete tracking system implemented
- ✅ **Memory Management**: Automatic memory monitoring and cleanup
- ✅ **Alert System**: Real-time performance alerts
- ✅ **Optimization**: Automatic performance optimization
- ✅ **Dashboard**: Real-time performance visualization
- ✅ **Thresholds**: Configurable performance thresholds

### **Future Enhancements**
- 🔄 **Advanced Analytics**: Machine learning for performance prediction
- 🔄 **A/B Testing**: Performance impact testing
- 🔄 **Cloud Monitoring**: Remote performance monitoring
- 🔄 **Performance Budgets**: Performance budget management
- 🔄 **Automated Testing**: Performance regression testing

---

**Document End**

**Go Digital, Grow Together.**