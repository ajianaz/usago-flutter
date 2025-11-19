import 'package:equatable/equatable.dart';
import '../../../domain/entities/brand.dart';

/// Abstract base class untuk semua brand list states
/// Extends Equatable untuk value comparison
abstract class BrandListState extends Equatable {
  const BrandListState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika brand list bloc pertama kali dibuat
class BrandListInitial extends BrandListState {
  const BrandListInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi brand list sedang berlangsung
class BrandListLoading extends BrandListState {
  const BrandListLoading();

  @override
  List<Object> get props => [];
}

/// State ketika brand list berhasil dimuat
class BrandListLoaded extends BrandListState {
  final List<Brand> userBrands;
  final List<Brand> accessibleBrands;
  final Brand? activeBrand;
  final List<Brand> filteredUserBrands;
  final List<Brand> filteredAccessibleBrands;
  final String? activeFilter;
  final String? activeBusinessTypeFilter;
  final String? activeIndustryFilter;

  const BrandListLoaded({
    required this.userBrands,
    required this.accessibleBrands,
    this.activeBrand,
    this.filteredUserBrands = const [],
    this.filteredAccessibleBrands = const [],
    this.activeFilter,
    this.activeBusinessTypeFilter,
    this.activeIndustryFilter,
  });

  /// Constructor untuk filtered state
  BrandListLoaded.copyWithFilters({
    required this.userBrands,
    required this.accessibleBrands,
    this.activeBrand,
    required this.filteredUserBrands,
    required this.filteredAccessibleBrands,
    this.activeFilter,
    this.activeBusinessTypeFilter,
    this.activeIndustryFilter,
  });

  /// Get all brands (user + accessible)
  List<Brand> get allBrands => [...userBrands, ...accessibleBrands];

  /// Get all filtered brands
  List<Brand> get allFilteredBrands => [...filteredUserBrands, ...filteredAccessibleBrands];

  /// Check if any filter is active
  bool get hasActiveFilter =>
      activeFilter != null ||
      activeBusinessTypeFilter != null ||
      activeIndustryFilter != null;

  @override
  List<Object> get props => [
        userBrands,
        accessibleBrands,
        activeBrand ?? Object(),
        filteredUserBrands,
        filteredAccessibleBrands,
        activeFilter ?? '',
        activeBusinessTypeFilter ?? '',
        activeIndustryFilter ?? '',
      ];
}

/// State ketika user brands berhasil dimuat
class UserBrandsLoaded extends BrandListState {
  final List<Brand> userBrands;

  const UserBrandsLoaded({required this.userBrands});

  @override
  List<Object> get props => [userBrands];
}

/// State ketika accessible brands berhasil dimuat
class AccessibleBrandsLoaded extends BrandListState {
  final List<Brand> accessibleBrands;

  const AccessibleBrandsLoaded({required this.accessibleBrands});

  @override
  List<Object> get props => [accessibleBrands];
}

/// State ketika active brand berhasil dimuat
class ActiveBrandLoaded extends BrandListState {
  final Brand activeBrand;

  const ActiveBrandLoaded({required this.activeBrand});

  @override
  List<Object> get props => [activeBrand];
}

/// State ketika operasi brand list gagal
class BrandListError extends BrandListState {
  final String message;
  final String? errorCode;

  const BrandListError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode ?? ''];
}

/// State ketika tidak ada brand ditemukan
class BrandListEmpty extends BrandListState {
  final String message;

  const BrandListEmpty({this.message = 'Tidak ada brand ditemukan'});

  @override
  List<Object> get props => [message];
}

/// State ketika tidak ada active brand
class NoActiveBrandState extends BrandListState {
  const NoActiveBrandState();

  @override
  List<Object> get props => [];
}