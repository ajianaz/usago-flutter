import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan statistik brand
class GetBrandStatsUseCase
    implements UseCase<Map<String, dynamic>, BrandIdParams> {
  final BrandRepository _repository;

  GetBrandStatsUseCase({required BrandRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      BrandIdParams params) async {
    try {
      // Log execution
      print('GetBrandStatsUseCase: Getting stats for brand ${params.brandId}');

      // Delegate ke repository
      final result = await _repository.getBrandStats(params.brandId);

      // Log result
      result.fold(
        (failure) => print(
            'GetBrandStatsUseCase: Failed to get brand stats - ${failure.message}'),
        (stats) => print(
            'GetBrandStatsUseCase: Successfully retrieved stats for brand ${params.brandId}'),
      );

      return result;
    } catch (e) {
      print('GetBrandStatsUseCase: Unexpected error - $e');
      return Left(ServerFailure(
          message: 'Gagal mendapatkan statistik brand: ${e.toString()}'));
    }
  }
}
