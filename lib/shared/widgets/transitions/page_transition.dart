import 'package:flutter/material.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Custom page transition dengan berbagai animasi
class CustomPageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration? duration;
  final Curve? curve;
  final bool maintainState;
  final bool fullscreenDialog;

  CustomPageTransition({
    Key? key,
    required this.child,
    this.transitionType = PageTransitionType.slideRight,
    this.duration,
    this.curve,
    this.maintainState = true,
    this.fullscreenDialog = false,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration ?? const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              context,
              animation,
              secondaryAnimation,
              child,
              transitionType,
              duration,
              curve,
            );
          },
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          settings: settings,
        );

  static Widget _buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageTransitionType transitionType,
    Duration? duration,
    Curve? curve,
  ) {
    switch (transitionType) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case PageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.5,
            end: 0.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: child,
        );
      case PageTransitionType.size:
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        );
      case PageTransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      case PageTransitionType.scaleAndFade:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeInOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

/// Page transition types
enum PageTransitionType {
  fade,
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  scale,
  rotation,
  size,
  slideAndFade,
  scaleAndFade,
}

/// Builder untuk membuat custom page transitions
class PageTransitionBuilder {
  static PageRoute<T> buildRoute<T>({
    required Widget page,
    PageTransitionType transitionType = PageTransitionType.slideRight,
    Duration? duration,
    Curve? curve,
    bool maintainState = true,
    bool fullscreenDialog = false,
    RouteSettings? settings,
  }) {
    return CustomPageTransition<T>(
      child: page,
      transitionType: transitionType,
      duration: duration,
      curve: curve,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static PageRoute<T> buildFadeRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
    RouteSettings? settings,
  }) {
    return buildRoute<T>(
      page: page,
      transitionType: PageTransitionType.fade,
      duration: duration,
      curve: curve,
      settings: settings,
    );
  }

  static PageRoute<T> buildSlideRoute<T>({
    required Widget page,
    PageTransitionType slideType = PageTransitionType.slideRight,
    Duration? duration,
    Curve? curve,
    RouteSettings? settings,
  }) {
    return buildRoute<T>(
      page: page,
      transitionType: slideType,
      duration: duration,
      curve: curve,
      settings: settings,
    );
  }

  static PageRoute<T> buildScaleRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
    RouteSettings? settings,
  }) {
    return buildRoute<T>(
      page: page,
      transitionType: PageTransitionType.scale,
      duration: duration,
      curve: curve,
      settings: settings,
    );
  }

  static PageRoute<T> buildSlideAndFadeRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
    RouteSettings? settings,
  }) {
    return buildRoute<T>(
      page: page,
      transitionType: PageTransitionType.slideAndFade,
      duration: duration,
      curve: curve,
      settings: settings,
    );
  }
}

/// Widget untuk membuat animated page transitions
class AnimatedPageTransition extends StatefulWidget {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;

  const AnimatedPageTransition({
    Key? key,
    required this.child,
    this.transitionType = PageTransitionType.fade,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
  }) : super(key: key);

  @override
  State<AnimatedPageTransition> createState() => _AnimatedPageTransitionState();
}

class _AnimatedPageTransitionState extends State<AnimatedPageTransition>
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

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    );

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
        return _buildTransition(context);
      },
    );
  }

  Widget _buildTransition(BuildContext context) {
    switch (widget.transitionType) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
      case PageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.5,
            end: 0.0,
          ).animate(_animation),
          child: widget.child,
        );
      case PageTransitionType.size:
        return SizeTransition(
          sizeFactor: _animation,
          axis: Axis.horizontal,
          child: widget.child,
        );
      case PageTransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_animation),
          child: FadeTransition(
            opacity: _animation,
            child: widget.child,
          ),
        );
      case PageTransitionType.scaleAndFade:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(_animation),
          child: FadeTransition(
            opacity: _animation,
            child: widget.child,
          ),
        );
    }
  }
}

/// Hero animation untuk shared element transitions
class CustomHero extends StatelessWidget {
  final String tag;
  final Widget child;
  final bool createRectTween;
  final bool transitionOnUserGestures;
  final Duration? transitionDuration;
  final bool placeholderBuilder;

  const CustomHero({
    Key? key,
    required this.tag,
    required this.child,
    this.createRectTween = true,
    this.transitionOnUserGestures = false,
    this.transitionDuration,
    this.placeholderBuilder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
    );
  }
}

/// Page transition dengan shared element
class SharedElementPageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;
  final String heroTag;
  final Duration? duration;
  final Curve? curve;

  SharedElementPageTransition({
    Key? key,
    required this.child,
    required this.heroTag,
    this.duration,
    this.curve,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration ?? const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildSharedElementTransition(
              context,
              animation,
              secondaryAnimation,
              child,
              heroTag,
              duration,
              curve,
            );
          },
          settings: settings,
        );

  static Widget _buildSharedElementTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    String heroTag,
    Duration? duration,
    Curve? curve,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeInOut,
      ),
      child: child,
    );
  }
}

/// Staggered page transition untuk multiple elements
class StaggeredPageTransition extends StatefulWidget {
  final List<Widget> children;
  final Duration? duration;
  final Duration? staggerDelay;
  final Curve? curve;
  final bool autoStart;

  const StaggeredPageTransition({
    Key? key,
    required this.children,
    this.duration,
    this.staggerDelay,
    this.curve,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<StaggeredPageTransition> createState() => _StaggeredPageTransitionState();
}

class _StaggeredPageTransitionState extends State<StaggeredPageTransition>
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

    _animations = AnimationUtils.createStaggeredAnimations(
      controller: _controller,
      count: widget.children.length,
      staggerDelay: widget.staggerDelay ?? const Duration(milliseconds: 100),
    );

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
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: widget.curve ?? Curves.easeInOut,
                )),
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}