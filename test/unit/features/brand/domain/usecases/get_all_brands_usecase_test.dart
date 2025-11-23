import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/features/brand/domain/usecases/brand/get_all_brands_usecase.dart';
import 'package:usago/features/brand/domain/usecases/common/usecase.dart';
import '../../../../../fixtures/brand_fixtures.dart';
import '../../../../../mocks/brand_mocks.dart';

void main() {
  group('GetAllBrandsUseCase', () {
    late GetAllBrandsUseCase usecase;
    late MockBrandRepository mockRepository;

    setUp(() {
      mockRepository = MockBrandRepository();
      usecase = GetAllBrandsUseCase(
        repository: mockRepository,
        currentUserId: 'test-user-123',
      );
    });

    test(
        'should call repository with correct parameters when get all brands is successful',
        () async {
      // Arrange
      final expectedBrands = BrandFixtures.testBrandList;

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => Right(expectedBrands));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, Right(expectedBrands));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should return repository failure when get all brands fails',
        () async {
      // Arrange
      const expectedFailure = ServerFailure(message: 'Failed to get brands');

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => const Left(expectedFailure));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, const Left(expectedFailure));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should return empty list when no brands exist', () async {
      // Arrange
      final expectedBrands = <Brand>[];

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => Right(expectedBrands));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, Right(expectedBrands));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should handle network failure properly', () async {
      // Arrange
      const networkFailure = NetworkFailure(message: 'No internet connection');

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, const Left(networkFailure));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should handle validation failure properly', () async {
      // Arrange
      const validationFailure = ValidationFailure(message: 'Invalid request');

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => const Left(validationFailure));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, const Left(validationFailure));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should handle unexpected errors properly', () async {
      // Arrange
      when(() => mockRepository.getAllBrands())
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, isA<Left<Failure, List<Brand>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Gagal mengambil semua data brand'));
        },
        (brands) => fail('Expected failure but got brands'),
      );
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should pass correct current user ID to use case', () async {
      // Arrange
      const currentUserId = 'specific-user-456';
      final expectedBrands = BrandFixtures.testBrandList;

      usecase = GetAllBrandsUseCase(
        repository: mockRepository,
        currentUserId: currentUserId,
      );

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => Right(expectedBrands));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, Right(expectedBrands));
      verify(() => mockRepository.getAllBrands()).called(1);
    });

    test('should handle large brand list properly', () async {
      // Arrange
      final largeBrandList = List.generate(
        100,
        (index) => Brand(
          id: 'brand-$index',
          name: 'Brand $index',
          slug: 'brand-$index',
          ownerId: 'owner-$index',
          businessType: 'RETAIL',
          settings: {},
          timezone: 'Asia/Jakarta',
          currency: 'IDR',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      when(() => mockRepository.getAllBrands())
          .thenAnswer((_) async => Right(largeBrandList));

      // Act
      final result = await usecase(const NoParams());

      // Assert
      expect(result, Right(largeBrandList));
      expect(largeBrandList.length, 100);
      verify(() => mockRepository.getAllBrands()).called(1);
    });
  });
}
