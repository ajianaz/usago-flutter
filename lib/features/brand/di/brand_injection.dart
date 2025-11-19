import 'package:get_it/get_it.dart';
import '../data/datasources/brand_remote_datasource.dart';
import '../data/datasources/brand_remote_datasource_impl.dart';
import '../data/datasources/brand_local_datasource.dart';
import '../data/datasources/brand_local_datasource_impl.dart';
import '../data/repositories/brand_repository_impl.dart';
import '../domain/repositories/brand_repository.dart';
import '../domain/usecases/index.dart';
import '../presentation/bloc/brand_bloc.dart';
// Import BLoCs baru
import '../presentation/bloc/brand_management/brand_management_bloc.dart';
import '../presentation/bloc/brand_list/brand_list_bloc.dart';
import '../presentation/bloc/brand_search/brand_search_bloc.dart';
import '../presentation/bloc/brand_switching/brand_switching_bloc.dart';
import '../presentation/bloc/brand_invitation/brand_invitation_bloc.dart';
import '../presentation/helpers/index.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';

/// Brand Feature Dependency Injection Configuration
///
/// This class handles the registration of all brand feature dependencies
/// including data sources, repositories, use cases, BLoCs, and helpers.
///
/// Lifecycle Management:
/// - Data Sources: LazySingleton (heavy objects that should be reused)
/// - Repositories: LazySingleton (stateless business logic)
/// - Use Cases: LazySingleton (stateless business logic)
/// - BLoCs: Factory (stateful, new instance per widget tree)
/// - Helpers: LazySingleton (utility functions)
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    try {
      await _registerDataSources(getIt);
      await _registerRepositories(getIt);
      await _registerUseCases(getIt);
      await _registerBlocs(getIt);
      await _registerHelpers(getIt);
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Brand dependencies: $e');
      rethrow;
    }
  }

  /// Register data sources with lazy loading for performance
  static Future<void> _registerDataSources(GetIt getIt) async {
    // Remote data source - LazySingleton untuk HTTP client yang heavy
    getIt.registerLazySingleton<BrandRemoteDataSource>(
      () => BrandRemoteDataSourceImpl(
        getIt<DioClient>(),
        getIt<AppLogger>(),
      ),
    );

    // Local data source - LazySingleton untuk shared preferences
    getIt.registerLazySingleton<BrandLocalDataSource>(
      () => BrandLocalDataSourceImpl(
        getIt<AppLogger>(),
      ),
    );
  }

  /// Register repositories with lazy loading
  static Future<void> _registerRepositories(GetIt getIt) async {
    getIt.registerLazySingleton<BrandRepository>(
      () => BrandRepositoryImpl(
        remoteDataSource: getIt<BrandRemoteDataSource>(),
        localDataSource: getIt<BrandLocalDataSource>(),
        logger: getIt<AppLogger>(),
      ),
    );
  }

  /// Register all use cases with lazy loading
  static Future<void> _registerUseCases(GetIt getIt) async {
    // Get current user ID from auth service (TODO: Implement proper auth service)
    final currentUserId = 'current_user_id';

    // Brand Use Cases
    getIt.registerLazySingleton<GetUserBrandsUseCase>(
      () => GetUserBrandsUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<GetAccessibleBrandsUseCase>(
      () => GetAccessibleBrandsUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<GetActiveBrandUseCase>(
      () => GetActiveBrandUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<CreateBrandUseCase>(
      () => CreateBrandUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<UpdateBrandUseCase>(
      () => UpdateBrandUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<DeleteBrandUseCase>(
      () => DeleteBrandUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<SwitchActiveBrandUseCase>(
      () => SwitchActiveBrandUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<SearchBrandsUseCase>(
      () => SearchBrandsUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    // Invitation Use Cases
    getIt.registerLazySingleton<GetBrandInvitationsUseCase>(
      () => GetBrandInvitationsUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<CreateBrandInvitationUseCase>(
      () => CreateBrandInvitationUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<AcceptBrandInvitationUseCase>(
      () => AcceptBrandInvitationUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<RejectBrandInvitationUseCase>(
      () => RejectBrandInvitationUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );

    getIt.registerLazySingleton<RevokeBrandInvitationUseCase>(
      () => RevokeBrandInvitationUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: currentUserId,
      ),
    );
  }

  /// Register BLoCs with factory pattern for proper lifecycle management
  static Future<void> _registerBlocs(GetIt getIt) async {
    // Brand Management BLoC - Factory untuk state management yang proper
    getIt.registerFactory<BrandManagementBloc>(
      () => BrandManagementBloc(
        createBrandUseCase: getIt<CreateBrandUseCase>(),
        updateBrandUseCase: getIt<UpdateBrandUseCase>(),
        deleteBrandUseCase: getIt<DeleteBrandUseCase>(),
      ),
    );

    // Brand List BLoC - Factory untuk state management yang proper
    getIt.registerFactory<BrandListBloc>(
      () => BrandListBloc(
        getUserBrandsUseCase: getIt<GetUserBrandsUseCase>(),
        getAccessibleBrandsUseCase: getIt<GetAccessibleBrandsUseCase>(),
        getActiveBrandUseCase: getIt<GetActiveBrandUseCase>(),
      ),
    );

    // Brand Search BLoC - Factory untuk state management yang proper
    getIt.registerFactory<BrandSearchBloc>(
      () => BrandSearchBloc(
        searchBrandsUseCase: getIt<SearchBrandsUseCase>(),
      ),
    );

    // Brand Switching BLoC - Factory untuk state management yang proper
    getIt.registerFactory<BrandSwitchingBloc>(
      () => BrandSwitchingBloc(
        switchActiveBrandUseCase: getIt<SwitchActiveBrandUseCase>(),
        getActiveBrandUseCase: getIt<GetActiveBrandUseCase>(),
      ),
    );

    // Brand Invitation BLoC - Factory untuk state management yang proper
    getIt.registerFactory<BrandInvitationBloc>(
      () => BrandInvitationBloc(
        getBrandInvitationsUseCase: getIt<GetBrandInvitationsUseCase>(),
        createBrandInvitationUseCase: getIt<CreateBrandInvitationUseCase>(),
        acceptBrandInvitationUseCase: getIt<AcceptBrandInvitationUseCase>(),
        rejectBrandInvitationUseCase: getIt<RejectBrandInvitationUseCase>(),
        revokeBrandInvitationUseCase: getIt<RevokeBrandInvitationUseCase>(),
      ),
    );

    // Legacy BrandBloc (deprecated) - Factory untuk backward compatibility
    getIt.registerFactory<BrandBloc>(
      () => BrandBloc(
        brandRepository: getIt<BrandRepository>(),
      ),
    );
  }

  /// Register helper classes with lazy loading
  static Future<void> _registerHelpers(GetIt getIt) async {
    // Formatters dan helpers - tidak perlu di-register karena static methods
    // BrandFormatter dan InvitationFormatter menggunakan static methods
    // jadi tidak perlu dependency injection
  }

  /// Reset all brand dependencies
  /// Useful for testing and reinitialization
  static Future<void> reset(GetIt getIt) async {
    try {
      // Reset only brand-related dependencies
      getIt.unregister<BrandRemoteDataSource>();
      getIt.unregister<BrandLocalDataSource>();
      getIt.unregister<BrandRepository>();

      // Reset use cases
      getIt.unregister<GetUserBrandsUseCase>();
      getIt.unregister<GetAccessibleBrandsUseCase>();
      getIt.unregister<GetActiveBrandUseCase>();
      getIt.unregister<CreateBrandUseCase>();
      getIt.unregister<UpdateBrandUseCase>();
      getIt.unregister<DeleteBrandUseCase>();
      getIt.unregister<SwitchActiveBrandUseCase>();
      getIt.unregister<SearchBrandsUseCase>();
      getIt.unregister<GetBrandInvitationsUseCase>();
      getIt.unregister<CreateBrandInvitationUseCase>();
      getIt.unregister<AcceptBrandInvitationUseCase>();
      getIt.unregister<RejectBrandInvitationUseCase>();
      getIt.unregister<RevokeBrandInvitationUseCase>();

      // Reset BLoCs
      getIt.unregister<BrandManagementBloc>();
      getIt.unregister<BrandListBloc>();
      getIt.unregister<BrandSearchBloc>();
      getIt.unregister<BrandSwitchingBloc>();
      getIt.unregister<BrandInvitationBloc>();
      getIt.unregister<BrandBloc>();

      // Reset helpers
      getIt.unregister<BrandFormatter>();
      getIt.unregister<InvitationFormatter>();

      getIt<AppLogger>().info('Brand dependencies reset successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to reset Brand dependencies: $e');
      rethrow;
    }
  }
}

/// Legacy function for backward compatibility
/// @deprecated Use BrandInjection.init() instead
void setupBrandDependencies(GetIt getIt) {
  BrandInjection.init(getIt);
}

/// Mock NetworkInfo class (TODO: Implement proper NetworkInfo)
class NetworkInfo {
  Future<bool> get isConnected async => true;
}
