import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/brand.dart';

part 'brand_model.g.dart';

/// Brand model for API serialization/deserialization
/// Extends the Brand entity with JSON capabilities
@JsonSerializable()
class BrandModel extends Brand {
  const BrandModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.ownerId,
    super.logoUrl,
    required super.businessType,
    super.industry,
    super.description,
    required super.settings,
    required super.timezone,
    required super.currency,
    required super.subscriptionTier,
    required super.subscriptionStatus,
    super.subscriptionExpiresAt,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create BrandModel from JSON
  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  /// Convert BrandModel to JSON
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  /// Convert BrandModel to Brand entity
  Brand toEntity() => Brand(
        id: id,
        name: name,
        slug: slug,
        ownerId: ownerId,
        logoUrl: logoUrl,
        businessType: businessType,
        industry: industry,
        description: description,
        settings: settings,
        timezone: timezone,
        currency: currency,
        subscriptionTier: subscriptionTier,
        subscriptionStatus: subscriptionStatus,
        subscriptionExpiresAt: subscriptionExpiresAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create BrandModel from Brand entity
  factory BrandModel.fromEntity(Brand brand) => BrandModel(
        id: brand.id,
        name: brand.name,
        slug: brand.slug,
        ownerId: brand.ownerId,
        logoUrl: brand.logoUrl,
        businessType: brand.businessType,
        industry: brand.industry,
        description: brand.description,
        settings: brand.settings,
        timezone: brand.timezone,
        currency: brand.currency,
        subscriptionTier: brand.subscriptionTier,
        subscriptionStatus: brand.subscriptionStatus,
        subscriptionExpiresAt: brand.subscriptionExpiresAt,
        createdAt: brand.createdAt,
        updatedAt: brand.updatedAt,
      );

  /// Create empty BrandModel
  factory BrandModel.empty() => BrandModel(
        id: '',
        name: '',
        slug: '',
        ownerId: '',
        businessType: '',
        settings: {},
        timezone: '',
        currency: '',
        subscriptionTier: '',
        subscriptionStatus: '',
        subscriptionExpiresAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  @override
  String toString() {
    return 'BrandModel(id: $id, name: $name, slug: $slug, businessType: $businessType)';
  }
}