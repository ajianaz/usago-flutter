import 'package:equatable/equatable.dart';

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

  /// Pure business logic: Check if invitation is valid for business operations
  bool get isValidForBusiness => !isExpired && isPending;

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