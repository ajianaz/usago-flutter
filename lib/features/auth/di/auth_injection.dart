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
import '../../../../core/performance/performance_tracker.dart';

/// Register auth feature dependencies using simplified DI patterns
///
/// Function ini setup semua dependencies yang dibutuhkan oleh feature Auth
/// mengikuti clean architecture pattern:
///
/// 1. Data Layer (Data Sources & Repositories)
///    - AuthLocalDatasource: Untuk local storage dan caching
///    - AuthRemoteDatasource: Untuk API communication
///    - AuthRepository: Koordinator business logic
///
/// 2. Domain Layer (Use Cases)
///    - LoginUsecase: Handle login logic
///    - RegisterUsecase: Handle registration logic
///    - LogoutUsecase: Handle logout logic
///    - CheckAuthUsecase: Check authentication status
///    - UpdateProfileUsecase: Update user profile
///    - ChangePasswordUsecase: Change user password
///    - ForgotPasswordUsecase: Handle forgot password
///    - ResetPasswordUsecase: Reset password with token
///    - VerifyEmailUsecase: Verify email address
///    - ResendVerificationEmailUsecase: Resend verification
///    - DeleteAccountUsecase: Delete user account
///
/// 3. Presentation Layer (BLoC)
///    - AuthBloc: State management untuk authentication
///
/// Cara penggunaan:
/// ```dart
/// // Di main.dart atau setup dependencies
/// await setupDependencies();
///
/// // Di aplikasi, get dependency:
/// final authBloc = DIServiceLocator.get<AuthBloc>();
/// final loginUsecase = DIServiceLocator.get<LoginUsecase>();
/// ```
///
/// Lifecycle Strategy:
/// - Data Sources: Lazy Singleton (dibuat saat pertama digunakan)
/// - Repository: Lazy Singleton (single instance untuk consistency)
/// - Use Cases: Lazy Singleton (reuse untuk performance)
/// - BLoC: Factory (instance baru untuk setiap widget)
Future<void> setupAuthDependencies(GetIt getIt) async {
  // Get existing instances from core dependencies
  // Ini adalah dependencies yang sudah diregister di core layer
  final dioClient = DIServiceLocator.get<DioClient>();
  final logger = DIServiceLocator.get<AppLogger>();
  final errorHandler = DIServiceLocator.get<ErrorHandler>();
  final secureStorage = DIServiceLocator.get<SecureStorageService>();

  // === DATA LAYER REGISTRATION ===

  // Register local data source dengan lazy singleton
  //
  // Kenapa lazy singleton?
  // - Hanya butuh satu instance untuk seluruh app
  // - Membutuhkan dependencies (logger, secureStorage)
  // - Inisialisasi mahal, jadi dibuat saat dibutuhkan saja
  DIServiceLocator.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(logger: logger, secureStorage: secureStorage),
    name: DINaming.dataSource('Auth'),
    description: 'Auth local data source for caching and storage',
  );

  // Register remote data source dengan lazy singleton
  //
  // Kenapa lazy singleton?
  // - Butuh satu instance untuk konsistensi API calls
  // - Membutuhkan dependencies (dioClient, logger, localDatasource)
  // - Inisialisasi mahal (HTTP client setup)
  DIServiceLocator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dioClient: dioClient,
      logger: logger,
      localDatasource: DIServiceLocator.get<AuthLocalDatasource>(),
    ),
    name: DINaming.dataSource('AuthRemote'),
    description: 'Auth remote data source for API communication',
  );

  // Register repository dengan lazy singleton
  //
  // Kenapa lazy singleton?
  // - Single source of truth untuk data logic
  // - Koordinator antara remote dan local data sources
  // - Membutuhkan dependencies (data sources, error handler, logger)
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

  // === DOMAIN LAYER REGISTRATION ===

  // Register semua use cases dengan lazy singleton
  //
  // Kenapa lazy singleton untuk use cases?
  // - Stateless logic, bisa di-reuse
  // - Lebih efisien daripada membuat instance baru setiap kali
  // - Membutuhkan repository dependency
  DIServiceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Login', 'Auth'),
    description: 'Login use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Register', 'Auth'),
    description: 'Register use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('Logout', 'Auth'),
    description: 'Logout use case for authentication',
  );

  DIServiceLocator.registerLazySingleton<CheckAuthUsecase>(
    () => CheckAuthUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('CheckAuth', 'Auth'),
    description: 'Check authentication status use case',
  );

  DIServiceLocator.registerLazySingleton<UpdateProfileUsecase>(
    () => UpdateProfileUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('UpdateProfile', 'Auth'),
    description: 'Update profile use case',
  );

  DIServiceLocator.registerLazySingleton<ChangePasswordUsecase>(
    () => ChangePasswordUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('ChangePassword', 'Auth'),
    description: 'Change password use case',
  );

  DIServiceLocator.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('ForgotPassword', 'Auth'),
    description: 'Forgot password use case',
  );

  DIServiceLocator.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('ResetPassword', 'Auth'),
    description: 'Reset password use case',
  );

  DIServiceLocator.registerLazySingleton<VerifyEmailUsecase>(
    () => VerifyEmailUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('VerifyEmail', 'Auth'),
    description: 'Verify email use case',
  );

  DIServiceLocator.registerLazySingleton<ResendVerificationEmailUsecase>(
    () => ResendVerificationEmailUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('ResendVerificationEmail', 'Auth'),
    description: 'Resend verification email use case',
  );

  DIServiceLocator.registerLazySingleton<DeleteAccountUsecase>(
    () => DeleteAccountUsecase(repository: DIServiceLocator.get<AuthRepository>()),
    name: DINaming.useCase('DeleteAccount', 'Auth'),
    description: 'Delete account use case',
  );

  // === PRESENTATION LAYER REGISTRATION ===

  // Register AuthBloc dengan factory lifecycle
  //
  // Kenapa factory untuk BLoC?
  // - BLoC memiliki state, tidak bisa di-share antar widget
  // - Setiap widget butuh instance baru untuk state management yang independen
  // - Membutuhkan semua use cases sebagai dependencies
  DIServiceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: DIServiceLocator.get<LoginUseCase>(),
      registerUsecase: DIServiceLocator.get<RegisterUseCase>(),
      logoutUsecase: DIServiceLocator.get<LogoutUseCase>(),
      checkAuthUsecase: DIServiceLocator.get<CheckAuthUsecase>(),
      updateProfileUsecase: DIServiceLocator.get<UpdateProfileUsecase>(),
      changePasswordUsecase: DIServiceLocator.get<ChangePasswordUsecase>(),
      forgotPasswordUsecase: DIServiceLocator.get<ForgotPasswordUsecase>(),
      resetPasswordUsecase: DIServiceLocator.get<ResetPasswordUsecase>(),
      verifyEmailUsecase: DIServiceLocator.get<VerifyEmailUsecase>(),
      resendVerificationEmailUsecase: DIServiceLocator.get<ResendVerificationEmailUsecase>(),
      deleteAccountUsecase: DIServiceLocator.get<DeleteAccountUsecase>(),
      performanceTracker: DIServiceLocator.get<PerformanceTracker>(),
    ),
    name: DINaming.bloc('Auth'),
    description: 'Auth BLoC for authentication state management with performance monitoring',
  );
}
