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

/// Register auth feature dependencies using standardized patterns
void setupAuthDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();
  final errorHandler = getIt<ErrorHandler>();

  // Register data sources with lazy singleton lifecycle
  getIt.registerWithMetadata<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(logger: logger, prefs: getIt()),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.datasource,
    name: DINaming.dataSource('Auth'),
    description: 'Auth local data source for caching and storage',
  );

  getIt.registerWithMetadata<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dioClient: dioClient,
      logger: logger,
      localDatasource: getIt(),
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.datasource,
    name: DINaming.dataSource('AuthRemote'),
    description: 'Auth remote data source for API communication',
  );

  // Register repository with lazy singleton lifecycle
  getIt.registerWithMetadata<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      errorHandler: errorHandler,
      logger: logger,
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.repository,
    name: DINaming.repository('Auth'),
    description: 'Auth repository for business logic coordination',
  );

  // Register use cases with lazy singleton lifecycle
  DICommonPatterns.registerUseCases(
    getIt,
    {
      DINaming.useCase('Login', 'Auth'): () => LoginUsecase(repository: getIt()),
      DINaming.useCase('Register', 'Auth'): () => RegisterUsecase(repository: getIt()),
      DINaming.useCase('Logout', 'Auth'): () => LogoutUsecase(repository: getIt()),
      DINaming.useCase('CheckAuth', 'Auth'): () => CheckAuthUsecase(repository: getIt()),
      DINaming.useCase('UpdateProfile', 'Auth'): () => UpdateProfileUsecase(repository: getIt()),
      DINaming.useCase('ChangePassword', 'Auth'): () => ChangePasswordUsecase(repository: getIt()),
      DINaming.useCase('ForgotPassword', 'Auth'): () => ForgotPasswordUsecase(repository: getIt()),
      DINaming.useCase('ResetPassword', 'Auth'): () => ResetPasswordUsecase(repository: getIt()),
      DINaming.useCase('VerifyEmail', 'Auth'): () => VerifyEmailUsecase(repository: getIt()),
      DINaming.useCase('ResendVerificationEmail', 'Auth'): () => ResendVerificationEmailUsecase(repository: getIt()),
      DINaming.useCase('DeleteAccount', 'Auth'): () => DeleteAccountUsecase(repository: getIt()),
    },
    lifecycle: DILifecycle.lazySingleton,
  );

  // Register BLoC with factory lifecycle (new instance each time)
  getIt.registerWithMetadata<AuthBloc>(
    () => AuthBloc(
      loginUsecase: getIt(),
      registerUsecase: getIt(),
      logoutUsecase: getIt(),
      checkAuthUsecase: getIt(),
      updateProfileUsecase: getIt(),
      changePasswordUsecase: getIt(),
      forgotPasswordUsecase: getIt(),
      resetPasswordUsecase: getIt(),
      verifyEmailUsecase: getIt(),
      resendVerificationEmailUsecase: getIt(),
      deleteAccountUsecase: getIt(),
    ),
    lifecycle: DILifecycle.factory,
    category: DICategory.bloc,
    name: DINaming.bloc('Auth'),
    description: 'Auth BLoC for authentication state management',
  );
}