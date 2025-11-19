import 'package:flutter/widgets.dart';
import '../../../../i18n/translations.g.dart';

/// Formatter helper untuk BrandInvitation entity
/// Memindahkan UI logic dari domain entity ke presentation layer
class InvitationFormatter {
  // Private constructor untuk mencegah instantiasi
  InvitationFormatter._();

  /// Format role dengan localization
  static String formatRole(String role, BuildContext context) {
    final t = Translations.of(context);
    switch (role.toUpperCase()) {
      case 'BRAND_OWNER':
        return t.brand.brand_owner ?? 'Pemilik Brand';
      case 'BRAND_ADMIN':
        return t.brand.brand_admin ?? 'Admin Brand';
      case 'BRANCH_MANAGER':
        return t.brand.branch_manager ?? 'Manajer Cabang';
      case 'BRANCH_ADMIN':
        return t.brand.branch_admin ?? 'Admin Cabang';
      case 'BRANCH_STAFF':
        return t.brand.branch_staff ?? 'Staf Cabang';
      case 'CROSS_BRANCH_VIEWER':
        return t.brand.cross_branch_viewer ?? 'Penonton Lintas Cabang';
      default:
        return role;
    }
  }

  /// Format status dengan localization
  static String formatStatus(String status, BuildContext context) {
    final t = Translations.of(context);
    switch (status.toUpperCase()) {
      case 'PENDING':
        return t.brand.pending ?? 'Menunggu';
      case 'ACCEPTED':
        return t.brand.accepted ?? 'Diterima';
      case 'DECLINED':
      case 'REJECTED':
        return t.brand.declined ?? 'Ditolak';
      case 'EXPIRED':
        return t.brand.expired ?? 'Kadaluarsa';
      default:
        return status;
    }
  }

  /// Format created date dengan localization
  static String formatCreatedDate(DateTime date, BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  /// Format expiration date dengan localization
  static String? formatExpirationDate(DateTime? date, BuildContext context) {
    if (date == null) return null;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  /// Format expiry status dengan localization
  static String formatExpiryStatus(DateTime? expiresAt, BuildContext context) {
    if (expiresAt == null) {
      return 'Tidak ada kedaluwarsa';
    }

    if (DateTime.now().isAfter(expiresAt)) {
      return 'Kadaluarsa';
    }

    final daysRemaining = expiresAt.difference(DateTime.now()).inDays;
    if (daysRemaining <= 1) {
      return 'Kadaluarsa besok';
    } else if (daysRemaining <= 7) {
      return '$daysRemaining hari lagi';
    } else {
      return formatExpirationDate(expiresAt, context) ?? '';
    }
  }

  /// Check if invitation is expiring soon (within 3 days)
  static bool isExpiringSoon(DateTime? expiresAt) {
    if (expiresAt == null) return false;

    final now = DateTime.now();
    final daysRemaining = expiresAt.difference(now).inDays;
    return daysRemaining > 0 && daysRemaining <= 3;
  }

  /// Get invitation priority based on expiry
  static String getInvitationPriority(DateTime? expiresAt, BuildContext context) {
    if (expiresAt == null) return 'normal';

    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return 'expired';

    final daysRemaining = expiresAt.difference(now).inDays;
    if (daysRemaining <= 1) return 'urgent';
    if (daysRemaining <= 3) return 'high';
    if (daysRemaining <= 7) return 'medium';

    return 'normal';
  }
}