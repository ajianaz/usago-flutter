import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../../../../i18n/translations.g.dart';

/// Brand Invitation entity representing an invitation to join a brand
class BrandInvitation extends Equatable {
  final String id;
  final String brandId;
  final String brandName;
  final String inviterId;
  final String inviterName;
  final String inviteeEmail;
  final String role;
  final String status;
  final List<String> branchIds;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BrandInvitation({
    required this.id,
    required this.brandId,
    required this.brandName,
    required this.inviterId,
    required this.inviterName,
    required this.inviteeEmail,
    required this.role,
    required this.status,
    this.branchIds = const [],
    this.expiresAt,
    required this.createdAt,
    this.updatedAt,
  });

  /// Returns a copy of this BrandInvitation with modified fields
  BrandInvitation copyWith({
    String? id,
    String? brandId,
    String? brandName,
    String? inviterId,
    String? inviterName,
    String? inviteeEmail,
    String? role,
    String? status,
    List<String>? branchIds,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BrandInvitation(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      inviterId: inviterId ?? this.inviterId,
      inviterName: inviterName ?? this.inviterName,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      role: role ?? this.role,
      status: status ?? this.status,
      branchIds: branchIds ?? this.branchIds,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if invitation is pending
  bool get isPending => status.toUpperCase() == 'PENDING';

  /// Check if invitation is accepted
  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';

  /// Check if invitation is declined
  bool get isDeclined => status.toUpperCase() == 'DECLINED';

  /// Check if invitation is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get formatted role
  String formattedRole(BuildContext context) {
    final t = Translations.of(context);
    switch (role.toUpperCase()) {
      case 'BRAND_OWNER':
        return t.brand.brand_owner;
      case 'BRANCH_MANAGER':
        return t.brand.branch_manager;
      case 'BRANCH_ADMIN':
        return t.brand.branch_admin;
      case 'BRANCH_STAFF':
        return t.brand.branch_staff;
      case 'CROSS_BRANCH_VIEWER':
        return t.brand.cross_branch_viewer;
      default:
        return role;
    }
  }

  /// Get formatted status
  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Menunggu';
      case 'ACCEPTED':
        return 'Diterima';
      case 'DECLINED':
        return 'Ditolak';
      case 'EXPIRED':
        return 'Kadaluarsa';
      default:
        return status;
    }
  }

  /// Get formatted created date
  String get createdDateFormatted {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = months[createdAt.month - 1];
    final year = createdAt.year;

    return '$day $month $year';
  }

  /// Get formatted expiration date
  String? get expirationDateFormatted {
    if (expiresAt == null) return null;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = expiresAt!.day.toString().padLeft(2, '0');
    final month = months[expiresAt!.month - 1];
    final year = expiresAt!.year;

    return '$day $month $year';
  }

  @override
  List<Object?> get props => [
        id,
        brandId,
        brandName,
        inviterId,
        inviterName,
        inviteeEmail,
        role,
        status,
        branchIds,
        expiresAt,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'BrandInvitation(id: $id, brandId: $brandId, inviteeEmail: $inviteeEmail, status: $status)';
  }
}