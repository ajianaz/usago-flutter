import 'package:flutter/widgets.dart';
import '../../domain/entities/brand.dart';
import 'brand_formatter.dart';

/// Extension methods untuk Brand entity
/// Menyediakan UI helper methods yang menggunakan BrandFormatter
extension BrandExtension on Brand {
  /// Pure business logic (tetap di domain)
  bool get isSubscriptionActive => subscriptionStatus.toUpperCase() == 'ACTIVE';

  bool get isSubscriptionExpired => subscriptionExpiresAt != null &&
      DateTime.now().isAfter(subscriptionExpiresAt!);

  /// UI helpers (pindah ke presentation)
  String displayBusinessType(BuildContext context) {
    return BrandFormatter.formatBusinessType(businessType, context);
  }

  String displaySubscriptionTier(BuildContext context) {
    return BrandFormatter.formatSubscriptionTier(subscriptionTier, context);
  }

  String displaySubscriptionStatus(BuildContext context) {
    return BrandFormatter.formatSubscriptionStatus(subscriptionStatus, context);
  }

  String displaySubscriptionDate(BuildContext context) {
    return BrandFormatter.formatSubscriptionDate(subscriptionExpiresAt, context);
  }

  String displayJoinDate(BuildContext context) {
    return BrandFormatter.formatJoinDate(createdAt, context);
  }

  bool get isNewBrand => BrandFormatter.isNewBrand(createdAt);

  String displayBrandAge(BuildContext context) {
    return BrandFormatter.formatBrandAge(createdAt, context);
  }
}