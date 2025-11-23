import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan semua brands (admin/system-wide access)
class GetAllBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  GetAllBrandsUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    try {
      // Log execution
      print('GetAllBrandsUseCase: Getting all brands for user $_currentUserId');

      // Delegate ke repository
      final result = await _repository.getAllBrands();

      // Log result
      result.fold(
        (failure) => print(
            'GetAllBrandsUseCase: Failed to get all brands - ${failure.message}'),
        (brands) => print(
            'GetAllBrandsUseCase: Successfully retrieved ${brands.length} brands'),
      );

      return result;
    } catch (e) {
      print('GetAllBrandsUseCase: Unexpected error - $e');
      return Left(ServerFailure(
          message: 'Gagal mengambil semua data brand: ${e.toString()}'));
    }
  }
}
