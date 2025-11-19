import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk delete brand (soft delete)
class DeleteBrandUseCase implements UseCase<void, BrandIdParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  DeleteBrandUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, void>> call(BrandIdParams params) async {
    try {
      // Log execution
      print('DeleteBrandUseCase: Deleting brand ${params.brandId} for user $_currentUserId');

      // Cek apakah user memiliki permission untuk delete brand
      final permissionResult = await _checkDeletePermission(params.brandId);
      if (permissionResult != null) {
        return Left(permissionResult);
      }

      // Cek apakah brand sedang aktif
      final activeBrandResult = await _checkActiveBrand(params.brandId);
      if (activeBrandResult != null) {
        return Left(activeBrandResult);
      }

      // Delegate ke repository
      final result = await _repository.deleteBrand(params.brandId);

      // Log result
      result.fold(
        (failure) => print('DeleteBrandUseCase: Failed to delete brand - ${failure.message}'),
        (_) => print('DeleteBrandUseCase: Successfully deleted brand ${params.brandId}'),
      );

      return result;
    } catch (e) {
      print('DeleteBrandUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal menghapus brand: ${e.toString()}'));
    }
  }

  /// Cek permission untuk delete brand
  Future<Failure?> _checkDeletePermission(String brandId) async {
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
            return const ValidationFailure(message: 'Anda tidak memiliki permission untuk menghapus brand ini');
          }
          return null;
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa permission: ${e.toString()}');
    }
  }

  /// Cek apakah brand sedang aktif
  Future<Failure?> _checkActiveBrand(String brandId) async {
    try {
      final activeBrandResult = await _repository.getActiveBrand();

      return activeBrandResult.fold(
        (failure) {
          // Jika gagal mendapatkan active brand, lanjutkan proses delete
          print('DeleteBrandUseCase: Warning - Could not check active brand: ${failure.message}');
          return null;
        },
        (activeBrand) {
          // Jika brand yang akan dihapus adalah active brand, tolak
          if (activeBrand != null && activeBrand.id == brandId) {
            return const ValidationFailure(message: 'Tidak dapat menghapus brand yang sedang aktif. Silakan switch ke brand lain terlebih dahulu.');
          }
          return null;
        },
      );
    } catch (e) {
      print('DeleteBrandUseCase: Warning - Error checking active brand: $e');
      return null;
    }
  }
}