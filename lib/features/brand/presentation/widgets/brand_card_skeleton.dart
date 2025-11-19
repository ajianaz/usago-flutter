import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/responsive_builder.dart';

/// Skeleton loader for Brand Cards
class BrandCardSkeleton extends StatelessWidget {
  final DeviceType deviceType;

  const BrandCardSkeleton({
    Key? key,
    required this.deviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = deviceType == DeviceType.mobile;
    final cardHeight = isMobile ? 120.0 : 140.0;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(
          color: AppColors.getBorder(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content row
            Row(
              children: [
                // Logo skeleton
                _buildSkeletonContainer(
                  isMobile ? 60.0 : 80.0,
                  isMobile ? 60.0 : 80.0,
                  AppSpacing.radiusMd,
                ),
                AppSpacing.gapMd,

                // Brand info skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title skeleton
                      _buildSkeletonContainer(
                        double.infinity,
                        16.0,
                        AppSpacing.radiusSm,
                      ),
                      AppSpacing.verticalGapXs,

                      // Tags skeleton
                      Row(
                        children: [
                          _buildSkeletonContainer(
                            60.0,
                            20.0,
                            AppSpacing.radiusSm,
                          ),
                          AppSpacing.gapSm,
                          _buildSkeletonContainer(
                            80.0,
                            20.0,
                            AppSpacing.radiusSm,
                          ),
                        ],
                      ),
                      AppSpacing.verticalGapSm,

                      // Description skeleton
                      _buildSkeletonContainer(
                        double.infinity,
                        12.0,
                        AppSpacing.radiusSm,
                      ),
                    ],
                  ),
                ),

                // Options menu skeleton (desktop only)
                if (!isMobile) ...[
                  AppSpacing.gapSm,
                  _buildSkeletonContainer(
                    24.0,
                    24.0,
                    AppSpacing.radiusSm,
                  ),
                ],
              ],
            ),

            // Quick actions skeleton
            AppSpacing.verticalGapMd,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSkeletonContainer(
                  isMobile ? 60.0 : 70.0,
                  isMobile ? 60.0 : 70.0,
                  AppSpacing.radiusButton,
                ),
                _buildSkeletonContainer(
                  isMobile ? 60.0 : 70.0,
                  isMobile ? 60.0 : 70.0,
                  AppSpacing.radiusButton,
                ),
                _buildSkeletonContainer(
                  isMobile ? 60.0 : 70.0,
                  isMobile ? 60.0 : 70.0,
                  AppSpacing.radiusButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonContainer(double width, double height, BorderRadius borderRadius) {
    return OptimizedAnimationBuilder(
      duration: const Duration(milliseconds: 1500),
      repeat: true,
      builder: (context, animation) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.getSurface(context),
                AppColors.getSurface(context).withOpacity(0.5),
                AppColors.getSurface(context),
              ],
              stops: [0.0, animation.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Optimized Animation Builder for skeleton loading
class OptimizedAnimationBuilder extends StatefulWidget {
  final Widget Function(BuildContext, Animation<double>) builder;
  final Duration duration;
  final bool repeat;
  final Curve curve;

  const OptimizedAnimationBuilder({
    Key? key,
    required this.builder,
    this.duration = const Duration(milliseconds: 1500),
    this.repeat = false,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<OptimizedAnimationBuilder> createState() => _OptimizedAnimationBuilderState();
}

class _OptimizedAnimationBuilderState extends State<OptimizedAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
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
      builder: (context, child) => widget.builder(context, _animation),
    );
  }
}