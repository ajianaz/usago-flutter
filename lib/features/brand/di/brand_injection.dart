import 'package:get_it/get_it.dart';
import '../data/datasources/brand_remote_datasource.dart';
import '../data/datasources/brand_remote_datasource_impl.dart';
import '../data/datasources/brand_local_datasource.dart';
import '../data/datasources/brand_local_datasource_impl.dart';
import '../data/repositories/brand_repository_impl.dart';
import '../domain/repositories/brand_repository.dart';
import '../presentation/bloc/brand_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/errors/error_handler.dart';

/// Register brand feature dependencies
void setupBrandDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();
  final errorHandler = getIt<ErrorHandler>();

  // Register local datasource first
  getIt.registerSingleton<BrandLocalDataSource>(
    BrandLocalDataSourceImpl(getIt<AppLogger>()),
  );

  // Register remote datasource with local datasource dependency
  getIt.registerSingleton<BrandRemoteDataSource>(
    BrandRemoteDataSourceImpl(
      getIt<DioClient>(),
      getIt<AppLogger>(),
    ),
  );

  // Register repository
  getIt.registerSingleton<BrandRepository>(
    BrandRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      logger: logger,
    ),
  );

  // Register BLoC
  getIt.registerSingleton<BrandBloc>(
    BrandBloc(
      brandRepository: getIt(),
    ),
  );
}