import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Animated button dengan berbagai efek micro-interactions
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isFullWidth;
  final Widget? icon;
  final ButtonAnimationType animationType;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  final bool enableFeedback;
  final String? semanticLabel;

  const AnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
    this.animationType = ButtonAnimationType.scale,
    this.animationDuration,
    this.animationCurve,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.enableFeedback = true,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = AnimationUtils.createPulseAnimation(
      controller: _scaleController,
      begin: 1.0,
      end: 1.1,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildAnimatedButton(context);
      },
    );
  }

  Widget _buildAnimatedButton(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? _handleTapDown : null,
      onTapUp: isEnabled ? _handleTapUp : null,
      onTapCancel: isEnabled ? _handleTapCancel : null,
      onTap: isEnabled ? _handleTap : null,
      child: AnimatedBuilder(
        animation: _getAnimation(),
        builder: (context, child) {
          return Transform.scale(
            scale: _getAnimationValue(),
            child: _buildButtonContent(context, buttonStyle),
          );
        },
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, ButtonStyle buttonStyle) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: widget.onPressed,
          style: buttonStyle,
          child: _buildButtonChild(),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: widget.onPressed,
          style: buttonStyle,
          child: _buildButtonChild(),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: widget.onPressed,
          style: buttonStyle,
          child: _buildButtonChild(),
        );
      case ButtonVariant.ghost:
        return TextButton(
          onPressed: widget.onPressed,
          style: buttonStyle,
          child: _buildButtonChild(),
        );
    }
  }

  Widget _buildButtonChild() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          AppSpacing.gapSm,
        ],
        Text(
          widget.text,
          style: widget.textStyle ?? _getTextStyle(),
        ),
      ],
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          textStyle: _getTextStyle(),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
          ),
          padding: widget.padding ?? _getButtonPadding(),
          elevation: widget.elevation,
          enableFeedback: widget.enableFeedback,
        );
      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.secondary,
          foregroundColor: widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary,
          textStyle: _getTextStyle(),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
          ),
          padding: widget.padding ?? _getButtonPadding(),
          elevation: widget.elevation,
          enableFeedback: widget.enableFeedback,
        );
      case ButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
          side: BorderSide(color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary),
          textStyle: _getTextStyle(),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
          ),
          padding: widget.padding ?? _getButtonPadding(),
          elevation: widget.elevation,
          enableFeedback: widget.enableFeedback,
        );
      case ButtonVariant.ghost:
        return TextButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
          textStyle: _getTextStyle(),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
          ),
          padding: widget.padding ?? _getButtonPadding(),
          elevation: widget.elevation,
          enableFeedback: widget.enableFeedback,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.medium:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.large:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.paddingHorizontalSm + AppSpacing.paddingVerticalSm;
      case ButtonSize.medium:
        return AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm;
      case ButtonSize.large:
        return AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalMd;
    }
  }

  Animation<double> _getAnimation() {
    switch (widget.animationType) {
      case ButtonAnimationType.scale:
        return _scaleAnimation;
      case ButtonAnimationType.shimmer:
        return _shimmerAnimation;
      case ButtonAnimationType.pulse:
        return _pulseAnimation;
      case ButtonAnimationType.bounce:
        return _bounceAnimation;
    }
  }

  double _getAnimationValue() {
    switch (widget.animationType) {
      case ButtonAnimationType.scale:
        return _scaleAnimation.value;
      case ButtonAnimationType.shimmer:
        return 1.0;
      case ButtonAnimationType.pulse:
        return _pulseAnimation.value;
      case ButtonAnimationType.bounce:
        return _bounceAnimation.value;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.animationType == ButtonAnimationType.pulse) {
      _scaleController.repeat(reverse: true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.animationType == ButtonAnimationType.pulse) {
      _scaleController.stop();
      _scaleController.reset();
    }
  }

  void _handleTapCancel() {
    _controller.reverse();
    if (widget.animationType == ButtonAnimationType.pulse) {
      _scaleController.stop();
      _scaleController.reset();
    }
  }

  void _handleTap() {
    widget.onPressed?.call();
  }
}

/// Animated button dengan shimmer effect
class ShimmerButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isFullWidth;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shimmerColor;
  final Duration? shimmerDuration;

  const ShimmerButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.shimmerColor,
    this.shimmerDuration,
  }) : super(key: key);

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.shimmerDuration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
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
        return _buildShimmerButton(context);
      },
    );
  }

  Widget _buildShimmerButton(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
            widget.shimmerColor ?? Colors.white.withOpacity(0.3),
            widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
          ],
          stops: [
            0.0,
            _animation.value,
            (_animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ).createShader(bounds);
      },
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        textStyle: _getTextStyle(),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusButton,
        ),
        padding: _getButtonPadding(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            AppSpacing.gapSm,
          ],
          Text(
            widget.text,
            style: _getTextStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.medium:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.large:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.paddingHorizontalSm + AppSpacing.paddingVerticalSm;
      case ButtonSize.medium:
        return AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm;
      case ButtonSize.large:
        return AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalMd;
    }
  }
}

/// Button variants enum
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

/// Button sizes enum
enum ButtonSize {
  small,
  medium,
  large,
}

/// Button animation types
enum ButtonAnimationType {
  scale,
  shimmer,
  pulse,
  bounce,
}

/// Animated button manager untuk managing multiple button states
class AnimatedButtonManager {
  static final Map<String, AnimationController> _controllers = {};
  static final Map<String, Animation<double>> _animations = {};

  static void registerButtonAnimation({
    required String key,
    required TickerProvider vsync,
    required ButtonAnimationType animationType,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final controller = AnimationController(
      duration: duration ?? const Duration(milliseconds: 150),
      vsync: vsync,
    );

    Animation<double> animation;
    switch (animationType) {
      case ButtonAnimationType.scale:
        animation = Tween<double>(
          begin: 1.0,
          end: 0.95,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: curve ?? Curves.easeInOut,
        ));
        break;
      case ButtonAnimationType.pulse:
        animation = AnimationUtils.createPulseAnimation(
          controller: controller,
          begin: 1.0,
          end: 1.1,
        );
        break;
      case ButtonAnimationType.bounce:
        animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ));
        break;
      case ButtonAnimationType.shimmer:
        animation = Tween<double>(
          begin: -1.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ));
        break;
    }

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