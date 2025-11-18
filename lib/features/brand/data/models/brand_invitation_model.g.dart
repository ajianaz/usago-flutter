// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandInvitationModel _$BrandInvitationModelFromJson(
        Map<String, dynamic> json) =>
    BrandInvitationModel(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      brandName: json['brandName'] as String,
      inviterId: json['inviterId'] as String,
      inviterName: json['inviterName'] as String,
      inviteeEmail: json['inviteeEmail'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BrandInvitationModelToJson(
        BrandInvitationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'inviterId': instance.inviterId,
      'inviterName': instance.inviterName,
      'inviteeEmail': instance.inviteeEmail,
      'role': instance.role,
      'status': instance.status,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
