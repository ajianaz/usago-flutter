import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan brand yang sedang aktif
class GetActiveBrandUseCase implements UseCase<Brand?, NoParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  GetActiveBrandUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, Brand?>> call(NoParams params) async {
    try {
      // Log execution
      print('GetActiveBrandUseCase: Getting active brand for user $_currentUserId');

      // Delegate ke repository
      final result = await _repository.getActiveBrand();

      // Log result
      result.fold(
        (failure) => print('GetActiveBrandUseCase: Failed to get active brand - ${failure.message}'),
        (brand) {
          if (brand != null) {
            print('GetActiveBrandUseCase: Active brand found - ${brand.name} (${brand.id})');
          } else {
            print('GetActiveBrandUseCase: No active brand found');
          }
        },
      );

      return result;
    } catch (e) {
      print('GetActiveBrandUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mengambil data brand aktif: ${e.toString()}'));
    }
  }
}