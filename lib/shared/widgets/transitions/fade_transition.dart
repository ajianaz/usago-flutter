import 'package:flutter/material.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Custom fade transition dengan berbagai efek
class CustomFadeTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginOpacity;
  final double? endOpacity;

  const CustomFadeTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
  }) : super(key: key);

  @override
  State<CustomFadeTransition> createState() => _CustomFadeTransitionState();
}

class _CustomFadeTransitionState extends State<CustomFadeTransition>
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
      begin: widget.beginOpacity ?? 0.0,
      end: widget.endOpacity ?? 1.0,
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
        return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
      },
    );
  }
}

/// Fade transition dengan stagger effect untuk multiple children
class StaggeredFadeTransition extends StatefulWidget {
  final List<Widget> children;
  final Duration? duration;
  final Duration? staggerDelay;
  final Curve? curve;
  final bool autoStart;
  final double? beginOpacity;
  final double? endOpacity;

  const StaggeredFadeTransition({
    Key? key,
    required this.children,
    this.duration,
    this.staggerDelay,
    this.curve,
    this.autoStart = true,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
  }) : super(key: key);

  @override
  State<StaggeredFadeTransition> createState() =>
      _StaggeredFadeTransitionState();
}

class _StaggeredFadeTransitionState extends State<StaggeredFadeTransition>
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
        begin: widget.beginOpacity ?? 0.0,
        end: widget.endOpacity ?? 1.0,
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
            return FadeTransition(
              opacity: _animations[index],
              child: widget.children[index],
            );
          },
        );
      }),
    );
  }
}

/// Fade transition dengan scale effect
class FadeScaleTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginOpacity;
  final double? endOpacity;
  final double? beginScale;
  final double? endScale;

  const FadeScaleTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
    this.beginScale = 0.8,
    this.endScale = 1.0,
  }) : super(key: key);

  @override
  State<FadeScaleTransition> createState() => _FadeScaleTransitionState();
}

class _FadeScaleTransitionState extends State<FadeScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final curve = widget.curve ?? AnimationTheme.pageTransitionCurve;

    _fadeAnimation = Tween<double>(
      begin: widget.beginOpacity ?? 0.0,
      end: widget.endOpacity ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale ?? 0.8,
      end: widget.endScale ?? 1.0,
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
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Fade transition dengan slide effect
class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? beginOpacity;
  final double? endOpacity;
  final FadeSlideDirection slideDirection;
  final double? slideDistance;

  const FadeSlideTransition({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
    this.slideDirection = FadeSlideDirection.up,
    this.slideDistance,
  }) : super(key: key);

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final curve = widget.curve ?? AnimationTheme.pageTransitionCurve;

    _fadeAnimation = Tween<double>(
      begin: widget.beginOpacity ?? 0.0,
      end: widget.endOpacity ?? 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    final beginOffset = _getBeginOffset();
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
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
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }

  Offset _getBeginOffset() {
    final distance = widget.slideDistance ?? 0.3;

    switch (widget.slideDirection) {
      case FadeSlideDirection.up:
        return Offset(0.0, distance);
      case FadeSlideDirection.down:
        return Offset(0.0, -distance);
      case FadeSlideDirection.left:
        return Offset(distance, 0.0);
      case FadeSlideDirection.right:
        return Offset(-distance, 0.0);
    }
  }
}

/// Fade slide direction enum
enum FadeSlideDirection {
  up,
  down,
  left,
  right,
}

/// Fade transition builder untuk penggunaan yang lebih mudah
class FadeTransitionBuilder {
  static Widget build({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginOpacity,
    double? endOpacity,
  }) {
    return CustomFadeTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginOpacity: beginOpacity,
      endOpacity: endOpacity,
    );
  }

  static Widget buildFadeIn({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return CustomFadeTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: true,
      onComplete: onComplete,
      beginOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  static Widget buildFadeOut({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return CustomFadeTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: true,
      onComplete: onComplete,
      beginOpacity: 1.0,
      endOpacity: 0.0,
    );
  }

  static Widget buildFadeScale({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginOpacity,
    double? endOpacity,
    double? beginScale,
    double? endScale,
  }) {
    return FadeScaleTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginOpacity: beginOpacity,
      endOpacity: endOpacity,
      beginScale: beginScale,
      endScale: endScale,
    );
  }

  static Widget buildFadeSlide({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? beginOpacity,
    double? endOpacity,
    FadeSlideDirection slideDirection = FadeSlideDirection.up,
    double? slideDistance,
  }) {
    return FadeSlideTransition(
      key: key,
      child: child,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      beginOpacity: beginOpacity,
      endOpacity: endOpacity,
      slideDirection: slideDirection,
      slideDistance: slideDistance,
    );
  }
}

/// Fade transition manager untuk managing multiple fade states
class FadeTransitionManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<double>> _animations = {};

  static void registerFadeTransition({
    required String key,
    required TickerProvider vsync,
    required double beginOpacity,
    required double endOpacity,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 300),
      vsync: vsync,
    );

    final animation = Tween<double>(
      begin: beginOpacity,
      end: endOpacity,
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
