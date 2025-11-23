import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/network/dio_client.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/brand/domain/usecases/index.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_bloc.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_event.dart';
import 'package:usago/features/brand/presentation/bloc/brand_management/brand_management_state.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/features/brand/data/models/brand_model.dart';
import 'package:usago/features/brand/domain/usecases/common/params/brand_params.dart';
import 'package:usago/features/brand/domain/usecases/common/usecase.dart';
import '../../fixtures/brand_fixtures.dart';
import '../../widget/features/brand/presentation/bloc/brand_management_bloc_test.dart';

/// Integration tests for Get All Brands functionality
///
/// This test suite verifies:
/// - Complete end-to-end flow for getting all brands
/// - Real API communication (mocked)
/// - BLoC state management
/// - Error handling and recovery
/// - Data transformation and caching
void main() {
  group('Get All Brands Integration Tests', () {
    late DioClient dioClient;
    late Dio mockDio;
    late AppLogger logger;
    late BrandManagementBloc brandManagementBloc;

    setUpAll(() async {
      // Initialize logging
      logger = AppLogger();
    });

    setUp(() {
      // Setup mock Dio
      mockDio = MockDio();
      dioClient = DioClient();

      // Setup BLoC with mocked dependencies
      final mockGetAllBrandsUseCase = MockGetAllBrandsUseCase();
      brandManagementBloc = BrandManagementBloc(
        getAllBrandsUseCase: mockGetAllBrandsUseCase,
        createBrandUseCase: MockCreateBrandUseCase(),
        updateBrandUseCase: MockUpdateBrandUseCase(),
        deleteBrandUseCase: MockDeleteBrandUseCase(),
      );
    });

    tearDown(() {
      brandManagementBloc.close();
    });

    group('Successful Get All Brands Flow', () {
      testWidgets(
          'should complete full flow when API returns brands successfully',
          (WidgetTester tester) async {
        // Arrange
        final mockBrands = BrandFixtures.testBrandModelList;
        final brandsJson = mockBrands.map((brand) => brand.toJson()).toList();
        final brandEntities = BrandFixtures.testBrandList;

        final successResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': brandsJson,
            'message': 'Brands retrieved successfully',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => successResponse);

        // Stub the use case
        final mockGetAllBrandsUseCase = MockGetAllBrandsUseCase();
        when(() => mockGetAllBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right(brandEntities));

        // Recreate bloc with stubbed use case
        brandManagementBloc.close();
        brandManagementBloc = BrandManagementBloc(
          getAllBrandsUseCase: mockGetAllBrandsUseCase,
          createBrandUseCase: MockCreateBrandUseCase(),
          updateBrandUseCase: MockUpdateBrandUseCase(),
          deleteBrandUseCase: MockDeleteBrandUseCase(),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Check if BLoC emitted correct states
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.length, equals(mockBrands.length));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle empty brand list from API',
          (WidgetTester tester) async {
        // Arrange
        final emptyBrandsJson = <dynamic>[];
        final successResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': emptyBrandsJson,
            'message': 'No brands found',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => successResponse);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle empty list gracefully
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.isEmpty, isTrue);

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle large brand list from API',
          (WidgetTester tester) async {
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

        final brandsJson = largeBrandList
            .map((brand) => BrandModel.fromEntity(brand).toJson())
            .toList();
        final successResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': brandsJson,
            'message': 'Large brand list retrieved successfully',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => successResponse);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle large list
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.length, equals(100));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });
    });

    group('Error Handling in Get All Brands Flow', () {
      testWidgets('should handle API server error gracefully',
          (WidgetTester tester) async {
        // Arrange
        final errorResponse = Response<dynamic>(
          data: {
            'success': false,
            'message': 'Internal server error',
          },
          statusCode: 500,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/api/brands'),
          response: errorResponse,
          type: DioExceptionType.badResponse,
        ));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle server error
        expect(brandManagementBloc.state, isA<BrandManagementError>());
        final errorState = brandManagementBloc.state as BrandManagementError;
        expect(errorState.message, contains('Server error occurred'));
        expect(errorState.errorCode, equals('500'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle network error gracefully',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockDio.get('/api/brands')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/api/brands'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle network error
        expect(brandManagementBloc.state, isA<BrandManagementError>());
        final errorState = brandManagementBloc.state as BrandManagementError;
        expect(errorState.message, contains('Network error occurred'));
        expect(errorState.errorCode, equals('NETWORK_ERROR'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle unauthorized access gracefully',
          (WidgetTester tester) async {
        // Arrange
        final unauthorizedResponse = Response<dynamic>(
          data: {
            'success': false,
            'message': 'Unauthorized access to brands',
          },
          statusCode: 403,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/api/brands'),
          response: unauthorizedResponse,
          type: DioExceptionType.badResponse,
        ));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle unauthorized error
        expect(brandManagementBloc.state, isA<BrandManagementError>());
        final errorState = brandManagementBloc.state as BrandManagementError;
        expect(errorState.message, contains('Anda tidak memiliki izin'));
        expect(errorState.errorCode, equals('UNAUTHORIZED'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle not found error gracefully',
          (WidgetTester tester) async {
        // Arrange
        final notFoundResponse = Response<dynamic>(
          data: {
            'success': false,
            'message': 'No brands found',
          },
          statusCode: 404,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/api/brands'),
          response: notFoundResponse,
          type: DioExceptionType.badResponse,
        ));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle not found error
        expect(brandManagementBloc.state, isA<BrandManagementError>());
        final errorState = brandManagementBloc.state as BrandManagementError;
        expect(errorState.message, contains('Brand tidak ditemukan'));
        expect(errorState.errorCode, equals('NOT_FOUND'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });
    });

    group('Data Transformation and Validation', () {
      testWidgets('should properly transform API response to brand entities',
          (WidgetTester tester) async {
        // Arrange
        final apiBrandJson = {
          'id': 'test-brand-123',
          'name': 'Test Brand',
          'slug': 'test-brand',
          'ownerId': 'test-owner-123',
          'businessType': 'RETAIL',
          'timezone': 'Asia/Jakarta',
          'currency': 'IDR',
          'subscriptionTier': 'BASIC',
          'subscriptionStatus': 'ACTIVE',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-02T00:00:00.000Z',
        };

        final successResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': [apiBrandJson],
            'message': 'Brand retrieved successfully',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => successResponse);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should properly transform data
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.length, equals(1));

        final brand = loadedState.brands.first;
        expect(brand.id, equals('test-brand-123'));
        expect(brand.name, equals('Test Brand'));
        expect(brand.slug, equals('test-brand'));
        expect(brand.businessType, equals('RETAIL'));
        expect(brand.timezone, equals('Asia/Jakarta'));
        expect(brand.currency, equals('IDR'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });

      testWidgets('should handle malformed JSON response gracefully',
          (WidgetTester tester) async {
        // Arrange
        final malformedResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': 'not an array', // Malformed data
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => malformedResponse);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger get all brands
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle malformed data gracefully
        expect(brandManagementBloc.state, isA<BrandManagementError>());
        final errorState = brandManagementBloc.state as BrandManagementError;
        expect(errorState.message, contains('Invalid response format'));

        // Verify API call was made
        verify(() => mockDio.get('/api/brands')).called(1);
      });
    });

    group('Performance and Edge Cases', () {
      testWidgets('should handle rapid successive calls correctly',
          (WidgetTester tester) async {
        // Arrange
        final firstBrands = [BrandFixtures.testBrandModel];
        final secondBrands = BrandFixtures.testBrandModelList;

        final firstResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': [firstBrands.first.toJson()],
            'message': 'First call successful',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        final secondResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': secondBrands.map((brand) => brand.toJson()).toList(),
            'message': 'Second call successful',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => firstResponse);

        // Act - First call
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Reset mock for second call
        reset(mockDio);
        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => secondResponse);

        // Act - Second call
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Both calls should succeed
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.length, equals(secondBrands.length));

        // Verify both API calls were made
        verify(() => mockDio.get('/api/brands')).called(2);
      });

      testWidgets('should handle concurrent calls safely',
          (WidgetTester tester) async {
        // Arrange
        final successResponse = Response<dynamic>(
          data: {
            'success': true,
            'data': BrandFixtures.testBrandModelList
                .map((brand) => brand.toJson())
                .toList(),
            'message': 'Brands retrieved successfully',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/brands'),
        );

        when(() => mockDio.get('/api/brands'))
            .thenAnswer((_) async => successResponse);

        // Act - Trigger multiple concurrent calls
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<BrandManagementBloc>.value(
              value: brandManagementBloc,
              child: Scaffold(
                body: BrandListTestWidget(bloc: brandManagementBloc),
              ),
            ),
          ),
        );

        // Trigger multiple concurrent calls
        brandManagementBloc.add(const GetAllBrandsEvent());
        brandManagementBloc.add(const GetAllBrandsEvent());
        brandManagementBloc.add(const GetAllBrandsEvent());
        await tester.pumpAndSettle();

        // Assert - Should handle concurrent calls safely
        expect(
            brandManagementBloc.state, isA<BrandManagementAllBrandsLoaded>());
        final loadedState =
            brandManagementBloc.state as BrandManagementAllBrandsLoaded;
        expect(loadedState.brands.length,
            equals(BrandFixtures.testBrandModelList.length));

        // Verify at least one API call was made
        verify(() => mockDio.get('/api/brands')).called(greaterThan(0));
      });
    });
  });
}

/// Test widget for brand list integration testing
class BrandListTestWidget extends StatelessWidget {
  final BrandManagementBloc bloc;

  const BrandListTestWidget({required this.bloc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandManagementBloc, BrandManagementState>(
      bloc: bloc,
      builder: (context, state) {
        // Build UI based on current state
        if (state is BrandManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BrandManagementAllBrandsLoaded) {
          return Center(
            child: Text('Loaded ${state.brands.length} brands'),
          );
        } else if (state is BrandManagementError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        return const Center(child: Text('Initial State'));
      },
    );
  }
}

/// Mock Dio class for testing
class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      super.noSuchMethod(Invocation.method(#get, [
        path,
        data,
        queryParameters,
        options,
        cancelToken,
        onReceiveProgress
      ]));
}
