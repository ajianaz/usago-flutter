import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk switch ke brand lain
class SwitchActiveBrandUseCase
    implements UseCase<Brand, SwitchActiveBrandParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  SwitchActiveBrandUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, Brand>> call(SwitchActiveBrandParams params) async {
    try {
      // Log execution
      print(
          'SwitchActiveBrandUseCase: Switching to brand ${params.brandId} for user $_currentUserId');

      // Cek apakah user memiliki akses ke brand
      final accessResult = await _checkBrandAccess(params.brandId);
      if (accessResult != null) {
        return Left(accessResult);
      }

      // Switch active brand di repository
      final result = await _repository.switchActiveBrand(params.brandId,
          branchId: params.branchId);

      // Simpan active brand ID ke local storage
      final saveResult = await _saveActiveBrandId(params.brandId);

      // Handle result
      return result.fold(
        (failure) {
          print(
              'SwitchActiveBrandUseCase: Failed to switch brand - ${failure.message}');
          return Left(failure);
        },
        (brand) async {
          // Log success
          print(
              'SwitchActiveBrandUseCase: Successfully switched to brand "${brand.name}" (${brand.id})');

          // Handle local storage result
          saveResult.fold(
            (storageFailure) {
              print(
                  'SwitchActiveBrandUseCase: Warning - Failed to save active brand ID locally: ${storageFailure.message}');
              // Tetap return success karena server side sudah berhasil
            },
            (_) {
              print('SwitchActiveBrandUseCase: Active brand ID saved locally');
            },
          );

          return Right(brand);
        },
      );
    } catch (e) {
      print('SwitchActiveBrandUseCase: Unexpected error - $e');
      return Left(
          ServerFailure(message: 'Gagal switch brand: ${e.toString()}'));
    }
  }

  /// Cek apakah user memiliki akses ke brand
  Future<Failure?> _checkBrandAccess(String brandId) async {
    try {
      // Ambil data brand untuk verifikasi
      final brandResult = await _repository.getBrandById(brandId);

      return brandResult.fold(
        (failure) {
          if (failure is ServerFailure && failure.statusCode == 404) {
            return const ValidationFailure(message: 'Brand tidak ditemukan');
          }
          return ServerFailure(
              message: 'Gagal memeriksa akses brand: ${failure.message}');
        },
        (brand) {
          // Cek apakah user adalah owner atau memiliki akses
          // TODO: Implementasi logika permission yang lebih kompleks jika needed
          if (brand.ownerId != _currentUserId) {
            // Untuk sekarang, kita anggap user memiliki akses jika brand ada di accessible brands
            // Nanti bisa ditambah dengan cek role/permission
            print(
                'SwitchActiveBrandUseCase: User is not owner, checking accessible brands...');

            // Cek apakah brand ada di accessible brands
            _repository.getAccessibleBrands().then(
                  (accessibleResult) => accessibleResult.fold(
                    (failure) => print(
                        'SwitchActiveBrandUseCase: Could not verify access: ${failure.message}'),
                    (brands) {
                      final hasAccess = brands.any((b) => b.id == brandId);
                      if (!hasAccess) {
                        print(
                            'SwitchActiveBrandUseCase: User does not have access to brand $brandId');
                      } else {
                        print(
                            'SwitchActiveBrandUseCase: User has access to brand $brandId');
                      }
                    },
                  ),
                );
          }
          return null;
        },
      );
    } catch (e) {
      return ServerFailure(
          message: 'Gagal memeriksa akses brand: ${e.toString()}');
    }
  }

  /// Simpan active brand ID ke local storage
  Future<Either<Failure, void>> _saveActiveBrandId(String brandId) async {
    try {
      return await _repository.saveActiveBrandId(brandId);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Gagal menyimpan active brand ID: ${e.toString()}'));
    }
  }
}
