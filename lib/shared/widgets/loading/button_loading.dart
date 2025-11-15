import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Button dengan loading state yang konsisten
class LoadingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isFullWidth;
  final Widget? icon;
  final Widget? loadingWidget;
  final Duration? loadingDuration;
  final Curve? loadingCurve;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? loadingColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  final bool enableFeedback;
  final String? semanticLabel;

  const LoadingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
    this.loadingWidget,
    this.loadingDuration,
    this.loadingCurve,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.textStyle,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.enableFeedback = true,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.loadingDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.loadingCurve ?? Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(LoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
        _controller.forward();
      } else {
        _controller.reverse();
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
      builder: (context, child) {
        return _buildButton(context);
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final isEnabled = !widget.isLoading && widget.onPressed != null;

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: _buildButtonVariant(context, buttonStyle, isEnabled),
    );
  }

  Widget _buildButtonVariant(
      BuildContext context, ButtonStyle buttonStyle, bool isEnabled) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return _buildLoadingContent();
    }

    return _buildNormalContent();
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.loadingWidget != null)
          widget.loadingWidget!
        else
          _buildDefaultSpinner(),
        AppSpacing.gapSm,
        AnimatedSwitcher(
          duration: AnimationUtils.durationFast,
          child: Text(
            widget.text,
            key: ValueKey(widget.text),
            style: _getTextStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalContent() {
    return Row(
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
    );
  }

  Widget _buildDefaultSpinner() {
    return SizedBox(
      width: _getSpinnerSize(),
      height: _getSpinnerSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.loadingColor ?? _getLoadingColor(),
        ),
      ),
    );
  }

  double _getSpinnerSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  Color _getLoadingColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return Theme.of(context).colorScheme.primary;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return widget.textStyle ??
            Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
      case ButtonSize.medium:
        return widget.textStyle ??
            Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            );
      case ButtonSize.large:
        return widget.textStyle ??
            Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final baseStyle = _getBaseButtonStyle(context);
    final animatedStyle = _getAnimatedButtonStyle();

    return baseStyle.merge(animatedStyle);
  }

  ButtonStyle _getBaseButtonStyle(BuildContext context) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor:
              widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
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
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).colorScheme.secondary,
          foregroundColor: widget.foregroundColor ??
              Theme.of(context).colorScheme.onSecondary,
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
          foregroundColor:
              widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
          side: BorderSide(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.primary),
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
          foregroundColor:
              widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
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

  ButtonStyle _getAnimatedButtonStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.all(
        Colors.white.withOpacity(_animation.value * 0.1),
      ),
    );
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

/// Button dengan progress indicator
class ProgressButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double progress;
  final bool showProgress;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isFullWidth;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? progressColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const ProgressButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.progress = 0.0,
    this.showProgress = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.progressColor,
    this.textStyle,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.durationNormal,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationUtils.curveEaseOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: AnimationUtils.curveEaseOut,
      ));

      _controller.forward(from: _animation.value);
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
        return _buildProgressButton(context);
      },
    );
  }

  Widget _buildProgressButton(BuildContext context) {
    return Stack(
      children: [
        // Progress indicator
        if (widget.showProgress)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
              child: LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressColor ?? Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        // Button
        LoadingButton(
          text: widget.text,
          onPressed: widget.onPressed,
          isLoading: false,
          variant: widget.variant,
          size: widget.size,
          isFullWidth: widget.isFullWidth,
          icon: widget.icon,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          textStyle: widget.textStyle,
          borderRadius: widget.borderRadius,
          padding: widget.padding,
        ),
      ],
    );
  }
}

/// Icon button dengan loading state
class LoadingIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? loadingColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  final bool enableFeedback;
  final String? tooltip;
  final String? semanticLabel;

  const LoadingIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.enableFeedback = true,
    this.tooltip,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(LoadingIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
        _controller.forward();
      } else {
        _controller.reverse();
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
      builder: (context, child) {
        return _buildIconButton(context);
      },
    );
  }

  Widget _buildIconButton(BuildContext context) {
    final button = IconButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: IconButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? AppSpacing.radiusButton,
        ),
        elevation: widget.elevation,
        enableFeedback: widget.enableFeedback,
      ),
      icon: widget.isLoading ? _buildLoadingIcon() : widget.icon,
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildLoadingIcon() {
    return SizedBox(
      width: _getIconSize(),
      height: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.loadingColor ??
              widget.foregroundColor ??
              Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 24;
      case ButtonSize.large:
        return 32;
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

/// Button loading manager untuk managing multiple button states
class ButtonLoadingManager {
  static final Map<String, bool> _buttonStates = {};
  static final Map<String, double> _buttonProgress = {};

  static void setButtonState(String key, bool isLoading) {
    _buttonStates[key] = isLoading;
  }

  static void setButtonProgress(String key, double progress) {
    _buttonProgress[key] = progress.clamp(0.0, 1.0);
  }

  static bool isButtonLoading(String key) {
    return _buttonStates[key] ?? false;
  }

  static double? getButtonProgress(String key) {
    return _buttonProgress[key];
  }

  static void clearButtonState(String key) {
    _buttonStates.remove(key);
    _buttonProgress.remove(key);
  }

  static void clearAllButtonStates() {
    _buttonStates.clear();
    _buttonProgress.clear();
  }
}
