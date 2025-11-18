import 'package:flutter/animation.dart';

/// Konstanta animasi yang digunakan di seluruh aplikasi
class AnimationConstants {
  const AnimationConstants._();

  // ==================== Durasi Animasi ====================

  /// Durasi animasi default (300ms)
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Durasi animasi button (150ms)
  static const Duration buttonDuration = Duration(milliseconds: 150);

  /// Durasi animasi input field (200ms)
  static const Duration inputDuration = Duration(milliseconds: 200);

  /// Durasi animasi success state (800ms)
  static const Duration successDuration = Duration(milliseconds: 800);

  /// Durasi animasi shimmer effect (1500ms)
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // ==================== Animasi Tambahan ====================

  /// Durasi animasi cepat (100ms)
  static const Duration fastDuration = Duration(milliseconds: 100);

  /// Durasi animasi sedang (500ms)
  static const Duration mediumDuration = Duration(milliseconds: 500);

  /// Durasi animasi lambat (1s)
  static const Duration slowDuration = Duration(seconds: 1);

  /// Durasi animasi sangat lambat (2s)
  static const Duration verySlowDuration = Duration(seconds: 2);

  // ==================== Page Transitions ====================

  /// Durasi animasi page transition (250ms)
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);

  /// Durasi animasi dialog transition (200ms)
  static const Duration dialogTransitionDuration = Duration(milliseconds: 200);

  /// Durasi animasi bottom sheet (300ms)
  static const Duration bottomSheetDuration = Duration(milliseconds: 300);

  // ==================== Micro-interactions ====================

  /// Durasi animasi hover (150ms)
  static const Duration hoverDuration = Duration(milliseconds: 150);

  /// Durasi animasi press (100ms)
  static const Duration pressDuration = Duration(milliseconds: 100);

  /// Durasi animasi ripple effect (600ms)
  static const Duration rippleDuration = Duration(milliseconds: 600);

  // ==================== Loading Animations ====================

  /// Durasi animasi loading spinner (1s)
  static const Duration loadingSpinnerDuration = Duration(seconds: 1);

  /// Durasi animasi progress bar (2s)
  static const Duration progressBarDuration = Duration(seconds: 2);

  /// Durasi animasi skeleton loading (1.5s)
  static const Duration skeletonLoadingDuration = Duration(milliseconds: 1500);

  // ==================== Gesture Animations ====================

  /// Durasi animasi swipe (300ms)
  static const Duration swipeDuration = Duration(milliseconds: 300);

  /// Durasi animasi drag (200ms)
  static const Duration dragDuration = Duration(milliseconds: 200);

  /// Durasi animasi pinch zoom (250ms)
  static const Duration pinchZoomDuration = Duration(milliseconds: 250);

  // ==================== Curve Constants ====================

  /// Curve untuk animasi masuk (easeOut)
  static final Curve curveEaseOut = Curves.easeOut;

  /// Curve untuk animasi keluar (easeIn)
  static final Curve curveEaseIn = Curves.easeIn;

  /// Curve untuk animasi bounce (bounceOut)
  static final Curve curveBounceOut = Curves.bounceOut;

  /// Curve untuk animasi elastic (elasticOut)
  static final Curve curveElasticOut = Curves.elasticOut;
}