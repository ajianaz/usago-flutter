import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Skeleton loader untuk menampilkan placeholder saat loading
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;
  final Curve? curve;

  const SkeletonLoader({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
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
    return Builder(
      builder: (context) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return _buildSkeleton(context);
          },
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? AppSpacing.radiusSm,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            widget.baseColor ?? AppColors.borderLight,
            widget.highlightColor ?? AppColors.border,
            widget.baseColor ?? AppColors.borderLight,
          ],
          stops: [
            0.0,
            0.5 + (_animation.value * 0.5),
            1.0,
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader untuk text
class SkeletonText extends StatelessWidget {
  final double width;
  final double? height;
  final int lines;
  final double spacing;
  final double? lastLineWidth;
  final BorderRadius? borderRadius;

  const SkeletonText({
    Key? key,
    this.width = double.infinity,
    this.height,
    this.lines = 1,
    this.spacing = 8.0,
    this.lastLineWidth,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textHeight = height ?? 16.0;
    final defaultLastWidth = lastLineWidth ?? (lines > 1 ? width * 0.7 : width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        final lineWidth = isLastLine ? defaultLastWidth : width;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastLine ? 0 : spacing),
          child: SkeletonLoader(
            width: lineWidth!,
            height: textHeight,
            borderRadius: borderRadius ?? AppSpacing.radiusXs,
          ),
        );
      }),
    );
  }
}

/// Skeleton loader untuk avatar
class SkeletonAvatar extends StatelessWidget {
  final double size;
  final ShapeBorder shape;

  const SkeletonAvatar({
    Key? key,
    this.size = 40.0,
    this.shape = const CircleBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: shape is CircleBorder ? null : BorderRadius.circular(8.0),
    );
  }
}

/// Skeleton loader untuk card
class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final bool showAvatar;
  final bool showTitle;
  final bool showSubtitle;
  final bool showContent;
  final Widget? footer;

  const SkeletonCard({
    Key? key,
    this.width,
    this.height,
    this.padding,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showContent = true,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppSpacing.radiusCard,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAvatar) ...[
            Row(
              children: [
                const SkeletonAvatar(size: 40),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTitle)
                        SkeletonText(
                          width: double.infinity,
                          height: 16,
                          lines: 1,
                        ),
                      if (showSubtitle) ...[
                        AppSpacing.verticalGapSm,
                        SkeletonText(
                          width: double.infinity,
                          height: 14,
                          lines: 1,
                          lastLineWidth: 120,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (showContent) ...[
            if (showAvatar) AppSpacing.verticalGapMd,
            SkeletonText(
              width: double.infinity,
              height: 14,
              lines: 3,
              spacing: 6,
              lastLineWidth: 150,
            ),
          ],
          if (footer != null) ...[
            AppSpacing.verticalGapMd,
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Skeleton loader untuk list
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;
  final double spacing;
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const SkeletonList({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding,
    this.spacing = 8.0,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: itemBuilder ??
          (context, index) {
            return SkeletonCard(
              width: double.infinity,
              height: itemHeight,
            );
          },
    );
  }
}

/// Skeleton loader untuk grid
class SkeletonGrid extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final int itemCount;
  final EdgeInsets? padding;
  final double spacing;
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const SkeletonGrid({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.itemCount = 6,
    this.padding,
    this.spacing = 8.0,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder ??
          (context, index) {
            return SkeletonCard(
              width: double.infinity,
              height: double.infinity,
            );
          },
    );
  }
}

/// Skeleton loader untuk custom widget
class SkeletonWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonWidget({
    Key? key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeletonPlaceholder(context);
    }
    return child;
  }

  Widget _buildSkeletonPlaceholder(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SkeletonLoader(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
      },
    );
  }
}

/// Skeleton loader dengan fade transition
class FadeSkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Duration? duration;
  final Duration? skeletonDuration;
  final Curve? curve;

  const FadeSkeletonLoader({
    Key? key,
    required this.child,
    required this.isLoading,
    this.duration,
    this.skeletonDuration,
    this.curve,
  }) : super(key: key);

  @override
  State<FadeSkeletonLoader> createState() => _FadeSkeletonLoaderState();
}

class _FadeSkeletonLoaderState extends State<FadeSkeletonLoader>
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

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AnimationUtils.curveEaseInOut,
    );

    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FadeSkeletonLoader oldWidget) {
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
        return Stack(
          children: [
            Opacity(
              opacity: 1.0 - _animation.value,
              child: widget.child,
            ),
            if (_animation.value > 0)
              Opacity(
                opacity: _animation.value,
                child: _buildSkeleton(context),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: AppSpacing.radiusSm,
      ),
    );
  }
}

/// Skeleton loader manager untuk managing multiple skeleton states
class SkeletonManager {
  static final Map<String, bool> _skeletonStates = {};

  static void setSkeletonState(String key, bool isLoading) {
    _skeletonStates[key] = isLoading;
  }

  static bool isSkeletonLoading(String key) {
    return _skeletonStates[key] ?? false;
  }

  static void clearSkeletonState(String key) {
    _skeletonStates.remove(key);
  }

  static void clearAllSkeletonStates() {
    _skeletonStates.clear();
  }
}
