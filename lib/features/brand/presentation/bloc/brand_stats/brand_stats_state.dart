import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand stats states
/// Extends Equatable untuk value comparison
abstract class BrandStatsState extends Equatable {
  const BrandStatsState();

  @override
  List<Object> get props => [];
}

/// Initial state untuk brand stats
class BrandStatsInitial extends BrandStatsState {
  const BrandStatsInitial();

  @override
  List<Object> get props => [];
}

/// Loading state saat mengambil brand stats
class BrandStatsLoading extends BrandStatsState {
  const BrandStatsLoading();

  @override
  List<Object> get props => [];
}

/// State saat brand stats berhasil dimuat
class BrandStatsLoaded extends BrandStatsState {
  final String brandId;
  final Map<String, dynamic> stats;
  final String message;

  const BrandStatsLoaded({
    required this.brandId,
    required this.stats,
    required this.message,
  });

  @override
  List<Object> get props => [brandId, stats, message];
}

/// Error state saat gagal mengambil brand stats
class BrandStatsError extends BrandStatsState {
  final String message;
  final String? errorCode;
  final String brandId;

  const BrandStatsError({
    required this.message,
    this.errorCode,
    required this.brandId,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', brandId];
}
