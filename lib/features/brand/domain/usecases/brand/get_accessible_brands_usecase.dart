import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan brands yang dapat diakses user
/// Termasuk brands milik user dan brands di mana user diundang
class GetAccessibleBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  GetAccessibleBrandsUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    try {
      // Log execution
      print('GetAccessibleBrandsUseCase: Getting accessible brands for user $_currentUserId');

      // Delegate ke repository
      final result = await _repository.getAccessibleBrands();

      // Log result
      result.fold(
        (failure) => print('GetAccessibleBrandsUseCase: Failed to get accessible brands - ${failure.message}'),
        (brands) => print('GetAccessibleBrandsUseCase: Successfully retrieved ${brands.length} accessible brands'),
      );

      return result;
    } catch (e) {
      print('GetAccessibleBrandsUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mengambil data brand yang dapat diakses: ${e.toString()}'));
    }
  }
}