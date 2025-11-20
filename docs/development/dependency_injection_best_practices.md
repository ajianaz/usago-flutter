# Dependency Injection Best Practices

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [GetIt Configuration Patterns](#getit-configuration-patterns)
3. [Avoiding Double Registration](#avoiding-double-registration)
4. [Proper Dependency Scoping](#proper-dependency-scoping)
5. [Feature-Specific Injection](#feature-specific-injection)
6. [Testing with Mocked Dependencies](#testing-with-mocked-dependencies)
7. [Lifecycle Management](#lifecycle-management)
8. [Common Pitfalls](#common-pitfalls)
9. [Code Examples](#code-examples)

---

## 🎯 Overview

This guide provides comprehensive best practices for implementing Dependency Injection (DI) in the Usago Flutter project using GetIt. Following these practices ensures maintainable, testable, and scalable dependency management.

### Key Principles

1. **Never register the same dependency multiple times**
2. **Use appropriate scoping for different dependency types**
3. **Organize dependencies by feature**
4. **Implement proper reset mechanisms for testing**
5. **Use lazy loading for performance optimization**

---

## ⚙️ GetIt Configuration Patterns

### Core Service Registration

```dart
// ✅ GOOD - Structured core service setup
Future<void> _setupCoreServices() async {
  // Register shared preferences first (dependency for other services)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  // Register HTTP client
  getIt.registerSingleton(DioClient());

  // Register Logger
  getIt.registerSingleton(AppLogger());

  // Register Error Handler
  getIt.registerSingleton(ErrorHandler());

  // Register Locale Service (depends on SharedPreferences and Logger)
  getIt.registerSingleton(LocaleService(
    prefs: getIt(),
    logger: getIt(),
  ));
}

// ❌ BAD - Unorganized setup
Future<void> _setupCoreServices() async {
  getIt.registerSingleton(DioClient());
  getIt.registerSingleton(AppLogger());
  getIt.registerSingleton(LocaleService()); // Missing dependencies!
  getIt.registerSingleton(ErrorHandler());
  // No SharedPreferences registration!
}
```

### Dependency Registration Order

```dart
// ✅ GOOD - Correct dependency order
Future<void> setupDependencies() async {
  // 1. Register core/infrastructure services first
  await _setupCoreServices();

  // 2. Register feature-specific services (can depend on core)
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);
  setupBrandDependencies(getIt);
}

// ❌ BAD - Wrong dependency order
Future<void> setupDependencies() async {
  // Feature dependencies before core services
  setupAuthDependencies(getIt); // ERROR! Core services not ready yet
  setupBrandDependencies(getIt); // ERROR! Core services not ready yet

  await _setupCoreServices(); // Too late!
}
```

### Error Handling in Setup

```dart
// ✅ GOOD - Proper error handling
Future<void> setupDependencies() async {
  try {
    await _setupCoreServices();
    setupAuthDependencies(getIt);
    setupHomeDependencies(getIt);
    setupBrandDependencies(getIt);

    getIt<AppLogger>().info('All dependencies registered successfully');
  } catch (e, stackTrace) {
    getIt<AppLogger>().error('Failed to setup dependencies', e, stackTrace);
    rethrow;
  }
}

// ❌ BAD - No error handling
Future<void> setupDependencies() async {
  await _setupCoreServices();
  setupAuthDependencies(getIt);
  setupBrandDependencies(getIt);
  // No error handling or logging!
}
```

---

## 🚫 Avoiding Double Registration

### Registration Check Pattern

```dart
// ✅ GOOD - Check before registration
static Future<void> _registerRepositories(GetIt getIt) async {
  // Check if already registered
  if (!getIt.isRegistered<BrandRepository>()) {
    getIt.registerLazySingleton<BrandRepository>(
      () => BrandRepositoryImpl(
        remoteDataSource: getIt<BrandRemoteDataSource>(),
        localDataSource: getIt<BrandLocalDataSource>(),
        logger: getIt<AppLogger>(),
      ),
    );
  }
}

// ❌ BAD - Double registration
static Future<void> _registerRepositories(GetIt getIt) async {
  getIt.registerLazySingleton<BrandRepository>(...); // First registration
  getIt.registerLazySingleton<BrandRepository>(...); // ERROR! Double registration
}
```

### Safe Registration Utility

```dart
// ✅ GOOD - Safe registration utility
class DIUtils {
  static void registerSafe<T extends Object>(
    GetIt getIt,
    T Function() factoryFunc, {
    bool isSingleton = false,
    bool isLazy = true,
  }) {
    if (!getIt.isRegistered<T>()) {
      if (isSingleton) {
        if (isLazy) {
          getIt.registerLazySingleton<T>(factoryFunc);
        } else {
          getIt.registerSingleton<T>(factoryFunc());
        }
      } else {
        getIt.registerFactory<T>(factoryFunc);
      }
    }
  }

  static void unregisterSafe<T extends Object>(GetIt getIt) {
    try {
      if (getIt.isRegistered<T>()) {
        getIt.unregister<T>();
      }
    } catch (e) {
      getIt<AppLogger>().warning('Failed to unregister $T: $e');
    }
  }
}

// Usage
static Future<void> _registerRepositories(GetIt getIt) async {
  DIUtils.registerSafe<BrandRepository>(
    getIt,
    () => BrandRepositoryImpl(
      remoteDataSource: getIt<BrandRemoteDataSource>(),
      localDataSource: getIt<BrandLocalDataSource>(),
      logger: getIt<AppLogger>(),
    ),
    isSingleton: true,
    isLazy: true,
  );
}
```

### Reset and Re-register Pattern

```dart
// ✅ GOOD - Safe reset and re-register
static Future<void> resetAndRegister(GetIt getIt) async {
  try {
    // Reset existing dependencies
    await reset(getIt);

    // Re-register with new configuration
    await init(getIt);

    getIt<AppLogger>().info('Dependencies reset and re-registered successfully');
  } catch (e) {
    getIt<AppLogger>().error('Failed to reset and register dependencies', e);
    rethrow;
  }
}

// ❌ BAD - Unsafe reset
static Future<void> resetAndRegister(GetIt getIt) async {
  reset(getIt); // Might throw if not registered
  init(getIt);   // Might cause double registration
}
```

---

## 🎯 Proper Dependency Scoping

### Scoping Guidelines

```dart
// ✅ GOOD - Correct scoping patterns
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    // Data Sources - LazySingleton (heavy objects, should be reused)
    getIt.registerLazySingleton<BrandRemoteDataSource>(
      () => BrandRemoteDataSourceImpl(
        dioClient: getIt<DioClient>(),
        logger: getIt<AppLogger>(),
      ),
    );

    // Repositories - LazySingleton (stateless business logic)
    getIt.registerLazySingleton<BrandRepository>(
      () => BrandRepositoryImpl(
        remoteDataSource: getIt<BrandRemoteDataSource>(),
        localDataSource: getIt<BrandLocalDataSource>(),
        logger: getIt<AppLogger>(),
      ),
    );

    // Use Cases - LazySingleton (stateless business logic)
    getIt.registerLazySingleton<GetUserBrandsUseCase>(
      () => GetUserBrandsUseCase(
        repository: getIt<BrandRepository>(),
        currentUserId: 'current_user_id',
      ),
    );

    // BLoCs - Factory (stateful, new instance per widget)
    getIt.registerFactory<BrandListBloc>(
      () => BrandListBloc(
        getUserBrandsUseCase: getIt<GetUserBrandsUseCase>(),
        getAccessibleBrandsUseCase: getIt<GetAccessibleBrandsUseCase>(),
        getActiveBrandUseCase: getIt<GetActiveBrandUseCase>(),
      ),
    );
  }
}

// ❌ BAD - Wrong scoping
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    // BLoC as Singleton - Wrong! Should be Factory
    getIt.registerSingleton<BrandListBloc>(
      () => BrandListBloc(...),
    );

    // Data Source as Factory - Wrong! Should be LazySingleton
    getIt.registerFactory<BrandRemoteDataSource>(
      () => BrandRemoteDataSourceImpl(...),
    );
  }
}
```

### When to Use Each Scope

| Scope Type | Use Case | Examples | Lifetime |
|------------|----------|-----------|-----------|
| **Singleton** | Global state, configuration | AppLogger, DioClient, ErrorHandler | App lifetime |
| **LazySingleton** | Heavy objects, stateless services | Repository, UseCase, DataSource | App lifetime, created on first use |
| **Factory** | Stateful objects, per-widget instances | BLoC, ViewModel, FormController | Per request/widget |

### Performance Considerations

```dart
// ✅ GOOD - Performance-optimized registration
static Future<void> _registerDataSources(GetIt getIt) async {
  // Heavy HTTP client - LazySingleton for performance
  getIt.registerLazySingleton<BrandRemoteDataSource>(
    () {
      final dioClient = getIt<DioClient>();
      final logger = getIt<AppLogger>();

      logger.info('Initializing BrandRemoteDataSource...');

      return BrandRemoteDataSourceImpl(
        dioClient: dioClient,
        logger: logger,
      );
    },
  );

  // Lightweight local data source - LazySingleton
  getIt.registerLazySingleton<BrandLocalDataSource>(
    () {
      final logger = getIt<AppLogger>();

      logger.info('Initializing BrandLocalDataSource...');

      return BrandLocalDataSourceImpl(logger: logger);
    },
  );
}

// ❌ BAD - Performance issues
static Future<void> _registerDataSources(GetIt getIt) async {
  // Creating heavy objects immediately - Wrong!
  getIt.registerSingleton<BrandRemoteDataSource>(
    BrandRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
      logger: getIt<AppLogger>(),
    ),
  );

  // Creating expensive objects on every request - Wrong!
  getIt.registerFactory<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
      logger: getIt<AppLogger>(),
    ),
  );
}
```

---

## 🏗️ Feature-Specific Injection

### Feature Injection Structure

```dart
// ✅ GOOD - Well-organized feature injection
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    try {
      await _registerDataSources(getIt);
      await _registerRepositories(getIt);
      await _registerUseCases(getIt);
      await _registerBlocs(getIt);
      await _registerHelpers(getIt);

      getIt<AppLogger>().info('Brand dependencies initialized successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Brand dependencies: $e');
      rethrow;
    }
  }

  static Future<void> _registerDataSources(GetIt getIt) async {
    // Implementation...
  }

  static Future<void> _registerRepositories(GetIt getIt) async {
    // Implementation...
  }

  static Future<void> _registerUseCases(GetIt getIt) async {
    // Implementation...
  }

  static Future<void> _registerBlocs(GetIt getIt) async {
    // Implementation...
  }

  static Future<void> _registerHelpers(GetIt getIt) async {
    // Implementation...
  }
}
```

### Feature Dependency Management

```dart
// ✅ GOOD - Complete feature dependency management
class BrandInjection {
  /// Initialize all brand feature dependencies
  static Future<void> init(GetIt getIt) async {
    try {
      await _registerDataSources(getIt);
      await _registerRepositories(getIt);
      await _registerUseCases(getIt);
      await _registerBlocs(getIt);

      getIt<AppLogger>().info('Brand dependencies initialized successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Brand dependencies: $e');
      rethrow;
    }
  }

  /// Reset all brand feature dependencies
  static Future<void> reset(GetIt getIt) async {
    try {
      // Reset in reverse order of registration
      await _resetBlocs(getIt);
      await _resetUseCases(getIt);
      await _resetRepositories(getIt);
      await _resetDataSources(getIt);

      getIt<AppLogger>().info('Brand dependencies reset successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to reset Brand dependencies: $e');
      rethrow;
    }
  }

  /// Check if brand dependencies are registered
  static bool isInitialized(GetIt getIt) {
    return getIt.isRegistered<BrandRemoteDataSource>() &&
           getIt.isRegistered<BrandRepository>() &&
           getIt.isRegistered<GetUserBrandsUseCase>() &&
           getIt.isRegistered<BrandListBloc>();
  }
}
```

### Cross-Feature Dependencies

```dart
// ✅ GOOD - Proper cross-feature dependency handling
class AuthInjection {
  static Future<void> init(GetIt getIt) async {
    try {
      // Auth dependencies can depend on core services
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: getIt<AuthRemoteDataSource>(),
          localDataSource: getIt<AuthLocalDataSource>(),
          logger: getIt<AppLogger>(),
        ),
      );

      // Auth BLoC can use use cases
      getIt.registerFactory<AuthBloc>(
        () => AuthBloc(
          loginUseCase: getIt<LoginUseCase>(),
          registerUseCase: getIt<RegisterUseCase>(),
          logoutUseCase: getIt<LogoutUseCase>(),
        ),
      );

      getIt<AppLogger>().info('Auth dependencies initialized successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Auth dependencies: $e');
      rethrow;
    }
  }
}

// ❌ BAD - Cross-feature direct dependencies
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    // WRONG! Direct dependency on another feature's implementation
    getIt.registerLazySingleton<BrandRepository>(
      () => BrandRepositoryImpl(
        authRepository: getIt<AuthRepository>(), // Wrong! Should use abstraction
      ),
    );
  }
}
```

---

## 🧪 Testing with Mocked Dependencies

### Test Setup with Mocks

```dart
// ✅ GOOD - Proper test setup with mocks
void main() {
  group('BrandListBloc Tests', () {
    late BrandListBloc bloc;
    late MockGetUserBrandsUseCase mockGetUserBrandsUseCase;
    late MockGetAccessibleBrandsUseCase mockGetAccessibleBrandsUseCase;
    late MockGetActiveBrandUseCase mockGetActiveBrandUseCase;
    late GetIt testGetIt;

    setUp(() async {
      // Create test GetIt instance
      testGetIt = GetIt.asNewInstance();

      // Register mocks
      testGetIt.registerSingleton<GetUserBrandsUseCase>(mockGetUserBrandsUseCase);
      testGetIt.registerSingleton<GetAccessibleBrandsUseCase>(mockGetAccessibleBrandsUseCase);
      testGetIt.registerSingleton<GetActiveBrandUseCase>(mockGetActiveBrandUseCase);

      // Create BLoC with mocked dependencies
      bloc = BrandListBloc(
        getUserBrandsUseCase: testGetIt<GetUserBrandsUseCase>(),
        getAccessibleBrandsUseCase: testGetIt<GetAccessibleBrandsUseCase>(),
        getActiveBrandUseCase: testGetIt<GetActiveBrandUseCase>(),
      );
    });

    tearDown(() {
      bloc.close();
      testGetIt.reset();
    });

    blocTest<BrandListBloc, BrandListState>(
      'emits [BrandListLoading, UserBrandsLoaded] when LoadUserBrandsEvent is added',
      setUp: () {
        when(() => mockGetUserBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Right([testBrand]));
      },
      act: (bloc) => bloc.add(const LoadUserBrandsEvent()),
      expect: () => [
        const BrandListLoading(),
        UserBrandsLoaded(userBrands: [testBrand]),
      ],
    );
  });
}

// ❌ BAD - Testing with real dependencies
void main() {
  group('BrandListBloc Tests', () {
    late BrandListBloc bloc;

    setUp(() async {
      // WRONG! Using real dependencies in tests
      await setupDependencies(); // Sets up real services!
      bloc = BrandListBloc(
        getUserBrandsUseCase: getIt<GetUserBrandsUseCase>(),
        getAccessibleBrandsUseCase: getIt<GetAccessibleBrandsUseCase>(),
        getActiveBrandUseCase: getIt<GetActiveBrandUseCase>(),
      );
    });

    tearDown(() {
      bloc.close();
      resetDependencies();
    });

    // Tests will be slow and unreliable!
  });
}
```

### Mock Registration Utility

```dart
// ✅ GOOD - Mock registration utility
class TestDIUtils {
  static GetIt setupTestDI() {
    final testGetIt = GetIt.asNewInstance();

    // Register common test mocks
    testGetIt.registerSingleton<AppLogger>(MockAppLogger());
    testGetIt.registerSingleton<DioClient>(MockDioClient());
    testGetIt.registerSingleton<SharedPreferences>(MockSharedPreferences());

    return testGetIt;
  }

  static void registerMock<T extends Object>(GetIt getIt, T mock) {
    if (!getIt.isRegistered<T>()) {
      getIt.registerSingleton<T>(mock);
    }
  }

  static T getMock<T extends Object>(GetIt getIt) {
    return getIt<T>();
  }
}

// Usage in tests
void main() {
  group('BrandRepository Tests', () {
    late BrandRepository repository;
    late MockBrandRemoteDataSource mockRemoteDataSource;
    late MockBrandLocalDataSource mockLocalDataSource;
    late GetIt testGetIt;

    setUp(() {
      testGetIt = TestDIUtils.setupTestDI();

      mockRemoteDataSource = MockBrandRemoteDataSource();
      mockLocalDataSource = MockBrandLocalDataSource();

      TestDIUtils.registerMock(testGetIt, mockRemoteDataSource);
      TestDIUtils.registerMock(testGetIt, mockLocalDataSource);

      repository = BrandRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        logger: testGetIt<AppLogger>(),
      );
    });

    tearDown(() {
      testGetIt.reset();
    });
  });
}
```

### Integration Test Setup

```dart
// ✅ GOOD - Integration test with real DI but test data
void main() {
  group('Brand Feature Integration Tests', () {
    late GetIt testGetIt;

    setUpAll(() async {
      testGetIt = GetIt.asNewInstance();

      // Setup real infrastructure but with test configuration
      await _setupTestInfrastructure(testGetIt);

      // Setup feature dependencies
      await BrandInjection.init(testGetIt);
    });

    tearDownAll(() {
      testGetIt.reset();
    });

    test('Complete brand loading flow', () async {
      final brandListBloc = testGetIt<BrandListBloc>();

      brandListBloc.add(const LoadAllBrandDataEvent());

      await expectLater(
        brandListBloc.stream,
        emitsInOrder([
          const BrandListLoading(),
          isA<BrandListLoaded>(),
        ]),
      );
    });
  });

  Future<void> _setupTestInfrastructure(GetIt getIt) async {
    // Register test-specific infrastructure
    getIt.registerSingleton<DioClient>(TestDioClient());
    getIt.registerSingleton<SharedPreferences>(TestSharedPreferences());
    getIt.registerSingleton<AppLogger>(TestAppLogger());
  }
}
```

---

## 🔄 Lifecycle Management

### Initialization Lifecycle

```dart
// ✅ GOOD - Proper initialization lifecycle
class DependencyManager {
  static bool _isInitialized = false;
  static GetIt? _getIt;

  static Future<void> initialize() async {
    if (_isInitialized) {
      return; // Already initialized
    }

    _getIt = GetIt.instance;

    try {
      await setupDependencies(_getIt!);
      _isInitialized = true;

      _getIt!.get<AppLogger>().info('Dependencies initialized successfully');
    } catch (e) {
      _getIt!.get<AppLogger>().error('Failed to initialize dependencies', e);
      rethrow;
    }
  }

  static bool get isInitialized => _isInitialized;
  static GetIt get getIt => _getIt ?? GetIt.instance;
}

// Usage in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyManager.initialize();

  runApp(const MyApp());
}
```

### Reset and Re-initialization

```dart
// ✅ GOOD - Safe reset and re-initialization
class DependencyManager {
  static Future<void> reset() async {
    if (!_isInitialized) {
      return; // Not initialized, nothing to reset
    }

    try {
      // Reset feature dependencies first
      await BrandInjection.reset(_getIt!);
      await AuthInjection.reset(_getIt!);
      await HomeInjection.reset(_getIt!);

      // Reset core dependencies last
      await _resetCoreDependencies(_getIt!);

      _isInitialized = false;

      _getIt!.get<AppLogger>().info('Dependencies reset successfully');
    } catch (e) {
      _getIt!.get<AppLogger>().error('Failed to reset dependencies', e);
      rethrow;
    }
  }

  static Future<void> reinitialize() async {
    await reset();
    await initialize();
  }
}

// ❌ BAD - Unsafe reset operations
class DependencyManager {
  static Future<void> reset() async {
    // WRONG! No initialization check
    getIt.reset(); // Might throw if not initialized

    // WRONG! No error handling
    BrandInjection.reset(getIt); // Might throw if not registered
  }
}
```

### Hot Reload Support

```dart
// ✅ GOOD - Hot reload safe DI
class DependencyManager {
  static bool _isHotReload = false;

  static Future<void> handleHotReload() async {
    _isHotReload = true;

    try {
      // Only reset feature dependencies, keep core
      await BrandInjection.reset(_getIt!);
      await AuthInjection.reset(_getIt!);

      // Re-register feature dependencies
      await BrandInjection.init(_getIt!);
      await AuthInjection.init(_getIt!);

      _getIt!.get<AppLogger>().info('Hot reload handled successfully');
    } catch (e) {
      _getIt!.get<AppLogger>().error('Failed to handle hot reload', e);
    } finally {
      _isHotReload = false;
    }
  }

  static bool get isHotReload => _isHotReload;
}
```

---

## ⚠️ Common Pitfalls

### 1. Double Registration

```dart
// ❌ WRONG
void setupDependencies() {
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<ApiService>(ApiService()); // ERROR!
}

// ✅ RIGHT
void setupDependencies() {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerSingleton<ApiService>(ApiService());
  }
}
```

### 2. Wrong Scoping

```dart
// ❌ WRONG
void setupDependencies() {
  // BLoC as Singleton - will cause state issues
  getIt.registerSingleton<AuthBloc>(AuthBloc(...));

  // Heavy object as Factory - performance issues
  getIt.registerFactory<DatabaseService>(DatabaseService(...));
}

// ✅ RIGHT
void setupDependencies() {
  // BLoC as Factory - new instance per widget
  getIt.registerFactory<AuthBloc>(() => AuthBloc(...));

  // Heavy object as LazySingleton - created once, reused
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService(...));
}
```

### 3. Circular Dependencies

```dart
// ❌ WRONG - Circular dependency
class ServiceA {
  final ServiceB serviceB;
  ServiceA(this.serviceB);
}

class ServiceB {
  final ServiceA serviceA;
  ServiceB(this.serviceA);
}

void setupDependencies() {
  getIt.registerSingleton<ServiceA>(ServiceA(getIt<ServiceB>())); // ERROR!
  getIt.registerSingleton<ServiceB>(ServiceB(getIt<ServiceA>())); // ERROR!
}

// ✅ RIGHT - Break circular dependency
abstract class ServiceAInterface {
  void doSomething();
}

class ServiceA implements ServiceAInterface {
  final ServiceB serviceB;
  ServiceA(this.serviceB);

  @override
  void doSomething() {
    serviceB.help();
  }
}

class ServiceB {
  final ServiceAInterface serviceA;
  ServiceB(this.serviceA);
}

void setupDependencies() {
  getIt.registerSingleton<ServiceAInterface>(ServiceA(getIt<ServiceB>()));
  getIt.registerSingleton<ServiceB>(ServiceB(getIt<ServiceAInterface>()));
}
```

### 4. Missing Dependencies

```dart
// ❌ WRONG - Missing dependency registration
void setupDependencies() {
  getIt.registerSingleton<AuthService>(AuthService());
  // Forgot to register ApiService that AuthService depends on!
}

// ✅ RIGHT - Complete dependency registration
void setupDependencies() {
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<AuthService>(AuthService(getIt<ApiService>()));
}
```

### 5. Testing with Real Dependencies

```dart
// ❌ WRONG - Testing with real dependencies
test('should load brands', () async {
  await setupDependencies(); // Real API calls!
  final bloc = BrandListBloc(...);

  bloc.add(LoadUserBrandsEvent());

  // Test will be slow and unreliable!
});

// ✅ RIGHT - Testing with mocks
test('should load brands', () async {
  final mockUseCase = MockGetUserBrandsUseCase();
  when(() => mockUseCase(const NoParams()))
      .thenAnswer((_) async => Right([testBrand]));

  final bloc = BrandListBloc(
    getUserBrandsUseCase: mockUseCase,
    // ... other mocked dependencies
  );

  bloc.add(LoadUserBrandsEvent());

  // Fast and reliable test!
});
```

---

## 💡 Code Examples

### Complete Feature Injection

```dart
// brand_injection.dart
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    try {
      await _registerDataSources(getIt);
      await _registerRepositories(getIt);
      await _registerUseCases(getIt);
      await _registerBlocs(getIt);
      await _registerHelpers(getIt);

      getIt<AppLogger>().info('Brand dependencies initialized successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to initialize Brand dependencies: $e');
      rethrow;
    }
  }

  static Future<void> _registerDataSources(GetIt getIt) async {
    if (!getIt.isRegistered<BrandRemoteDataSource>()) {
      getIt.registerLazySingleton<BrandRemoteDataSource>(
        () => BrandRemoteDataSourceImpl(
          dioClient: getIt<DioClient>(),
          logger: getIt<AppLogger>(),
        ),
      );
    }

    if (!getIt.isRegistered<BrandLocalDataSource>()) {
      getIt.registerLazySingleton<BrandLocalDataSource>(
        () => BrandLocalDataSourceImpl(
          logger: getIt<AppLogger>(),
        ),
      );
    }
  }

  static Future<void> _registerRepositories(GetIt getIt) async {
    if (!getIt.isRegistered<BrandRepository>()) {
      getIt.registerLazySingleton<BrandRepository>(
        () => BrandRepositoryImpl(
          remoteDataSource: getIt<BrandRemoteDataSource>(),
          localDataSource: getIt<BrandLocalDataSource>(),
          logger: getIt<AppLogger>(),
        ),
      );
    }
  }

  static Future<void> _registerUseCases(GetIt getIt) async {
    final currentUserId = 'current_user_id';

    if (!getIt.isRegistered<GetUserBrandsUseCase>()) {
      getIt.registerLazySingleton<GetUserBrandsUseCase>(
        () => GetUserBrandsUseCase(
          repository: getIt<BrandRepository>(),
          currentUserId: currentUserId,
        ),
      );
    }

    if (!getIt.isRegistered<CreateBrandUseCase>()) {
      getIt.registerLazySingleton<CreateBrandUseCase>(
        () => CreateBrandUseCase(
          repository: getIt<BrandRepository>(),
          currentUserId: currentUserId,
        ),
      );
    }
  }

  static Future<void> _registerBlocs(GetIt getIt) async {
    if (!getIt.isRegistered<BrandListBloc>()) {
      getIt.registerFactory<BrandListBloc>(
        () => BrandListBloc(
          getUserBrandsUseCase: getIt<GetUserBrandsUseCase>(),
          getAccessibleBrandsUseCase: getIt<GetAccessibleBrandsUseCase>(),
          getActiveBrandUseCase: getIt<GetActiveBrandUseCase>(),
        ),
      );
    }

    if (!getIt.isRegistered<BrandManagementBloc>()) {
      getIt.registerFactory<BrandManagementBloc>(
        () => BrandManagementBloc(
          createBrandUseCase: getIt<CreateBrandUseCase>(),
          updateBrandUseCase: getIt<UpdateBrandUseCase>(),
          deleteBrandUseCase: getIt<DeleteBrandUseCase>(),
        ),
      );
    }
  }

  static Future<void> _registerHelpers(GetIt getIt) async {
    // Static helpers don't need registration
    // BrandFormatter and InvitationFormatter use static methods
  }

  static Future<void> reset(GetIt getIt) async {
    try {
      // Reset in reverse order of registration
      await _resetBlocs(getIt);
      await _resetUseCases(getIt);
      await _resetRepositories(getIt);
      await _resetDataSources(getIt);

      getIt<AppLogger>().info('Brand dependencies reset successfully');
    } catch (e) {
      getIt<AppLogger>().error('Failed to reset Brand dependencies: $e');
      rethrow;
    }
  }

  static Future<void> _resetBlocs(GetIt getIt) async {
    DIUtils.unregisterSafe<BrandListBloc>(getIt);
    DIUtils.unregisterSafe<BrandManagementBloc>(getIt);
  }

  static Future<void> _resetUseCases(GetIt getIt) async {
    DIUtils.unregisterSafe<GetUserBrandsUseCase>(getIt);
    DIUtils.unregisterSafe<CreateBrandUseCase>(getIt);
    DIUtils.unregisterSafe<UpdateBrandUseCase>(getIt);
    DIUtils.unregisterSafe<DeleteBrandUseCase>(getIt);
  }

  static Future<void> _resetRepositories(GetIt getIt) async {
    DIUtils.unregisterSafe<BrandRepository>(getIt);
  }

  static Future<void> _resetDataSources(GetIt getIt) async {
    DIUtils.unregisterSafe<BrandRemoteDataSource>(getIt);
    DIUtils.unregisterSafe<BrandLocalDataSource>(getIt);
  }
}
```

### Testing Utilities

```dart
// test_utils.dart
class TestUtils {
  static GetIt setupTestDI() {
    final testGetIt = GetIt.asNewInstance();

    // Register common test mocks
    testGetIt.registerSingleton<AppLogger>(MockAppLogger());
    testGetIt.registerSingleton<DioClient>(MockDioClient());
    testGetIt.registerSingleton<SharedPreferences>(MockSharedPreferences());

    return testGetIt;
  }

  static Future<void> setupFeatureDependencies<T>(
    GetIt getIt,
    Future<void> Function(GetIt) setupFunction,
  ) async {
    try {
      await setupFunction(getIt);
    } catch (e) {
      getIt<AppLogger>().error('Failed to setup feature dependencies: $e');
      rethrow;
    }
  }

  static void verifyAllMocks(List<Mock> mocks) {
    for (final mock in mocks) {
      verifyNoMoreInteractions(mock);
    }
  }
}

// Usage in tests
void main() {
  group('Brand Feature Tests', () {
    late GetIt testGetIt;
    late List<Mock> mocks;

    setUp(() async {
      testGetIt = TestUtils.setupTestDI();
      mocks = [];

      await TestUtils.setupFeatureDependencies<BrandInjection>(
        testGetIt,
        BrandInjection.init,
      );
    });

    tearDown(() {
      TestUtils.verifyAllMocks(mocks);
      testGetIt.reset();
    });
  });
}
```

---

## 📝 Summary Checklist

### Dependency Registration
- [ ] Always check for existing registration before registering
- [ ] Use appropriate scoping (Singleton, LazySingleton, Factory)
- [ ] Register dependencies in correct order
- [ ] Implement proper error handling in setup
- [ ] Use lazy loading for performance optimization

### Feature Injection
- [ ] Organize dependencies by feature
- [ ] Implement complete reset mechanisms
- [ ] Use consistent naming patterns
- [ ] Provide initialization status checking
- [ ] Handle cross-feature dependencies properly

### Testing
- [ ] Use separate GetIt instance for tests
- [ ] Mock all external dependencies
- [ ] Create test utilities for common setup
- [ ] Verify all mock interactions
- [ ] Clean up test dependencies after each test

### Lifecycle Management
- [ ] Implement proper initialization checks
- [ ] Handle hot reload scenarios
- [ ] Provide safe reset mechanisms
- [ ] Log all dependency operations
- [ ] Handle errors gracefully

### Performance
- [ ] Use LazySingleton for heavy objects
- [ ] Use Factory for stateful objects
- [ ] Avoid immediate object creation
- [ ] Profile dependency creation time
- [ ] Optimize dependency graphs

---

**Last Updated:** November 20, 2025
**Next Review:** After major dependency changes
**Status:** Active Implementation Guide
**Version:** 1.0.0

---

*This guide should be updated regularly as new dependency patterns emerge and the project evolves.*