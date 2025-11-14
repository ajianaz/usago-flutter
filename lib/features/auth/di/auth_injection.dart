import 'package:get_it/get_it.dart';
import '../../../../core/di/di_patterns.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_local_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/check_auth_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/reset_password_usecase.dart';
import '../domain/usecases/verify_email_usecase.dart';
import '../domain/usecases/resend_verification_email_usecase.dart';
import '../domain/usecases/delete_account_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/secure_storage_service.dart';

/// Register auth feature dependencies using simplified patterns
void setupAuthDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = DIServiceLocator.get<DioClient>();
  final logger = DIServiceLocator.get<AppLogger>();
  final errorHandler = DIServiceLocator.get<ErrorHandler>();
  final secureStorage = DIServiceLocator.get<SecureStorageService>();

  // Register data sources with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(logger: logger, secureStorage: secureStorage),
    name: DINaming.dataSource('Auth'),
    description: 'Auth local data source for caching and storage',
  );

  DIServiceLocator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dioClient: dioClient,
      logger: logger,
      localDatasource: DIServiceLocator.get<AuthLocalDatasource>(),
    ),
    name: DINaming.dataSource('AuthRemote'),
    description: 'Auth remote data source for API communication',
  );

  // Register repository with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: DIServiceLocator.get<AuthRemoteDatasource>(),
      localDatasource: DIServiceLocator.get<AuthLocalDatasource>(),
      errorHandler: errorHandler,
      logger: logger,
    ),
    name: DINaming.repository('Auth'),
    description: 'Auth repository for business logic coordination',
  );

  // Register use cases individually with lazy singleton lifecycle
  DIServiceLocator.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Login', 'Auth'),
    description: 'Login use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Register', 'Auth'),
    description: 'Register use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Logout', 'Auth'),
    description: 'Logout use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<CheckAuthUsecase>(
    () => CheckAuthUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('CheckAuth', 'Auth'),
    description: 'Check authentication status use case',
  );

  DIServiceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: DIServiceLocator.get<LoginUsecase>(),
      registerUsecase: DIServiceLocator.get<RegisterUsecase>(),
      logoutUsecase: DIServiceLocator.get<LogoutUsecase>(),
      checkAuthUsecase: DIServiceLocator.get<CheckAuthUsecase>(),
    ),
    name: DINaming.bloc('Auth'),
    description: 'Auth BLoC for authentication state management',
  );
}
