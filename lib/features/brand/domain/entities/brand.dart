import 'package:equatable/equatable.dart';

/// Brand entity representing a business brand
/// This is a pure domain entity without any implementation details
class Brand extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String ownerId;
  final String? logoUrl;
  final String businessType;
  final String? industry;
  final String? description;
  final Map<String, dynamic> settings;
  final String timezone;
  final String currency;
  final String subscriptionTier;
  final String subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.ownerId,
    this.logoUrl,
    required this.businessType,
    this.industry,
    this.description,
    required this.settings,
    required this.timezone,
    required this.currency,
    required this.subscriptionTier,
    required this.subscriptionStatus,
    this.subscriptionExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns a copy of this Brand with modified fields
  Brand copyWith({
    String? id,
    String? name,
    String? slug,
    String? ownerId,
    String? logoUrl,
    String? businessType,
    String? industry,
    String? description,
    Map<String, dynamic>? settings,
    String? timezone,
    String? currency,
    String? subscriptionTier,
    String? subscriptionStatus,
    DateTime? subscriptionExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      ownerId: ownerId ?? this.ownerId,
      logoUrl: logoUrl ?? this.logoUrl,
      businessType: businessType ?? this.businessType,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get brand's display name
  String get displayName => name.trim().isNotEmpty ? name : slug;

  /// Check if brand has logo
  bool get hasLogo => logoUrl != null && logoUrl!.trim().isNotEmpty;

  /// Check if subscription is active
  bool get isSubscriptionActive => subscriptionStatus.toUpperCase() == 'ACTIVE';

  /// Check if subscription is expired
  bool get isSubscriptionExpired {
    if (subscriptionExpiresAt == null) return false;
    return DateTime.now().isAfter(subscriptionExpiresAt!);
  }

  /// Pure business logic: Check if brand is newly created (less than 7 days)
  /// Note: This can be used in business rules, not for UI display
  bool get isNewlyCreated {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        ownerId,
        logoUrl,
        businessType,
        industry,
        description,
        settings,
        timezone,
        currency,
        subscriptionTier,
        subscriptionStatus,
        subscriptionExpiresAt,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Brand(id: $id, name: $name, slug: $slug, businessType: $businessType, subscriptionTier: $subscriptionTier, subscriptionStatus: $subscriptionStatus, subscriptionExpiresAt: $subscriptionExpiresAt)';
  }
}