import 'package:get_it/get_it.dart';

/// Standardized Dependency Injection Patterns for Usago Mobile App
///
/// This file defines consistent patterns for registering dependencies
/// to ensure maintainability and predictability across the application.

/// Dependency lifecycle types
enum DILifecycle {
  /// Single instance throughout app lifetime
  /// Use for: HTTP clients, services, repositories
  singleton,

  /// Single instance created when first accessed
  /// Use for: Heavy objects, data sources
  lazySingleton,

  /// New instance every time it's requested
  /// Use for: BLoCs, use cases, stateful objects
  factory,
}

/// Standardized dependency registration helper
class DIRegistry {
  final GetIt getIt;

  DIRegistry(this.getIt);

  /// Register singleton dependency
  void registerSingleton<T extends Object>(T instance) {
    getIt.registerSingleton<T>(instance);
  }

  /// Register lazy singleton dependency
  void registerLazySingleton<T extends Object>(T Function() factoryFunc) {
    getIt.registerLazySingleton<T>(factoryFunc);
  }

  /// Register factory dependency
  void registerFactory<T extends Object>(T Function() factoryFunc) {
    getIt.registerFactory<T>(factoryFunc);
  }

  /// Register dependency with specified lifecycle
  void register<T extends Object>(
    T Function() factoryFunc, {
    DILifecycle lifecycle = DILifecycle.factory,
    T? instance,
  }) {
    switch (lifecycle) {
      case DILifecycle.singleton:
        if (instance != null) {
          getIt.registerSingleton<T>(instance);
        } else {
          getIt.registerSingleton<T>(factoryFunc());
        }
        break;
      case DILifecycle.lazySingleton:
        getIt.registerLazySingleton<T>(factoryFunc);
        break;
      case DILifecycle.factory:
        getIt.registerFactory<T>(factoryFunc);
        break;
    }
  }
}

/// Standard dependency categories for consistent organization
enum DICategory {
  /// Core infrastructure services (HTTP client, logger, etc.)
  core,

  /// Data sources (remote and local)
  datasource,

  /// Repository implementations
  repository,

  /// Domain use cases
  usecase,

  /// BLoC state management
  bloc,

  /// Presentation widgets and utilities
  presentation,

  /// External services and third-party integrations
  external,
}

/// Dependency metadata for documentation and debugging
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

/// Collection of all registered dependencies for documentation
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

/// Extension methods for GetIt to support standardized registration
extension GetItExtensions on GetIt {
  /// Register with metadata tracking
  void registerWithMetadata<T extends Object>(
    T Function() factoryFunc, {
    DILifecycle lifecycle = DILifecycle.factory,
    DICategory category = DICategory.core,
    String name = '',
    String description = '',
    T? instance,
  }) {
    // Register dependency
    switch (lifecycle) {
      case DILifecycle.singleton:
        if (instance != null) {
          registerSingleton<T>(instance);
        } else {
          registerSingleton<T>(factoryFunc());
        }
        break;
      case DILifecycle.lazySingleton:
        registerLazySingleton<T>(factoryFunc);
        break;
      case DILifecycle.factory:
        registerFactory<T>(factoryFunc);
        break;
    }

    // Track metadata
    DIDependencyRegistry.register(DIDependency(
      name: name.isNotEmpty ? name : T.toString(),
      category: category,
      lifecycle: lifecycle,
      description: description,
    ));
  }
}

/// Standard naming conventions for dependency registration
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

/// Common registration patterns
class DICommonPatterns {
  /// Register a complete feature layer (data source, repository, use cases, BLoC)
  static void registerFeature<TDataSource extends Object, TRepository extends Object, TBloc extends Object>(
    GetIt getIt, {
    required TDataSource Function() dataSourceFactory,
    required TRepository Function(TDataSource) repositoryFactory,
    required TBloc Function(TRepository) blocFactory,
    required String featureName,
    DILifecycle dataSourceLifecycle = DILifecycle.lazySingleton,
    DILifecycle repositoryLifecycle = DILifecycle.lazySingleton,
    DILifecycle blocLifecycle = DILifecycle.factory,
  }) {
    // Register data source
    getIt.registerWithMetadata<TDataSource>(
      dataSourceFactory,
      lifecycle: dataSourceLifecycle,
      category: DICategory.datasource,
      name: DINaming.dataSource(featureName),
      description: '$featureName data source implementation',
    );

    // Register repository
    getIt.registerWithMetadata<TRepository>(
      () => repositoryFactory(getIt<TDataSource>()),
      lifecycle: repositoryLifecycle,
      category: DICategory.repository,
      name: DINaming.repository(featureName),
      description: '$featureName repository implementation',
    );

    // Register BLoC
    getIt.registerWithMetadata<TBloc>(
      () => blocFactory(getIt<TRepository>()),
      lifecycle: blocLifecycle,
      category: DICategory.bloc,
      name: DINaming.bloc(featureName),
      description: '$featureName BLoC for state management',
    );
  }

  /// Register multiple use cases for a feature
  static void registerUseCases<T extends Object>(
    GetIt getIt,
    Map<String, T Function()> useCaseFactories, {
    DILifecycle lifecycle = DILifecycle.lazySingleton,
  }) {
    useCaseFactories.forEach((name, factory) {
      getIt.registerWithMetadata<T>(
        factory,
        lifecycle: lifecycle,
        category: DICategory.usecase,
        name: name,
        description: 'Use case: $name',
      );
    });
  }

  /// Register core services with standard lifecycle
  static void registerCoreServices<T extends Object>(
    GetIt getIt,
    Map<String, T Function()> services, {
    DILifecycle lifecycle = DILifecycle.singleton,
  }) {
    services.forEach((name, factory) {
      getIt.registerWithMetadata<T>(
        factory,
        lifecycle: lifecycle,
        category: DICategory.core,
        name: name,
        description: 'Core service: $name',
      );
    });
  }
}