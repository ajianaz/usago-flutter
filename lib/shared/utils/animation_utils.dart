import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utility class untuk animation constants dan helper functions
class AnimationUtils {
  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationSlower = Duration(milliseconds: 800);
  static const Duration durationSlowest = Duration(milliseconds: 1200);

  // Animation Curves
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve curveBounceIn = Curves.bounceIn;
  static const Curve curveBounceOut = Curves.bounceOut;
  static const Curve curveElasticIn = Curves.elasticIn;
  static const Curve curveElasticOut = Curves.elasticOut;

  // Default Animation Controllers
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = durationNormal,
  }) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  // Fade Animation
  static Animation<double> createFadeAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }

  // Scale Animation
  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveFastOutSlowIn,
    ));
  }

  // Slide Animation
  static Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseOut,
    ));
  }

  // Rotation Animation
  static Animation<double> createRotationAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }

  // Size Animation
  static Animation<Size?> createSizeAnimation({
    required AnimationController controller,
    Size? begin,
    Size? end,
  }) {
    return SizeTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }

  // Color Animation
  static Animation<Color?> createColorAnimation({
    required AnimationController controller,
    Color? begin,
    Color? end,
  }) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }

  // Staggered Animation Builder
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    int count = 3,
    Duration staggerDelay = const Duration(milliseconds: 100),
  }) {
    final totalDuration = controller.duration!;
    final staggerDuration = totalDuration ~/ count;

    return List.generate(count, (index) {
      final startTime = staggerDuration * index;
      final endTime = startTime + staggerDuration;

      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime.inMilliseconds / totalDuration.inMilliseconds,
          endTime.inMilliseconds / totalDuration.inMilliseconds,
          curve: curveEaseOut,
        ),
      ));
    });
  }

  // Shake Animation
  static Animation<double> createShakeAnimation({
    required AnimationController controller,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const ShakeCurve(),
    ));
  }

  // Pulse Animation
  static Animation<double> createPulseAnimation({
    required AnimationController controller,
    double begin = 1.0,
    double end = 1.1,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const PulseCurve(),
    ));
  }
}

/// Custom Curve untuk shake animation
class ShakeCurve extends Curve {
  const ShakeCurve();

  @override
  double transform(double t) {
    return math.sin(t * 2 * math.pi) * (1 - t);
  }
}

/// Custom Curve untuk pulse animation
class PulseCurve extends Curve {
  const PulseCurve();

  @override
  double transform(double t) {
    if (t < 0.5) {
      return 2 * t;
    } else {
      return 2 * (1 - t);
    }
  }
}

/// Animation State Helper
class AnimationStateHelper {
  static bool isAnimationCompleted(AnimationController controller) {
    return controller.status == AnimationStatus.completed ||
        controller.status == AnimationStatus.dismissed;
  }

  static bool isAnimationRunning(AnimationController controller) {
    return controller.status == AnimationStatus.forward ||
        controller.status == AnimationStatus.reverse;
  }

  static Future<void> playAnimationForward(
      AnimationController controller) async {
    if (controller.isDismissed) {
      await controller.forward();
    }
  }

  static Future<void> playAnimationReverse(
      AnimationController controller) async {
    if (controller.isCompleted) {
      await controller.reverse();
    }
  }

  static Future<void> replayAnimation(AnimationController controller) async {
    controller.reset();
    await controller.forward();
  }
}

/// Performance-friendly Animation Builder
class OptimizedAnimationBuilder extends StatefulWidget {
  final Widget Function(BuildContext, Animation<double>) builder;
  final Duration duration;
  final Curve curve;
  final bool autoStart;
  final bool repeat;

  const OptimizedAnimationBuilder({
    Key? key,
    required this.builder,
    this.duration = AnimationUtils.durationNormal,
    this.curve = AnimationUtils.curveEaseInOut,
    this.autoStart = true,
    this.repeat = false,
  }) : super(key: key);

  @override
  State<OptimizedAnimationBuilder> createState() =>
      _OptimizedAnimationBuilderState();
}

class _OptimizedAnimationBuilderState extends State<OptimizedAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.autoStart) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => widget.builder(context, _animation),
    );
  }
}
