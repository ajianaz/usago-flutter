import 'package:flutter/material.dart';
import '../themes/animation_theme.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_spacing.dart';
import '../../core/constants/animation_constants.dart';

/// Animated text field with focus animations and validation feedback
class AnimatedTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(bool)? onFocusChanged;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AnimatedTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFocusChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  AnimationController? _shakeController;
  late Animation<double> _focusAnimation;
  late Animation<double> _errorAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _borderWidthAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  String? _errorMessage;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _animationController = AnimationController(
      duration: AnimationTheme.inputFocusDuration,
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTheme.inputFocusCurve,
    ));

    // Create a separate controller for shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController!,
      curve: AnimationTheme.shakeCurve,
    ));

    _borderColorAnimation = ColorTween(
      begin: AppColors.border,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTheme.inputFocusCurve,
    ));

    _borderWidthAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTheme.inputFocusCurve,
    ));

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shakeController?.dispose();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  void _validateField(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _hasError = error != null;
        _errorMessage = error;
      });

      if (_hasError) {
        _triggerErrorAnimation();
      }
    }

    widget.onChanged?.call(value);
  }

  void _triggerErrorAnimation() {
    _shakeController?.forward().then((_) {
      _shakeController?.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: AnimationTheme.inputFocusDuration,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.radiusSm,
                border: Border.all(
                  color: _hasError
                    ? AppColors.error
                    : _borderColorAnimation.value ?? AppColors.border,
                  width: _borderWidthAnimation.value,
                ),
                boxShadow: _focusNode.hasFocus ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8 * _focusAnimation.value,
                    offset: Offset(0, 2 * _focusAnimation.value),
                  ),
                ] : null,
              ),
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                autofocus: widget.autofocus,
                textInputAction: widget.textInputAction,
                onFieldSubmitted: widget.onSubmitted,
                onTap: widget.onTap,
                onChanged: _validateField,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: _focusNode.hasFocus
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  ),
                ),
              ),
            ),
            if (_hasError)
              AnimatedContainer(
                duration: AnimationConstants.fastDuration,
                margin: EdgeInsets.only(top: AppSpacing.xs),
                // Wrap in a flexible container to prevent overflow
                child: Row(
                  children: [
                    Expanded(
                      child: Transform.translate(
                        offset: Offset((_shakeAnimation.value - 0.5) * 10, 0),  // Center the shake and scale it
                        child: Text(
                          _errorMessage ?? '',
                          style: AppTextStyles.error,
                          overflow: TextOverflow.visible,  // Handle text overflow gracefully
                          maxLines: 2,  // Limit lines to prevent excessive height
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}