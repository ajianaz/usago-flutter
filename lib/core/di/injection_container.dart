import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../services/secure_storage_service.dart';
import '../services/session_service.dart';
import '../utils/logger.dart';
import '../errors/error_handler.dart';
import '../errors/better_auth_error_handler.dart';
import '../services/locale_service.dart';
import '../services/device_info_service.dart';
import '../config/logging_config.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/brand/di/brand_injection.dart';
// import '../../features/profile/di/profile_injection.dart';
// import '../../features/payment/di/payment_injection.dart';

final getIt = GetIt.instance;

/// Setup all dependencies
/// Call this in main() before runApp()
Future<void> setupDependencies() async {
  // 0. Initialize environment variables
  await LoggingConfig.initialize();

  // 1. Register core/infrastructure services
  await _setupCoreServices();

  // 2. Register feature-specific services
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);
  setupBrandDependencies(getIt);
}

/// Setup core layer services
/// These have no dependencies on features
Future<void> _setupCoreServices() async {
  // 1. Register shared preferences (no dependencies)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  // 2. Register Logging Configuration (no dependencies)
  final loggingConfig = LoggingConfig.fromEnvironment();
  getIt.registerSingleton(loggingConfig);

  // 3. Register Logger with configuration (depends on LoggingConfig)
  final logger = AppLogger(loggingConfig);
  getIt.registerSingleton(logger);

  // 4. Register Device Info Service (no dependencies)
  getIt.registerSingleton(DeviceInfoService());

  // 5. Register Secure Storage Service (depends on AppLogger)
  final secureStorageService = SecureStorageService(logger: logger);
  await secureStorageService.initialize();
  getIt.registerSingleton(secureStorageService);

  // 6. Register Dio HTTP client (depends on AppLogger)
  final dioClient = DioClient(logger: logger);
  getIt.registerSingleton(dioClient);

  // 6b. Register Dio instance separately for services that need it
  getIt.registerSingleton<Dio>(dioClient.dio);

  // 7. Register Error Handlers (no dependencies)
  getIt.registerSingleton(ErrorHandler());
  getIt.registerSingleton(BetterAuthErrorHandler(logger: logger));

  // 8. Register Locale Service (depends on SharedPreferences, AppLogger)
  getIt.registerSingleton(LocaleService(
    prefs: sharedPreferences,
    logger: logger,
  ));

  // 9. Register Session Service (depends on multiple services)
  getIt.registerSingleton(SessionService(
    dio: getIt<Dio>(),
    secureStorage: secureStorageService,
    deviceInfoService: getIt(),
    errorHandler: getIt(),
    logger: logger,
  ));
}

/// Reset all dependencies
/// Useful for testing
Future<void> resetDependencies() async {
  await getIt.reset();
}
