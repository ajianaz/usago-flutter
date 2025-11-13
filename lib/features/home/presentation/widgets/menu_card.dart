import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../domain/entities/menu_item.dart';

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const MenuCard({
    Key? key,
    required this.menuItem,
    required this.onTap,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusCard,
      ),
      child: InkWell(
        onTap: menuItem.isEnabled ? onTap : null,
        borderRadius: AppSpacing.radiusCard,
        child: Container(
          width: width,
          height: height,
          padding: AppSpacing.paddingCard,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.radiusCard,
            gradient: menuItem.isEnabled
                ? LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [AppColors.textDisabled.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: menuItem.isEnabled
                      ? AppColors.onPrimary.withOpacity(0.2)
                      : AppColors.textDisabled.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(menuItem.icon),
                  size: 32,
                  color: menuItem.isEnabled
                      ? AppColors.onPrimary
                      : AppColors.textDisabled,
                ),
              ),
              AppSpacing.verticalGapSm,
              Text(
                menuItem.title,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: menuItem.isEnabled
                      ? AppColors.onPrimary
                      : AppColors.textDisabled,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (menuItem.description.isNotEmpty) ...[
                AppSpacing.verticalGapXs,
                Text(
                  menuItem.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: menuItem.isEnabled
                        ? AppColors.onPrimary.withOpacity(0.8)
                        : AppColors.textDisabled,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Map icon name to IconData
    switch (iconName.toLowerCase()) {
      case 'dashboard':
        return Icons.dashboard;
      case 'people':
        return Icons.people;
      case 'inventory':
        return Icons.inventory;
      case 'analytics':
        return Icons.analytics;
      case 'settings':
        return Icons.settings;
      case 'reports':
        return Icons.assessment;
      case 'orders':
        return Icons.shopping_cart;
      case 'products':
        return Icons.category;
      case 'customers':
        return Icons.person;
      case 'finance':
        return Icons.account_balance;
      case 'notifications':
        return Icons.notifications;
      case 'calendar':
        return Icons.calendar_today;
      case 'document':
        return Icons.description;
      case 'help':
        return Icons.help;
      case 'security':
        return Icons.security;
      case 'branch':
        return Icons.store;
      case 'brand':
        return Icons.business;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'payment':
        return Icons.payment;
      case 'history':
        return Icons.history;
      case 'search':
        return Icons.search;
      case 'filter':
        return Icons.filter_list;
      case 'add':
        return Icons.add_circle;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'download':
        return Icons.download;
      case 'upload':
        return Icons.upload;
      case 'print':
        return Icons.print;
      case 'share':
        return Icons.share;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'home':
        return Icons.home;
      case 'logout':
        return Icons.logout;
      case 'login':
        return Icons.login;
      case 'menu':
        return Icons.menu;
      case 'close':
        return Icons.close;
      case 'check':
        return Icons.check;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
        return Icons.info;
      case 'success':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'completed':
        return Icons.task_alt;
      case 'cancelled':
        return Icons.cancel;
      case 'active':
        return Icons.check_circle;
      case 'inactive':
        return Icons.cancel;
      default:
        return Icons.apps;
    }
  }
}