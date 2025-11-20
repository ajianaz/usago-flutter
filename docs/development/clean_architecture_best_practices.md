# Best Practices for Clean Architecture Implementation

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Translation Best Practices](#translation-best-practices)
3. [Dependency Injection Guidelines](#dependency-injection-guidelines)
4. [Debugging Strategies](#debugging-strategies)
5. [BLoC Single Responsibility](#bloc-single-responsibility)
6. [Error Handling with Either Pattern](#error-handling-with-either-pattern)
7. [Code Examples](#code-examples)
8. [Common Pitfalls](#common-pitfalls)
9. [Testing Guidelines](#testing-guidelines)

---

## 🎯 Overview

This document outlines the best practices for implementing Clean Architecture in the Usago Flutter project, based on debugging sessions and real-world implementation experience. These practices ensure maintainable, testable, and scalable code.

---

## 🌐 Translation Best Practices

### Always Use `context.t.key` for User-Facing Text

**Rule:** Never hardcode text that will be displayed to users. Always use the translation system.

```dart
// ✅ GOOD - Using translation system
Text(context.t.brandTitle)
Text(context.t.validationRequired)
Text(context.t.authLogin)

// ❌ BAD - Hardcoded text
Text('Brand Management')
Text('This field is required')
Text('Login')
```

### Translation Key Organization

```dart
// Organize translations by feature and purpose
// lib/i18n/en.i18n.yaml
brand:
  title: Brand Management
  create: Create Brand
  edit: Edit Brand
  delete: Delete Brand

validation:
  required: This field is required
  email_invalid: Please enter a valid email
  password_too_short: Password must be at least 6 characters

messages:
  success: Operation completed successfully
  error: An error occurred
```

### Translations in BLoC

```dart
// ✅ GOOD - Use translations in BLoC error messages
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.'
            : 'No internet connection. Please check your connection and try again.';
      default:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.'
            : 'An unexpected error occurred. Please try again.';
    }
  }
}

// ❌ BAD - Hardcoded error messages in BLoC
String _mapFailureToMessage(Failure failure) {
  return 'An error occurred'; // Wrong! Should use translations
}
```

### Dynamic Locale Detection

```dart
// ✅ GOOD - Dynamic locale-based messages
String getSuccessMessage() {
  return LocaleSettings.currentLocale == AppLocale.id
      ? 'Operasi berhasil'
      : 'Operation successful';
}

// ❌ BAD - Static messages
String getSuccessMessage() {
  return 'Operation successful'; // Not localized
}
```

---

## 🔧 Dependency Injection Guidelines

### Avoid Double Registration

**Rule:** Never register the same dependency multiple times. This causes runtime errors.

```dart
// ✅ GOOD - Check before registration
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

// ❌ BAD - Double registration
static Future<void> _registerRepositories(GetIt getIt) async {
  getIt.registerLazySingleton<BrandRepository>(...); // First registration
  getIt.registerLazySingleton<BrandRepository>(...); // ERROR! Double registration
}
```

### Proper Dependency Scoping

```dart
// ✅ GOOD - Correct scoping
class BrandInjection {
  static Future<void> init(GetIt getIt) async {
    // Data Sources - LazySingleton (heavy objects)
    getIt.registerLazySingleton<BrandRemoteDataSource>(
      () => BrandRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repositories - LazySingleton (stateless business logic)
    getIt.registerLazySingleton<BrandRepository>(
      () => BrandRepositoryImpl(
        remoteDataSource: getIt<BrandRemoteDataSource>(),
      ),
    );

    // BLoCs - Factory (stateful, new instance per widget)
    getIt.registerFactory<BrandListBloc>(
      () => BrandListBloc(
        getUserBrandsUseCase: getIt<GetUserBrandsUseCase>(),
      ),
    );
  }
}

// ❌ BAD - Wrong scoping
getIt.registerSingleton<BrandListBloc>(...); // Wrong! BLoC should be Factory
```

### Dependency Reset for Testing

```dart
// ✅ GOOD - Proper reset mechanism
static Future<void> reset(GetIt getIt) async {
  try {
    // Reset in reverse order of registration
    getIt.unregister<BrandListBloc>();
    getIt.unregister<BrandRepository>();
    getIt.unregister<BrandRemoteDataSource>();

    getIt<AppLogger>().info('Brand dependencies reset successfully');
  } catch (e) {
    getIt<AppLogger>().error('Failed to reset Brand dependencies: $e');
    rethrow;
  }
}
```

---

## 🐛 Debugging Strategies

### Structured Logging

**Rule:** Use structured logging with proper context and severity levels.

```dart
// ✅ GOOD - Structured logging
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  final AppLogger _logger;

  Future<void> _onLoadUserBrands(
    LoadUserBrandsEvent event,
    Emitter<BrandListState> emit,
  ) async {
    _logger.info('Loading user brands...');

    emit(const BrandListLoading());

    final result = await _getUserBrandsUseCase(const NoParams());

    result.fold(
      (failure) {
        _logger.error('Failed to load user brands', failure);
        emit(BrandListError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        ));
      },
      (brands) {
        _logger.info('Successfully loaded ${brands.length} user brands');
        _cachedUserBrands = brands;
        emit(UserBrandsLoaded(userBrands: brands));
      },
    );
  }
}

// ❌ BAD - Poor logging
Future<void> _onLoadUserBrands(...) async {
  print('Loading brands...'); // Wrong! Use proper logging

  final result = await _getUserBrandsUseCase(const NoParams());

  result.fold(
    (failure) => emit(BrandListError(message: 'Error')), // No context
    (brands) => emit(UserBrandsLoaded(userBrands: brands)),
  );
}
```

### Systematic Debugging Approach

1. **Log Entry Points**: Log when methods are called
2. **Log State Changes**: Log state transitions
3. **Log Errors with Context**: Include relevant data in error logs
4. **Use Log Levels**: INFO, WARNING, ERROR appropriately
5. **Performance Logging**: Log slow operations

```dart
// ✅ GOOD - Comprehensive logging
class BrandRepositoryImpl implements BrandRepository {
  final AppLogger _logger;

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands(String userId) async {
    final stopwatch = Stopwatch()..start();

    try {
      _logger.info('Getting user brands for userId: $userId');

      final brands = await _remoteDataSource.getUserBrands(userId);

      stopwatch.stop();
      _logger.info('Successfully retrieved ${brands.length} brands in ${stopwatch.elapsedMilliseconds}ms');

      return Right(brands);
    } catch (e) {
      stopwatch.stop();
      _logger.error('Failed to get user brands after ${stopwatch.elapsedMilliseconds}ms', e);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

---

## 🎯 BLoC Single Responsibility

### Focused BLoC Design

**Rule:** Each BLoC should have a single, well-defined responsibility.

```dart
// ✅ GOOD - Focused BLoCs
// BrandListBloc - Handles brand listing operations
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  // Only handles: LoadUserBrands, LoadAccessibleBrands, GetActiveBrand
}

// BrandManagementBloc - Handles CRUD operations
class BrandManagementBloc extends Bloc<BrandManagementEvent, BrandManagementState> {
  // Only handles: CreateBrand, UpdateBrand, DeleteBrand
}

// BrandSearchBloc - Handles search functionality
class BrandSearchBloc extends Bloc<BrandSearchEvent, BrandSearchState> {
  // Only handles: SearchBrands, FilterBrands
}

// ❌ BAD - Monolithic BLoC
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  // Handles EVERYTHING: List, Create, Update, Delete, Search, Switch, etc.
  // This violates Single Responsibility Principle
}
```

### Event and State Organization

```dart
// ✅ GOOD - Clear event and state separation
// brand_list_event.dart
abstract class BrandListEvent extends Equatable {
  const BrandListEvent();
}

class LoadUserBrandsEvent extends BrandListEvent {
  const LoadUserBrandsEvent();
  @override
  List<Object?> get props => [];
}

class RefreshBrandListEvent extends BrandListEvent {
  const RefreshBrandListEvent();
  @override
  List<Object?> get props => [];
}

// brand_list_state.dart
abstract class BrandListState extends Equatable {
  const BrandListState();
}

class BrandListInitial extends BrandListState {
  const BrandListInitial();
  @override
  List<Object?> get props => [];
}

class BrandListLoading extends BrandListState {
  const BrandListLoading();
  @override
  List<Object?> get props => [];
}

class UserBrandsLoaded extends BrandListState {
  final List<Brand> userBrands;

  const UserBrandsLoaded({required this.userBrands});
  @override
  List<Object?> get props => [userBrands];
}
```

### BLoC Dependency Management

```dart
// ✅ GOOD - Minimal, focused dependencies
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  final GetUserBrandsUseCase _getUserBrandsUseCase;
  final GetAccessibleBrandsUseCase _getAccessibleBrandsUseCase;
  final GetActiveBrandUseCase _getActiveBrandUseCase;

  // Cache for performance
  List<Brand> _cachedUserBrands = [];
  List<Brand> _cachedAccessibleBrands = [];
  Brand? _cachedActiveBrand;

  BrandListBloc({
    required GetUserBrandsUseCase getUserBrandsUseCase,
    required GetAccessibleBrandsUseCase getAccessibleBrandsUseCase,
    required GetActiveBrandUseCase getActiveBrandUseCase,
  })  : _getUserBrandsUseCase = getUserBrandsUseCase,
        _getAccessibleBrandsUseCase = getAccessibleBrandsUseCase,
        _getActiveBrandUseCase = getActiveBrandUseCase,
        super(const BrandListInitial());
}
```

---

## ⚡ Error Handling with Either Pattern

### Consistent Error Handling

**Rule:** Always use Either<Failure, Success> pattern for consistent error handling.

```dart
// ✅ GOOD - Consistent Either pattern
class GetUserBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  final BrandRepository _repository;

  GetUserBrandsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    try {
      final brands = await _repository.getUserBrands();
      return Right(brands);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}

// ❌ BAD - Inconsistent error handling
class GetUserBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  @override
  Future<List<Brand>> call(NoParams params) async {
    try {
      return await _repository.getUserBrands();
    } catch (e) {
      throw e; // Wrong! Should return Either
    }
  }
}
```

### Failure Type Hierarchy

```dart
// ✅ GOOD - Structured failure hierarchy
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class BetterAuthFailure extends Failure {
  const BetterAuthFailure(String message) : super(message);
}
```

### Error Mapping in BLoC

```dart
// ✅ GOOD - Comprehensive error mapping
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        return _getLocalizedServerMessage(serverFailure);
      case NetworkFailure:
        return _getLocalizedNetworkMessage();
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return _getLocalizedAuthMessage();
      default:
        return _getLocalizedDefaultMessage();
    }
  }

  String _getLocalizedServerMessage(ServerFailure failure) {
    // Handle specific server error codes
    switch (failure.statusCode) {
      case 401:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Anda tidak memiliki izin untuk mengakses data brand'
            : 'You don\'t have permission to access brand data';
      case 404:
        return LocaleSettings.currentLocale == AppLocale.id
            ? 'Data brand tidak ditemukan'
            : 'Brand data not found';
      default:
        return failure.message;
    }
  }

  String _getLocalizedNetworkMessage() {
    return LocaleSettings.currentLocale == AppLocale.id
        ? 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.'
        : 'No internet connection. Please check your connection and try again.';
  }

  String? _mapFailureToErrorCode(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        return serverFailure.statusCode?.toString();
      case NetworkFailure:
        return 'NETWORK_ERROR';
      case ValidationFailure:
        return 'VALIDATION_ERROR';
      case BetterAuthFailure:
        return 'AUTH_ERROR';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}
```

---

## 💡 Code Examples

### Complete BLoC Implementation

```dart
// brand_list_bloc.dart
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> {
  final GetUserBrandsUseCase _getUserBrandsUseCase;
  final GetAccessibleBrandsUseCase _getAccessibleBrandsUseCase;
  final GetActiveBrandUseCase _getActiveBrandUseCase;
  final AppLogger _logger;

  // Cache for performance
  List<Brand> _cachedUserBrands = [];
  List<Brand> _cachedAccessibleBrands = [];
  Brand? _cachedActiveBrand;

  BrandListBloc({
    required GetUserBrandsUseCase getUserBrandsUseCase,
    required GetAccessibleBrandsUseCase getAccessibleBrandsUseCase,
    required GetActiveBrandUseCase getActiveBrandUseCase,
    required AppLogger logger,
  })  : _getUserBrandsUseCase = getUserBrandsUseCase,
        _getAccessibleBrandsUseCase = getAccessibleBrandsUseCase,
        _getActiveBrandUseCase = getActiveBrandUseCase,
        _logger = logger,
        super(const BrandListInitial()) {
    on<LoadUserBrandsEvent>(_onLoadUserBrands);
    on<LoadAccessibleBrandsEvent>(_onLoadAccessibleBrands);
    on<GetActiveBrandEvent>(_onGetActiveBrand);
    on<RefreshBrandListEvent>(_onRefreshBrandList);
  }

  Future<void> _onLoadUserBrands(
    LoadUserBrandsEvent event,
    Emitter<BrandListState> emit,
  ) async {
    _logger.info('Loading user brands...');
    emit(const BrandListLoading());

    final result = await _getUserBrandsUseCase(const NoParams());

    result.fold(
      (failure) {
        _logger.error('Failed to load user brands', failure);
        emit(BrandListError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        ));
      },
      (brands) {
        _logger.info('Successfully loaded ${brands.length} user brands');
        _cachedUserBrands = brands;
        emit(UserBrandsLoaded(userBrands: brands));
      },
    );
  }
}
```

### Proper Use Case Implementation

```dart
// get_user_brands_usecase.dart
class GetUserBrandsUseCase implements UseCase<List<Brand>, NoParams> {
  final BrandRepository _repository;
  final String _currentUserId;
  final AppLogger _logger;

  GetUserBrandsUseCase({
    required BrandRepository repository,
    required String currentUserId,
    required AppLogger logger,
  })  : _repository = repository,
        _currentUserId = currentUserId,
        _logger = logger;

  @override
  Future<Either<Failure, List<Brand>>> call(NoParams params) async {
    try {
      _logger.info('Getting user brands for userId: $_currentUserId');

      final brands = await _repository.getUserBrands(_currentUserId);

      _logger.info('Successfully retrieved ${brands.length} brands');
      return Right(brands);
    } on ServerException catch (e) {
      _logger.error('Server error while getting user brands', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      _logger.error('Network error while getting user brands', e);
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      _logger.error('Unexpected error while getting user brands', e);
      return Left(ServerFailure(
        message: 'Failed to load user brands: ${e.toString()}',
      ));
    }
  }
}
```

---

## ⚠️ Common Pitfalls

### 1. Hardcoded Text in UI Components

```dart
// ❌ WRONG
ElevatedButton(
  onPressed: () {},
  child: Text('Create Brand'), // Hardcoded!
)

// ✅ RIGHT
ElevatedButton(
  onPressed: () {},
  child: Text(context.t.brandCreate), // Using translation!
)
```

### 2. Double Dependency Registration

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

### 3. Missing Error Handling

```dart
// ❌ WRONG
Future<List<Brand>> getBrands() async {
  return await repository.getBrands(); // No error handling!
}

// ✅ RIGHT
Future<Either<Failure, List<Brand>>> getBrands() async {
  try {
    final brands = await repository.getBrands();
    return Right(brands);
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}
```

### 4. Monolithic BLoC

```dart
// ❌ WRONG - One BLoC for everything
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  // Handles list, create, update, delete, search, switch...
  // Too many responsibilities!
}

// ✅ RIGHT - Focused BLoCs
class BrandListBloc extends Bloc<BrandListEvent, BrandListState> { }
class BrandManagementBloc extends Bloc<BrandManagementEvent, BrandManagementState> { }
class BrandSearchBloc extends Bloc<BrandSearchEvent, BrandSearchState> { }
```

---

## 🧪 Testing Guidelines

### Unit Testing BLoCs

```dart
void main() {
  group('BrandListBloc', () {
    late BrandListBloc bloc;
    late MockGetUserBrandsUseCase mockGetUserBrandsUseCase;
    late MockAppLogger mockLogger;

    setUp(() {
      mockGetUserBrandsUseCase = MockGetUserBrandsUseCase();
      mockLogger = MockAppLogger();

      bloc = BrandListBloc(
        getUserBrandsUseCase: mockGetUserBrandsUseCase,
        getAccessibleBrandsUseCase: MockGetAccessibleBrandsUseCase(),
        getActiveBrandUseCase: MockGetActiveBrandUseCase(),
        logger: mockLogger,
      );
    });

    tearDown(() => bloc.close());

    test('initial state is BrandListInitial', () {
      expect(bloc.state, equals(const BrandListInitial()));
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

    blocTest<BrandListBloc, BrandListState>(
      'emits [BrandListLoading, BrandListError] when LoadUserBrandsEvent fails',
      setUp: () {
        when(() => mockGetUserBrandsUseCase(const NoParams()))
            .thenAnswer((_) async => Left(NetworkFailure('No internet')));
      },
      act: (bloc) => bloc.add(const LoadUserBrandsEvent()),
      expect: () => [
        const BrandListLoading(),
        BrandListError(
          message: 'No internet connection. Please check your connection and try again.',
          errorCode: 'NETWORK_ERROR',
        ),
      ],
    );
  });
}
```

### Testing Use Cases

```dart
void main() {
  group('GetUserBrandsUseCase', () {
    late GetUserBrandsUseCase useCase;
    late MockBrandRepository mockRepository;
    late MockAppLogger mockLogger;

    setUp(() {
      mockRepository = MockBrandRepository();
      mockLogger = MockAppLogger();

      useCase = GetUserBrandsUseCase(
        repository: mockRepository,
        currentUserId: 'test-user-id',
        logger: mockLogger,
      );
    });

    test('returns Right(List<Brand>) when repository succeeds', () async {
      // Arrange
      final expectedBrands = [testBrand1, testBrand2];
      when(() => mockRepository.getUserBrands('test-user-id'))
          .thenAnswer((_) async => expectedBrands);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      expect(result, equals(Right(expectedBrands)));
      verify(() => mockRepository.getUserBrands('test-user-id')).called(1);
    });

    test('returns Left(ServerFailure) when repository throws ServerException', () async {
      // Arrange
      when(() => mockRepository.getUserBrands('test-user-id'))
          .thenThrow(ServerException('Server error', 500));

      // Act
      final result = await useCase(const NoParams());

      // Assert
      expect(
        result,
        equals(const Left(ServerFailure(message: 'Server error', statusCode: 500))),
      );
    });
  });
}
```

---

## 📝 Summary Checklist

### Translation Practices
- [ ] Always use `context.t.key` for user-facing text
- [ ] Never hardcode strings in UI components
- [ ] Use locale-based messages in BLoC error handling
- [ ] Organize translation keys by feature and purpose
- [ ] Test with all supported locales

### Dependency Injection
- [ ] Check for existing registration before registering
- [ ] Use proper scoping (LazySingleton, Factory, Singleton)
- [ ] Implement proper reset mechanisms for testing
- [ ] Register dependencies in dependency order
- [ ] Use structured error handling in DI setup

### BLoC Implementation
- [ ] Follow Single Responsibility Principle
- [ ] Use focused BLoCs for specific functionality
- [ ] Implement proper event and state hierarchies
- [ ] Use Either pattern for error handling
- [ ] Include structured logging

### Error Handling
- [ ] Always use Either<Failure, Success> pattern
- [ ] Create structured failure hierarchy
- [ ] Implement localized error messages
- [ ] Map failures to appropriate error codes
- [ ] Log errors with proper context

### Testing
- [ ] Write unit tests for all BLoCs
- [ ] Test use cases with mock dependencies
- [ ] Test error scenarios
- [ ] Test with different locales
- [ ] Use structured test organization

---

**Last Updated:** November 20, 2025
**Next Review:** After next major feature implementation
**Status:** Active Implementation Guide
**Version:** 1.0.0

---

*This document is based on real debugging sessions and implementation experience. Update it regularly as new patterns emerge.*