import 'package:equatable/equatable.dart';

/// Parameter class untuk operasi yang memerlukan brand ID
class BrandIdParams extends Equatable {
  final String brandId;

  const BrandIdParams({required this.brandId});

  @override
  List<Object?> get props => [brandId];
}

/// Parameter class untuk membuat brand baru
class CreateBrandParams extends Equatable {
  final String name;
  final String slug;
  final String businessType;
  final String? industry;
  final String? description;
  final String timezone;
  final String currency;

  const CreateBrandParams({
    required this.name,
    required this.slug,
    required this.businessType,
    this.industry,
    this.description,
    required this.timezone,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        name,
        slug,
        businessType,
        industry,
        description,
        timezone,
        currency,
      ];
}

/// Parameter class untuk update brand
class UpdateBrandParams extends Equatable {
  final String brandId;
  final String? name;
  final String? businessType;
  final String? industry;
  final String? description;
  final String? timezone;
  final String? currency;
  final Map<String, dynamic>? settings;

  const UpdateBrandParams({
    required this.brandId,
    this.name,
    this.businessType,
    this.industry,
    this.description,
    this.timezone,
    this.currency,
    this.settings,
  });

  @override
  List<Object?> get props => [
        brandId,
        name,
        businessType,
        industry,
        description,
        timezone,
        currency,
        settings,
      ];
}

/// Parameter class untuk pencarian brand
class SearchBrandsParams extends Equatable {
  final String? query;
  final String? businessType;
  final String? industry;
  final int? limit;
  final int? offset;

  const SearchBrandsParams({
    this.query,
    this.businessType,
    this.industry,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [
        query,
        businessType,
        industry,
        limit,
        offset,
      ];
}

/// Parameter class untuk switch active brand
class SwitchActiveBrandParams extends Equatable {
  final String brandId;

  const SwitchActiveBrandParams({required this.brandId});

  @override
  List<Object?> get props => [brandId];
}