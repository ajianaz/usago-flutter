import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/brand_invitation.dart';

part 'brand_invitation_model.g.dart';

/// Brand Invitation model for API serialization/deserialization
/// Extends the BrandInvitation entity with JSON capabilities
@JsonSerializable(
  includeIfNull: false,
)
class BrandInvitationModel extends BrandInvitation {
  const BrandInvitationModel({
    required super.id,
    required super.brandId,
    required super.brandName,
    required super.inviterId,
    required super.inviterName,
    required super.inviteeEmail,
    required super.role,
    required super.status,
    @JsonKey(defaultValue: []) super.branchIds,
    super.expiresAt,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create BrandInvitationModel from JSON
  factory BrandInvitationModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' and 'invitationId' for backward compatibility
    final id = json['id'] ?? json['invitationId'] ?? '';

    // Handle missing fields with defaults
    final inviterId = json['inviterId'] ?? '';
    final inviteeEmail = json['inviteeEmail'] ?? json['email'] ?? '';
    final status = json['status'] ?? 'PENDING';
    final updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;

    // Handle branchIds as List<String> with default empty list
    List<String> branchIds = [];
    if (json['branchIds'] != null) {
      if (json['branchIds'] is List) {
        branchIds = List<String>.from(json['branchIds']);
      }
    }

    return BrandInvitationModel(
      id: id,
      brandId: json['brandId'] ?? '',
      brandName: json['brandName'] ?? '',
      inviterId: inviterId,
      inviterName: json['inviterName'] ?? '',
      inviteeEmail: inviteeEmail,
      role: json['role'] ?? '',
      status: status,
      branchIds: branchIds,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: updatedAt,
    );
  }

  /// Convert BrandInvitationModel to JSON
  Map<String, dynamic> toJson() => _$BrandInvitationModelToJson(this);

  /// Convert BrandInvitationModel to BrandInvitation entity
  BrandInvitation toEntity() => BrandInvitation(
        id: id,
        brandId: brandId,
        brandName: brandName,
        inviterId: inviterId,
        inviterName: inviterName,
        inviteeEmail: inviteeEmail,
        role: role,
        status: status,
        branchIds: branchIds,
        expiresAt: expiresAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create BrandInvitationModel from BrandInvitation entity
  factory BrandInvitationModel.fromEntity(BrandInvitation invitation) =>
      BrandInvitationModel(
        id: invitation.id,
        brandId: invitation.brandId,
        brandName: invitation.brandName,
        inviterId: invitation.inviterId,
        inviterName: invitation.inviterName,
        inviteeEmail: invitation.inviteeEmail,
        role: invitation.role,
        status: invitation.status,
        branchIds: invitation.branchIds,
        expiresAt: invitation.expiresAt,
        createdAt: invitation.createdAt,
        updatedAt: invitation.updatedAt,
      );

  /// Create empty BrandInvitationModel
  factory BrandInvitationModel.empty() => BrandInvitationModel(
        id: '',
        brandId: '',
        brandName: '',
        inviterId: '',
        inviterName: '',
        inviteeEmail: '',
        role: '',
        status: '',
        branchIds: const [],
        createdAt: DateTime.now(),
      );

  @override
  String toString() {
    return 'BrandInvitationModel(id: $id, brandId: $brandId, inviteeEmail: $inviteeEmail, status: $status)';
  }
}