import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'di_patterns.dart';
import '../network/dio_client.dart';
import '../utils/logger.dart';
import '../errors/error_handler.dart';
import '../services/locale_service.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/home/di/home_injection.dart';
// import '../../features/profile/di/profile_injection.dart';
// import '../../features/payment/di/payment_injection.dart';

final getIt = GetIt.instance;

/// Setup all dependencies using standardized patterns
/// Call this in main() before runApp()
Future<void> setupDependencies() async {
  // 1. Register core/infrastructure services
  await _setupCoreServices();

  // 2. Register feature-specific services
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);
  // setupProfileDependencies(getIt);
  // setupPaymentDependencies(getIt);

  // 3. Log all registered dependencies for debugging
  _logRegisteredDependencies();
}

/// Setup core layer services using standardized patterns
/// These have no dependencies on features
Future<void> _setupCoreServices() async {
  // Register shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerWithMetadata<SharedPreferences>(
    () => sharedPreferences,
    lifecycle: DILifecycle.singleton,
    category: DICategory.core,
    name: 'SharedPreferences',
    description: 'Shared preferences for local storage',
  );

  // Register core services using the common pattern
  DICommonPatterns.registerCoreServices(
    getIt,
    {
      'DioClient': () => DioClient(),
      'AppLogger': () => AppLogger(),
      'ErrorHandler': () => ErrorHandler(),
      'LocaleService': () => LocaleService(
        prefs: getIt(),
        logger: getIt(),
      ),
    },
  );
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