import 'package:get_it/get_it.dart';
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
import '../domain/usecases/refresh_token_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/secure_storage_service.dart';

/// Register auth feature dependencies
void setupAuthDependencies(GetIt getIt) {
  // Get existing instances from core
  final logger = getIt<AppLogger>();
  final errorHandler = getIt<ErrorHandler>();

  // Register local datasource first
  getIt.registerSingleton<AuthLocalDatasource>(
    AuthLocalDatasourceImpl(
      logger: logger,
      prefs: getIt(),
      secureStorage: getIt<SecureStorageService>(),
    ),
  );

  // DioClient is already registered in core services, so we just get it
  final dioClient = getIt<DioClient>();

  // Register remote datasource with DioClient dependency
  getIt.registerSingleton<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(
      dioClient: getIt(),
      logger: logger,
      localDatasource: getIt(),
      deviceInfoService: getIt(),
    ),
  );

  // Register repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      errorHandler: errorHandler,
      logger: logger,
    ),
  );

  // Update DioClient with AuthRepository after registration
  final authRepository = getIt<AuthRepository>();
  dioClient.updateAuthRepository(authRepository);

  // Register usecases
  getIt.registerSingleton(
    LoginUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    RegisterUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    LogoutUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    CheckAuthUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    UpdateProfileUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    ChangePasswordUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    ForgotPasswordUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    ResetPasswordUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    VerifyEmailUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    ResendVerificationEmailUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    DeleteAccountUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    RefreshTokenUsecase(repository: getIt()),
  );

  // Register BLoC
  getIt.registerSingleton(
    AuthBloc(
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
      refreshTokenUsecase: getIt(),
    ),
  );
}
