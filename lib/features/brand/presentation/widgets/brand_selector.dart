import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';

/// Brand Selector Widget for switching between brands
class BrandSelector extends StatelessWidget {
  final Brand? currentBrand;
  final List<Brand> availableBrands;
  final Function(Brand)? onBrandSelected;
  final bool showActiveIndicator;
  final bool isCompact;
  final DeviceType deviceType;

  const BrandSelector({
    Key? key,
    this.currentBrand,
    required this.availableBrands,
    this.onBrandSelected,
    this.showActiveIndicator = true,
    this.isCompact = false,
    required this.deviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (availableBrands.isEmpty) {
      return _buildEmptyState(context);
    }

    return isCompact
        ? _buildCompactSelector(context)
        : _buildFullSelector(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Tidak ada brand tersedia',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSelector(BuildContext context) {
    return PopupMenuButton<Brand>(
      icon: _buildCurrentBrandIndicator(),
      onSelected: (brand) {
        onBrandSelected?.call(brand);
      },
      itemBuilder: (BuildContext context) {
        return availableBrands.map((brand) {
          return PopupMenuItem<Brand>(
            value: brand,
            child: Row(
              children: [
                _buildBrandLogo(brand, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        brand.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (brand.isSubscriptionActive) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Aktif',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showActiveIndicator && currentBrand?.id == brand.id) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 16,
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildFullSelector(BuildContext context) {
    final isMobile = deviceType == DeviceType.mobile;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Pilih Brand',
                      style: AppTextStyles.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (currentBrand != null) ...[
                      Text(
                        'Saat ini:',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currentBrand!.name,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (isMobile) const SizedBox(height: 8),
              ],
            ),
          ),

          // Brand List
          Container(
            constraints: BoxConstraints(
              maxHeight: isMobile ? 200 : 300,
              minHeight: isMobile ? 120 : 200,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: AppColors.border,
              ),
              itemCount: availableBrands.length,
              itemBuilder: (context, index) {
                final brand = availableBrands[index];
                final isSelected = currentBrand?.id == brand.id;

                return InkWell(
                  onTap: () => onBrandSelected?.call(brand),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildBrandLogo(brand, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                brand.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                brand.formattedBusinessType,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (brand.isSubscriptionActive) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Aktif',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (showActiveIndicator && isSelected) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBrandIndicator() {
    if (currentBrand == null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.business_outlined,
          color: AppColors.textSecondary,
          size: 18,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: currentBrand!.hasLogo
            ? Image.network(
                currentBrand!.logoUrl!,
                fit: BoxFit.cover,
                width: 28,
                height: 28,
                errorBuilder: (context, error, stackTrace) => _buildBrandLogoPlaceholder(),
              )
            : _buildBrandLogoPlaceholder(),
      ),
    );
  }

  Widget _buildBrandLogo(Brand brand, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
      ),
      child: brand.hasLogo
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                brand.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildBrandLogoPlaceholder(size: size),
              ),
            )
          : _buildBrandLogoPlaceholder(size: size),
    );
  }

  Widget _buildBrandLogoPlaceholder({double size = 32}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'B',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Popup menu button for brand selection
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