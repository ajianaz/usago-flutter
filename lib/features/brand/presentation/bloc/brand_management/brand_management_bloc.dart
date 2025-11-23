import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/slug_utils.dart';
import '../../../domain/usecases/brand/get_all_brands_usecase.dart';
import '../../../domain/usecases/brand/create_brand_usecase.dart';
import '../../../domain/usecases/brand/update_brand_usecase.dart';
import '../../../domain/usecases/brand/delete_brand_usecase.dart';
import '../../../domain/usecases/common/params/brand_params.dart';
import '../../../domain/usecases/common/usecase.dart';
import 'brand_management_event.dart';
import 'brand_management_state.dart';

/// Brand Management BLoC
/// Bertanggung jawab untuk operasi CRUD pada brand
/// Menggunakan use cases untuk business logic
class BrandManagementBloc
    extends Bloc<BrandManagementEvent, BrandManagementState> {
  final GetAllBrandsUseCase _getAllBrandsUseCase;
  final CreateBrandUseCase _createBrandUseCase;
  final UpdateBrandUseCase _updateBrandUseCase;
  final DeleteBrandUseCase _deleteBrandUseCase;

  BrandManagementBloc({
    required GetAllBrandsUseCase getAllBrandsUseCase,
    required CreateBrandUseCase createBrandUseCase,
    required UpdateBrandUseCase updateBrandUseCase,
    required DeleteBrandUseCase deleteBrandUseCase,
  })  : _getAllBrandsUseCase = getAllBrandsUseCase,
        _createBrandUseCase = createBrandUseCase,
        _updateBrandUseCase = updateBrandUseCase,
        _deleteBrandUseCase = deleteBrandUseCase,
        super(const BrandManagementInitial()) {
    // Register event handlers
    on<GetAllBrandsEvent>(_onGetAllBrands);
    on<CreateBrandEvent>(_onCreateBrand);
    on<UpdateBrandEvent>(_onUpdateBrand);
    on<DeleteBrandEvent>(_onDeleteBrand);
    on<RefreshBrandEvent>(_onRefreshBrand);
    on<TransferOwnershipEvent>(_onTransferOwnership);
    on<ResetBrandManagementEvent>(_onResetBrandManagement);
  }

  /// Handler untuk mendapatkan semua brands
  Future<void> _onGetAllBrands(
    GetAllBrandsEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementLoading());

    // Panggil use case
    final result = await _getAllBrandsUseCase(const NoParams());

    // Handle result
    result.fold(
      (failure) => emit(BrandManagementError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (brands) => emit(BrandManagementAllBrandsLoaded(
        brands: brands,
      )),
    );
  }

  /// Handler untuk membuat brand baru
  Future<void> _onCreateBrand(
    CreateBrandEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementLoading());

    // Validasi input
    final validationErrors = _validateCreateBrandData(event);
    if (validationErrors.isNotEmpty) {
      emit(BrandManagementValidationError(errors: validationErrors));
      return;
    }

    // Buat parameter untuk use case
    final params = CreateBrandParams(
      name: event.name,
      slug: SlugUtils.sanitize(event.name),
      logoUrl: event.logoUrl,
      businessType: event.businessType,
      industry: event.industry,
      description: event.description,
      timezone: event.timezone,
      currency: event.currency,
      settings: event.settings ??
          {
            'timezone': event.timezone,
            'currency': event.currency,
            'businessType': event.businessType,
            'single_brand_mode': true,
          },
    );

    // Panggil use case
    final result = await _createBrandUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandManagementError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (brand) => emit(BrandManagementCreated(
        brand: brand,
        message: 'Brand "${brand.name}" berhasil dibuat',
      )),
    );
  }

  /// Handler untuk update brand
  Future<void> _onUpdateBrand(
    UpdateBrandEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementLoading());

    // Validasi input
    final validationErrors = _validateUpdateBrandData(event);
    if (validationErrors.isNotEmpty) {
      emit(BrandManagementValidationError(errors: validationErrors));
      return;
    }

    // Buat parameter untuk use case
    final params = UpdateBrandParams(
      brandId: event.brandId,
      name: event.name,
      businessType: event.businessType,
      industry: event.industry,
      description: event.description,
      timezone: event.timezone,
      currency: event.currency,
      settings: event.settings,
    );

    // Panggil use case
    final result = await _updateBrandUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandManagementError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (brand) => emit(BrandManagementUpdated(
        brand: brand,
        message: 'Brand "${brand.name}" berhasil diperbarui',
      )),
    );
  }

  /// Handler untuk menghapus brand
  Future<void> _onDeleteBrand(
    DeleteBrandEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementLoading());

    // Buat parameter untuk use case
    final params = BrandIdParams(brandId: event.brandId);

    // Panggil use case
    final result = await _deleteBrandUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandManagementError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (_) => emit(BrandManagementDeleted(
        brandId: event.brandId,
        message: 'Brand berhasil dihapus',
      )),
    );
  }

  /// Handler untuk refresh data brand
  Future<void> _onRefreshBrand(
    RefreshBrandEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementLoading());

    // TODO: Implement get brand by ID use case
    // Untuk sekarang, emit state error
    emit(const BrandManagementError(
      message: 'Refresh brand belum diimplementasi',
    ));
  }

  /// Handler untuk transfer ownership brand
  Future<void> _onTransferOwnership(
    TransferOwnershipEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(TransferOwnershipInProgress(
      brandId: event.brandId,
      newOwnerEmail: event.newOwnerEmail,
    ));

    // Validasi input
    final validationErrors = _validateTransferOwnershipData(event);
    if (validationErrors.isNotEmpty) {
      emit(TransferOwnershipError(
        brandId: event.brandId,
        newOwnerEmail: event.newOwnerEmail,
        message: validationErrors.values.first,
        errorCode: 'VALIDATION_ERROR',
      ));
      return;
    }

    // TODO: Implement transfer ownership use case
    // Untuk sekarang, simulasi proses transfer
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi sukses
      emit(TransferOwnershipSuccess(
        brandId: event.brandId,
        newOwnerEmail: event.newOwnerEmail,
        message: 'Brand berhasil ditransfer ke ${event.newOwnerEmail}',
      ));
    } catch (e) {
      emit(TransferOwnershipError(
        brandId: event.brandId,
        newOwnerEmail: event.newOwnerEmail,
        message: 'Gagal mentransfer brand: ${e.toString()}',
        errorCode: 'TRANSFER_ERROR',
      ));
    }
  }

  /// Handler untuk reset state
  Future<void> _onResetBrandManagement(
    ResetBrandManagementEvent event,
    Emitter<BrandManagementState> emit,
  ) async {
    emit(const BrandManagementInitial());
  }

  /// Validasi data untuk membuat brand
  Map<String, String> _validateCreateBrandData(CreateBrandEvent event) {
    final errors = <String, String>{};

    // Validasi nama
    if (event.name.trim().isEmpty) {
      errors['name'] = 'Nama brand tidak boleh kosong';
    } else if (event.name.trim().length < 2) {
      errors['name'] = 'Nama brand minimal 2 karakter';
    } else if (event.name.trim().length > 100) {
      errors['name'] = 'Nama brand maksimal 100 karakter';
    }

    // Validasi business type
    if (event.businessType.trim().isEmpty) {
      errors['businessType'] = 'Tipe bisnis tidak boleh kosong';
    }

    // Validasi timezone
    if (event.timezone.trim().isEmpty) {
      errors['timezone'] = 'Timezone tidak boleh kosong';
    }

    // Validasi currency
    if (event.currency.trim().isEmpty) {
      errors['currency'] = 'Mata uang tidak boleh kosong';
    }

    // Validasi industry jika ada
    if (event.industry != null && event.industry!.trim().length > 50) {
      errors['industry'] = 'Industri maksimal 50 karakter';
    }

    // Validasi description jika ada
    if (event.description != null && event.description!.trim().length > 500) {
      errors['description'] = 'Deskripsi maksimal 500 karakter';
    }

    return errors;
  }

  /// Validasi data untuk update brand
  Map<String, String> _validateUpdateBrandData(UpdateBrandEvent event) {
    final errors = <String, String>{};

    // Validasi brand ID
    if (event.brandId.trim().isEmpty) {
      errors['brandId'] = 'Brand ID tidak boleh kosong';
    }

    // Validasi nama jika ada
    if (event.name != null) {
      if (event.name!.trim().isEmpty) {
        errors['name'] = 'Nama brand tidak boleh kosong';
      } else if (event.name!.trim().length < 2) {
        errors['name'] = 'Nama brand minimal 2 karakter';
      } else if (event.name!.trim().length > 100) {
        errors['name'] = 'Nama brand maksimal 100 karakter';
      }
    }

    // Validasi business type jika ada
    if (event.businessType != null && event.businessType!.trim().isEmpty) {
      errors['businessType'] = 'Tipe bisnis tidak boleh kosong';
    }

    // Validasi timezone jika ada
    if (event.timezone != null && event.timezone!.trim().isEmpty) {
      errors['timezone'] = 'Timezone tidak boleh kosong';
    }

    // Validasi currency jika ada
    if (event.currency != null && event.currency!.trim().isEmpty) {
      errors['currency'] = 'Mata uang tidak boleh kosong';
    }

    // Validasi industry jika ada
    if (event.industry != null && event.industry!.trim().length > 50) {
      errors['industry'] = 'Industri maksimal 50 karakter';
    }

    // Validasi description jika ada
    if (event.description != null && event.description!.trim().length > 500) {
      errors['description'] = 'Deskripsi maksimal 500 karakter';
    }

    return errors;
  }

  /// Mapping failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode == 404) {
          return 'Brand tidak ditemukan';
        } else if (serverFailure.statusCode == 403) {
          return 'Anda tidak memiliki izin untuk melakukan operasi ini';
        }
        return failure.message;
      case NetworkFailure:
        return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return 'Anda tidak memiliki izin untuk melakukan operasi ini';
      case ConflictFailure:
        final conflictFailure = failure as ConflictFailure;
        if (conflictFailure.code == 'BRAND_SLUG_EXISTS') {
          return 'Slug brand sudah digunakan. Silakan gunakan slug lain atau ubah sedikit nama brand.';
        }
        return conflictFailure.message;
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
      case ConflictFailure:
        final conflictFailure = failure as ConflictFailure;
        return conflictFailure.code ?? 'CONFLICT';
      default:
        return 'UNKNOWN_ERROR';
    }
  }

  /// Validasi data untuk transfer ownership
  Map<String, String> _validateTransferOwnershipData(
      TransferOwnershipEvent event) {
    final errors = <String, String>{};

    // Validasi brand ID
    if (event.brandId.trim().isEmpty) {
      errors['brandId'] = 'Brand ID tidak boleh kosong';
    }

    // Validasi email pemilik baru
    if (event.newOwnerEmail.trim().isEmpty) {
      errors['newOwnerEmail'] = 'Email pemilik baru tidak boleh kosong';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$')
        .hasMatch(event.newOwnerEmail.trim())) {
      errors['newOwnerEmail'] = 'Format email tidak valid';
    }

    // Validasi kode konfirmasi
    if (event.confirmationCode.trim().isEmpty) {
      errors['confirmationCode'] = 'Kode konfirmasi tidak boleh kosong';
    } else if (event.confirmationCode.length != 6) {
      errors['confirmationCode'] = 'Kode konfirmasi harus 6 digit';
    }

    return errors;
  }
}
