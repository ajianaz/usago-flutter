import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../domain/entities/menu_item.dart';
import 'menu_card.dart';

class FeatureGrid extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Function(MenuItem) onMenuTap;
  final int crossAxisCount;
  final double childAspectRatio;
  final String? category;

  const FeatureGrid({
    Key? key,
    required this.menuItems,
    required this.onMenuTap,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (menuItems.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category != null) ...[
          Padding(
            padding: AppSpacing.paddingHorizontalMd,
            child: Text(
              _getCategoryDisplayName(category!),
              style: AppTextStyles.headline6,
            ),
          ),
          AppSpacing.verticalGapMd,
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final menuItem = menuItems[index];
            return MenuCard(
              menuItem: menuItem,
              onTap: () => onMenuTap(menuItem),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: AppSpacing.paddingAllLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.layerGroup,
            size: 64,
            color: Colors.grey[400],
          ),
          AppSpacing.verticalGapMd,
          Text(
            category != null
                ? 'Tidak ada menu dalam kategori ${_getCategoryDisplayName(category!)}'
                : 'Tidak ada menu tersedia',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGapSm,
          Text(
            'Hubungi administrator untuk mengakses fitur ini',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'management':
        return 'Manajemen';
      case 'operations':
        return 'Operasional';
      case 'reports':
        return 'Laporan';
      case 'settings':
        return 'Pengaturan';
      case 'all':
        return 'Semua Menu';
      default:
        return category;
    }
  }
}