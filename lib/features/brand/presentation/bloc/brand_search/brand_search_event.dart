import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand search events
/// Extends Equatable untuk value comparison
abstract class BrandSearchEvent extends Equatable {
  const BrandSearchEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk search brands
class SearchBrandsEvent extends BrandSearchEvent {
  final String query;
  final String? businessType;
  final String? industry;
  final int? limit;
  final int? offset;

  const SearchBrandsEvent({
    required this.query,
    this.businessType,
    this.industry,
    this.limit,
    this.offset,
  });

  @override
  List<Object> get props => [
        query,
        businessType ?? '',
        industry ?? '',
        limit ?? 0,
        offset ?? 0,
      ];
}

/// Event untuk clear search results
class ClearSearchEvent extends BrandSearchEvent {
  const ClearSearchEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load more search results
class LoadMoreSearchResultsEvent extends BrandSearchEvent {
  final String query;
  final String? businessType;
  final String? industry;
  final int offset;

  const LoadMoreSearchResultsEvent({
    required this.query,
    this.businessType,
    this.industry,
    required this.offset,
  });

  @override
  List<Object> get props => [
        query,
        businessType ?? '',
        industry ?? '',
        offset,
      ];
}

/// Event untuk reset search state
class ResetSearchEvent extends BrandSearchEvent {
  const ResetSearchEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk update search filters
class UpdateSearchFiltersEvent extends BrandSearchEvent {
  final String? businessType;
  final String? industry;

  const UpdateSearchFiltersEvent({
    this.businessType,
    this.industry,
  });

  @override
  List<Object> get props => [
        businessType ?? '',
        industry ?? '',
      ];
}

/// Event untuk clear search filters
class ClearSearchFiltersEvent extends BrandSearchEvent {
  const ClearSearchFiltersEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get search suggestions
class GetSearchSuggestionsEvent extends BrandSearchEvent {
  final String query;

  const GetSearchSuggestionsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

/// Event untuk save recent search
class SaveRecentSearchEvent extends BrandSearchEvent {
  final String query;

  const SaveRecentSearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

/// Event untuk get recent searches
class GetRecentSearchesEvent extends BrandSearchEvent {
  const GetRecentSearchesEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk clear recent searches
class ClearRecentSearchesEvent extends BrandSearchEvent {
  const ClearRecentSearchesEvent();

  @override
  List<Object> get props => [];
}