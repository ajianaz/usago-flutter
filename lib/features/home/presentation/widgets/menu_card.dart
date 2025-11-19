import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../domain/entities/menu_item.dart';
import '../../../../i18n/translations.g.dart';

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
                _getTranslatedTitle(context),
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
                  _getTranslatedDescription(context),
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
    // Map icon name to FontAwesome IconData
    switch (iconName.toLowerCase()) {
      case 'dashboard':
        return FontAwesomeIcons.gaugeHigh;
      case 'people':
        return FontAwesomeIcons.users;
      case 'inventory':
        return FontAwesomeIcons.boxesStacked;
      case 'analytics':
        return FontAwesomeIcons.chartSimple;
      case 'settings':
        return FontAwesomeIcons.gear;
      case 'reports':
        return FontAwesomeIcons.fileLines;
      case 'orders':
        return FontAwesomeIcons.cartShopping;
      case 'products':
        return FontAwesomeIcons.box;
      case 'customers':
        return FontAwesomeIcons.user;
      case 'finance':
        return FontAwesomeIcons.moneyBillWave;
      case 'notifications':
        return FontAwesomeIcons.bell;
      case 'calendar':
        return FontAwesomeIcons.calendar;
      case 'document':
        return FontAwesomeIcons.file;
      case 'help':
        return FontAwesomeIcons.circleQuestion;
      case 'security':
        return FontAwesomeIcons.shieldHalved;
      case 'branch':
        return FontAwesomeIcons.store;
      case 'brand':
        return FontAwesomeIcons.building;
      case 'wallet':
        return FontAwesomeIcons.wallet;
      case 'payment':
        return FontAwesomeIcons.creditCard;
      case 'history':
        return FontAwesomeIcons.clockRotateLeft;
      case 'search':
        return FontAwesomeIcons.magnifyingGlass;
      case 'filter':
        return FontAwesomeIcons.filter;
      case 'add':
        return FontAwesomeIcons.circlePlus;
      case 'edit':
        return FontAwesomeIcons.penToSquare;
      case 'delete':
        return FontAwesomeIcons.trash;
      case 'download':
        return FontAwesomeIcons.download;
      case 'upload':
        return FontAwesomeIcons.upload;
      case 'print':
        return FontAwesomeIcons.print;
      case 'share':
        return FontAwesomeIcons.share;
      case 'favorite':
        return FontAwesomeIcons.heart;
      case 'star':
        return FontAwesomeIcons.star;
      case 'home':
        return FontAwesomeIcons.house;
      case 'logout':
        return FontAwesomeIcons.rightFromBracket;
      case 'login':
        return FontAwesomeIcons.rightToBracket;
      case 'menu':
        return FontAwesomeIcons.bars;
      case 'close':
        return FontAwesomeIcons.xmark;
      case 'check':
        return FontAwesomeIcons.check;
      case 'warning':
        return FontAwesomeIcons.triangleExclamation;
      case 'error':
        return FontAwesomeIcons.circleXmark;
      case 'info':
        return FontAwesomeIcons.circleInfo;
      case 'success':
        return FontAwesomeIcons.circleCheck;
      case 'pending':
        return FontAwesomeIcons.hourglassHalf;
      case 'completed':
        return FontAwesomeIcons.circleCheck;
      case 'cancelled':
        return FontAwesomeIcons.ban;
      case 'active':
        return FontAwesomeIcons.circleCheck;
      case 'inactive':
        return FontAwesomeIcons.circlePause;
      default:
        return FontAwesomeIcons.cube;
    }
  }

  /// Get translated title based on menu item ID
  String _getTranslatedTitle(BuildContext context) {
    final translations = context.t;

    switch (menuItem.id) {
      case '1':
        return translations.home.menu_dashboard;
      case '2':
        return translations.home.menu_brand;
      case '3':
        return translations.home.menu_orders;
      case '4':
        return translations.home.menu_products;
      case '5':
        return translations.home.menu_customers;
      case '6':
        return translations.home.menu_reports;
      case '7':
        return translations.home.menu_finance;
      case '8':
        return translations.home.menu_settings;
      case '9':
        return translations.home.menu_notifications;
      default:
        // Fallback to original title if no translation found
        return menuItem.title;
    }
  }

  /// Get translated description based on menu item ID
  String _getTranslatedDescription(BuildContext context) {
    final translations = context.t;

    switch (menuItem.id) {
      case '1':
        return translations.home.menu_dashboard_description;
      case '2':
        return translations.home.menu_brand_description;
      case '3':
        return translations.home.menu_orders_description;
      case '4':
        return translations.home.menu_products_description;
      case '5':
        return translations.home.menu_customers_description;
      case '6':
        return translations.home.menu_reports_description;
      case '7':
        return translations.home.menu_finance_description;
      case '8':
        return translations.home.menu_settings_description;
      case '9':
        return translations.home.menu_notifications_description;
      default:
        // Fallback to original description if no translation found
        return menuItem.description;
    }
  }
}