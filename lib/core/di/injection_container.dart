import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../utils/logger.dart';
import '../errors/error_handler.dart';
import '../services/locale_service.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/home/di/home_injection.dart';
// import '../../features/profile/di/profile_injection.dart';
// import '../../features/payment/di/payment_injection.dart';

final getIt = GetIt.instance;

/// Setup all dependencies
/// Call this in main() before runApp()
Future<void> setupDependencies() async {
  // 1. Register core/infrastructure services
  await _setupCoreServices();

  // 2. Register feature-specific services
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);
  // setupProfileDependencies(getIt);
  // setupPaymentDependencies(getIt);
}

/// Setup core layer services
/// These have no dependencies on features
Future<void> _setupCoreServices() async {
  // Register shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  // Register Dio HTTP client
  getIt.registerSingleton(DioClient());

  // Register Logger
  getIt.registerSingleton(AppLogger());

  // Register Error Handler
  getIt.registerSingleton(ErrorHandler());

  // Register Locale Service
  getIt.registerSingleton(LocaleService(
    prefs: sharedPreferences,
    logger: getIt(),
  ));

}

/// Reset all dependencies
/// Useful for testing
Future<void> resetDependencies() async {
  await getIt.reset();
}