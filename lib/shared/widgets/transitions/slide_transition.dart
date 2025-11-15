import 'package:flutter/material.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Custom slide transition dengan berbagai arah
class CustomSlideTransition extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? distance;
  final bool fade;
  final double? fadeStart;

  const CustomSlideTransition({
    Key? key,
    required this.child,
    this.direction = SlideDirection.left,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.distance,
    this.fade = false,
    this.fadeStart,
  }) : super(key: key);

  @override
  State<CustomSlideTransition> createState() => _CustomSlideTransitionState();
}

class _CustomSlideTransitionState extends State<CustomSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final beginOffset = _getBeginOffset();
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    ));

    if (widget.fade) {
      _fadeAnimation = Tween<double>(
        begin: widget.fadeStart ?? 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? Curves.easeInOut,
      ));
    }

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
      animation: _slideAnimation,
      builder: (context, child) {
        Widget transitionChild = SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );

        if (widget.fade && _fadeAnimation != null) {
          transitionChild = FadeTransition(
            opacity: _fadeAnimation!,
            child: transitionChild,
          );
        }

        return transitionChild;
      },
    );
  }

  Offset _getBeginOffset() {
    final distance = widget.distance ?? 1.0;

    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-distance, 0.0);
      case SlideDirection.right:
        return Offset(distance, 0.0);
      case SlideDirection.up:
        return Offset(0.0, -distance);
      case SlideDirection.down:
        return Offset(0.0, distance);
    }
  }
}

/// Slide direction enum
enum SlideDirection {
  left,
  right,
  up,
  down,
}

/// Slide transition dengan stagger effect untuk multiple children
class StaggeredSlideTransition extends StatefulWidget {
  final List<Widget> children;
  final SlideDirection direction;
  final Duration? duration;
  final Duration? staggerDelay;
  final Curve? curve;
  final bool autoStart;
  final double? distance;
  final bool fade;

  const StaggeredSlideTransition({
    Key? key,
    required this.children,
    this.direction = SlideDirection.left,
    this.duration,
    this.staggerDelay,
    this.curve,
    this.autoStart = true,
    this.distance,
    this.fade = false,
  }) : super(key: key);

  @override
  State<StaggeredSlideTransition> createState() => _StaggeredSlideTransitionState();
}

class _StaggeredSlideTransitionState extends State<StaggeredSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>>? _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final beginOffset = _getBeginOffset();
    _slideAnimations = List.generate(widget.children.length, (index) {
      return Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          (index + 1) * 0.1,
          curve: widget.curve ?? Curves.easeInOut,
        ),
      ));
    });

    if (widget.fade) {
      _fadeAnimations = List.generate(widget.children.length, (index) {
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index + 1) * 0.1,
            curve: widget.curve ?? Curves.easeInOut,
          ),
        ));
      });
    }

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
          animation: _slideAnimations[index],
          builder: (context, child) {
            Widget transitionChild = SlideTransition(
              position: _slideAnimations[index],
              child: widget.children[index],
            );

            if (widget.fade && _fadeAnimations != null) {
              transitionChild = FadeTransition(
                opacity: _fadeAnimations![index],
                child: transitionChild,
              );
            }

            return transitionChild;
          },
        );
      }),
    );
  }

  Offset _getBeginOffset() {
    final distance = widget.distance ?? 1.0;

    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-distance, 0.0);
      case SlideDirection.right:
        return Offset(distance, 0.0);
      case SlideDirection.up:
        return Offset(0.0, -distance);
      case SlideDirection.down:
        return Offset(0.0, distance);
    }
  }
}

/// Slide transition dengan bounce effect
class BounceSlideTransition extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final double? distance;

  const BounceSlideTransition({
    Key? key,
    required this.child,
    this.direction = SlideDirection.left,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.distance,
  }) : super(key: key);

  @override
  State<BounceSlideTransition> createState() => _BounceSlideTransitionState();
}

class _BounceSlideTransitionState extends State<BounceSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final beginOffset = _getBeginOffset();
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
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
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );
      },
    );
  }

  Offset _getBeginOffset() {
    final distance = widget.distance ?? 1.0;

    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-distance, 0.0);
      case SlideDirection.right:
        return Offset(distance, 0.0);
      case SlideDirection.up:
        return Offset(0.0, -distance);
      case SlideDirection.down:
        return Offset(0.0, distance);
    }
  }
}

/// Slide transition untuk page navigation
class PageSlideTransition extends StatefulWidget {
  final Widget child;
  final bool isEntering;
  final SlideDirection direction;
  final Duration? duration;
  final Curve? curve;

  const PageSlideTransition({
    Key? key,
    required this.child,
    required this.isEntering,
    this.direction = SlideDirection.left,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  State<PageSlideTransition> createState() => _PageSlideTransitionState();
}

class _PageSlideTransitionState extends State<PageSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    final offset = _getOffset();
    _slideAnimation = Tween<Offset>(
      begin: widget.isEntering ? offset : Offset.zero,
      end: widget.isEntering ? Offset.zero : offset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }

  Offset _getOffset() {
    final distance = 1.0;

    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-distance, 0.0);
      case SlideDirection.right:
        return Offset(distance, 0.0);
      case SlideDirection.up:
        return Offset(0.0, -distance);
      case SlideDirection.down:
        return Offset(0.0, distance);
    }
  }
}

/// Slide transition builder untuk penggunaan yang lebih mudah
class SlideTransitionBuilder {
  static Widget build({
    Key? key,
    required Widget child,
    SlideDirection direction = SlideDirection.left,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? distance,
    bool fade = false,
  }) {
    return CustomSlideTransition(
      key: key,
      child: child,
      direction: direction,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      distance: distance,
      fade: fade,
    );
  }

  static Widget buildFromLeft({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? distance,
    bool fade = false,
  }) {
    return CustomSlideTransition(
      key: key,
      child: child,
      direction: SlideDirection.left,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      distance: distance,
      fade: fade,
    );
  }

  static Widget buildFromRight({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? distance,
    bool fade = false,
  }) {
    return CustomSlideTransition(
      key: key,
      child: child,
      direction: SlideDirection.right,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      distance: distance,
      fade: fade,
    );
  }

  static Widget buildFromTop({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? distance,
    bool fade = false,
  }) {
    return CustomSlideTransition(
      key: key,
      child: child,
      direction: SlideDirection.up,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      distance: distance,
      fade: fade,
    );
  }

  static Widget buildFromBottom({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    double? distance,
    bool fade = false,
  }) {
    return CustomSlideTransition(
      key: key,
      child: child,
      direction: SlideDirection.down,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      distance: distance,
      fade: fade,
    );
  }
}

/// Slide transition manager untuk managing multiple slide states
class SlideTransitionManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<Offset>> _animations = {};

  static void registerSlideTransition({
    required String key,
    required TickerProvider vsync,
    required Offset beginOffset,
    required Offset endOffset,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 300),
      vsync: vsync,
    );

    final animation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
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

  static Animation<Offset>? getAnimation(String key) {
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