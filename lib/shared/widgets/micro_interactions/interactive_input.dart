import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Interactive input dengan berbagai efek micro-interactions
class InteractiveInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final InputAnimationType animationType;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Color? focusColor;
  final Color? errorColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;

  const InteractiveInput({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
    this.textCapitalization = TextCapitalization.none,
    this.animationType = InputAnimationType.scale,
    this.animationDuration,
    this.animationCurve,
    this.focusColor,
    this.errorColor,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<InteractiveInput> createState() => _InteractiveInputState();
}

class _InteractiveInputState extends State<InteractiveInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _focusController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<Color?> _colorAnimation;
  late FocusNode _focusNode;
  late TextEditingController _textController;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? Curves.easeOut,
    ));

    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: widget.animationCurve ?? Curves.easeOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.fillColor ?? Theme.of(context).colorScheme.surface,
      end: widget.focusColor ??
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: widget.animationCurve ??
          context.microInteractionTheme.inputFocusCurve,
    ));

    _focusNode = widget.focusNode ?? FocusNode();
    _textController =
        widget.controller ?? TextEditingController(text: widget.initialValue);

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) {
      _textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _focusController,
          builder: (context, child) {
            return _buildAnimatedInput(context);
          },
        );
      },
    );
  }

  Widget _buildAnimatedInput(BuildContext context) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Container(
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: widget.borderRadius ?? AppSpacing.radiusInput,
          border: Border.all(
            color: _getBorderColor(),
            width: _isFocused ? _borderAnimation.value : 1.0,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: (widget.focusColor ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: _buildInputField(context),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return TextFormField(
      controller: _textController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: InputBorder.none,
        enabled: widget.enabled,
        filled: false,
        contentPadding: widget.contentPadding ?? AppSpacing.paddingAllMd,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: widget.prefixIcon,
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        errorText: _errorText,
        errorStyle: TextStyle(
          color: widget.errorColor ?? Theme.of(context).colorScheme.error,
        ),
        labelStyle: TextStyle(
          color: _isFocused
              ? widget.focusColor ?? Theme.of(context).colorScheme.primary
              : AppColors.textSecondary,
        ),
        hintStyle: TextStyle(
          color: AppColors.textDisabled,
        ),
      ),
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      validator: widget.validator != null
          ? (value) => widget.validator!(value!)
          : null,
      autovalidateMode: widget.autovalidateMode,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
      ),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: widget.suffixIcon,
      );
    }

    if (widget.onClear != null && _textController.text.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          _textController.clear();
          widget.onClear?.call();
        },
        child: Icon(
          Icons.clear,
          size: 20,
          color: AppColors.textSecondary,
        ),
      );
    }

    return null;
  }

  Color _getBorderColor() {
    if (_errorText != null) {
      return widget.errorColor ?? Theme.of(context).colorScheme.error;
    }

    if (_isFocused) {
      return widget.focusColor ?? Theme.of(context).colorScheme.primary;
    }

    return AppColors.border;
  }

  void _handleFocusChange() {
    final wasFocused = _isFocused;
    _isFocused = _focusNode.hasFocus;

    if (wasFocused != _isFocused) {
      if (_isFocused) {
        _controller.forward();
        _focusController.forward();
      } else {
        _controller.reverse();
        _focusController.reverse();
      }
      setState(() {});
    }
  }
}

/// Interactive input dengan floating label
class FloatingLabelInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Color? focusColor;
  final Color? errorColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;

  const FloatingLabelInput({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
    this.textCapitalization = TextCapitalization.none,
    this.animationDuration,
    this.animationCurve,
    this.focusColor,
    this.errorColor,
    this.fillColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<FloatingLabelInput> createState() => _FloatingLabelInputState();
}

class _FloatingLabelInputState extends State<FloatingLabelInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _labelController;
  late Animation<Offset> _labelAnimation;
  late FocusNode _focusNode;
  late TextEditingController _textController;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _labelController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );

    _labelAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -20),
    ).animate(CurvedAnimation(
      parent: _labelController,
      curve: widget.animationCurve ?? Curves.easeOut,
    ));

    _focusNode = widget.focusNode ?? FocusNode();
    _textController =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _textController.text.isNotEmpty;

    _focusNode.addListener(_handleFocusChange);
    _textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _textController.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _labelController,
      builder: (context, child) {
        return _buildFloatingInput(context);
      },
    );
  }

  Widget _buildFloatingInput(BuildContext context) {
    return Stack(
      children: [
        if (widget.label != null)
          Positioned(
            left: 16,
            top: _isFocused || _hasText ? _labelAnimation.value.dy : 16,
            child: AnimatedContainer(
              duration: AnimationUtils.durationFast,
              curve: AnimationUtils.curveEaseOut,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _isFocused
                    ? widget.focusColor ?? Theme.of(context).colorScheme.primary
                    : widget.fillColor ?? Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 12,
                  color: _isFocused
                      ? Theme.of(context).colorScheme.onPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.only(top: widget.label != null ? 32 : 0),
          child: InteractiveInput(
            label: null,
            hint: widget.hint,
            initialValue: widget.initialValue,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onClear: widget.onClear,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            controller: _textController,
            focusNode: _focusNode,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            textCapitalization: widget.textCapitalization,
            animationType: InputAnimationType.none,
            focusColor: widget.focusColor,
            errorColor: widget.errorColor,
            fillColor: widget.fillColor,
            borderRadius: widget.borderRadius,
          ),
        ),
      ],
    );
  }

  void _handleFocusChange() {
    final wasFocused = _isFocused;
    _isFocused = _focusNode.hasFocus;

    if (wasFocused != _isFocused) {
      if (_isFocused || _hasText) {
        _labelController.forward();
      } else {
        _labelController.reverse();
      }
      setState(() {});
    }
  }

  void _handleTextChange() {
    final hasText = _textController.text.isNotEmpty;
    if (hasText != _hasText) {
      _hasText = hasText;
      if (_isFocused || _hasText) {
        _labelController.forward();
      } else {
        _labelController.reverse();
      }
      setState(() {});
    }
  }
}

/// Input animation types
enum InputAnimationType {
  none,
  scale,
  border,
  color,
  all,
}

/// Interactive input manager untuk managing multiple input states
class InteractiveInputManager {
  static final Map<String, FocusNode> _focusNodes = {};
  static final Map<String, TextEditingController> _controllers = {};

  static void registerInput({
    required String key,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    _focusNodes[key] = focusNode ?? FocusNode();
    _controllers[key] = controller ?? TextEditingController();
  }

  static FocusNode? getFocusNode(String key) {
    return _focusNodes[key];
  }

  static TextEditingController? getController(String key) {
    return _controllers[key];
  }

  static void focusInput(String key) {
    final focusNode = _focusNodes[key];
    if (focusNode != null) {
      focusNode.requestFocus();
    }
  }

  static void unfocusInput(String key) {
    final focusNode = _focusNodes[key];
    if (focusNode != null) {
      focusNode.unfocus();
    }
  }

  static void clearInput(String key) {
    final controller = _controllers[key];
    if (controller != null) {
      controller.clear();
    }
  }

  static void disposeInput(String key) {
    final focusNode = _focusNodes[key];
    final controller = _controllers[key];

    if (focusNode != null) {
      focusNode.dispose();
    }

    if (controller != null) {
      controller.dispose();
    }

    _focusNodes.remove(key);
    _controllers.remove(key);
  }

  static void disposeAllInputs() {
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }

    for (final controller in _controllers.values) {
      controller.dispose();
    }

    _focusNodes.clear();
    _controllers.clear();
  }
}
