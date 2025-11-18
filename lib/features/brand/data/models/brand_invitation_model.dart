import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/brand_invitation.dart';

part 'brand_invitation_model.g.dart';

/// Brand Invitation model for API serialization/deserialization
/// Extends the BrandInvitation entity with JSON capabilities
@JsonSerializable()
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
    super.expiresAt,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create BrandInvitationModel from JSON
  factory BrandInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$BrandInvitationModelFromJson(json);

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
        createdAt: DateTime.now(),
      );

  @override
  String toString() {
    return 'BrandInvitationModel(id: $id, brandId: $brandId, inviteeEmail: $inviteeEmail, status: $status)';
  }
}