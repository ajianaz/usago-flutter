import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Custom progress indicator dengan berbagai style
class CustomProgressIndicator extends StatefulWidget {
  final double progress;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final StrokeCap? strokeCap;
  final bool showPercentage;
  final String? label;
  final TextStyle? labelStyle;
  final Duration? duration;
  final Curve? curve;

  const CustomProgressIndicator({
    Key? key,
    required this.progress,
    this.width,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.strokeCap,
    this.showPercentage = false,
    this.label,
    this.labelStyle,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AnimationUtils.durationNormal,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AnimationUtils.curveEaseOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CustomProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? AnimationUtils.curveEaseOut,
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
        return _buildProgressIndicator(context);
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
          AppSpacing.verticalGapSm,
        ],
        SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 8,
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusXs,
            child: LinearProgressIndicator(
              value: _animation.value,
              backgroundColor: widget.backgroundColor ?? AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        if (widget.showPercentage) ...[
          AppSpacing.verticalGapSm,
          Text(
            '${(_animation.value * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Circular progress indicator dengan custom styling
class CustomCircularProgressIndicator extends StatefulWidget {
  final double progress;
  final double? size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final String? centerText;
  final TextStyle? centerTextStyle;
  final Duration? duration;
  final Curve? curve;

  const CustomCircularProgressIndicator({
    Key? key,
    required this.progress,
    this.size,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
    this.centerText,
    this.centerTextStyle,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  State<CustomCircularProgressIndicator> createState() => _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AnimationUtils.durationNormal,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AnimationUtils.curveEaseOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CustomCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? AnimationUtils.curveEaseOut,
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
        return _buildCircularProgress(context);
      },
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    final size = widget.size ?? 100.0;
    final strokeWidth = widget.strokeWidth;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: CirclePainter(
                progress: 1.0,
                color: widget.backgroundColor ?? AppColors.border,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: CirclePainter(
                progress: _animation.value,
                color: widget.progressColor ?? Theme.of(context).colorScheme.primary,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          // Center content
          Center(
            child: _buildCenterContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    if (widget.centerText != null) {
      return Text(
        widget.centerText!,
        style: widget.centerTextStyle ?? Theme.of(context).textTheme.bodyLarge,
      );
    }

    if (widget.showPercentage) {
      return Text(
        '${(_animation.value * 100).toInt()}%',
        style: widget.centerTextStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Custom painter untuk circular progress
class CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CirclePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Step progress indicator untuk multi-step process
class StepProgressIndicator extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final TextStyle? textStyle;
  final double? stepSize;
  final double? lineWidth;

  const StepProgressIndicator({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.textStyle,
    this.stepSize,
    this.lineWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepLine(context),
        AppSpacing.verticalGapSm,
        _buildStepLabels(context),
      ],
    );
  }

  Widget _buildStepLine(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: lineWidth ?? 4,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;
          final isLast = index == steps.length - 1;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: lineWidth ?? 4,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? completedColor ?? Theme.of(context).colorScheme.primary
                          : inactiveColor ?? AppColors.border,
                      borderRadius: isLast
                          ? const BorderRadius.only(
                              topRight: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            )
                          : null,
                    ),
                  ),
                ),
                if (!isLast) AppSpacing.gapSm,
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepLabels(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep;
        final isActive = index == currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: stepSize ?? 24,
              height: stepSize ?? 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? completedColor ?? Theme.of(context).colorScheme.primary
                    : isActive
                        ? activeColor ?? Theme.of(context).colorScheme.primary
                        : inactiveColor ?? AppColors.border,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: (stepSize ?? 24) * 0.6,
                        color: Colors.white,
                      )
                    : Text(
                        '${index + 1}',
                        style: textStyle ?? TextStyle(
                          color: isActive ? Colors.white : AppColors.textSecondary,
                          fontSize: (stepSize ?? 24) * 0.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            AppSpacing.verticalGapXs,
            SizedBox(
              width: 60,
              child: Text(
                steps[index],
                style: textStyle ?? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Dotted progress indicator
class DottedProgressIndicator extends StatefulWidget {
  final int totalDots;
  final int activeDots;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration? duration;
  final Curve? curve;

  const DottedProgressIndicator({
    Key? key,
    required this.totalDots,
    required this.activeDots,
    this.dotSize = 8.0,
    this.spacing = 4.0,
    this.activeColor,
    this.inactiveColor,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  State<DottedProgressIndicator> createState() => _DottedProgressIndicatorState();
}

class _DottedProgressIndicatorState extends State<DottedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AnimationUtils.durationNormal,
      vsync: this,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.activeDots.clamp(0, widget.totalDots),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AnimationUtils.curveEaseOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(DottedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeDots != widget.activeDots) {
      _animation = IntTween(
        begin: _animation.value,
        end: widget.activeDots.clamp(0, widget.totalDots),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? AnimationUtils.curveEaseOut,
      ));

      _controller.forward(from: _animation.value.toDouble());
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.totalDots, (index) {
            final isActive = index < _animation.value;

            return Padding(
              padding: EdgeInsets.only(right: index < widget.totalDots - 1 ? widget.spacing : 0),
              child: AnimatedContainer(
                duration: AnimationUtils.durationFast,
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: isActive
                      ? widget.activeColor ?? Theme.of(context).colorScheme.primary
                      : widget.inactiveColor ?? AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Progress indicator dengan pulse animation
class PulseProgressIndicator extends StatefulWidget {
  final double progress;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final Duration? pulseDuration;

  const PulseProgressIndicator({
    Key? key,
    required this.progress,
    this.width,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.pulseDuration,
  }) : super(key: key);

  @override
  State<PulseProgressIndicator> createState() => _PulseProgressIndicatorState();
}

class _PulseProgressIndicatorState extends State<PulseProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: widget.pulseDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomProgressIndicator(
            progress: widget.progress,
            width: widget.width,
            height: widget.height,
            backgroundColor: widget.backgroundColor,
            progressColor: widget.progressColor,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}
