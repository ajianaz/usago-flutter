import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/animation_utils.dart';
import '../../core/constants/animation_constants.dart';

/// Theme untuk animation yang konsisten di seluruh aplikasi
class AnimationTheme {
  // Default Durations
  static const Duration defaultDuration = AnimationUtils.durationNormal;
  static const Duration fastDuration = AnimationUtils.durationFast;
  static const Duration slowDuration = AnimationUtils.durationSlow;
  static const Duration slowerDuration = AnimationUtils.durationSlower;

  // Default Curves
  static const Curve defaultCurve = AnimationUtils.curveEaseInOut;
  static const Curve fastOutSlowInCurve = AnimationUtils.curveFastOutSlowIn;
  static const Curve bounceInCurve = AnimationUtils.curveBounceIn;
  static const Curve bounceOutCurve = AnimationUtils.curveBounceOut;

  // Loading Animation Durations
  static Duration get loadingSpinnerDuration => AnimationConstants.loadingSpinnerDuration;
  static Duration get skeletonShimmerDuration => AnimationConstants.skeletonLoadingDuration;
  static Duration get pulseDuration => AnimationConstants.successDuration;
  static Duration get shakeDuration => AnimationConstants.mediumDuration;

  // Page Transition Durations
  static Duration get pageTransitionDuration => AnimationConstants.pageTransitionDuration;
  static Duration get heroAnimationDuration => AnimationConstants.slowDuration;
  static Duration get sharedElementDuration => AnimationConstants.mediumDuration;

  // Micro-interaction Durations
  static Duration get buttonPressDuration => AnimationConstants.buttonDuration;
  static Duration get inputFocusDuration => AnimationConstants.inputDuration;
  static Duration get gestureFeedbackDuration => AnimationConstants.fastDuration;
  static Duration get successAnimationDuration => AnimationConstants.successDuration;

  // Loading Animation Curves
  static const Curve loadingCurve = Curves.linear;
  static const Curve skeletonCurve = Curves.easeInOut;
  static const Curve pulseCurve = Curves.easeInOut;
  static const Curve shakeCurve = ShakeCurve();

  // Page Transition Curves
  static const Curve pageTransitionCurve = Curves.easeInOut;
  static const Curve heroAnimationCurve = Curves.easeOut;
  static const Curve sharedElementCurve = Curves.easeInOut;

  // Micro-interaction Curves
  static const Curve buttonPressCurve = Curves.easeInOut;
  static const Curve inputFocusCurve = Curves.easeOut;
  static const Curve gestureFeedbackCurve = Curves.easeOut;
  static const Curve successAnimationCurve = Curves.elasticOut;

  // Loading Animation Themes
  static LoadingAnimationTheme get loadingAnimationTheme => LoadingAnimationTheme(
    spinnerDuration: loadingSpinnerDuration,
    spinnerCurve: loadingCurve,
    skeletonDuration: skeletonShimmerDuration,
    skeletonCurve: skeletonCurve,
    pulseDuration: pulseDuration,
    pulseCurve: pulseCurve,
    shakeDuration: shakeDuration,
    shakeCurve: shakeCurve,
  );

  // Page Transition Theme
  static PageTransitionTheme get pageTransitionTheme => PageTransitionTheme(
    duration: pageTransitionDuration,
    curve: pageTransitionCurve,
    heroDuration: heroAnimationDuration,
    heroCurve: heroAnimationCurve,
    sharedElementDuration: sharedElementDuration,
    sharedElementCurve: sharedElementCurve,
  );

  // Micro-interaction Theme
  static MicroInteractionTheme get microInteractionTheme => MicroInteractionTheme(
    buttonPressDuration: buttonPressDuration,
    buttonPressCurve: buttonPressCurve,
    inputFocusDuration: inputFocusDuration,
    inputFocusCurve: inputFocusCurve,
    gestureFeedbackDuration: gestureFeedbackDuration,
    gestureFeedbackCurve: gestureFeedbackCurve,
    successAnimationDuration: successAnimationDuration,
    successAnimationCurve: successAnimationCurve,
  );
}

/// Theme untuk loading animations
class LoadingAnimationTheme {
  final Duration spinnerDuration;
  final Curve spinnerCurve;
  final Duration skeletonDuration;
  final Curve skeletonCurve;
  final Duration pulseDuration;
  final Curve pulseCurve;
  final Duration shakeDuration;
  final Curve shakeCurve;

  const LoadingAnimationTheme({
    required this.spinnerDuration,
    required this.spinnerCurve,
    required this.skeletonDuration,
    required this.skeletonCurve,
    required this.pulseDuration,
    required this.pulseCurve,
    required this.shakeDuration,
    required this.shakeCurve,
  });
}

/// Theme untuk page transitions
class PageTransitionTheme {
  final Duration duration;
  final Curve curve;
  final Duration heroDuration;
  final Curve heroCurve;
  final Duration sharedElementDuration;
  final Curve sharedElementCurve;

  const PageTransitionTheme({
    required this.duration,
    required this.curve,
    required this.heroDuration,
    required this.heroCurve,
    required this.sharedElementDuration,
    required this.sharedElementCurve,
  });
}

/// Theme untuk micro-interactions
class MicroInteractionTheme {
  final Duration buttonPressDuration;
  final Curve buttonPressCurve;
  final Duration inputFocusDuration;
  final Curve inputFocusCurve;
  final Duration gestureFeedbackDuration;
  final Curve gestureFeedbackCurve;
  final Duration successAnimationDuration;
  final Curve successAnimationCurve;

  const MicroInteractionTheme({
    required this.buttonPressDuration,
    required this.buttonPressCurve,
    required this.inputFocusDuration,
    required this.inputFocusCurve,
    required this.gestureFeedbackDuration,
    required this.gestureFeedbackCurve,
    required this.successAnimationDuration,
    required this.successAnimationCurve,
  });
}

/// Extension untuk memudahkan akses animation theme
extension AnimationThemeExtension on BuildContext {
  LoadingAnimationTheme get loadingTheme => AnimationTheme.loadingAnimationTheme;
  PageTransitionTheme get pageTransitionTheme => AnimationTheme.pageTransitionTheme;
  MicroInteractionTheme get microInteractionTheme => AnimationTheme.microInteractionTheme;
}

/// Custom Shake Curve
class ShakeCurve extends Curve {
  const ShakeCurve();

  @override
  double transform(double t) {
    return math.sin(t * 2 * math.pi) * (1 - t);
  }
}

/// Animation Presets untuk penggunaan umum
class AnimationPresets {
  // Loading Presets
  static AnimationPreset get loadingSpinner => AnimationPreset(
    duration: AnimationTheme.loadingSpinnerDuration,
    curve: AnimationTheme.loadingCurve,
    reverseCurve: AnimationTheme.loadingCurve,
  );

  static AnimationPreset get skeletonShimmer => AnimationPreset(
    duration: AnimationTheme.skeletonShimmerDuration,
    curve: AnimationTheme.skeletonCurve,
    reverseCurve: AnimationTheme.skeletonCurve,
  );

  static AnimationPreset get pulse => AnimationPreset(
    duration: AnimationTheme.pulseDuration,
    curve: AnimationTheme.pulseCurve,
    reverseCurve: AnimationTheme.pulseCurve,
  );

  static AnimationPreset get shake => AnimationPreset(
    duration: AnimationTheme.shakeDuration,
    curve: AnimationTheme.shakeCurve,
    reverseCurve: AnimationTheme.shakeCurve,
  );

  // Page Transition Presets
  static AnimationPreset get pageTransition => AnimationPreset(
    duration: AnimationTheme.pageTransitionDuration,
    curve: AnimationTheme.pageTransitionCurve,
    reverseCurve: AnimationTheme.pageTransitionCurve,
  );

  static AnimationPreset get heroAnimation => AnimationPreset(
    duration: AnimationTheme.heroAnimationDuration,
    curve: AnimationTheme.heroAnimationCurve,
    reverseCurve: AnimationTheme.heroAnimationCurve,
  );

  // Micro-interaction Presets
  static AnimationPreset get buttonPress => AnimationPreset(
    duration: AnimationTheme.buttonPressDuration,
    curve: AnimationTheme.buttonPressCurve,
    reverseCurve: AnimationTheme.buttonPressCurve,
  );

  static AnimationPreset get inputFocus => AnimationPreset(
    duration: AnimationTheme.inputFocusDuration,
    curve: AnimationTheme.inputFocusCurve,
    reverseCurve: AnimationTheme.inputFocusCurve,
  );

  static AnimationPreset get gestureFeedback => AnimationPreset(
    duration: AnimationTheme.gestureFeedbackDuration,
    curve: AnimationTheme.gestureFeedbackCurve,
    reverseCurve: AnimationTheme.gestureFeedbackCurve,
  );

  static AnimationPreset get successAnimation => AnimationPreset(
    duration: AnimationTheme.successAnimationDuration,
    curve: AnimationTheme.successAnimationCurve,
    reverseCurve: AnimationTheme.successAnimationCurve,
  );
}

/// Animation Preset class
class AnimationPreset {
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;

  const AnimationPreset({
    required this.duration,
    required this.curve,
    required this.reverseCurve,
  });
}

/// Animation Configuration Builder
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;
  final bool repeat;
  final bool autoReverse;

  const AnimationConfig({
    required this.duration,
    required this.curve,
    this.reverseCurve,
    this.repeat = false,
    this.autoReverse = false,
  });

  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    bool? repeat,
    bool? autoReverse,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      repeat: repeat ?? this.repeat,
      autoReverse: autoReverse ?? this.autoReverse,
    );
  }
}

/// Performance-aware Animation Manager
class AnimationManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, AnimationConfig> _configs = {};

  static void registerController({
    required String key,
    required AnimationController controller,
    required AnimationConfig config,
  }) {
    _controllers[key] = controller;
    _configs[key] = config;
  }

  static AnimationController? getController(String key) {
    return _controllers[key];
  }

  static AnimationConfig? getConfig(String key) {
    return _configs[key];
  }

  static Future<void> playAnimation(String key) async {
    final controller = _controllers[key];
    final config = _configs[key];

    if (controller != null && config != null) {
      if (config.repeat) {
        if (config.autoReverse) {
          await controller.repeat(reverse: true);
        } else {
          await controller.repeat();
        }
      } else {
        if (config.autoReverse) {
          await controller.forward();
          await controller.reverse();
        } else {
          await controller.forward();
        }
      }
    }
  }

  static void stopAnimation(String key) {
    final controller = _controllers[key];
    if (controller != null) {
      controller.stop();
    }
  }

  static void disposeAnimation(String key) {
    final controller = _controllers[key];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(key);
      _configs.remove(key);
    }
  }

  static void disposeAllAnimations() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _configs.clear();
  }
}