import 'package:get_it/get_it.dart';
// import '../data/datasources/auth_remote_datasource.dart';
// import '../data/datasources/auth_remote_datasource_impl.dart';
// import '../data/datasources/auth_local_datasource.dart';
// import '../data/datasources/auth_local_datasource_impl.dart';
// import '../data/repositories/auth_repository_impl.dart';
// import '../domain/repositories/auth_repository.dart';
// import '../domain/usecases/login_usecase.dart';
// import '../domain/usecases/logout_usecase.dart';
// import '../domain/usecases/check_auth_usecase.dart';
// import '../presentation/bloc/auth_bloc.dart';
// import '../../../../core/network/dio_client.dart';

/// Register auth feature dependencies
void setupAuthDependencies(GetIt getIt) {
  // Get existing instances from core
  // final dioClient = getIt<DioClient>();

  // Register datasources
  // getIt.registerSingleton<AuthRemoteDatasource>(
  //   AuthRemoteDatasourceImpl(dioClient: dioClient),
  // );

  // getIt.registerSingleton<AuthLocalDatasource>(
  //   AuthLocalDatasourceImpl(),
  // );

  // Register repository
  // getIt.registerSingleton<AuthRepository>(
  //   AuthRepositoryImpl(
  //     remoteDatasource: getIt(),
  //     localDatasource: getIt(),
  //   ),
  // );

  // Register usecases
  // getIt.registerSingleton(
  //   LoginUsecase(repository: getIt()),
  // );
  // getIt.registerSingleton(
  //   LogoutUsecase(repository: getIt()),
  // );
  // getIt.registerSingleton(
  //   CheckAuthUsecase(repository: getIt()),
  // );

  // Register BLoC
  // getIt.registerSingleton(
  //   AuthBloc(
  //     loginUsecase: getIt(),
  //     logoutUsecase: getIt(),
  //     checkAuthUsecase: getIt(),
  //   ),
  // );
}