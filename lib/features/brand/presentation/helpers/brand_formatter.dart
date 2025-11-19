import 'package:flutter/widgets.dart';
import '../../../../i18n/translations.g.dart';

/// Formatter helper untuk Brand entity
/// Memindahkan UI logic dari domain entity ke presentation layer
class BrandFormatter {
  // Private constructor untuk mencegah instantiasi
  BrandFormatter._();

  /// Format business type dengan localization
  static String formatBusinessType(String businessType, BuildContext context) {
    final t = Translations.of(context);
    switch (businessType.toUpperCase()) {
      case 'SERVICE':
        return t.brand.business_type_service ?? 'Layanan';
      case 'RETAIL':
        return t.brand.business_type_retail ?? 'Ritel';
      case 'MANUFACTURING':
        return t.brand.business_type_manufacturing ?? 'Manufaktur';
      case 'OTHER':
        return t.brand.business_type_other ?? 'Lainnya';
      default:
        return businessType;
    }
  }

  /// Format subscription tier dengan localization
  static String formatSubscriptionTier(String subscriptionTier, BuildContext context) {
    final t = Translations.of(context);
    switch (subscriptionTier.toUpperCase()) {
      case 'BASIC':
        return t.brand.subscription_tier_basic ?? 'Dasar';
      case 'PRO':
        return t.brand.subscription_tier_pro ?? 'Pro';
      case 'ENTERPRISE':
        return t.brand.subscription_tier_enterprise ?? 'Enterprise';
      default:
        return subscriptionTier;
    }
  }

  /// Format subscription status dengan localization
  static String formatSubscriptionStatus(String subscriptionStatus, BuildContext context) {
    final t = Translations.of(context);
    switch (subscriptionStatus.toUpperCase()) {
      case 'ACTIVE':
        return t.brand.subscription_status_active ?? 'Aktif';
      case 'INACTIVE':
        return t.brand.subscription_status_inactive ?? 'Tidak Aktif';
      case 'SUSPENDED':
        return t.brand.subscription_status_suspended ?? 'Ditangguhkan';
      case 'CANCELLED':
        return t.brand.subscription_status_cancelled ?? 'Dibatalkan';
      default:
        return subscriptionStatus;
    }
  }

  /// Format subscription expiration date dengan localization
  static String formatSubscriptionDate(DateTime? date, BuildContext context) {
    if (date == null) return 'Tidak ada kedaluwarsa';

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  /// Format brand join date dengan localization
  static String formatJoinDate(DateTime date, BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  /// Check if brand is newly created (less than 7 days)
  static bool isNewBrand(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }

  /// Format brand age dengan localization
  static String formatBrandAge(DateTime createdAt, BuildContext context) {
    if (isNewBrand(createdAt)) {
      return 'Brand Baru';
    }

    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days hari';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun';
    }
  }
}