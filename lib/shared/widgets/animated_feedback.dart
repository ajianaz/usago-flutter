import 'package:flutter/material.dart';
import '../../core/constants/animation_constants.dart';

enum FeedbackType {
  success,
  error,
  info,
  warning,
}

/// Animated feedback widget for success/error states
class AnimatedFeedback extends StatefulWidget {
  final String message;
  final FeedbackType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final bool showIcon;
  final IconData? customIcon;

  const AnimatedFeedback({
    Key? key,
    required this.message,
    required this.type,
    this.duration = AnimationConstants.successDuration,
    this.onDismiss,
    this.showIcon = true,
    this.customIcon,
  }) : super(key: key);

  @override
  State<AnimatedFeedback> createState() => _AnimatedFeedbackState();
}

class _AnimatedFeedbackState extends State<AnimatedFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: _getShadowColor(context),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: _getBorderColor(context),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.showIcon) ...[
                      _buildIcon(context),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: _getTextColor(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.onDismiss != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: _getTextColor(context).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (widget.type) {
      case FeedbackType.success:
        iconData = widget.customIcon ?? Icons.check_circle;
        iconColor = Colors.green;
        break;
      case FeedbackType.error:
        iconData = widget.customIcon ?? Icons.error;
        iconColor = Colors.red;
        break;
      case FeedbackType.info:
        iconData = widget.customIcon ?? Icons.info;
        iconColor = Colors.blue;
        break;
      case FeedbackType.warning:
        iconData = widget.customIcon ?? Icons.warning;
        iconColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        iconData,
        size: 24,
        color: iconColor,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green.withOpacity(0.1);
      case FeedbackType.error:
        return Colors.red.withOpacity(0.1);
      case FeedbackType.info:
        return Colors.blue.withOpacity(0.1);
      case FeedbackType.warning:
        return Colors.orange.withOpacity(0.1);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green.shade700;
      case FeedbackType.error:
        return Colors.red.shade700;
      case FeedbackType.info:
        return Colors.blue.shade700;
      case FeedbackType.warning:
        return Colors.orange.shade700;
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green.withOpacity(0.3);
      case FeedbackType.error:
        return Colors.red.withOpacity(0.3);
      case FeedbackType.info:
        return Colors.blue.withOpacity(0.3);
      case FeedbackType.warning:
        return Colors.orange.withOpacity(0.3);
    }
  }

  Color _getShadowColor(BuildContext context) {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green.withOpacity(0.2);
      case FeedbackType.error:
        return Colors.red.withOpacity(0.2);
      case FeedbackType.info:
        return Colors.blue.withOpacity(0.2);
      case FeedbackType.warning:
        return Colors.orange.withOpacity(0.2);
    }
  }
}

/// Toast notification widget that shows animated feedback
class AnimatedToast extends StatefulWidget {
  final String message;
  final FeedbackType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final bool showIcon;
  final IconData? customIcon;

  const AnimatedToast({
    Key? key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
    this.showIcon = true,
    this.customIcon,
  }) : super(key: key);

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AnimationConstants.mediumDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showIcon) ...[
                    Icon(
                      _getIconData(),
                      size: 20,
                      color: _getTextColor(context),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: _getTextColor(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData() {
    switch (widget.type) {
      case FeedbackType.success:
        return widget.customIcon ?? Icons.check_circle;
      case FeedbackType.error:
        return widget.customIcon ?? Icons.error;
      case FeedbackType.info:
        return widget.customIcon ?? Icons.info;
      case FeedbackType.warning:
        return widget.customIcon ?? Icons.warning;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.error:
        return Colors.red;
      case FeedbackType.info:
        return Colors.blue;
      case FeedbackType.warning:
        return Colors.orange;
    }
  }

  Color _getTextColor(BuildContext context) {
    return Colors.white;
  }
}