import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../../../../i18n/translations.g.dart';

/// Brand Statistics Page
/// Displays comprehensive statistics and analytics for a brand
@RoutePage()
class BrandStatsPage extends StatelessWidget {
  final Brand brand;

  const BrandStatsPage({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<BrandBloc>(),
      child: BlocResponsiveLayout<BrandBloc, BrandState>(
        builder: (context, bloc, state, deviceType) {
          return _buildContent(context, deviceType);
        },
        listener: (context, state) {
          if (state is BrandError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;
    final isTablet = deviceType == DeviceType.tablet;

    final content = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(context)),
          onPressed: () {
            context.router.maybePop();
          },
          tooltip: context.t.brand.back,
        ),
        title: Text(
          context.t.brand.brand_stats,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.getTextSecondary(context)),
            onPressed: () {
              // Refresh statistics
              context.read<BrandBloc>().add(LoadUserBrandsEvent());
            },
            tooltip: context.t.brand.refresh,
          ),
        ],
      ),
      body: _buildStatsContent(context, deviceType, isMobile, isTablet),
    );

    // Apply desktop constraint
    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildStatsContent(
    BuildContext context,
    DeviceType deviceType,
    bool isMobile,
    bool isTablet,
  ) {
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final childAspectRatio = isMobile ? 1.0 : 1.2;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Overview Card
          _buildBrandOverviewCard(context, isMobile),
          SizedBox(height: AppSpacing.lg),

          // Statistics Grid
          GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTotalUsersCard(context, isMobile),
              _buildActiveBranchesCard(context, isMobile),
              _buildRevenueCard(context, isMobile),
              _buildGrowthCard(context, isMobile),
              _buildInvitationsCard(context, isMobile),
              _buildActivityCard(context, isMobile),
              _buildPerformanceCard(context, isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandOverviewCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: UIConstants.elevationCard,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: UIConstants.containerSizeSmall,
                height: UIConstants.containerSizeSmall,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
                ),
                child: brand.logoUrl != null
                    ? Image.network(
                        brand.logoUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.business,
                          color: AppColors.getTextSecondary(context),
                        ),
                      )
                    : Icon(
                        Icons.business,
                        color: AppColors.primary,
                        size: UIConstants.fontSizeExtraLarge,
                      ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: AppTextStyles.headline6Dynamic(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      brand.formattedBusinessType,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                    if (brand.description != null) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        brand.description!,
                        style: AppTextStyles.bodySmallDynamic(context).copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  context.t.brand.created,
                  brand.joinDateFormatted,
                  Icons.calendar_today,
                  AppColors.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  context.t.brand.status,
                  brand.formattedSubscriptionStatus,
                  brand.isSubscriptionActive ? Icons.check_circle : Icons.pending,
                  brand.isSubscriptionActive ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: UIConstants.fontSizeSmall,
              color: color,
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodySmallDynamic(context).copyWith(
                color: AppColors.getTextSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.bodyLargeDynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalUsersCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.total_users,
      '1,234',
      Icons.people,
      AppColors.primary,
      isMobile,
      subtitle: context.t.brand.active_users.replaceAll('{count}', '892'),
      changePercent: 12.5,
      changeType: 'increase',
    );
  }

  Widget _buildActiveBranchesCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.active_branches,
      '15',
      Icons.store,
      AppColors.secondary,
      isMobile,
      subtitle: context.t.brand.total_branches.replaceAll('{count}', '23'),
      changePercent: -8.3,
      changeType: 'decrease',
    );
  }

  Widget _buildRevenueCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.monthly_revenue,
      'Rp 45.2M',
      Icons.attach_money,
      AppColors.success,
      isMobile,
      subtitle: context.t.brand.revenue_target.replaceAll('{amount}', 'Rp 50M'),
      changePercent: 9.6,
      changeType: 'increase',
    );
  }

  Widget _buildGrowthCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.growth,
      '23.4%',
      Icons.trending_up,
      AppColors.info,
      isMobile,
      subtitle: context.t.brand.compare_last_month,
      changePercent: 5.2,
      changeType: 'increase',
    );
  }

  Widget _buildInvitationsCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.invitations_sent,
      '8',
      Icons.mail,
      AppColors.warning,
      isMobile,
      subtitle: context.t.brand.pending_invitations.replaceAll('{pending}', '5').replaceAll('{accepted}', '3'),
      changePercent: null,
      changeType: null,
    );
  }

  Widget _buildActivityCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.weekly_activity,
      '342',
      FontAwesomeIcons.chartLine,
      AppColors.primary,
      isMobile,
      subtitle: context.t.brand.daily_average.replaceAll('{count}', '49'),
      changePercent: 15.3,
      changeType: 'increase',
    );
  }

  Widget _buildPerformanceCard(BuildContext context, bool isMobile) {
    return _buildStatsCard(
      context,
      context.t.brand.performance_score,
      '87.5',
      Icons.speed,
      AppColors.secondary,
      isMobile,
      subtitle: context.t.brand.very_good,
      changePercent: 2.1,
      changeType: 'increase',
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isMobile, {
    String? subtitle,
    double? changePercent,
    String? changeType,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: UIConstants.elevationCard,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isMobile ? UIConstants.fontSizeLarge : UIConstants.fontSizeExtraLarge,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headline6Dynamic(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmallDynamic(context).copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppTextStyles.headline4Dynamic(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (changePercent != null && changeType != null) ...[
                Row(
                  children: [
                    Icon(
                      changeType == 'increase' ? Icons.trending_up : Icons.trending_down,
                      size: UIConstants.fontSizeSmall,
                      color: changeType == 'increase' ? AppColors.success : AppColors.error,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${changeType == 'increase' ? '+' : '-'}${changePercent!.toStringAsFixed(1)}%',
                      style: AppTextStyles.bodySmallDynamic(context).copyWith(
                        color: changeType == 'increase' ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}