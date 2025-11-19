import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/usecases/brand/switch_active_brand_usecase.dart';
import '../../../domain/usecases/brand/get_active_brand_usecase.dart';
import '../../../domain/usecases/common/params/brand_params.dart';
import '../../../domain/usecases/common/usecase.dart';
import 'brand_switching_event.dart';
import 'brand_switching_state.dart';

/// Brand Switching BLoC
/// Bertanggung jawab untuk operasi switch active brand dan handle switching flow
/// Menggunakan use cases untuk business logic
class BrandSwitchingBloc extends Bloc<BrandSwitchingEvent, BrandSwitchingState> {
  final SwitchActiveBrandUseCase _switchActiveBrandUseCase;
  final GetActiveBrandUseCase _getActiveBrandUseCase;

  // Cache untuk menyimpan state
  Brand? _currentActiveBrand;
  List<BrandSwitchRecord> _switchingHistory = [];

  BrandSwitchingBloc({
    required SwitchActiveBrandUseCase switchActiveBrandUseCase,
    required GetActiveBrandUseCase getActiveBrandUseCase,
  })  : _switchActiveBrandUseCase = switchActiveBrandUseCase,
        _getActiveBrandUseCase = getActiveBrandUseCase,
        super(const BrandSwitchingInitial()) {
    // Register event handlers
    on<SwitchActiveBrandEvent>(_onSwitchActiveBrand);
    on<GetActiveBrandStatusEvent>(_onGetActiveBrandStatus);
    on<ResetBrandSwitchingEvent>(_onResetBrandSwitching);
    on<PreCheckBrandSwitchEvent>(_onPreCheckBrandSwitch);
    on<ConfirmBrandSwitchEvent>(_onConfirmBrandSwitch);
    on<CancelBrandSwitchEvent>(_onCancelBrandSwitch);
    on<GetSwitchingHistoryEvent>(_onGetSwitchingHistory);
    on<ClearSwitchingHistoryEvent>(_onClearSwitchingHistory);
    on<ValidateBrandAccessEvent>(_onValidateBrandAccess);
    on<SyncBrandDataEvent>(_onSyncBrandData);
  }

  /// Handler untuk switch active brand
  Future<void> _onSwitchActiveBrand(
    SwitchActiveBrandEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    emit(const BrandSwitchingLoading());

    // Simpan brand aktif saat ini
    final previousBrand = _currentActiveBrand;

    // Buat parameter untuk use case
    final params = SwitchActiveBrandParams(brandId: event.brandId);

    // Panggil use case
    final result = await _switchActiveBrandUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandSwitchingError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        brandId: event.brandId,
      )),
      (brand) {
        _currentActiveBrand = brand;

        // Tambahkan ke history
        final record = BrandSwitchRecord(
          brandId: brand.id,
          brandName: brand.name,
          switchedAt: DateTime.now(),
          previousBrandId: previousBrand?.id,
          previousBrandName: previousBrand?.name,
        );
        _switchingHistory.insert(0, record);

        // Keep only 20 records
        if (_switchingHistory.length > 20) {
          _switchingHistory = _switchingHistory.take(20).toList();
        }

        emit(BrandSwitchingSuccess(
          previousBrand: previousBrand ?? brand, // Fallback ke brand baru jika tidak ada previous
          newActiveBrand: brand,
          message: 'Berhasil beralih ke brand "${brand.name}"',
        ));
      },
    );
  }

  /// Handler untuk get active brand status
  Future<void> _onGetActiveBrandStatus(
    GetActiveBrandStatusEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    emit(const BrandSwitchingLoading());

    final result = await _getActiveBrandUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.statusCode == 404) {
          emit(const NoActiveBrandState());
        } else {
          emit(BrandSwitchingError(
            message: _mapFailureToMessage(failure),
            errorCode: _mapFailureToErrorCode(failure),
          ));
        }
      },
      (brand) {
        if (brand != null) {
          _currentActiveBrand = brand;
          emit(ActiveBrandStatusLoaded(
            activeBrand: brand,
            hasActiveBrand: true,
          ));
        } else {
          emit(const NoActiveBrandState());
        }
      },
    );
  }

  /// Handler untuk reset switching state
  Future<void> _onResetBrandSwitching(
    ResetBrandSwitchingEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    emit(const BrandSwitchingInitial());
  }

  /// Handler untuk pre-check brand switch
  Future<void> _onPreCheckBrandSwitch(
    PreCheckBrandSwitchEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    // TODO: Implement pre-check logic
    // Untuk sekarang, kita akan emit state success dengan mock data

    // Mock brand untuk testing
    final targetBrand = Brand(
      id: event.brandId,
      name: 'Target Brand',
      slug: 'target-brand',
      businessType: 'Retail',
      description: 'Target brand for switching',
      ownerId: 'owner-id',
      settings: {},
      timezone: 'Asia/Jakarta',
      currency: 'IDR',
      subscriptionTier: 'BASIC',
      subscriptionStatus: 'ACTIVE',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Mock pre-check result
    final canSwitch = true;
    final warningMessage = 'Anda akan beralih ke brand "${targetBrand.name}". Semua perubahan yang belum disimpan akan hilang.';
    final requirements = <String>[];

    emit(BrandSwitchPreCheckCompleted(
      targetBrand: targetBrand,
      canSwitch: canSwitch,
      warningMessage: warningMessage,
      requirements: requirements,
    ));
  }

  /// Handler untuk confirm brand switch
  Future<void> _onConfirmBrandSwitch(
    ConfirmBrandSwitchEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    if (!event.confirmPermission) {
      emit(const BrandSwitchingError(
        message: 'Konfirmasi dibatalkan. Brand switching tidak dilakukan.',
      ));
      return;
    }

    // Lakukan switch
    add(SwitchActiveBrandEvent(brandId: event.brandId));
  }

  /// Handler untuk cancel brand switch
  Future<void> _onCancelBrandSwitch(
    CancelBrandSwitchEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    emit(const BrandSwitchingInitial());
  }

  /// Handler untuk get switching history
  Future<void> _onGetSwitchingHistory(
    GetSwitchingHistoryEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    emit(SwitchingHistoryLoaded(history: _switchingHistory));
  }

  /// Handler untuk clear switching history
  Future<void> _onClearSwitchingHistory(
    ClearSwitchingHistoryEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    _switchingHistory = [];
    emit(const SwitchingHistoryLoaded(history: []));
  }

  /// Handler untuk validate brand access
  Future<void> _onValidateBrandAccess(
    ValidateBrandAccessEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    // TODO: Implement access validation logic
    // Untuk sekarang, kita akan emit state success dengan mock data

    // Mock validation result
    final hasAccess = true;
    final role = 'BRAND_OWNER';
    final permissions = ['read', 'write', 'delete', 'admin'];

    emit(BrandAccessValidationCompleted(
      brandId: event.brandId,
      hasAccess: hasAccess,
      role: role,
      permissions: permissions,
    ));
  }

  /// Handler untuk sync brand data
  Future<void> _onSyncBrandData(
    SyncBrandDataEvent event,
    Emitter<BrandSwitchingState> emit,
  ) async {
    // TODO: Implement data sync logic
    // Untuk sekarang, kita akan emit state success dengan mock data

    // Mock sync result
    final syncSuccessful = true;
    final syncMessage = 'Data brand berhasil disinkronkan';

    emit(BrandDataSyncCompleted(
      brandId: event.brandId,
      syncSuccessful: syncSuccessful,
      syncMessage: syncMessage,
    ));
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
        return 'Anda tidak memiliki izin untuk melakukan switching brand';
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