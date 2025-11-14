import 'package:get_it/get_it.dart';
import '../../../../core/di/di_patterns.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/usecases/get_menu_items_usecase.dart';
import '../domain/usecases/get_user_dashboard_usecase.dart';
import '../presentation/bloc/home_bloc.dart';

/// Setup home feature dependencies using standardized patterns
Future<void> setupHomeDependencies(GetIt getIt) async {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();

  // Register data source with lazy singleton lifecycle
  getIt.registerWithMetadata<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      dioClient: dioClient,
      logger: logger,
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.datasource,
    name: DINaming.dataSource('Home'),
    description: 'Home remote data source for API communication',
  );

  // Register repository with lazy singleton lifecycle
  getIt.registerWithMetadata<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt(),
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.repository,
    name: DINaming.repository('Home'),
    description: 'Home repository for business logic coordination',
  );

  // Register use cases with lazy singleton lifecycle
  DICommonPatterns.registerUseCases(
    getIt,
    {
      DINaming.useCase('GetMenuItems', 'Home'): () => GetMenuItemsUseCase(getIt()),
      DINaming.useCase('GetUserDashboard', 'Home'): () => GetUserDashboardUseCase(getIt()),
    },
    lifecycle: DILifecycle.lazySingleton,
  );

  // Register BLoC with factory lifecycle (new instance each time)
  getIt.registerWithMetadata<HomeBloc>(
    () => HomeBloc(
      getMenuItemsUseCase: getIt(),
      getUserDashboardUseCase: getIt(),
    ),
    lifecycle: DILifecycle.factory,
    category: DICategory.bloc,
    name: DINaming.bloc('Home'),
    description: 'Home BLoC for home screen state management',
  );
}