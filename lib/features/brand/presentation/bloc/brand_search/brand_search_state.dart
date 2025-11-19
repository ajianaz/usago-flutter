import 'package:equatable/equatable.dart';
import '../../../domain/entities/brand.dart';

/// Abstract base class untuk semua brand search states
/// Extends Equatable untuk value comparison
abstract class BrandSearchState extends Equatable {
  const BrandSearchState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika brand search bloc pertama kali dibuat
class BrandSearchInitial extends BrandSearchState {
  const BrandSearchInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi search sedang berlangsung
class BrandSearchLoading extends BrandSearchState {
  const BrandSearchLoading();

  @override
  List<Object> get props => [];
}

/// State ketika search results berhasil dimuat
class BrandSearchLoaded extends BrandSearchState {
  final List<Brand> searchResults;
  final String query;
  final String? businessType;
  final String? industry;
  final int limit;
  final int offset;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const BrandSearchLoaded({
    required this.searchResults,
    required this.query,
    this.businessType,
    this.industry,
    this.limit = 20,
    this.offset = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  /// Constructor untuk load more
  BrandSearchLoaded.copyWithMore({
    required this.searchResults,
    required this.query,
    this.businessType,
    this.industry,
    required this.limit,
    required this.offset,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [
        searchResults,
        query,
        businessType ?? '',
        industry ?? '',
        limit,
        offset,
        hasReachedMax,
        isLoadingMore,
      ];
}

/// State ketika search results kosong
class BrandSearchEmpty extends BrandSearchState {
  final String query;
  final String? businessType;
  final String? industry;

  const BrandSearchEmpty({
    required this.query,
    this.businessType,
    this.industry,
  });

  @override
  List<Object> get props => [
        query,
        businessType ?? '',
        industry ?? '',
      ];
}

/// State ketika operasi search gagal
class BrandSearchError extends BrandSearchState {
  final String message;
  final String? errorCode;
  final String? query;

  const BrandSearchError({
    required this.message,
    this.errorCode,
    this.query,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', query ?? ''];
}

/// State untuk search suggestions
class BrandSearchSuggestionsLoaded extends BrandSearchState {
  final List<String> suggestions;
  final String query;

  const BrandSearchSuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object> get props => [suggestions, query];
}

/// State untuk recent searches
class BrandRecentSearchesLoaded extends BrandSearchState {
  final List<String> recentSearches;

  const BrandRecentSearchesLoaded({required this.recentSearches});

  @override
  List<Object> get props => [recentSearches];
}

/// State untuk search filters
class BrandSearchFiltersLoaded extends BrandSearchState {
  final List<String> businessTypes;
  final List<String> industries;
  final String? selectedBusinessType;
  final String? selectedIndustry;

  const BrandSearchFiltersLoaded({
    required this.businessTypes,
    required this.industries,
    this.selectedBusinessType,
    this.selectedIndustry,
  });

  @override
  List<Object> get props => [
        businessTypes,
        industries,
        selectedBusinessType ?? '',
        selectedIndustry ?? '',
      ];
}

/// State ketika sedang load more results
class BrandSearchLoadingMore extends BrandSearchState {
  final List<Brand> currentResults;
  final String query;
  final String? businessType;
  final String? industry;

  const BrandSearchLoadingMore({
    required this.currentResults,
    required this.query,
    this.businessType,
    this.industry,
  });

  @override
  List<Object> get props => [
        currentResults,
        query,
        businessType ?? '',
        industry ?? '',
      ];
}