import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand list events
/// Extends Equatable untuk value comparison
abstract class BrandListEvent extends Equatable {
  const BrandListEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load user brands
class LoadUserBrandsEvent extends BrandListEvent {
  const LoadUserBrandsEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load accessible brands
class LoadAccessibleBrandsEvent extends BrandListEvent {
  const LoadAccessibleBrandsEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get active brand
class GetActiveBrandEvent extends BrandListEvent {
  const GetActiveBrandEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load semua brand data (user brands, accessible brands, active brand)
class LoadAllBrandDataEvent extends BrandListEvent {
  const LoadAllBrandDataEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk refresh brand list
class RefreshBrandListEvent extends BrandListEvent {
  const RefreshBrandListEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk reset state ke initial
class ResetBrandListEvent extends BrandListEvent {
  const ResetBrandListEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk filter brands
class FilterBrandsEvent extends BrandListEvent {
  final String? query;
  final String? businessType;
  final String? industry;

  const FilterBrandsEvent({
    this.query,
    this.businessType,
    this.industry,
  });

  @override
  List<Object> get props => [
        query ?? '',
        businessType ?? '',
        industry ?? '',
      ];
}

/// Event untuk clear filter
class ClearBrandFilterEvent extends BrandListEvent {
  const ClearBrandFilterEvent();

  @override
  List<Object> get props => [];
}