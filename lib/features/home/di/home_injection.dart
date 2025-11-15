import 'package:get_it/get_it.dart';
import '../../../../core/di/di_patterns.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/performance/performance_tracker.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/usecases/get_menu_items_usecase.dart';
import '../domain/usecases/get_user_dashboard_usecase.dart';
import '../presentation/bloc/home_bloc.dart';

/// Setup home feature dependencies using simplified patterns
Future<void> setupHomeDependencies(GetIt getIt) async {
  // Get existing instances from core
  final dioClient = DIServiceLocator.get<DioClient>();
  final logger = DIServiceLocator.get<AppLogger>();

  // Register data source with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      dioClient: dioClient,
      logger: logger,
    ),
    name: DINaming.dataSource('Home'),
    description: 'Home remote data source for API communication',
  );

  // Register repository with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: DIServiceLocator.get<HomeRemoteDataSource>(),
    ),
    name: DINaming.repository('Home'),
    description: 'Home repository for business logic coordination',
  );

  // Register use cases individually with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<GetMenuItemsUseCase>(
    () => GetMenuItemsUseCase(DIServiceLocator.get<HomeRepository>()),
    name: DINaming.useCase('GetMenuItems', 'Home'),
    description: 'Get menu items use case',
  );

  DIServiceLocator.registerLazySingleton<GetUserDashboardUseCase>(
    () => GetUserDashboardUseCase(DIServiceLocator.get<HomeRepository>()),
    name: DINaming.useCase('GetUserDashboard', 'Home'),
    description: 'Get user dashboard use case',
  );

  // Register BLoC with factory lifecycle (new instance each time)
  DIServiceLocator.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMenuItemsUseCase: DIServiceLocator.get<GetMenuItemsUseCase>(),
      getUserDashboardUseCase: DIServiceLocator.get<GetUserDashboardUseCase>(),
      performanceTracker: DIServiceLocator.get<PerformanceTracker>(),
    ),
    name: DINaming.bloc('Home'),
    description: 'Home BLoC for home screen state management',
  );
}
