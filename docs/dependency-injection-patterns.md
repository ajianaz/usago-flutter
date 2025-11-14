# Dependency Injection Patterns Documentation

## 📋 Overview

Dokumentasi ini menjelaskan standardized dependency injection (DI) patterns yang digunakan dalam aplikasi Usago Mobile untuk memastikan konsistensi, maintainability, dan testability.

## 🏗️ Architecture Overview

Aplikasi menggunakan **GetIt** sebagai DI container dengan patterns yang telah distandarisasi untuk memudahkan pengelolaan dependencies.

## 📦 Dependency Lifecycle Types

### 1. Singleton (`DILifecycle.singleton`)
- **Deskripsi**: Single instance throughout app lifetime
- **Use Cases**: HTTP clients, services, repositories
- **Contoh**: `DioClient`, `AppLogger`, `ErrorHandler`

```dart
getIt.registerWithMetadata<DioClient>(
  () => DioClient(),
  lifecycle: DILifecycle.singleton,
  category: DICategory.core,
  name: 'DioClient',
  description: 'HTTP client for API communication',
);
```

### 2. Lazy Singleton (`DILifecycle.lazySingleton`)
- **Deskripsi**: Single instance created when first accessed
- **Use Cases**: Heavy objects, data sources, repositories
- **Contoh**: `AuthRemoteDatasource`, `HomeRepository`

```dart
getIt.registerWithMetadata<AuthRemoteDatasource>(
  () => AuthRemoteDatasourceImpl(
    dioClient: getIt(),
    logger: getIt(),
  ),
  lifecycle: DILifecycle.lazySingleton,
  category: DICategory.datasource,
  name: DINaming.dataSource('Auth'),
  description: 'Auth remote data source for API communication',
);
```

### 3. Factory (`DILifecycle.factory`)
- **Deskripsi**: New instance every time it's requested
- **Use Cases**: BLoCs, use cases, stateful objects
- **Contoh**: `AuthBloc`, `HomeBloc`

```dart
getIt.registerWithMetadata<AuthBloc>(
  () => AuthBloc(
    loginUsecase: getIt(),
    registerUsecase: getIt(),
    // ... other dependencies
  ),
  lifecycle: DILifecycle.factory,
  category: DICategory.bloc,
  name: DINaming.bloc('Auth'),
  description: 'Auth BLoC for authentication state management',
);
```

## 📂 Dependency Categories

### Core (`DICategory.core`)
- **Deskripsi**: Core infrastructure services
- **Contoh**: HTTP client, logger, error handler, locale service
- **Lifecycle**: `singleton`

### Data Source (`DICategory.datasource`)
- **Deskripsi**: Data sources (remote and local)
- **Contoh**: `AuthRemoteDatasource`, `HomeRemoteDataSource`
- **Lifecycle**: `lazySingleton`

### Repository (`DICategory.repository`)
- **Deskripsi**: Repository implementations
- **Contoh**: `AuthRepository`, `HomeRepository`
- **Lifecycle**: `lazySingleton`

### Use Case (`DICategory.usecase`)
- **Deskripsi**: Domain use cases
- **Contoh**: `LoginUseCase`, `GetMenuItemsUseCase`
- **Lifecycle**: `lazySingleton`

### BLoC (`DICategory.bloc`)
- **Deskripsi**: BLoC state management
- **Contoh**: `AuthBloc`, `HomeBloc`
- **Lifecycle**: `factory`

## 🔧 Standardized Patterns

### 1. Core Services Registration
```dart
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
```

### 2. Feature Registration
```dart
DICommonPatterns.registerFeature<TDataSource, TRepository, TBloc>(
  getIt,
  dataSourceFactory: () => AuthRemoteDatasourceImpl(...),
  repositoryFactory: (dataSource) => AuthRepositoryImpl(...),
  blocFactory: (repository) => AuthBloc(...),
  featureName: 'Auth',
  dataSourceLifecycle: DILifecycle.lazySingleton,
  repositoryLifecycle: DILifecycle.lazySingleton,
  blocLifecycle: DILifecycle.factory,
);
```

### 3. Use Cases Registration
```dart
DICommonPatterns.registerUseCases(
  getIt,
  {
    DINaming.useCase('Login', 'Auth'): () => LoginUsecase(repository: getIt()),
    DINaming.useCase('Register', 'Auth'): () => RegisterUsecase(repository: getIt()),
    // ... other use cases
  },
  lifecycle: DILifecycle.lazySingleton,
);
```

## 📝 Naming Conventions

### Standard Naming Patterns
```dart
class DINaming {
  static String dataSource(String feature) => '${feature}DataSource';
  static String repository(String feature) => '${feature}Repository';
  static String useCase(String action, String feature) => '${action}${feature}UseCase';
  static String bloc(String feature) => '${feature}Bloc';
  static String service(String name) => '${name}Service';
}
```

### Examples
- **Data Source**: `AuthDataSource`, `HomeDataSource`
- **Repository**: `AuthRepository`, `HomeRepository`
- **Use Case**: `LoginAuthUseCase`, `GetMenuItemsHomeUseCase`
- **BLoC**: `AuthBloc`, `HomeBloc`
- **Service**: `LocaleService`, `ThemeService`

## 🏛️ Feature Structure

### Standard Feature Directory Structure
```
lib/features/feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_remote_datasource_impl.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_feature_usecase.dart
│       └── update_feature_usecase.dart
├── presentation/
│   ├── bloc/
│   │   ├── feature_bloc.dart
│   │   ├── feature_event.dart
│   │   └── feature_state.dart
│   ├── pages/
│   │   └── feature_page.dart
│   └── widgets/
│       └── feature_widget.dart
└── di/
    └── feature_injection.dart
```

## 🔍 Debugging and Monitoring

### Dependency Information
```dart
// Get all dependencies
final allDeps = DIInfo.getAllDependencies();

// Get dependencies by category
final coreDeps = DIInfo.getDependenciesByCategory(DICategory.core);

// Get specific dependency
final authBloc = DIInfo.getDependencyByName('AuthBloc');
```

### Logging
Semua dependencies akan di-log saat aplikasi startup:
```
=== Registered Dependencies (15) ===

CORE:
  - DioClient (singleton)
    HTTP client for API communication
  - AppLogger (singleton)
    Application logger for debugging and monitoring
  - ErrorHandler (singleton)
    Centralized error handling

DATASOURCE:
  - AuthDataSource (lazySingleton)
    Auth remote data source for API communication
  - HomeDataSource (lazySingleton)
    Home remote data source for API communication

REPOSITORY:
  - AuthRepository (lazySingleton)
    Auth repository for business logic coordination
  - HomeRepository (lazySingleton)
    Home repository for business logic coordination

USECASE:
  - LoginAuthUseCase (lazySingleton)
    Use case: LoginAuthUseCase
  - RegisterAuthUseCase (lazySingleton)
    Use case: RegisterAuthUseCase

BLOC:
  - AuthBloc (factory)
    Auth BLoC for authentication state management
  - HomeBloc (factory)
    Home BLoC for home screen state management
=== End of Dependencies ===
```

## 📋 Best Practices

### 1. Lifecycle Selection
- **Singleton**: Untuk objek yang stateless dan mahal untuk di-inisialisasi
- **Lazy Singleton**: Untuk objek yang berat dan tidak selalu dibutuhkan
- **Factory**: Untuk objek yang stateful (BLoCs, use cases dengan state)

### 2. Dependency Organization
- Gunakan categories yang sesuai untuk setiap dependency
- Berikan deskripsi yang jelas untuk debugging
- Ikuti naming conventions untuk konsistensi

### 3. Feature Development
- Setiap feature memiliki file injection sendiri
- Gunakan standardized patterns untuk registration
- Pastikan dependencies terdaftar dengan metadata lengkap

### 4. Testing
- Gunakan `resetDependencies()` untuk clean state antar tests
- Mock dependencies menggunakan `registerSingleton()` dengan mock objects
- Test lifecycle behavior sesuai dengan expected usage

## 🚀 Implementation Guide

### Menambah Feature Baru
1. **Buat feature structure** sesuai pattern di atas
2. **Implementasi injection file**:
   ```dart
   void setupFeatureDependencies(GetIt getIt) {
     // Register data sources
     getIt.registerWithMetadata<FeatureRemoteDataSource>(
       () => FeatureRemoteDataSourceImpl(...),
       lifecycle: DILifecycle.lazySingleton,
       category: DICategory.datasource,
       name: DINaming.dataSource('Feature'),
       description: 'Feature remote data source',
     );

     // Register repository
     getIt.registerWithMetadata<FeatureRepository>(
       () => FeatureRepositoryImpl(...),
       lifecycle: DILifecycle.lazySingleton,
       category: DICategory.repository,
       name: DINaming.repository('Feature'),
       description: 'Feature repository',
     );

     // Register use cases
     DICommonPatterns.registerUseCases(getIt, {
       DINaming.useCase('Get', 'Feature'): () => GetFeatureUseCase(...),
     });

     // Register BLoC
     getIt.registerWithMetadata<FeatureBloc>(
       () => FeatureBloc(...),
       lifecycle: DILifecycle.factory,
       category: DICategory.bloc,
       name: DINaming.bloc('Feature'),
       description: 'Feature BLoC',
     );
   }
   ```
3. **Tambah ke main container**:
   ```dart
   Future<void> setupDependencies() async {
     await _setupCoreServices();
     setupAuthDependencies(getIt);
     setupHomeDependencies(getIt);
     setupFeatureDependencies(getIt); // Tambah ini
     _logRegisteredDependencies();
   }
   ```

## 📊 Performance Considerations

### Memory Management
- **Singleton**: Satu instance seumur aplikasi (hemat memory)
- **Lazy Singleton**: Instance dibuat saat pertama digunakan (efisien)
- **Factory**: Instance baru setiap request (gunakan dengan hati-hati)

### Startup Time
- Core services: Immediate registration
- Feature dependencies: Lazy registration
- Logging: Optional untuk production builds

### Testing Performance
- Gunakan lazy loading untuk test isolation
- Mock dependencies untuk unit testing
- Reset container antar test suites

## 🔧 Tools and Utilities

### DIInfo Class
```dart
class DIInfo {
  static List<DIDependency> getAllDependencies();
  static List<DIDependency> getDependenciesByCategory(DICategory category);
  static DIDependency? getDependencyByName(String name);
}
```

### DIDependencyRegistry
```dart
class DIDependencyRegistry {
  static void register(DIDependency dependency);
  static List<DIDependency> get all;
  static List<DIDependency> getByCategory(DICategory category);
  static void clear();
}
```

## 📚 References

- [GetIt Package Documentation](https://pub.dev/packages/get_it)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob-clean-architecture)
- [Flutter BLoC Pattern](https://bloclibrary.dev/)
- [Dependency Injection Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt/dependency-injection)

---

*Dokumentasi ini akan terus diupdate sesuai dengan perkembangan aplikasi. Untuk pertanyaan atau clarifications, silakan hubungi team architecture.*