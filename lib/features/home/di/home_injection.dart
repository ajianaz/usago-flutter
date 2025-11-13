import 'package:get_it/get_it.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/usecases/get_menu_items_usecase.dart';
import '../domain/usecases/get_user_dashboard_usecase.dart';
import '../presentation/bloc/home_bloc.dart';

/// Setup home feature dependencies
Future<void> setupHomeDependencies(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      dioClient: getIt(),
      logger: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetMenuItemsUseCase>(
    () => GetMenuItemsUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetUserDashboardUseCase>(
    () => GetUserDashboardUseCase(getIt()),
  );

  // BLoC
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMenuItemsUseCase: getIt(),
      getUserDashboardUseCase: getIt(),
    ),
  );
}