import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/brand_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk membuat brand baru dengan validasi
class CreateBrandUseCase implements UseCase<Brand, CreateBrandParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  CreateBrandUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, Brand>> call(CreateBrandParams params) async {
    try {
      // Log execution
      print(
          'CreateBrandUseCase: Creating brand "${params.name}" for user $_currentUserId');

      // Validasi input
      final validationResult = _validateBrandData(params);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Persiapkan data brand
      final brandData = {
        'name': params.name.trim(),
        'slug': params.slug.trim(),
        'businessType': params.businessType,
        'industry':
            params.industry?.trim() ?? '', // Ensure industry is never null
        'description': params.description?.trim() ??
            '', // Ensure description is never null
        'timezone': params.timezone,
        'currency': params.currency,
        'ownerId': _currentUserId,
        'settings': {},
        'subscriptionTier': 'BASIC',
        'subscriptionStatus': 'ACTIVE',
      };

      // Delegate ke repository
      final result = await _repository.createBrand(brandData);

      // Log result
      result.fold(
        (failure) => print(
            'CreateBrandUseCase: Failed to create brand - ${failure.message}'),
        (brand) => print(
            'CreateBrandUseCase: Successfully created brand "${brand.name}" (${brand.id})'),
      );

      return result;
    } catch (e) {
      print('CreateBrandUseCase: Unexpected error - $e');
      return Left(
          ServerFailure(message: 'Gagal membuat brand: ${e.toString()}'));
    }
  }

  /// Validasi data brand sebelum membuat
  Failure? _validateBrandData(CreateBrandParams params) {
    // Validasi nama brand
    if (params.name.trim().isEmpty) {
      return const ValidationFailure(message: 'Nama brand tidak boleh kosong');
    }

    if (params.name.trim().length < 2) {
      return const ValidationFailure(message: 'Nama brand minimal 2 karakter');
    }

    if (params.name.trim().length > 100) {
      return const ValidationFailure(
          message: 'Nama brand maksimal 100 karakter');
    }

    // Validasi slug
    if (params.slug.trim().isEmpty) {
      return const ValidationFailure(message: 'Slug brand tidak boleh kosong');
    }

    if (params.slug.trim().length < 2) {
      return const ValidationFailure(message: 'Slug brand minimal 2 karakter');
    }

    if (params.slug.trim().length > 100) {
      return const ValidationFailure(
          message: 'Slug brand maksimal 100 karakter');
    }

    // Validasi format slug (hanya lowercase, angka, dan dash)
    final slugRegex = RegExp(r'^[a-z0-9-]+$');
    if (!slugRegex.hasMatch(params.slug.trim())) {
      return const ValidationFailure(
        message:
            'Slug hanya boleh berisi huruf kecil, angka, dan tanda hubung (-)',
      );
    }

    // Slug tidak boleh dimulai atau diakhiri dengan dash
    if (params.slug.trim().startsWith('-') ||
        params.slug.trim().endsWith('-')) {
      return const ValidationFailure(
        message:
            'Slug tidak boleh dimulai atau diakhiri dengan tanda hubung (-)',
      );
    }

    // Validasi business type
    if (params.businessType.trim().isEmpty) {
      return const ValidationFailure(message: 'Tipe bisnis tidak boleh kosong');
    }

    // Validasi timezone
    if (params.timezone.trim().isEmpty) {
      return const ValidationFailure(message: 'Timezone tidak boleh kosong');
    }

    // Validasi currency
    if (params.currency.trim().isEmpty) {
      return const ValidationFailure(message: 'Mata uang tidak boleh kosong');
    }

    // Validasi industry jika ada
    if (params.industry != null && params.industry!.trim().length > 50) {
      return const ValidationFailure(message: 'Industri maksimal 50 karakter');
    }

    // Validasi description jika ada
    if (params.description != null && params.description!.trim().length > 500) {
      return const ValidationFailure(
          message: 'Deskripsi maksimal 500 karakter');
    }

    return null;
  }
}
