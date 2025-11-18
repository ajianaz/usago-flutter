import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';
import '../themes/animation_theme.dart';
import '../utils/animation_utils.dart';
import '../../core/constants/animation_constants.dart';

enum AnimatedButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

enum AnimatedButtonSize {
  small,
  medium,
  large,
}

/// Animated button with press, hover, and loading state animations
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AnimatedButtonVariant variant;
  final AnimatedButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Widget? child;
  final Duration? animationDuration;

  const AnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = AnimatedButtonVariant.primary,
    this.size = AnimatedButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
    this.animationDuration,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pressAnimation;
  late Animation<double> _hoverAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration ?? AnimationTheme.buttonPressDuration,
      vsync: this,
    );

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTheme.buttonPressCurve,
    ));

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTheme.buttonPressCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isHovered = true;
      });
      _animationController.forward();
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() {
        _isHovered = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = _isPressed
          ? _pressAnimation.value
          : _isHovered
            ? _hoverAnimation.value
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: MouseRegion(
            onEnter: _handleMouseEnter,
            onExit: _handleMouseExit,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: SizedBox(
                width: widget.isFullWidth ? double.infinity : null,
                child: _buildButton(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (widget.variant) {
      case AnimatedButtonVariant.primary:
        return ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getPrimaryButtonStyle(context),
          child: _buildButtonContent(),
        );
      case AnimatedButtonVariant.secondary:
        return ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getSecondaryButtonStyle(context),
          child: _buildButtonContent(),
        );
      case AnimatedButtonVariant.outline:
        return OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getOutlineButtonStyle(context),
          child: _buildButtonContent(),
        );
      case AnimatedButtonVariant.ghost:
        return TextButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getGhostButtonStyle(context),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getTextSize(),
            height: _getTextSize(),
            child: OptimizedAnimationBuilder(
              duration: AnimationConstants.loadingSpinnerDuration,
              repeat: true,
              builder: (context, animation) {
                return Transform.rotate(
                  angle: animation.value * 2 * 3.14159,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.variant == AnimatedButtonVariant.ghost
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.icon != null) ...[
            AppSpacing.gapSm,
            widget.icon!,
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.child != null)
          widget.child!
        else ...[
          if (widget.icon != null) ...[
            widget.icon!,
            AppSpacing.gapSm,
          ],
          Text(
            widget.text,
            style: _getTextStyle(),
          ),
        ],
      ],
    );
  }

  double _getTextSize() {
    switch (widget.size) {
      case AnimatedButtonSize.small:
        return 16;
      case AnimatedButtonSize.medium:
        return 20;
      case AnimatedButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case AnimatedButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AnimatedButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case AnimatedButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (widget.size) {
      case AnimatedButtonSize.small:
        return AppSpacing.paddingHorizontalSm + AppSpacing.paddingVerticalSm;
      case AnimatedButtonSize.medium:
        return AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm;
      case AnimatedButtonSize.large:
        return AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalMd;
    }
  }

  ButtonStyle _getPrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
      elevation: _isHovered ? 8 : 2,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
    );
  }

  ButtonStyle _getSecondaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
      elevation: _isHovered ? 8 : 2,
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
    );
  }

  ButtonStyle _getOutlineButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: _isHovered ? 2 : 1,
      ),
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }

  ButtonStyle _getGhostButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      textStyle: _getTextStyle().copyWith(
        color: _isHovered ? Theme.of(context).colorScheme.primary.withOpacity(0.8) : null,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }
}