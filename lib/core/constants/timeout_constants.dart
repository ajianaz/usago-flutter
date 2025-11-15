import 'dart:async';

/// Konstanta timeout yang digunakan di seluruh aplikasi
class TimeoutConstants {
  const TimeoutConstants._();

  /// Timeout untuk operasi jaringan (30 detik)
  static const Duration network = Duration(seconds: 30);

  /// Timeout untuk operasi kritis (2 detik)
  static const Duration critical = Duration(seconds: 2);

  /// Threshold warning untuk BLoC execution time (100ms)
  static const Duration blocWarning = Duration(milliseconds: 100);

  /// Threshold critical untuk BLoC execution time (500ms)
  static const Duration blocCritical = Duration(milliseconds: 500);

  /// Timeout untuk koneksi database (15 detik)
  static const Duration database = Duration(seconds: 15);

  /// Timeout untuk operasi file I/O (10 detik)
  static const Duration fileIO = Duration(seconds: 10);

  /// Timeout untuk cache retrieval (1 detik)
  static const Duration cache = Duration(seconds: 1);

  /// Timeout untuk operasi storage (5 detik)
  static const Duration storage = Duration(seconds: 5);

  /// Timeout untuk retry mechanism (1 detik)
  static const Duration retry = Duration(seconds: 1);

  /// Timeout untuk splash screen (3 detik)
  static const Duration splash = Duration(seconds: 3);

  /// Timeout untuk animasi loading (30 detik maksimal)
  static const Duration loading = Duration(seconds: 30);
}