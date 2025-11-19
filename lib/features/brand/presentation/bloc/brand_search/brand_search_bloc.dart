import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/usecases/brand/search_brands_usecase.dart';
import '../../../domain/usecases/common/params/brand_params.dart';
import 'brand_search_event.dart';
import 'brand_search_state.dart';

/// Brand Search BLoC
/// Bertanggung jawab untuk fungsi pencarian brand, filter, dan pagination
/// Menggunakan use cases untuk business logic
class BrandSearchBloc extends Bloc<BrandSearchEvent, BrandSearchState> {
  final SearchBrandsUseCase _searchBrandsUseCase;

  // Cache untuk menyimpan search state
  String _currentQuery = '';
  String? _currentBusinessType;
  String? _currentIndustry;
  List<Brand> _cachedResults = [];
  List<String> _recentSearches = [];
  bool _hasReachedMax = false;

  BrandSearchBloc({
    required SearchBrandsUseCase searchBrandsUseCase,
  }) : _searchBrandsUseCase = searchBrandsUseCase,
       super(const BrandSearchInitial()) {
    // Register event handlers
    on<SearchBrandsEvent>(_onSearchBrands);
    on<ClearSearchEvent>(_onClearSearch);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ResetSearchEvent>(_onResetSearch);
    on<UpdateSearchFiltersEvent>(_onUpdateSearchFilters);
    on<ClearSearchFiltersEvent>(_onClearSearchFilters);
    on<GetSearchSuggestionsEvent>(_onGetSearchSuggestions);
    on<SaveRecentSearchEvent>(_onSaveRecentSearch);
    on<GetRecentSearchesEvent>(_onGetRecentSearchesEvent);
    on<ClearRecentSearchesEvent>(_onClearRecentSearches);
  }

  /// Handler untuk search brands
  Future<void> _onSearchBrands(
    SearchBrandsEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    // Validasi query
    if (event.query.trim().isEmpty) {
      emit(const BrandSearchError(
        message: 'Query pencarian tidak boleh kosong',
      ));
      return;
    }

    if (event.query.trim().length < 2) {
      emit(const BrandSearchError(
        message: 'Query pencarian minimal 2 karakter',
      ));
      return;
    }

    emit(const BrandSearchLoading());

    // Update cache
    _currentQuery = event.query;
    _currentBusinessType = event.businessType;
    _currentIndustry = event.industry;

    // Buat parameter untuk use case
    final params = SearchBrandsParams(
      query: event.query,
      businessType: event.businessType,
      industry: event.industry,
      limit: event.limit ?? 20,
      offset: event.offset ?? 0,
    );

    // Panggil use case
    final result = await _searchBrandsUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandSearchError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        query: event.query,
      )),
      (brands) {
        _cachedResults = brands;
        _hasReachedMax = brands.length < (event.limit ?? 20);

        if (brands.isEmpty) {
          emit(BrandSearchEmpty(
            query: event.query,
            businessType: event.businessType,
            industry: event.industry,
          ));
        } else {
          emit(BrandSearchLoaded(
            searchResults: brands,
            query: event.query,
            businessType: event.businessType,
            industry: event.industry,
            limit: event.limit ?? 20,
            offset: event.offset ?? 0,
            hasReachedMax: _hasReachedMax,
          ));
        }
      },
    );
  }

  /// Handler untuk clear search
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    _currentQuery = '';
    _currentBusinessType = null;
    _currentIndustry = null;
    _cachedResults = [];
    _hasReachedMax = false;
    emit(const BrandSearchInitial());
  }

  /// Handler untuk load more results
  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    if (_hasReachedMax) {
      return; // Tidak perlu load more jika sudah mencapai maksimum
    }

    emit(BrandSearchLoadingMore(
      currentResults: _cachedResults,
      query: _currentQuery,
      businessType: _currentBusinessType,
      industry: _currentIndustry,
    ));

    // Buat parameter untuk use case
    final params = SearchBrandsParams(
      query: event.query,
      businessType: event.businessType,
      industry: event.industry,
      limit: 20,
      offset: event.offset,
    );

    // Panggil use case
    final result = await _searchBrandsUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandSearchError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        query: event.query,
      )),
      (brands) {
        final updatedResults = [..._cachedResults, ...brands];
        _cachedResults = updatedResults;
        _hasReachedMax = brands.length < 20;

        emit(BrandSearchLoaded.copyWithMore(
          searchResults: updatedResults,
          query: event.query,
          businessType: event.businessType,
          industry: event.industry,
          limit: 20,
          offset: event.offset,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }

  /// Handler untuk reset search
  Future<void> _onResetSearch(
    ResetSearchEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    _currentQuery = '';
    _currentBusinessType = null;
    _currentIndustry = null;
    _cachedResults = [];
    _hasReachedMax = false;
    emit(const BrandSearchInitial());
  }

  /// Handler untuk update search filters
  Future<void> _onUpdateSearchFilters(
    UpdateSearchFiltersEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    _currentBusinessType = event.businessType;
    _currentIndustry = event.industry;

    // Jika ada query yang aktif, search ulang dengan filter baru
    if (_currentQuery.isNotEmpty) {
      add(SearchBrandsEvent(
        query: _currentQuery,
        businessType: event.businessType,
        industry: event.industry,
      ));
    } else {
      // Emit filter state
      emit(BrandSearchFiltersLoaded(
        businessTypes: _getAvailableBusinessTypes(),
        industries: _getAvailableIndustries(),
        selectedBusinessType: event.businessType,
        selectedIndustry: event.industry,
      ));
    }
  }

  /// Handler untuk clear search filters
  Future<void> _onClearSearchFilters(
    ClearSearchFiltersEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    _currentBusinessType = null;
    _currentIndustry = null;

    // Jika ada query yang aktif, search ulang tanpa filter
    if (_currentQuery.isNotEmpty) {
      add(SearchBrandsEvent(query: _currentQuery));
    } else {
      // Emit filter state
      emit(BrandSearchFiltersLoaded(
        businessTypes: _getAvailableBusinessTypes(),
        industries: _getAvailableIndustries(),
      ));
    }
  }

  /// Handler untuk get search suggestions
  Future<void> _onGetSearchSuggestions(
    GetSearchSuggestionsEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    // Generate suggestions berdasarkan recent searches
    final suggestions = _recentSearches
        .where((search) => search.toLowerCase().contains(event.query.toLowerCase()))
        .take(5)
        .toList();

    emit(BrandSearchSuggestionsLoaded(
      suggestions: suggestions,
      query: event.query,
    ));
  }

  /// Handler untuk save recent search
  Future<void> _onSaveRecentSearch(
    SaveRecentSearchEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    // Remove jika sudah ada
    _recentSearches.remove(event.query);

    // Add ke awal list
    _recentSearches.insert(0, event.query);

    // Keep only 10 recent searches
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    // Emit recent searches state
    emit(BrandRecentSearchesLoaded(recentSearches: _recentSearches));
  }

  /// Handler untuk get recent searches
  Future<void> _onGetRecentSearchesEvent(
    GetRecentSearchesEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    emit(BrandRecentSearchesLoaded(recentSearches: _recentSearches));
  }

  /// Handler untuk clear recent searches
  Future<void> _onClearRecentSearches(
    ClearRecentSearchesEvent event,
    Emitter<BrandSearchState> emit,
  ) async {
    _recentSearches = [];
    emit(const BrandRecentSearchesLoaded(recentSearches: []));
  }

  /// Get available business types (mock data)
  List<String> _getAvailableBusinessTypes() {
    return [
      'Retail',
      'Restaurant',
      'Service',
      'Manufacturing',
      'Technology',
      'Healthcare',
      'Education',
      'Entertainment',
    ];
  }

  /// Get available industries (mock data)
  List<String> _getAvailableIndustries() {
    return [
      'Fashion',
      'Food & Beverage',
      'Electronics',
      'Health & Beauty',
      'Home & Garden',
      'Sports & Outdoors',
      'Automotive',
      'Books & Media',
    ];
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
        return 'Anda tidak memiliki izin untuk melakukan pencarian';
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