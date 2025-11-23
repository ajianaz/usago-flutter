import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../i18n/translations.g.dart';

/// Token Card Widget
/// Displays information about an active session/token
class TokenCard extends StatelessWidget {
  final Map<String, dynamic> token;
  final VoidCallback onRevoke;

  const TokenCard({
    Key? key,
    required this.token,
    required this.onRevoke,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with device icon and name
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getDeviceIcon(token['deviceType'] ?? 'unknown'),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token['deviceName'] ?? 'Unknown Device',
                      style: AppTextStyles.bodyLargeDynamic(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      token['deviceType'] ?? 'Unknown Type',
                      style: AppTextStyles.bodySmallDynamic(context).copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (token['isCurrent'] == true)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Current',
                    style: AppTextStyles.bodySmallDynamic(context).copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // Token details
          _buildDetailRow(
            context,
            'IP Address',
            token['ipAddress'] ?? 'Unknown',
            Icons.wifi,
          ),
          SizedBox(height: AppSpacing.sm),
          _buildDetailRow(
            context,
            'Location',
            token['location'] ?? 'Unknown',
            Icons.location_on,
          ),
          SizedBox(height: AppSpacing.sm),
          _buildDetailRow(
            context,
            'Last Active',
            _formatLastSeen(token['lastSeen']),
            Icons.access_time,
          ),
          SizedBox(height: AppSpacing.md),

          // Actions
          if (token['isCurrent'] != true)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Revoke',
                  onPressed: onRevoke,
                  variant: ButtonVariant.outline,
                  size: ButtonSize.small,
                  icon: const Icon(Icons.delete_outline, size: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.getTextSecondary(context),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmallDynamic(context).copyWith(
            color: AppColors.getTextSecondary(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmallDynamic(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
      case 'android':
        return FontAwesomeIcons.mobileScreen;
      case 'ios':
      case 'iphone':
        return FontAwesomeIcons.mobileScreen;
      case 'tablet':
        return FontAwesomeIcons.tabletScreenButton;
      case 'desktop':
      case 'windows':
        return FontAwesomeIcons.desktop;
      case 'mac':
      case 'macos':
        return FontAwesomeIcons.computer;
      case 'web':
        return FontAwesomeIcons.globe;
      default:
        return FontAwesomeIcons.question;
    }
  }

  String _formatLastSeen(String? lastSeen) {
    if (lastSeen == null || lastSeen.isEmpty) {
      return 'Never';
    }

    try {
      final dateTime = DateTime.parse(lastSeen);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return lastSeen;
    }
  }
}
