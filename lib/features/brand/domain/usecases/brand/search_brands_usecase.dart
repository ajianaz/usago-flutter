import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk pencarian brand dengan filter
class SearchBrandsUseCase implements UseCase<List<Brand>, SearchBrandsParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  SearchBrandsUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, List<Brand>>> call(SearchBrandsParams params) async {
    try {
      // Log execution
      print('SearchBrandsUseCase: Searching brands for user $_currentUserId with params: query=${params.query}, businessType=${params.businessType}, industry=${params.industry}');

      // Validasi parameter
      final validationResult = _validateSearchParams(params);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Ambil semua accessible brands terlebih dahulu
      final accessibleBrandsResult = await _repository.getAccessibleBrands();

      return accessibleBrandsResult.fold(
        (failure) {
          print('SearchBrandsUseCase: Failed to get accessible brands - ${failure.message}');
          return Left(failure);
        },
        (brands) {
          // Filter brands berdasarkan parameter
          final filteredBrands = _filterBrands(brands, params);

          print('SearchBrandsUseCase: Found ${filteredBrands.length} brands matching criteria');

          return Right(filteredBrands);
        },
      );
    } catch (e) {
      print('SearchBrandsUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mencari brand: ${e.toString()}'));
    }
  }

  /// Validasi parameter pencarian
  Failure? _validateSearchParams(SearchBrandsParams params) {
    // Validasi query jika ada
    if (params.query != null && params.query!.trim().isNotEmpty) {
      if (params.query!.trim().length < 2) {
        return const ValidationFailure(message: 'Query pencarian minimal 2 karakter');
      }

      if (params.query!.trim().length > 100) {
        return const ValidationFailure(message: 'Query pencarian maksimal 100 karakter');
      }
    }

    // Validasi limit jika ada
    if (params.limit != null && (params.limit! <= 0 || params.limit! > 100)) {
      return const ValidationFailure(message: 'Limit harus antara 1 dan 100');
    }

    // Validasi offset jika ada
    if (params.offset != null && params.offset! < 0) {
      return const ValidationFailure(message: 'Offset tidak boleh negatif');
    }

    return null;
  }

  /// Filter brands berdasarkan parameter
  List<Brand> _filterBrands(List<Brand> brands, SearchBrandsParams params) {
    var filteredBrands = brands;

    // Filter berdasarkan query
    if (params.query != null && params.query!.trim().isNotEmpty) {
      final query = params.query!.toLowerCase().trim();
      filteredBrands = filteredBrands.where((brand) {
        return brand.name.toLowerCase().contains(query) ||
               brand.slug.toLowerCase().contains(query) ||
               (brand.description?.toLowerCase().contains(query) ?? false) ||
               (brand.industry?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Filter berdasarkan business type
    if (params.businessType != null && params.businessType!.trim().isNotEmpty) {
      final businessType = params.businessType!.trim();
      filteredBrands = filteredBrands.where((brand) {
        return brand.businessType.toLowerCase() == businessType.toLowerCase();
      }).toList();
    }

    // Filter berdasarkan industry
    if (params.industry != null && params.industry!.trim().isNotEmpty) {
      final industry = params.industry!.trim();
      filteredBrands = filteredBrands.where((brand) {
        return brand.industry?.toLowerCase().contains(industry.toLowerCase()) ?? false;
      }).toList();
    }

    // Sort berdasarkan nama brand
    filteredBrands.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Apply pagination
    if (params.offset != null && params.offset! > 0) {
      if (params.offset! < filteredBrands.length) {
        filteredBrands = filteredBrands.skip(params.offset!).toList();
      } else {
        // Offset melebihi jumlah data
        return [];
      }
    }

    if (params.limit != null && params.limit! > 0) {
      filteredBrands = filteredBrands.take(params.limit!).toList();
    }

    return filteredBrands;
  }
}