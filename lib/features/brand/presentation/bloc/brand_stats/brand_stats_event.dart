import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand stats events
/// Extends Equatable untuk value comparison
abstract class BrandStatsEvent extends Equatable {
  const BrandStatsEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get brand statistics
class GetBrandStatsEvent extends BrandStatsEvent {
  final String brandId;

  const GetBrandStatsEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

/// Event untuk refresh brand statistics
class RefreshBrandStatsEvent extends BrandStatsEvent {
  final String brandId;

  const RefreshBrandStatsEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

/// Event untuk reset state ke initial
class ResetBrandStatsEvent extends BrandStatsEvent {
  const ResetBrandStatsEvent();

  @override
  List<Object> get props => [];
}
