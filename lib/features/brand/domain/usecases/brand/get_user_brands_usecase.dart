import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan brands milik user
class GetUserBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  GetUserBrandsUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    try {
      // Log execution
      print('GetUserBrandsUseCase: Getting brands for user $_currentUserId');

      // Delegate ke repository
      final result = await _repository.getUserBrands();

      // Log result
      result.fold(
        (failure) => print('GetUserBrandsUseCase: Failed to get brands - ${failure.message}'),
        (brands) => print('GetUserBrandsUseCase: Successfully retrieved ${brands.length} brands'),
      );

      return result;
    } catch (e) {
      print('GetUserBrandsUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mengambil data brand: ${e.toString()}'));
    }
  }
}