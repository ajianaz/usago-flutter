import 'package:flutter/material.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Custom scale transition dengan berbagai efek
class CustomScaleTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginScale;
  final double? endScale;
  final Alignment? alignment;

  const CustomScaleTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.alignment,
  }) : super(key: key);

  @override
  State<CustomScaleTransition> createState() => _CustomScaleTransitionState();
}

class _CustomScaleTransitionState extends State<CustomScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.beginScale ?? 0.0,
      end: widget.endScale ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    ));

    if (widget.autoStart) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
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
      builder: (context, child) {
        return ScaleTransition(
          scale: _animation,
          alignment: widget.alignment ?? Alignment.center,
          child: widget.child,
        );
      },
    );
  }
}

/// Scale transition dengan stagger effect untuk multiple children
class StaggeredScaleTransition extends StatefulWidget {
  final List<Widget> children;
  final Duration? duration;
  final Duration? staggerDelay;
  final Curve? curve;
  final bool autoStart;
  final double? beginScale;
  final double? endScale;

  const StaggeredScaleTransition({
    Key? key,
    required this.children,
    this.duration,
    this.staggerDelay,
    this.curve,
    this.autoStart = true,
    this.beginScale = 0.0,
    this.endScale = 1.0,
  }) : super(key: key);

  @override
  State<StaggeredScaleTransition> createState() => _StaggeredScaleTransitionState();
}

class _StaggeredScaleTransitionState extends State<StaggeredScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    _animations = List.generate(widget.children.length, (index) {
      final stagger = (index * (widget.staggerDelay?.inMilliseconds ?? 100)) /
                   (_controller.duration?.inMilliseconds ?? 300);

      return Tween<double>(
        begin: widget.beginScale ?? 0.0,
        end: widget.endScale ?? 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          stagger,
          (stagger + 0.3).clamp(0.0, 1.0),
          curve: widget.curve ?? Curves.easeInOut,
        ),
      ));
    });

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return ScaleTransition(
              scale: _animations[index],
              child: widget.children[index],
            );
          },
        );
      }),
    );
  }
}

/// Scale transition dengan fade effect
class ScaleFadeTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginScale;
  final double? endScale;
  final double? beginOpacity;
  final double? endOpacity;

  const ScaleFadeTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginScale = 0.8,
    this.endScale = 1.0,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
  }) : super(key: key);

  @override
  State<ScaleFadeTransition> createState() => _ScaleFadeTransitionState();
}

class _ScaleFadeTransitionState extends State<ScaleFadeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final curve = widget.curve ?? AnimationTheme.pageTransitionCurve;

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale ?? 0.8,
      end: widget.endScale ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: widget.beginOpacity ?? 0.0,
      end: widget.endOpacity ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    if (widget.autoStart) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Scale transition dengan bounce effect
class BounceScaleTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginScale;
  final double? endScale;
  final Alignment? alignment;

  const BounceScaleTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.alignment,
  }) : super(key: key);

  @override
  State<BounceScaleTransition> createState() => _BounceScaleTransitionState();
}

class _BounceScaleTransitionState extends State<BounceScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.beginScale ?? 0.0,
      end: widget.endScale ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.elasticOut,
    ));

    if (widget.autoStart) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
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
      builder: (context, child) {
        return ScaleTransition(
          scale: _animation,
          alignment: widget.alignment ?? Alignment.center,
          child: widget.child,
        );
      },
    );
  }
}

/// Scale transition dengan rotation effect
class ScaleRotateTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginScale;
  final double? endScale;
  final double? beginRotation;
  final double? endRotation;

  const ScaleRotateTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.beginRotation = 0.0,
    this.endRotation = 1.0,
  }) : super(key: key);

  @override
  State<ScaleRotateTransition> createState() => _ScaleRotateTransitionState();
}

class _ScaleRotateTransitionState extends State<ScaleRotateTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final curve = widget.curve ?? AnimationTheme.pageTransitionCurve;

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale ?? 0.0,
      end: widget.endScale ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _rotationAnimation = Tween<double>(
      begin: widget.beginRotation ?? 0.0,
      end: widget.endRotation ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    if (widget.autoStart) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Scale transition builder untuk penggunaan yang lebih mudah
class ScaleTransitionBuilder {
  static Widget build({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginScale,
    double? endScale,
    Alignment? alignment,
  }) {
    return CustomScaleTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginScale: beginScale,
      endScale: endScale,
      alignment: alignment,
    );
  }

  static Widget buildScaleIn({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Alignment? alignment,
  }) {
    return CustomScaleTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: true,
      onComplete: onComplete,
      beginScale: 0.0,
      endScale: 1.0,
      alignment: alignment,
    );
  }

  static Widget buildScaleOut({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Alignment? alignment,
  }) {
    return CustomScaleTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: true,
      onComplete: onComplete,
      beginScale: 1.0,
      endScale: 0.0,
      alignment: alignment,
    );
  }

  static Widget buildBounce({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginScale,
    double? endScale,
    Alignment? alignment,
  }) {
    return BounceScaleTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginScale: beginScale,
      endScale: endScale,
      alignment: alignment,
    );
  }

  static Widget buildScaleFade({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginScale,
    double? endScale,
    double? beginOpacity,
    double? endOpacity,
  }) {
    return ScaleFadeTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginScale: beginScale,
      endScale: endScale,
      beginOpacity: beginOpacity,
      endOpacity: endOpacity,
    );
  }

  static Widget buildScaleRotate({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginScale,
    double? endScale,
    double? beginRotation,
    double? endRotation,
  }) {
    return ScaleRotateTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginScale: beginScale,
      endScale: endScale,
      beginRotation: beginRotation,
      endRotation: endRotation,
    );
  }
}

/// Scale transition manager untuk managing multiple scale states
class ScaleTransitionManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<double>> _animations = {};

  static void registerScaleTransition({
    required String key,
    required TickerProvider vsync,
    required double beginScale,
    required double endScale,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 300),
      vsync: vsync,
    );

    final animation = Tween<double>(
      begin: beginScale,
      end: endScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve ?? Curves.easeInOut,
    ));

    _controllers[key] = controller;
    _animations[key] = animation;

    controller.forward().then((_) {
      onComplete?.call();
    });
  }

  static Animation<double>? getAnimation(String key) {
    return _animations[key];
  }

  static AnimationController? getController(String key) {
    return _controllers[key];
  }

  static Future<void> playAnimation(String key) async {
    final controller = _controllers[key];
    if (controller != null) {
      await controller.forward();
    }
  }

  static Future<void> reverseAnimation(String key) async {
    final controller = _controllers[key];
    if (controller != null) {
      await controller.reverse();
    }
  }

  static void disposeAnimation(String key) {
    final controller = _controllers[key];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(key);
      _animations.remove(key);
    }
  }

  static void disposeAllAnimations() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
  }
}