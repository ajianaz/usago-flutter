import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/usecases/brand/get_user_brands_usecase.dart';
import '../../../domain/usecases/brand/get_accessible_brands_usecase.dart';
import '../../../domain/usecases/brand/get_active_brand_usecase.dart';
import '../../../domain/usecases/common/usecase.dart';
import 'brand_list_event.dart';
import 'brand_list_state.dart';

/// Brand List BLoC
/// Bertanggung jawab untuk mengelola daftar brand (user brands, accessible brands, active brand)
/// Menggunakan use cases untuk business logic
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  final GetUserBrandsUseCase _getUserBrandsUseCase;
  final GetAccessibleBrandsUseCase _getAccessibleBrandsUseCase;
  final GetActiveBrandUseCase _getActiveBrandUseCase;

  // Cache untuk menyimpan data
  List<Brand> _cachedUserBrands = [];
  List<Brand> _cachedAccessibleBrands = [];
  Brand? _cachedActiveBrand;

  BrandListBloc({
    required GetUserBrandsUseCase getUserBrandsUseCase,
    required GetAccessibleBrandsUseCase getAccessibleBrandsUseCase,
    required GetActiveBrandUseCase getActiveBrandUseCase,
  })  : _getUserBrandsUseCase = getUserBrandsUseCase,
        _getAccessibleBrandsUseCase = getAccessibleBrandsUseCase,
        _getActiveBrandUseCase = getActiveBrandUseCase,
        super(const BrandListInitial()) {
    // Register event handlers
    on<LoadUserBrandsEvent>(_onLoadUserBrands);
    on<LoadAccessibleBrandsEvent>(_onLoadAccessibleBrands);
    on<GetActiveBrandEvent>(_onGetActiveBrand);
    on<LoadAllBrandDataEvent>(_onLoadAllBrandData);
    on<RefreshBrandListEvent>(_onRefreshBrandList);
    on<ResetBrandListEvent>(_onResetBrandList);
    on<FilterBrandsEvent>(_onFilterBrands);
    on<ClearBrandFilterEvent>(_onClearBrandFilter);
  }

  /// Handler untuk load user brands
  Future<void> _onLoadUserBrands(
    LoadUserBrandsEvent event,
    Emitter<BrandListState> emit,
  ) async {
    emit(const BrandListLoading());

    final result = await _getUserBrandsUseCase(const NoParams());

    result.fold(
      (failure) => emit(BrandListError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (brands) {
        _cachedUserBrands = brands;
        emit(UserBrandsLoaded(userBrands: brands));
      },
    );
  }

  /// Handler untuk load accessible brands
  Future<void> _onLoadAccessibleBrands(
    LoadAccessibleBrandsEvent event,
    Emitter<BrandListState> emit,
  ) async {
    emit(const BrandListLoading());

    final result = await _getAccessibleBrandsUseCase(const NoParams());

    result.fold(
      (failure) => emit(BrandListError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (brands) {
        _cachedAccessibleBrands = brands;
        emit(AccessibleBrandsLoaded(accessibleBrands: brands));
      },
    );
  }

  /// Handler untuk get active brand
  Future<void> _onGetActiveBrand(
    GetActiveBrandEvent event,
    Emitter<BrandListState> emit,
  ) async {
    emit(const BrandListLoading());

    final result = await _getActiveBrandUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.statusCode == 404) {
          emit(const NoActiveBrandState());
        } else {
          emit(BrandListError(
            message: _mapFailureToMessage(failure),
            errorCode: _mapFailureToErrorCode(failure),
          ));
        }
      },
      (brand) {
        if (brand != null) {
          _cachedActiveBrand = brand;
          emit(ActiveBrandLoaded(activeBrand: brand));
        } else {
          emit(const NoActiveBrandState());
        }
      },
    );
  }

  /// Handler untuk load semua brand data
  Future<void> _onLoadAllBrandData(
    LoadAllBrandDataEvent event,
    Emitter<BrandListState> emit,
  ) async {
    emit(const BrandListLoading());

    // Load semua data secara paralel
    final userBrandsResult = await _getUserBrandsUseCase(const NoParams());
    final accessibleBrandsResult = await _getAccessibleBrandsUseCase(const NoParams());
    final activeBrandResult = await _getActiveBrandUseCase(const NoParams());

    // Extract results
    final userBrands = userBrandsResult.fold(
      (failure) => <Brand>[],
      (brands) => brands,
    );

    final accessibleBrands = accessibleBrandsResult.fold(
      (failure) => <Brand>[],
      (brands) => brands,
    );

    final activeBrand = activeBrandResult.fold(
      (failure) => null as Brand?,
      (brand) => brand,
    );

    // Cache hasil
    _cachedUserBrands = userBrands;
    _cachedAccessibleBrands = accessibleBrands;
    _cachedActiveBrand = activeBrand;

    // Check jika semua gagal
    if (userBrandsResult.isLeft() &&
        accessibleBrandsResult.isLeft() &&
        activeBrandResult.isLeft()) {
      final failure = userBrandsResult.fold((failure) => failure, (_) => null as dynamic);
      emit(BrandListError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      ));
    } else {
      // Check jika tidak ada brand sama sekali
      if (userBrands.isEmpty && accessibleBrands.isEmpty) {
        emit(const BrandListEmpty(message: 'Anda belum memiliki brand. Buat brand pertama Anda sekarang!'));
      } else {
        emit(BrandListLoaded(
          userBrands: userBrands,
          accessibleBrands: accessibleBrands,
          activeBrand: activeBrand,
          filteredUserBrands: userBrands,
          filteredAccessibleBrands: accessibleBrands,
        ));
      }
    }
  }

  /// Handler untuk refresh brand list
  Future<void> _onRefreshBrandList(
    RefreshBrandListEvent event,
    Emitter<BrandListState> emit,
  ) async {
    // Clear cache
    _cachedUserBrands = [];
    _cachedAccessibleBrands = [];
    _cachedActiveBrand = null;

    // Load ulang semua data
    add(const LoadAllBrandDataEvent());
  }

  /// Handler untuk reset state
  Future<void> _onResetBrandList(
    ResetBrandListEvent event,
    Emitter<BrandListState> emit,
  ) async {
    _cachedUserBrands = [];
    _cachedAccessibleBrands = [];
    _cachedActiveBrand = null;
    emit(const BrandListInitial());
  }

  /// Handler untuk filter brands
  Future<void> _onFilterBrands(
    FilterBrandsEvent event,
    Emitter<BrandListState> emit,
  ) async {
    // Gunakan cached data jika ada
    final userBrands = _cachedUserBrands;
    final accessibleBrands = _cachedAccessibleBrands;
    final activeBrand = _cachedActiveBrand;

    // Filter user brands
    final filteredUserBrands = _filterBrands(userBrands, event);

    // Filter accessible brands
    final filteredAccessibleBrands = _filterBrands(accessibleBrands, event);

    emit(BrandListLoaded.copyWithFilters(
      userBrands: userBrands,
      accessibleBrands: accessibleBrands,
      activeBrand: activeBrand,
      filteredUserBrands: filteredUserBrands,
      filteredAccessibleBrands: filteredAccessibleBrands,
      activeFilter: event.query,
      activeBusinessTypeFilter: event.businessType,
      activeIndustryFilter: event.industry,
    ));
  }

  /// Handler untuk clear filter
  Future<void> _onClearBrandFilter(
    ClearBrandFilterEvent event,
    Emitter<BrandListState> emit,
  ) async {
    final userBrands = _cachedUserBrands;
    final accessibleBrands = _cachedAccessibleBrands;
    final activeBrand = _cachedActiveBrand;

    emit(BrandListLoaded(
      userBrands: userBrands,
      accessibleBrands: accessibleBrands,
      activeBrand: activeBrand,
      filteredUserBrands: userBrands,
      filteredAccessibleBrands: accessibleBrands,
    ));
  }

  /// Filter brands berdasarkan kriteria
  List<Brand> _filterBrands(List<Brand> brands, FilterBrandsEvent event) {
    if (event.query == null &&
        event.businessType == null &&
        event.industry == null) {
      return brands;
    }

    return brands.where((brand) {
      // Filter berdasarkan query
      if (event.query != null && event.query!.trim().isNotEmpty) {
        final query = event.query!.toLowerCase().trim();
        final nameMatch = brand.name.toLowerCase().contains(query);
        final slugMatch = brand.slug.toLowerCase().contains(query);
        final descriptionMatch = brand.description?.toLowerCase().contains(query) ?? false;
        final industryMatch = brand.industry?.toLowerCase().contains(query) ?? false;

        if (!nameMatch && !slugMatch && !descriptionMatch && !industryMatch) {
          return false;
        }
      }

      // Filter berdasarkan business type
      if (event.businessType != null && event.businessType!.trim().isNotEmpty) {
        if (brand.businessType.toLowerCase() != event.businessType!.toLowerCase()) {
          return false;
        }
      }

      // Filter berdasarkan industry
      if (event.industry != null && event.industry!.trim().isNotEmpty) {
        if (brand.industry?.toLowerCase() != event.industry!.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Mapping failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return 'Anda tidak memiliki izin untuk mengakses data brand';
      default:
        return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }

  /// Mapping failure ke error code
  String? _mapFailureToErrorCode(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        return serverFailure.statusCode?.toString();
      case NetworkFailure:
        return 'NETWORK_ERROR';
      case ValidationFailure:
        return 'VALIDATION_ERROR';
      case BetterAuthFailure:
        return 'AUTH_ERROR';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}