import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Gesture feedback widget untuk berbagai interaksi
class GestureFeedback extends StatefulWidget {
  final Widget child;
  final GestureType gestureType;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onPanStart;
  final VoidCallback? onPanUpdate;
  final VoidCallback? onPanEnd;
  final Duration? feedbackDuration;
  final Curve? feedbackCurve;
  final Color? feedbackColor;
  final double? feedbackScale;
  final bool enableHapticFeedback;
  final bool enableVisualFeedback;

  const GestureFeedback({
    Key? key,
    required this.child,
    this.gestureType = GestureType.tap,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.feedbackDuration,
    this.feedbackCurve,
    this.feedbackColor,
    this.feedbackScale,
    this.enableHapticFeedback = true,
    this.enableVisualFeedback = true,
  }) : super(key: key);

  @override
  State<GestureFeedback> createState() => _GestureFeedbackState();
}

class _GestureFeedbackState extends State<GestureFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.feedbackDuration ?? const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.feedbackScale ?? 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.feedbackCurve ?? Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.feedbackCurve ?? Curves.easeOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildGestureFeedback(context);
      },
    );
  }

  Widget _buildGestureFeedback(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null ? _handleTap : null,
      onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      onPanStart: widget.onPanStart != null ? _handlePanStart : null,
      onPanUpdate: widget.onPanUpdate != null ? _handlePanUpdate : null,
      onPanEnd: widget.onPanEnd != null ? _handlePanEnd : null,
      child: Stack(
        children: [
          // Ripple effect
          if (widget.enableVisualFeedback &&
              _controller.status == AnimationStatus.forward)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: (widget.feedbackColor ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(_rippleAnimation.value * 0.2),
                  ),
                ),
              ),
            ),
          // Main content with scale effect
          Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    _triggerFeedback();
    widget.onTap?.call();
  }

  void _handleDoubleTap() {
    _triggerFeedback();
    widget.onDoubleTap?.call();
  }

  void _handleLongPress() {
    _triggerFeedback();
    widget.onLongPress?.call();
  }

  void _handlePanStart(DragStartDetails details) {
    _triggerFeedback();
    widget.onPanStart?.call();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    widget.onPanUpdate?.call();
  }

  void _handlePanEnd(DragEndDetails details) {
    _reverseFeedback();
    widget.onPanEnd?.call();
  }

  void _triggerFeedback() {
    if (widget.enableHapticFeedback) {
      _triggerHapticFeedback();
    }

    if (widget.enableVisualFeedback) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  void _reverseFeedback() {
    if (widget.enableVisualFeedback) {
      _controller.reverse();
    }
  }

  void _triggerHapticFeedback() {
    switch (widget.gestureType) {
      case GestureType.tap:
        HapticFeedback.lightImpact();
        break;
      case GestureType.longPress:
        HapticFeedback.mediumImpact();
        break;
      case GestureType.pan:
        HapticFeedback.selectionClick();
        break;
    }
  }
}

/// Ripple effect widget
class RippleEffect extends StatefulWidget {
  final Widget child;
  final Color? rippleColor;
  final double? rippleRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final VoidCallback? onTap;

  const RippleEffect({
    Key? key,
    required this.child,
    this.rippleColor,
    this.rippleRadius,
    this.animationDuration,
    this.animationCurve,
    this.onTap,
  }) : super(key: key);

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? AnimationUtils.durationNormal,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? AnimationUtils.curveEaseOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Stack(
        children: [
          widget.child,
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return _buildRipple(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.rippleRadius ?? 100),
            color: (widget.rippleColor ?? Theme.of(context).colorScheme.primary)
                .withOpacity(_animation.value * 0.3),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }
}

/// Swipe gesture widget
class SwipeGesture extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double? threshold;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Color? feedbackColor;

  const SwipeGesture({
    Key? key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.threshold,
    this.animationDuration,
    this.animationCurve,
    this.feedbackColor,
  }) : super(key: key);

  @override
  State<SwipeGesture> createState() => _SwipeGestureState();
}

class _SwipeGestureState extends State<SwipeGesture>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Offset _startPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? AnimationUtils.curveEaseOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final offset = details.localPosition - _startPosition;
    _animation = Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? AnimationUtils.curveEaseOut,
    ));
    _controller.reset();
    _controller.forward();
  }

  void _handlePanEnd(DragEndDetails details) {
    final offset = details.localPosition - _startPosition;
    final threshold = widget.threshold ?? 50.0;

    if (offset.dx.abs() > offset.dy.abs()) {
      // Horizontal swipe
      if (offset.dx > threshold) {
        widget.onSwipeRight?.call();
        _triggerSwipeFeedback();
      } else if (offset.dx < -threshold) {
        widget.onSwipeLeft?.call();
        _triggerSwipeFeedback();
      }
    } else {
      // Vertical swipe
      if (offset.dy > threshold) {
        widget.onSwipeDown?.call();
        _triggerSwipeFeedback();
      } else if (offset.dy < -threshold) {
        widget.onSwipeUp?.call();
        _triggerSwipeFeedback();
      }
    }

    // Reset animation
    _animation = Tween<Offset>(
      begin: _animation.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? AnimationUtils.curveEaseOut,
    ));
    _controller.forward();
  }

  void _triggerSwipeFeedback() {
    HapticFeedback.lightImpact();
  }
}

/// Gesture types enum
enum GestureType {
  tap,
  longPress,
  pan,
}

/// Gesture feedback manager untuk managing multiple gesture states
class GestureFeedbackManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<double>> _animations = {};

  static void registerGestureFeedback({
    required String key,
    required TickerProvider vsync,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 100),
      vsync: vsync,
    );

    final animation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve ?? Curves.easeOut,
    ));

    _controllers[key] = controller;
    _animations[key] = animation;

    controller.forward().then((_) {
      onComplete?.call();
      controller.reverse();
    });
  }

  static Animation<double>? getAnimation(String key) {
    return _animations[key];
  }

  static AnimationController? getController(String key) {
    return _controllers[key];
  }

  static Future<void> triggerFeedback(String key) async {
    final controller = _controllers[key];
    if (controller != null) {
      await controller.forward();
      await controller.reverse();
    }
  }

  static void disposeGestureFeedback(String key) {
    final controller = _controllers[key];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(key);
      _animations.remove(key);
    }
  }

  static void disposeAllGestureFeedbacks() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
  }
}

/// Custom haptic feedback utilities
class HapticFeedbackUtils {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void notificationSuccess() {
    // Haptic feedback untuk notifikasi sukses
    // Menggunakan vibration karena HapticFeedback tidak tersedia
    // Bisa diganti dengan package haptic_feedback jika diperlukan
  }

  static void notificationWarning() {
    // Haptic feedback untuk notifikasi peringatan
    // Menggunakan vibration karena HapticFeedback tidak tersedia
    // Bisa diganti dengan package haptic_feedback jika diperlukan
  }

  static void notificationError() {
    // Haptic feedback untuk notifikasi error
    // Menggunakan vibration karena HapticFeedback tidak tersedia
    // Bisa diganti dengan package haptic_feedback jika diperlukan
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }
}
