// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      ownerId: json['ownerId'] as String,
      logoUrl: json['logoUrl'] as String?,
      businessType: json['businessType'] as String,
      industry: json['industry'] as String?,
      description: json['description'] as String?,
      settings: json['settings'] as Map<String, dynamic>,
      timezone: json['timezone'] as String,
      currency: json['currency'] as String,
      subscriptionTier: json['subscriptionTier'] as String,
      subscriptionStatus: json['subscriptionStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'ownerId': instance.ownerId,
      'logoUrl': instance.logoUrl,
      'businessType': instance.businessType,
      'industry': instance.industry,
      'description': instance.description,
      'settings': instance.settings,
      'timezone': instance.timezone,
      'currency': instance.currency,
      'subscriptionTier': instance.subscriptionTier,
      'subscriptionStatus': instance.subscriptionStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
