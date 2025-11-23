import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/features/brand/domain/usecases/index.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_bloc.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_event.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_state.dart';
import 'package:usago/features/brand/domain/usecases/brand/get_all_brands_usecase.dart';
import 'package:usago/features/brand/domain/usecases/brand/create_brand_usecase.dart';
import 'package:usago/features/brand/domain/usecases/brand/update_brand_usecase.dart';
import 'package:usago/features/brand/domain/usecases/brand/delete_brand_usecase.dart';
import 'package:usago/features/brand/domain/usecases/common/params/brand_params.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import '../../../../../fixtures/brand_fixtures.dart';
import '../../../../../mocks/brand_mocks.dart';

void main() {
  group('BrandManagementBloc', () {
    late BrandManagementBloc bloc;
    late MockGetAllBrandsUseCase mockGetAllBrandsUseCase;
    late MockCreateBrandUseCase mockCreateBrandUseCase;
    late MockUpdateBrandUseCase mockUpdateBrandUseCase;
    late MockDeleteBrandUseCase mockDeleteBrandUseCase;

    setUp(() {
      mockGetAllBrandsUseCase = MockGetAllBrandsUseCase();
      mockCreateBrandUseCase = MockCreateBrandUseCase();
      mockUpdateBrandUseCase = MockUpdateBrandUseCase();
      mockDeleteBrandUseCase = MockDeleteBrandUseCase();

      bloc = BrandManagementBloc(
        getAllBrandsUseCase: mockGetAllBrandsUseCase,
        createBrandUseCase: mockCreateBrandUseCase,
        updateBrandUseCase: mockUpdateBrandUseCase,
        deleteBrandUseCase: mockDeleteBrandUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be BrandManagementInitial', () {
      // Assert
      expect(bloc.state, const BrandManagementInitial());
    });

    group('GetAllBrandsEvent', () {
      test('should emit loading and loaded states when get all brands succeeds',
          () async {
        // Arrange
        final expectedBrands = BrandFixtures.testBrandList;
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(expectedBrands));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementAllBrandsLoaded(brands: expectedBrands),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // Trigger the event
        bloc.add(const GetAllBrandsEvent());

        // Verify use case was called
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should emit loading and error states when get all brands fails',
          () async {
        // Arrange
        const expectedFailure = ServerFailure(message: 'Failed to get brands');
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(expectedFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: expectedFailure.message,
            errorCode: null,
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // Trigger the event
        bloc.add(const GetAllBrandsEvent());

        // Verify use case was called
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test(
          'should emit loading and error states with error code when get all brands fails with code',
          () async {
        // Arrange
        const expectedFailure = NetworkFailure(message: 'Network error');
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(expectedFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: expectedFailure.message,
            errorCode: 'NETWORK_ERROR',
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // Trigger the event
        bloc.add(const GetAllBrandsEvent());

        // Verify use case was called
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should handle empty brand list correctly', () async {
        // Arrange
        final emptyBrands = <Brand>[];
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(emptyBrands));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementAllBrandsLoaded(brands: emptyBrands),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // Trigger the event
        bloc.add(const GetAllBrandsEvent());

        // Verify use case was called
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should handle large brand list correctly', () async {
        // Arrange
        final largeBrandList = List.generate(
          50,
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

        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(largeBrandList));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementAllBrandsLoaded(brands: largeBrandList),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // Trigger the event
        bloc.add(const GetAllBrandsEvent());

        // Verify use case was called
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });
    });

    group('Multiple Events', () {
      test('should handle multiple get all brands events correctly', () async {
        // Arrange
        final firstBrands = [BrandFixtures.testBrand];
        final secondBrands = BrandFixtures.testBrandList;

        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(firstBrands));

        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(secondBrands));

        // Act & Assert - First event
        final firstExpectedStates = [
          const BrandManagementLoading(),
          BrandManagementAllBrandsLoaded(brands: firstBrands),
        ];

        expectLater(bloc.stream, emitsInOrder(firstExpectedStates));

        bloc.add(const GetAllBrandsEvent());
        await Future.delayed(const Duration(milliseconds: 100));

        // Reset mock for second call
        reset(mockGetAllBrandsUseCase);

        // Act & Assert - Second event
        final secondExpectedStates = [
          const BrandManagementLoading(),
          BrandManagementAllBrandsLoaded(brands: secondBrands),
        ];

        expectLater(bloc.stream, emitsInOrder(secondExpectedStates));

        bloc.add(const GetAllBrandsEvent());

        // Verify both use case calls
        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(2);
      });
    });

    group('Error Handling', () {
      test('should map validation failure correctly', () async {
        // Arrange
        const validationFailure =
            ValidationFailure(message: 'Validation failed');
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(validationFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: validationFailure.message,
            errorCode: 'VALIDATION_ERROR',
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(const GetAllBrandsEvent());

        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should map server failure with status code correctly', () async {
        // Arrange
        const serverFailure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(serverFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: serverFailure.message,
            errorCode: '500',
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(const GetAllBrandsEvent());

        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should map unauthorized failure correctly', () async {
        // Arrange
        const unauthorizedFailure = ServerFailure(
          message: 'Unauthorized access',
          statusCode: 403,
        );
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(unauthorizedFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: 'Anda tidak memiliki izin untuk melakukan operasi ini',
            errorCode: 'UNAUTHORIZED',
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(const GetAllBrandsEvent());

        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });

      test('should map not found failure correctly', () async {
        // Arrange
        const notFoundFailure = ServerFailure(
          message: 'Brands not found',
          statusCode: 404,
        );
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(notFoundFailure));

        // Act
        final expectedStates = [
          const BrandManagementLoading(),
          BrandManagementError(
            message: 'Brand tidak ditemukan',
            errorCode: 'NOT_FOUND',
          ),
        ];

        // Assert
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        bloc.add(const GetAllBrandsEvent());

        verify(() => mockGetAllBrandsUseCase(const NoParams())).called(1);
      });
    });
  });
}

// Mock classes for use cases
class MockGetAllBrandsUseCase extends Mock implements GetAllBrandsUseCase {
  MockGetAllBrandsUseCase() : super();

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) =>
      super.noSuchMethod(Invocation.method(#call, [params]));
}

class MockCreateBrandUseCase extends Mock implements CreateBrandUseCase {
  MockCreateBrandUseCase() : super();

  @override
  Future<Either<Failure, Brand>> call(CreateBrandParams params) =>
      super.noSuchMethod(Invocation.method(#call, [params]));
}

class MockUpdateBrandUseCase extends Mock implements UpdateBrandUseCase {
  MockUpdateBrandUseCase() : super();

  @override
  Future<Either<Failure, Brand>> call(UpdateBrandParams params) =>
      super.noSuchMethod(Invocation.method(#call, [params]));
}

class MockDeleteBrandUseCase extends Mock implements DeleteBrandUseCase {
  MockDeleteBrandUseCase() : super();

  @override
  Future<Either<Failure, void>> call(BrandIdParams params) =>
      super.noSuchMethod(Invocation.method(#call, [params]));
}
