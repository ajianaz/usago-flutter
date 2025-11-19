import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk update brand data
class UpdateBrandUseCase implements UseCase<Brand, UpdateBrandParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  UpdateBrandUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, Brand>> call(UpdateBrandParams params) async {
    try {
      // Log execution
      print('UpdateBrandUseCase: Updating brand ${params.brandId} for user $_currentUserId');

      // Validasi input
      final validationResult = _validateUpdateData(params);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Cek apakah user memiliki permission untuk update brand
      final permissionResult = await _checkUpdatePermission(params.brandId);
      if (permissionResult != null) {
        return Left(permissionResult);
      }

      // Persiapkan data update
      final updateData = <String, dynamic>{};

      if (params.name != null) {
        updateData['name'] = params.name!.trim();
      }

      if (params.businessType != null) {
        updateData['businessType'] = params.businessType!.trim();
      }

      if (params.industry != null) {
        updateData['industry'] = params.industry!.trim();
      }

      if (params.description != null) {
        updateData['description'] = params.description!.trim();
      }

      if (params.timezone != null) {
        updateData['timezone'] = params.timezone!.trim();
      }

      if (params.currency != null) {
        updateData['currency'] = params.currency!.trim();
      }

      if (params.settings != null) {
        updateData['settings'] = params.settings;
      }

      // Delegate ke repository
      final result = await _repository.updateBrand(params.brandId, updateData);

      // Log result
      result.fold(
        (failure) => print('UpdateBrandUseCase: Failed to update brand - ${failure.message}'),
        (brand) => print('UpdateBrandUseCase: Successfully updated brand "${brand.name}" (${brand.id})'),
      );

      return result;
    } catch (e) {
      print('UpdateBrandUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mengupdate brand: ${e.toString()}'));
    }
  }

  /// Validasi data update
  Failure? _validateUpdateData(UpdateBrandParams params) {
    // Validasi nama jika ada
    if (params.name != null) {
      if (params.name!.trim().isEmpty) {
        return const ValidationFailure(message: 'Nama brand tidak boleh kosong');
      }

      if (params.name!.trim().length < 2) {
        return const ValidationFailure(message: 'Nama brand minimal 2 karakter');
      }

      if (params.name!.trim().length > 100) {
        return const ValidationFailure(message: 'Nama brand maksimal 100 karakter');
      }
    }

    // Validasi business type jika ada
    if (params.businessType != null && params.businessType!.trim().isEmpty) {
      return const ValidationFailure(message: 'Tipe bisnis tidak boleh kosong');
    }

    // Validasi timezone jika ada
    if (params.timezone != null && params.timezone!.trim().isEmpty) {
      return const ValidationFailure(message: 'Timezone tidak boleh kosong');
    }

    // Validasi currency jika ada
    if (params.currency != null && params.currency!.trim().isEmpty) {
      return const ValidationFailure(message: 'Mata uang tidak boleh kosong');
    }

    // Validasi industry jika ada
    if (params.industry != null && params.industry!.trim().length > 50) {
      return const ValidationFailure(message: 'Industri maksimal 50 karakter');
    }

    // Validasi description jika ada
    if (params.description != null && params.description!.trim().length > 500) {
      return const ValidationFailure(message: 'Deskripsi maksimal 500 karakter');
    }

    return null;
  }

  /// Cek permission untuk update brand
  Future<Failure?> _checkUpdatePermission(String brandId) async {
    try {
      // Ambil data brand untuk cek ownership
      final brandResult = await _repository.getBrandById(brandId);

      return brandResult.fold(
        (failure) {
          if (failure is ServerFailure && failure.statusCode == 404) {
            return const ValidationFailure(message: 'Brand tidak ditemukan');
          }
          return ServerFailure(message: 'Gagal memeriksa permission: ${failure.message}');
        },
        (brand) {
          // Cek apakah user adalah owner
          if (brand.ownerId != _currentUserId) {
            return const ValidationFailure(message: 'Anda tidak memiliki permission untuk mengupdate brand ini');
          }
          return null;
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa permission: ${e.toString()}');
    }
  }
}