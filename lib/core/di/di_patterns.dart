import 'package:get_it/get_it.dart';

/// Standardized Dependency Injection Patterns for Usago Mobile App
/// Simplified version to avoid type inference issues

enum DILifecycle {
  singleton,
  lazySingleton,
  factory,
}

enum DICategory {
  core,
  datasource,
  repository,
  usecase,
  bloc,
  presentation,
  external,
}

/// Metadata untuk dokumentasi
class DIDependency {
  final String name;
  final DICategory category;
  final DILifecycle lifecycle;
  final String description;

  const DIDependency({
    required this.name,
    required this.category,
    required this.lifecycle,
    this.description = '',
  });
}

/// Registry untuk tracking dependencies
class DIDependencyRegistry {
  static final List<DIDependency> _dependencies = [];

  static void register(DIDependency dependency) {
    _dependencies.add(dependency);
  }

  static List<DIDependency> get all => List.unmodifiable(_dependencies);

  static List<DIDependency> getByCategory(DICategory category) {
    return _dependencies.where((dep) => dep.category == category).toList();
  }

  static void clear() {
    _dependencies.clear();
  }
}

/// Simplified DI helper - NO GENERIC COMPLEXITY!
class DIServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  /// Register singleton dengan instance langsung
  static void registerSingleton<T extends Object>(
    T instance, {
    String name = '',
    String description = '',
  }) {
    _getIt.registerSingleton<T>(instance);

    DIDependencyRegistry.register(DIDependency(
      name: name.isNotEmpty ? name : T.toString(),
      category: DICategory.core,
      lifecycle: DILifecycle.singleton,
      description: description,
    ));
  }

  /// Register lazy singleton dengan factory
  static void registerLazySingleton<T extends Object>(
    T Function() factory, {
    String name = '',
    String description = '',
  }) {
    _getIt.registerLazySingleton<T>(factory);

    DIDependencyRegistry.register(DIDependency(
      name: name.isNotEmpty ? name : T.toString(),
      category: DICategory.core,
      lifecycle: DILifecycle.lazySingleton,
      description: description,
    ));
  }

  /// Register factory
  static void registerFactory<T extends Object>(
    T Function() factory, {
    String name = '',
    String description = '',
  }) {
    _getIt.registerFactory<T>(factory);

    DIDependencyRegistry.register(DIDependency(
      name: name.isNotEmpty ? name : T.toString(),
      category: DICategory.core,
      lifecycle: DILifecycle.factory,
      description: description,
    ));
  }

  /// Get dependency dengan type yang jelas
  static T get<T extends Object>() {
    return _getIt<T>();
  }
}

/// Standard naming conventions
class DINaming {
  /// Standard naming for data sources
  static String dataSource(String feature) => '${feature}DataSource';

  /// Standard naming for repositories
  static String repository(String feature) => '${feature}Repository';

  /// Standard naming for use cases
  static String useCase(String action, String feature) => '${action}${feature}UseCase';

  /// Standard naming for BLoCs
  static String bloc(String feature) => '${feature}Bloc';

  /// Standard naming for services
  static String service(String name) => '${name}Service';
}