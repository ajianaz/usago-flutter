import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import '../data/datasources/brand_remote_datasource.dart';
import '../data/datasources/brand_local_datasource.dart';
import '../domain/repositories/brand_repository.dart';
import '../domain/entities/brand.dart';
import '../domain/entities/brand_invitation.dart';
import '../domain/usecases/index.dart';
import '../presentation/bloc/brand_management/brand_management_bloc.dart';
import '../presentation/bloc/brand_list/brand_list_bloc.dart';
import '../presentation/bloc/brand_search/brand_search_bloc.dart';
import '../presentation/bloc/brand_switching/brand_switching_bloc.dart';
import '../presentation/bloc/brand_invitation/brand_invitation_bloc.dart';
import '../presentation/bloc/brand_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/error_handler.dart';

/// Brand Feature Test Dependency Injection Configuration
///
/// This class handles the registration of mock dependencies for testing
/// all brand feature components including BLoCs, use cases, and repositories.
class BrandInjectionTest {
  static Future<void> initTest(GetIt getIt) async {
    try {
      await _registerMockDataSources(getIt);
      await _registerMockRepositories(getIt);
      await _registerMockUseCases(getIt);
      await _registerMockBlocs(getIt);
      await _registerMockHelpers(getIt);
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Brand test dependencies: $e');
      rethrow;
    }
  }

  /// Register mock data sources for testing
  static Future<void> _registerMockDataSources(GetIt getIt) async {
    // Mock remote data source - akan di-override di test
    // getIt.registerLazySingleton<BrandRemoteDataSource>(
    //   () => MockBrandRemoteDataSource(),
    // );

    // Mock local data source - akan di-override di test
    // getIt.registerLazySingleton<BrandLocalDataSource>(
    //   () => MockBrandLocalDataSource(),
    // );
  }

  /// Register mock repositories for testing
  static Future<void> _registerMockRepositories(GetIt getIt) async {
    // Mock repository - akan di-override di test
    // getIt.registerLazySingleton<BrandRepository>(
    //   () => MockBrandRepository(),
    // );
  }

  /// Register mock use cases for testing
  static Future<void> _registerMockUseCases(GetIt getIt) async {
    // Get current user ID for testing
    final currentUserId = 'test_user_id';

    // Mock use cases - akan di-override di test
    // getIt.registerLazySingleton<GetUserBrandsUseCase>(
    //   () => MockGetUserBrandsUseCase(),
    // );
    // ... dan seterusnya untuk semua use cases
  }

  /// Register mock BLoCs for testing
  static Future<void> _registerMockBlocs(GetIt getIt) async {
    // Mock BLoCs - akan di-override di test
    // getIt.registerFactory<BrandManagementBloc>(
    //   () => MockBrandManagementBloc(),
    // );
    // ... dan seterusnya untuk semua BLoCs
  }

  /// Register mock helpers for testing
  static Future<void> _registerMockHelpers(GetIt getIt) async {
    // Mock helpers akan di-override di test masing-masing
    // getIt.registerLazySingleton<AppLogger>(() => MockAppLogger());
    // getIt.registerLazySingleton<DioClient>(() => MockDioClient());
    // getIt.registerLazySingleton<ErrorHandler>(() => MockErrorHandler());
  }

  /// Reset all test dependencies
  static Future<void> resetTest(GetIt getIt) async {
    try {
      // Reset all brand-related test dependencies
      getIt.reset();

      // Re-register core mocks
      await _registerMockHelpers(getIt);

      getIt<AppLogger>().info('Brand test dependencies reset successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to reset Brand test dependencies: $e');
      rethrow;
    }
  }

  /// Setup test environment with specific mocks
  static Future<void> setupTestEnvironment(
    GetIt getIt, {
    BrandRepository? brandRepository,
    BrandRemoteDataSource? remoteDataSource,
    BrandLocalDataSource? localDataSource,
    AppLogger? logger,
  }) async {
    // Reset dependencies first
    await resetTest(getIt);

    // Register custom mocks if provided
    if (brandRepository != null) {
      getIt.registerLazySingleton<BrandRepository>(() => brandRepository);
    }

    if (remoteDataSource != null) {
      getIt.registerLazySingleton<BrandRemoteDataSource>(() => remoteDataSource);
    }

    if (localDataSource != null) {
      getIt.registerLazySingleton<BrandLocalDataSource>(() => localDataSource);
    }

    if (logger != null) {
      getIt.registerLazySingleton<AppLogger>(() => logger);
    }

    // Re-register use cases and BLoCs with custom dependencies
    await _registerMockUseCases(getIt);
    await _registerMockBlocs(getIt);
  }
}

/// Test helper functions for brand feature testing
class BrandTestHelper {
  /// Create a mock brand entity for testing
  static Brand createMockBrand({
    String id = 'test-brand-id',
    String name = 'Test Brand',
    String slug = 'test-brand',
    String businessType = 'RETAIL',
    String? industry = 'Technology',
    String? description = 'Test brand description',
    String ownerId = 'test-owner-id',
    Map<String, dynamic>? settings,
    String timezone = 'Asia/Jakarta',
    String currency = 'IDR',
    String subscriptionTier = 'BASIC',
    String subscriptionStatus = 'ACTIVE',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id,
      name: name,
      slug: slug,
      businessType: businessType,
      industry: industry,
      description: description,
      ownerId: ownerId,
      settings: settings ?? {},
      timezone: timezone,
      currency: currency,
      subscriptionTier: subscriptionTier,
      subscriptionStatus: subscriptionStatus,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Create a mock brand invitation entity for testing
  static BrandInvitation createMockInvitation({
    String id = 'test-invitation-id',
    String brandId = 'test-brand-id',
    String brandName = 'Test Brand',
    String inviterId = 'test-inviter-id',
    String inviterName = 'Test Inviter',
    String inviteeEmail = 'test@example.com',
    String role = 'BRAND_MEMBER',
    String status = 'PENDING',
    List<String> branchIds = const [],
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return BrandInvitation(
      id: id,
      brandId: brandId,
      brandName: brandName,
      inviterId: inviterId,
      inviterName: inviterName,
      inviteeEmail: inviteeEmail,
      role: role,
      status: status,
      branchIds: branchIds,
      createdAt: createdAt ?? DateTime.now(),
      expiresAt: expiresAt ?? DateTime.now().add(const Duration(days: 7)),
    );
  }

  /// Create a test widget with brand BLoCs
  static Widget createTestWidget({
    required Widget child,
    BrandManagementBloc? brandManagementBloc,
    BrandListBloc? brandListBloc,
    BrandSearchBloc? brandSearchBloc,
    BrandSwitchingBloc? brandSwitchingBloc,
    BrandInvitationBloc? brandInvitationBloc,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Wait for BLoC to complete processing
  static Future<void> waitForBloc(dynamic bloc) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Pump and wait for BLoC events
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pump();
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }
}

// Mock class definitions (these should be generated with mockito build_runner)
// Run: flutter packages pub run build_runner build
@GenerateMocks([
  BrandRemoteDataSource,
  BrandLocalDataSource,
  BrandRepository,
  GetUserBrandsUseCase,
  GetAccessibleBrandsUseCase,
  GetActiveBrandUseCase,
  CreateBrandUseCase,
  UpdateBrandUseCase,
  DeleteBrandUseCase,
  SwitchActiveBrandUseCase,
  SearchBrandsUseCase,
  GetBrandInvitationsUseCase,
  CreateBrandInvitationUseCase,
  AcceptBrandInvitationUseCase,
  RejectBrandInvitationUseCase,
  RevokeBrandInvitationUseCase,
  BrandManagementBloc,
  BrandListBloc,
  BrandSearchBloc,
  BrandSwitchingBloc,
  BrandInvitationBloc,
  BrandBloc,
  AppLogger,
  DioClient,
  ErrorHandler,
])
void main() {}