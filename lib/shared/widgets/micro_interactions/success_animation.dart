import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Success animation widget dengan berbagai efek
class SuccessAnimation extends StatefulWidget {
  final Widget child;
  final SuccessAnimationType animationType;
  final Duration? duration;
  final Curve? curve;
  final bool autoStart;
  final VoidCallback? onComplete;
  final Color? successColor;
  final double? iconSize;
  final String? successMessage;
  final TextStyle? messageStyle;

  const SuccessAnimation({
    Key? key,
    required this.child,
    this.animationType = SuccessAnimationType.checkmark,
    this.duration,
    this.curve,
    this.autoStart = true,
    this.onComplete,
    this.successColor,
    this.iconSize,
    this.successMessage,
    this.messageStyle,
  }) : super(key: key);

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    final curve = widget.curve ?? Curves.elasticOut;

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: curve),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1.0, curve: curve),
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
      animation: _controller,
      builder: (context, child) {
        return _buildSuccessAnimation(context);
      },
    );
  }

  Widget _buildSuccessAnimation(BuildContext context) {
    switch (widget.animationType) {
      case SuccessAnimationType.checkmark:
        return _buildCheckmarkAnimation(context);
      case SuccessAnimationType.circle:
        return _buildCircleAnimation(context);
      case SuccessAnimationType.confetti:
        return _buildConfettiAnimation(context);
      case SuccessAnimationType.pulse:
        return _buildPulseAnimation(context);
    }
  }

  Widget _buildCheckmarkAnimation(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
        // Success icon
        Positioned.fill(
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159265359,
                child: Icon(
                  Icons.check_circle,
                  size: widget.iconSize ?? 48,
                  color: widget.successColor ?? AppColors.success,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAnimation(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
        // Success circle
        Positioned.fill(
          child: Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.successColor ?? AppColors.success)
                        .withOpacity(0.2 * _scaleAnimation.value),
                    border: Border.all(
                      color: widget.successColor ?? AppColors.success,
                      width: 3,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiAnimation(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
        // Confetti particles
        if (_scaleAnimation.value > 0.3)
          Positioned.fill(
            child: IgnorePointer(
              child: _buildConfettiParticles(context),
            ),
          ),
      ],
    );
  }

  Widget _buildConfettiParticles(BuildContext context) {
    return Stack(
      children: List.generate(8, (index) {
        final angle = (index * 45) * (3.14159265359 / 180);
        final distance = 50 + (_scaleAnimation.value - 0.3) * 100;

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width / 2 +
                  (distance * math.cos(angle)),
              top: MediaQuery.of(context).size.height / 2 +
                  (distance * math.sin(angle)),
              child: Transform.rotate(
                angle: _scaleAnimation.value * 2 * 3.14159265359,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getConfettiColor(index),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      AppColors.success,
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Widget _buildPulseAnimation(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
        // Pulse effect
        Positioned.fill(
          child: Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.successColor ?? AppColors.success)
                        .withOpacity(0.3 * (1 - _scaleAnimation.value)),
                    border: Border.all(
                      color: widget.successColor ?? AppColors.success,
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Success animation dengan overlay
class SuccessOverlay extends StatefulWidget {
  final Widget child;
  final bool isSuccess;
  final SuccessAnimationType animationType;
  final Duration? duration;
  final String? successMessage;
  final TextStyle? messageStyle;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  const SuccessOverlay({
    Key? key,
    required this.child,
    required this.isSuccess,
    this.animationType = SuccessAnimationType.checkmark,
    this.duration,
    this.successMessage,
    this.messageStyle,
    this.onComplete,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    if (widget.isSuccess) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
        // Haptic feedback untuk notifikasi sukses
        // Menggunakan vibration karena HapticFeedback tidak tersedia
        // Bisa diganti dengan package haptic_feedback jika diperlukan
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
    return Stack(
      children: [
        // Main content
        widget.child,
        // Success overlay
        if (widget.isSuccess)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return _buildSuccessOverlay(context);
            },
          ),
      ],
    );
  }

  Widget _buildSuccessOverlay(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.5 * _animation.value),
        child: Center(
          child: Container(
            margin: AppSpacing.paddingAllLg,
            padding: AppSpacing.paddingAllLg,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.radiusLg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Transform.scale(
                  scale: _animation.value,
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.success,
                  ),
                ),
                AppSpacing.verticalGapMd,
                // Success message
                if (widget.successMessage != null)
                  Text(
                    widget.successMessage!,
                    style: widget.messageStyle ??
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Success animation types
enum SuccessAnimationType {
  checkmark,
  circle,
  confetti,
  pulse,
}

/// Success animation builder untuk penggunaan yang lebih mudah
class SuccessAnimationBuilder {
  static Widget build({
    Key? key,
    required Widget child,
    SuccessAnimationType animationType = SuccessAnimationType.checkmark,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    Color? successColor,
    double? iconSize,
    String? successMessage,
    TextStyle? messageStyle,
  }) {
    return SuccessAnimation(
      key: key,
      child: child,
      animationType: animationType,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      successColor: successColor,
      iconSize: iconSize,
      successMessage: successMessage,
      messageStyle: messageStyle,
    );
  }

  static Widget buildCheckmark({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    Color? successColor,
    double? iconSize,
  }) {
    return SuccessAnimation(
      key: key,
      child: child,
      animationType: SuccessAnimationType.checkmark,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      successColor: successColor,
      iconSize: iconSize,
    );
  }

  static Widget buildCircle({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    Color? successColor,
  }) {
    return SuccessAnimation(
      key: key,
      child: child,
      animationType: SuccessAnimationType.circle,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      successColor: successColor,
    );
  }

  static Widget buildConfetti({
    Key? key,
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool autoStart = true,
    VoidCallback? onComplete,
    Color? successColor,
  }) {
    return SuccessAnimation(
      key: key,
      child: child,
      animationType: SuccessAnimationType.confetti,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      onComplete: onComplete,
      successColor: successColor,
    );
  }

  static Widget buildOverlay({
    Key? key,
    required Widget child,
    required bool isSuccess,
    Duration? duration,
    String? successMessage,
    TextStyle? messageStyle,
    VoidCallback? onComplete,
    VoidCallback? onDismiss,
  }) {
    return SuccessOverlay(
      key: key,
      child: child,
      isSuccess: isSuccess,
      duration: duration,
      successMessage: successMessage,
      messageStyle: messageStyle,
      onComplete: onComplete,
      onDismiss: onDismiss,
    );
  }
}

/// Success animation manager untuk managing multiple success states
class SuccessAnimationManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<double>> _animations = {};

  static void registerSuccessAnimation({
    required String key,
    required TickerProvider vsync,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 800),
      vsync: vsync,
    );

    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve ?? Curves.elasticOut,
    ));

    _controllers[key] = controller;
    _animations[key] = animation;

    controller.forward().then((_) {
      onComplete?.call();
      // Haptic feedback untuk notifikasi sukses
      // Menggunakan vibration karena HapticFeedback tidak tersedia
      // Bisa diganti dengan package haptic_feedback jika diperlukan
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
