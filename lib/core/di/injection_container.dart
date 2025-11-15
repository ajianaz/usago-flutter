import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'di_patterns.dart';
import '../network/dio_client.dart';
import '../utils/logger.dart';
import '../errors/error_handler.dart';
import '../services/locale_service.dart';
import '../services/secure_storage_service.dart';
import '../services/performance_service.dart';
import '../performance/performance_tracker.dart';
import '../performance/memory_manager.dart';
import '../performance/bloc_monitor.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/home/di/home_injection.dart';
// import '../../features/profile/di/profile_injection.dart';
// import '../../features/payment/di/payment_injection.dart';

final GetIt getIt = GetIt.instance;

/// Setup all dependencies using standardized patterns
/// Call this in main() before runApp()
Future<void> setupDependencies() async {
  // 1. Register core/infrastructure services
  await _setupCoreServices();

  // 2. Initialize performance services
  await _initializePerformanceServices();

  // 3. Register feature-specific services
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);
  // setupProfileDependencies(getIt);
  // setupPaymentDependencies(getIt);

  // 4. Log all registered dependencies for debugging
  _logRegisteredDependencies();
}

/// Setup core layer services using standardized patterns
/// These have no dependencies on features
Future<void> _setupCoreServices() async {
  // Register shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  DIServiceLocator.registerSingleton<SharedPreferences>(
    sharedPreferences,
    name: 'SharedPreferences',
    description: 'Shared preferences for local storage',
  );

  // Register secure storage
  const secureStorage = FlutterSecureStorage();
  DIServiceLocator.registerSingleton<FlutterSecureStorage>(
    secureStorage,
    name: 'FlutterSecureStorage',
    description: 'Secure storage for sensitive data',
  );

  // Register core services directly
  DIServiceLocator.registerSingleton<DioClient>(
    DioClient(),
    name: 'DioClient',
    description: 'HTTP client for API communication',
  );

  DIServiceLocator.registerSingleton<AppLogger>(
    AppLogger(),
    name: 'AppLogger',
    description: 'Application logger',
  );

  DIServiceLocator.registerSingleton<ErrorHandler>(
    ErrorHandler(),
    name: 'ErrorHandler',
    description: 'Global error handler',
  );

  DIServiceLocator.registerLazySingleton<LocaleService>(
    () => LocaleService(
      prefs: DIServiceLocator.get<SharedPreferences>(),
      logger: DIServiceLocator.get<AppLogger>(),
    ),
    name: 'LocaleService',
    description: 'Locale management service',
  );

  DIServiceLocator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(
      secureStorage: DIServiceLocator.get<FlutterSecureStorage>(),
      prefs: DIServiceLocator.get<SharedPreferences>(),
      logger: DIServiceLocator.get<AppLogger>(),
    ),
    name: 'SecureStorageService',
    description: 'Secure storage service wrapper',
  );

  // Register performance services
  DIServiceLocator.registerSingleton<PerformanceTracker>(
    PerformanceTracker(),
    name: 'PerformanceTracker',
    description: 'Performance metrics tracker',
  );

  DIServiceLocator.registerSingleton<MemoryManager>(
    MemoryManager(),
    name: 'MemoryManager',
    description: 'Memory usage monitor and manager',
  );

  DIServiceLocator.registerSingleton<BlocMonitor>(
    BlocMonitor(),
    name: 'BlocMonitor',
    description: 'BLoC performance monitor',
  );

  DIServiceLocator.registerSingleton<PerformanceService>(
    PerformanceService(),
    name: 'PerformanceService',
    description: 'Centralized performance management service',
  );
}

/// Initialize performance services after all dependencies are registered
Future<void> _initializePerformanceServices() async {
  try {
    final logger = getIt<AppLogger>();
    logger.info('Initializing performance services...');

    // Get performance service
    final performanceService = getIt<PerformanceService>();

    // Initialize performance service with config from AppConfig
    await performanceService.initialize();

    logger.info('Performance services initialized successfully');
  } catch (e, stackTrace) {
    final logger = getIt<AppLogger>();
    logger.error('Failed to initialize performance services', e, stackTrace);
    // Continue without performance services - don't crash the app
  }
}

/// Log all registered dependencies for debugging and documentation
void _logRegisteredDependencies() {
  final allDeps = DIDependencyRegistry.all;

  if (allDeps.isNotEmpty) {
    final logger = getIt<AppLogger>();
    logger.info('=== Registered Dependencies (${allDeps.length}) ===');

    // Group by category
    for (final category in DICategory.values) {
      final categoryDeps = DIDependencyRegistry.getByCategory(category);
      if (categoryDeps.isNotEmpty) {
        logger.info('\n${category.name.toUpperCase()}:');
        for (final dep in categoryDeps) {
          logger.info('  - ${dep.name} (${dep.lifecycle.name})');
          if (dep.description.isNotEmpty) {
            logger.info('    ${dep.description}');
          }
        }
      }
    }
    logger.info('=== End of Dependencies ===');
  }
}

/// Reset all dependencies
/// Useful for testing
Future<void> resetDependencies() async {
  await getIt.reset();
  DIDependencyRegistry.clear();
}

/// Get dependency information for debugging
class DIInfo {
  static List<DIDependency> getAllDependencies() => DIDependencyRegistry.all;

  static List<DIDependency> getDependenciesByCategory(DICategory category) {
    return DIDependencyRegistry.getByCategory(category);
  }

  static DIDependency? getDependencyByName(String name) {
    try {
      return DIDependencyRegistry.all.firstWhere((dep) => dep.name == name);
    } catch (e) {
      return null;
    }
  }
}
