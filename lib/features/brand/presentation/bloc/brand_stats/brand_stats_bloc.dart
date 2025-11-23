import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/usecases/brand/get_brand_stats_usecase.dart';
import '../../../domain/usecases/common/params/brand_params.dart';
import '../../../domain/usecases/common/usecase.dart';
import 'brand_stats_event.dart';
import 'brand_stats_state.dart';

/// Brand Statistics BLoC
/// Bertanggung jawab untuk operasi获取 brand statistics
/// Menggunakan use cases untuk business logic
class BrandStatsBloc extends Bloc<BrandStatsEvent, BrandStatsState> {
  final GetBrandStatsUseCase _getBrandStatsUseCase;

  BrandStatsBloc({
    required GetBrandStatsUseCase getBrandStatsUseCase,
  })  : _getBrandStatsUseCase = getBrandStatsUseCase,
        super(const BrandStatsInitial()) {
    // Register event handlers
    on<GetBrandStatsEvent>(_onGetBrandStats);
    on<RefreshBrandStatsEvent>(_onRefreshBrandStats);
    on<ResetBrandStatsEvent>(_onResetBrandStats);
  }

  /// Handler untuk get brand statistics
  Future<void> _onGetBrandStats(
    GetBrandStatsEvent event,
    Emitter<BrandStatsState> emit,
  ) async {
    emit(const BrandStatsLoading());

    // Buat parameter untuk use case
    final params = BrandIdParams(brandId: event.brandId);

    // Panggil use case
    final result = await _getBrandStatsUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandStatsError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        brandId: event.brandId,
      )),
      (stats) => emit(BrandStatsLoaded(
        brandId: event.brandId,
        stats: stats,
        message: 'Berhasil mengambil statistik brand',
      )),
    );
  }

  /// Handler untuk refresh brand statistics
  Future<void> _onRefreshBrandStats(
    RefreshBrandStatsEvent event,
    Emitter<BrandStatsState> emit,
  ) async {
    // Trigger get brand stats again
    add(GetBrandStatsEvent(brandId: event.brandId));
  }

  /// Handler untuk reset state
  Future<void> _onResetBrandStats(
    ResetBrandStatsEvent event,
    Emitter<BrandStatsState> emit,
  ) async {
    emit(const BrandStatsInitial());
  }

  /// Mapping failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode == 404) {
          return 'Brand tidak ditemukan';
        } else if (serverFailure.statusCode == 403) {
          return 'Anda tidak memiliki izin untuk melihat statistik brand ini';
        }
        return failure.message;
      case NetworkFailure:
        return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return 'Anda tidak memiliki izin untuk melihat statistik brand ini';
      default:
        return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }

  /// Mapping failure ke error code
  String? _mapFailureToErrorCode(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode == 404) {
          return 'NOT_FOUND';
        } else if (serverFailure.statusCode == 403) {
          return 'UNAUTHORIZED';
        }
        return serverFailure.statusCode?.toString();
      case NetworkFailure:
        return 'NETWORK_ERROR';
      case ValidationFailure:
        return 'VALIDATION_ERROR';
      case BetterAuthFailure:
        return 'UNAUTHORIZED';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}
