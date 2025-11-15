import 'package:get_it/get_it.dart';

/// Standardized Dependency Injection Patterns for Usago Mobile App
///
/// Pattern ini dirancang untuk:
/// 1. Menghindari type inference issues yang sering terjadi dengan GetIt
/// 2. Menyediakan dokumentasi otomatis untuk semua dependencies
/// 3. Memastikan konsistensi naming convention
/// 4. Memudahkan tracking dan debugging dependencies
///
/// Cara penggunaan:
/// ```dart
/// // Register singleton (instance dibuat sekali)
/// DIServiceLocator.registerSingleton<MyService>(MyService());
///
/// // Register lazy singleton (instance dibuat saat pertama kali digunakan)
/// DIServiceLocator.registerLazySingleton<MyRepository>(() => MyRepository());
///
/// // Register factory (instance baru dibuat setiap kali)
/// DIServiceLocator.registerFactory<MyBloc>(() => MyBloc());
///
/// // Get dependency
/// final myService = DIServiceLocator.get<MyService>();
/// ```

/// Lifecycle options untuk dependencies
///
/// - singleton: Instance dibuat sekali saat registrasi dan digunakan kembali
/// - lazySingleton: Instance dibuat saat pertama kali dipanggil, lalu digunakan kembali
/// - factory: Instance baru dibuat setiap kali dipanggil
enum DILifecycle {
  /// Instance dibuat sekali saat registrasi dan digunakan kembali
  /// Cocok untuk: Services, Configuration, HTTP Client
  singleton,

  /// Instance dibuat saat pertama kali dipanggil, lalu digunakan kembali
  /// Cocok untuk: Repositories, Data Sources, BLoCs
  lazySingleton,

  /// Instance baru dibuat setiap kali dipanggil
  /// Cocok untuk: View Models, State Objects, Use Cases yang membutuhkan state baru
  factory,
}

/// Kategori untuk mengelompokkan dependencies
///
/// Memudahkan tracking dan dokumentasi berdasarkan layer arsitektur
enum DICategory {
  /// Core services: HTTP Client, Logger, Error Handler
  core,

  /// Data sources: Remote API, Local Storage, Cache
  datasource,

  /// Repository layer: Business logic coordination
  repository,

  /// Use case layer: Application specific business rules
  usecase,

  /// BLoC/Cubit layer: State management
  bloc,

  /// Presentation layer: UI components, Pages, Widgets
  presentation,

  /// External dependencies: Third-party services, SDKs
  external,
}

/// Metadata untuk dokumentasi dan tracking dependency
///
/// Setiap dependency yang diregister akan memiliki metadata ini
/// untuk memudahkan debugging dan dokumentasi otomatis
class DIDependency {
  /// Nama unik untuk dependency
  final String name;

  /// Kategori berdasarkan layer arsitektur
  final DICategory category;

  /// Lifecycle management
  final DILifecycle lifecycle;

  /// Deskripsi fungsi dan tujuan dependency
  final String description;

  const DIDependency({
    required this.name,
    required this.category,
    required this.lifecycle,
    this.description = '',
  });

  @override
  String toString() {
    return 'DIDependency(name: $name, category: $category, lifecycle: $lifecycle)';
  }
}

/// Registry untuk tracking semua dependencies yang terdaftar
///
/// Fungsi:
/// - Menyimpan metadata semua dependencies
/// - Memudahkan debugging dengan list lengkap
/// - Support grouping berdasarkan kategori
/// - Generate dokumentasi otomatis
class DIDependencyRegistry {
  static final List<DIDependency> _dependencies = [];

  /// Registrasi dependency ke registry
  ///
  /// Dipanggil otomatis oleh DIServiceLocator saat registrasi
  static void register(DIDependency dependency) {
    _dependencies.add(dependency);
  }

  /// Get semua dependencies yang terdaftar
  ///
  /// Returns: List immutable dari semua dependencies
  static List<DIDependency> get all => List.unmodifiable(_dependencies);

  /// Get dependencies berdasarkan kategori
  ///
  /// Parameters:
  /// - [category]: Kategori yang ingin difilter
  ///
  /// Returns: List dependencies dalam kategori tersebut
  static List<DIDependency> getByCategory(DICategory category) {
    return _dependencies.where((dep) => dep.category == category).toList();
  }

  /// Hapus semua dependencies dari registry
  ///
  /// Biasanya digunakan saat testing atau reset aplikasi
  static void clear() {
    _dependencies.clear();
  }

  /// Get dependency berdasarkan nama
  ///
  /// Parameters:
  /// - [name]: Nama dependency yang dicari
  ///
  /// Returns: Dependency object jika ditemukan, null jika tidak
  static DIDependency? getByName(String name) {
    try {
      return _dependencies.firstWhere((dep) => dep.name == name);
    } catch (e) {
      return null;
    }
  }
}

/// Simplified DI Helper untuk menghindari type inference issues
///
/// Class ini adalah wrapper di atas GetIt yang menyediakan:
/// 1. Type safety yang lebih baik
/// 2. Dokumentasi otomatis
/// 3. Error handling yang lebih jelas
/// 4. Consistent API
///
/// Cara penggunaan:
/// ```dart
/// // Setup di main.dart
/// await setupDependencies();
///
/// // Registrasi dependency
/// DIServiceLocator.registerSingleton<ApiService>(ApiService());
/// DIServiceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
/// DIServiceLocator.registerFactory<AuthBloc>(() => AuthBloc());
///
/// // Penggunaan di aplikasi
/// final apiService = DIServiceLocator.get<ApiService>();
/// final authBloc = DIServiceLocator.get<AuthBloc>();
/// ```
class DIServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  /// Register singleton dengan instance langsung
  ///
  /// Instance dibuat sekali saat registrasi dan digunakan kembali
  ///
  /// Parameters:
  /// - [instance]: Instance yang akan diregister
  /// - [name]: Nama unik (opsional, default: T.toString())
  /// - [description]: Deskripsi fungsi (opsional)
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// DIServiceLocator.registerSingleton<ApiService>(ApiService());
  /// ```
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

  /// Register lazy singleton dengan factory function
  ///
  /// Instance dibuat saat pertama kali dipanggil, lalu digunakan kembali
  ///
  /// Parameters:
  /// - [factory]: Function yang membuat instance
  /// - [name]: Nama unik (opsional, default: T.toString())
  /// - [description]: Deskripsi fungsi (opsional)
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// DIServiceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  /// ```
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

  /// Register factory dengan factory function
  ///
  /// Instance baru dibuat setiap kali dipanggil
  ///
  /// Parameters:
  /// - [factory]: Function yang membuat instance
  /// - [name]: Nama unik (opsional, default: T.toString())
  /// - [description]: Deskripsi fungsi (opsional)
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// DIServiceLocator.registerFactory<AuthBloc>(() => AuthBloc());
  /// ```
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
  ///
  /// Parameters:
  /// - [T]: Type dependency yang ingin diambil
  ///
  /// Returns: Instance dari type T
  ///
  /// Throws: Exception jika dependency tidak terdaftar
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// final apiService = DIServiceLocator.get<ApiService>();
  /// ```
  static T get<T extends Object>() {
    return _getIt.get<T>();
  }

  /// Check apakah dependency terdaftar
  ///
  /// Parameters:
  /// - [T]: Type dependency yang ingin dicek
  ///
  /// Returns: true jika terdaftar, false jika tidak
  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }
}

/// Standard naming conventions untuk consistency
///
/// Memastikan semua dependencies mengikuti naming pattern yang sama
/// Memudahkan debugging dan maintenance
class DINaming {
  /// Standard naming untuk data sources
  ///
  /// Pattern: {Feature}DataSource
  /// Contoh: AuthDataSource, UserDataSource
  static String dataSource(String feature) => '${feature}DataSource';

  /// Standard naming untuk repositories
  ///
  /// Pattern: {Feature}Repository
  /// Contoh: AuthRepository, UserRepository
  static String repository(String feature) => '${feature}Repository';

  /// Standard naming untuk use cases
  ///
  /// Pattern: {Action}{Feature}UseCase
  /// Contoh: LoginAuthUseCase, GetUserProfileUseCase
  static String useCase(String action, String feature) =>
      '${action}${feature}UseCase';

  /// Standard naming untuk BLoCs
  ///
  /// Pattern: {Feature}Bloc
  /// Contoh: AuthBloc, HomeBloc
  static String bloc(String feature) => '${feature}Bloc';

  /// Standard naming untuk services
  ///
  /// Pattern: {Name}Service
  /// Contoh: ApiService, StorageService
  static String service(String name) => '${name}Service';
}