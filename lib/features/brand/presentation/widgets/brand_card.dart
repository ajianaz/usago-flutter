import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../domain/entities/brand.dart';
// Import routes will be handled by the parent component

/// Brand Card Widget for displaying brand information
class BrandCard extends StatelessWidget {
  final Brand brand;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewStats;
  final VoidCallback? onViewInvitations;
  final VoidCallback? onTransfer;
  final bool showOptions;

  const BrandCard({
    Key? key,
    required this.brand,
    this.isActive = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewStats,
    this.onViewInvitations,
    this.onTransfer,
    this.showOptions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return _buildCard(context, deviceType);
      },
    );
  }

  Widget _buildCard(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;
    final cardWidth = isMobile ? double.infinity : 350.0;
    final cardHeight = isMobile ? 120.0 : 140.0;

    return Card(
      elevation: isActive ? 8 : 2,
      shadowColor: isActive ? AppColors.primary.withOpacity(0.3) : Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? AppColors.primary : AppColors.border,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive
            ? LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main content row
                Row(
                  children: [
                    // Brand Logo
                    _buildLogo(context, isMobile),
                    const SizedBox(width: 12),

                    // Brand Information
                    Expanded(
                      child: _buildBrandInfo(context, isMobile),
                    ),

                    // Options Menu
                    if (showOptions && !isMobile) ...[
                      const SizedBox(width: 8),
                      _buildOptionsMenu(context),
                    ],
                  ],
                ),

                // Quick Actions
                if (showOptions) ...[
                  const SizedBox(height: 12),
                  _buildQuickActions(context, isMobile),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isMobile) {
    final logoSize = isMobile ? 60.0 : 80.0;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: brand.hasLogo
            ? Image.network(
                brand.logoUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) => _buildLogoPlaceholder(context),
                errorBuilder: (context, error, stackTrace) => _buildLogoPlaceholder(context),
              )
            : _buildLogoPlaceholder(context),
      ),
    );
  }

  Widget _buildLogoPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          brand.name.isNotEmpty ? brand.name[0].toUpperCase() : 'B',
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandInfo(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Brand Name and Status
        Row(
          children: [
            Expanded(
              child: Text(
                brand.displayName,
                style: AppTextStyles.headline5.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: isMobile ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (brand.isNewBrand) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BARU',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onSuccess,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Business Type and Subscription
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                brand.formattedBusinessType,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getSubscriptionStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${brand.formattedSubscriptionTier} • ${brand.formattedSubscriptionStatus}',
                style: AppTextStyles.caption.copyWith(
                  color: _getSubscriptionStatusColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Description
        if (brand.description != null && brand.description!.isNotEmpty) ...[
          Text(
            brand.description!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],

        // Join Date
        Text(
          'Bergabung: ${brand.joinDateFormatted}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        // Active Indicator
        if (isActive) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                'Brand Aktif',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          'Statistik',
          FontAwesomeIcons.chartLine,
          AppColors.info,
          () {
            onViewStats?.call();
          },
          isMobile,
        ),
        _buildActionButton(
          context,
          'Undangan',
          FontAwesomeIcons.envelope,
          AppColors.warning,
          () {
            onViewInvitations?.call();
          },
          isMobile,
        ),
        _buildActionButton(
          context,
          'Transfer',
          FontAwesomeIcons.rightLeft,
          AppColors.secondary,
          () {
            onTransfer?.call();
          },
          isMobile,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    bool isMobile,
  ) {
    final buttonSize = isMobile ? 60.0 : 70.0;
    final iconSize = isMobile ? UIConstants.fontSizeDefault : UIConstants.fontSizeLarge;
    final fontSize = isMobile ? UIConstants.fontSizeSmall : UIConstants.fontSizeDefault;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            const SizedBox(height: UIConstants.spacingTiny),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: fontSize * 0.7,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onSelected: (value) {
        switch (value) {
          case 'stats':
            onViewStats?.call();
            break;
          case 'invitations':
            onViewInvitations?.call();
            break;
          case 'transfer':
            onTransfer?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'stats',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.chartLine,
                size: 18,
                color: AppColors.info,
              ),
              const SizedBox(width: 12),
              Text(
                'Lihat Statistik',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'invitations',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.envelope,
                size: 18,
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              Text(
                'Kelola Undangan',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'transfer',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.rightLeft,
                size: 18,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Transfer Brand',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Edit',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Hapus',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSubscriptionStatusColor() {
    switch (brand.subscriptionStatus.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.success;
      case 'INACTIVE':
        return AppColors.textDisabled;
      case 'SUSPENDED':
        return AppColors.warning;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Popup menu button for options
class PopupMenuButton<T> extends StatelessWidget {
  final Widget icon;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final Function(T value)? onSelected;

  const PopupMenuButton({
    Key? key,
    required this.icon,
    required this.itemBuilder,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: icon,
      onSelected: onSelected,
      itemBuilder: itemBuilder,
    );
  }
}