import 'dart:async';

/// Konstanta performance yang digunakan di seluruh aplikasi
class PerformanceConstants {
  const PerformanceConstants._();

  // ==================== Memory Thresholds ====================

  /// Memory threshold untuk warning (70%)
  static const double memoryWarningThreshold = 0.7;

  /// Memory threshold untuk critical (85%)
  static const double memoryCriticalThreshold = 0.85;

  /// Memory threshold untuk alert (80%)
  static const double memoryAlertThreshold = 0.8;

  /// Memory threshold untuk very critical (90%)
  static const double memoryVeryCriticalThreshold = 0.9;

  // ==================== Cache Configuration ====================

  /// Default cache expiry duration (24 jam)
  static const Duration defaultCacheExpiry = Duration(hours: 24);

  /// Short cache expiry (1 jam)
  static const Duration shortCacheExpiry = Duration(hours: 1);

  /// Long cache expiry (7 hari)
  static const Duration longCacheExpiry = Duration(days: 7);

  /// Session cache expiry (30 menit)
  static const Duration sessionCacheExpiry = Duration(minutes: 30);

  /// Image cache expiry (3 hari)
  static const Duration imageCacheExpiry = Duration(days: 3);

  // ==================== Pagination ====================

  /// Default page size untuk pagination
  static const int defaultPageSize = 20;

  /// Maximum page size
  static const int maxPageSize = 100;

  /// Minimum page size
  static const int minPageSize = 5;

  // ==================== Metrics History ====================

  /// Maximum history length untuk performance metrics (1000 entries)
  static const int maxMetricsHistoryLength = 1000;

  /// Maximum history length untuk memory metrics (100 entries)
  static const int maxMemoryHistoryLength = 100;

  /// Maximum history length untuk CPU metrics (500 entries)
  static const int maxCpuHistoryLength = 500;

  // ==================== Performance Monitoring ====================

  /// Interval untuk performance monitoring (5 detik)
  static const Duration performanceMonitoringInterval = Duration(seconds: 5);

  /// Interval untuk memory monitoring (2 detik)
  static const Duration memoryMonitoringInterval = Duration(seconds: 2);

  /// Interval untuk CPU monitoring (1 detik)
  static const Duration cpuMonitoringInterval = Duration(seconds: 1);

  /// Interval untuk network monitoring (10 detik)
  static const Duration networkMonitoringInterval = Duration(seconds: 10);

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

  /// Maximum connection pool size
  static const int maxConnectionPoolSize = 10;

  /// Minimum connection pool size
  static const int minConnectionPoolSize = 2;

  // ==================== Network Performance ====================

  /// Maximum concurrent network requests
  static const int maxConcurrentRequests = 5;

  /// Network request timeout (30 detik)
  static const Duration networkRequestTimeout = Duration(seconds: 30);

  /// Retry delay untuk failed requests (1 detik)
  static const Duration retryDelay = Duration(seconds: 1);

  /// Maximum retry attempts
  static const int maxRetryAttempts = 3;

  // ==================== UI Performance ====================

  /// Maximum frame time untuk smooth animation (16ms untuk 60fps)
  static const Duration maxFrameTime = Duration(milliseconds: 16);

  /// Warning threshold untuk frame time (33ms untuk 30fps)
  static const Duration frameTimeWarning = Duration(milliseconds: 33);

  /// Maximum widgets dalam rebuild cycle
  static const int maxWidgetsInRebuild = 100;

  /// Debounce time untuk search input (300ms)
  static const Duration searchDebounceTime = Duration(milliseconds: 300);

  // ==================== File I/O Performance ====================

  /// Maximum file read time (5 detik)
  static const Duration maxFileReadTime = Duration(seconds: 5);

  /// Maximum file write time (10 detik)
  static const Duration maxFileWriteTime = Duration(seconds: 10);

  /// Buffer size untuk file operations
  static const int fileBufferSize = 8192;

  /// Maximum concurrent file operations
  static const int maxConcurrentFileOperations = 3;

  // ==================== Logging Performance ====================

  /// Maximum log entries in memory
  static const int maxLogEntriesInMemory = 1000;

  /// Log flush interval (1 menit)
  static const Duration logFlushInterval = Duration(minutes: 1);

  /// Maximum log file size (10MB)
  static const int maxLogFileSizeBytes = 10 * 1024 * 1024;

  /// Maximum log files to keep
  static const int maxLogFilesToKeep = 5;
}