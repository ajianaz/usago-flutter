# Shared Utilities Guide
# Panduan Shared Utilities

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-SHARED-UTILITIES-GUIDE |
| **Version** | 1.0 |
| **Status** | Ready to Implement |
| **Category** | Technical Documentation |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Tech Lead, Senior Developers |
| **Stakeholders** | Development Team, QA Team |

---

## 🎯 **Purpose**

Dokumen ini menjelaskan shared utilities yang telah dibuat untuk aplikasi Usago Mobile. Shared utilities ini dirancang untuk menyediakan fungsionalitas umum yang dapat digunakan kembali di seluruh aplikasi, mempromosikan konsistensi, maintainability, dan pengurangan duplikasi kode.

## 🗂️ **Dokumentasi Terkait**

- [`architecture-patterns.md`](./architecture-patterns.md) - Implementasi Clean Architecture
- [`configuration-management.md`](./configuration-management.md) - Manajemen konfigurasi aplikasi
- [`performance-monitoring.md`](./performance-monitoring.md) - Monitoring performa aplikasi
- [`security-implementation.md`](./security-implementation.md) - Implementasi keamanan
- [`code-review-checklist.md`](./code-review-checklist.md) - Checklist untuk code review

Untuk daftar lengkap dokumentasi, lihat [`README.md`](./README.md).

---

## 📚 **Table of Contents**

1. [BaseUseCase](#baseusecase)
2. [RepositoryMixin](#repositorymixin)
3. [BaseBloc](#basebloc)
4. [ErrorHandlerUtils](#errorhandlerutils)
5. [DataSourceMixin](#datasourcemixin)
6. [ResultHandler](#resulthandler)
7. [Best Practices](#best-practices)
8. [Usage Examples](#usage-examples)
9. [Pattern Benefits](#pattern-benefits)
10. [Trade-offs](#trade-offs)

---

## 🏗️ **BaseUseCase**

### Deskripsi

[`BaseUseCase<Params, Type>`](../lib/core/utils/base_usecase.dart:10) adalah kelas abstrak yang menyediakan fungsionalitas umum untuk semua use case dalam aplikasi. Ini mengimplementasikan pattern Command dan memastikan konsistensi dalam eksekusi business logic.

### Fitur Utama

- **Template Method Pattern**: Menyediakan struktur eksekusi yang konsisten
- **Error Handling**: Centralized error handling dengan logging
- **Parameter Validation**: Built-in validation untuk input parameters
- **Performance Tracking**: Otomatis tracking untuk eksekusi use case
- **Logging**: Structured logging dengan correlation ID

### Specialized Classes

1. **NoParamsUseCase<Type>**: Untuk use case tanpa parameter
2. **VoidReturnUseCase<Params>**: Untuk use case yang tidak mengembalikan nilai
3. **ValidationMixin**: Menyediakan validasi umum (email, password, dll)

### Kapan Menggunakan

✅ **Gunakan BaseUseCase untuk:**
- Business logic yang kompleks
- Operasi yang memerlukan validation
- Use case yang memerlukan error handling konsisten
- Operasi yang perlu di-track performancenya

❌ **Jangan gunakan BaseUseCase untuk:**
- Operasi CRUD sederhana (gunakan Repository langsung)
- Validasi UI form (gunakan form validation)
- Transformasi data sederhana (gunakan mapper)

### Contoh Penggunaan

```dart
class LoginUseCase extends BaseUseCase<LoginParams, User> with ValidationMixin {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, User>> execute(LoginParams params) async {
    // Business logic here
    return await _repository.login(email: params.email, password: params.password);
  }

  @override
  Failure? validateParams(LoginParams params) {
    final emailError = validateEmail(params.email);
    if (emailError != null) return emailError;

    final passwordError = validatePassword(params.password);
    if (passwordError != null) return passwordError;

    return super.validateBusinessRules(params);
  }

  @override
  Failure? validateBusinessRules(LoginParams params) {
    if (params.email.toLowerCase().contains('admin')) {
      return const ValidationFailure(message: 'Admin login not allowed through this method');
    }
    return null;
  }
}
```

---

## 🔧 **RepositoryMixin**

### Deskripsi

[`RepositoryMixin`](../lib/core/mixins/repository_mixin.dart:8) menyediakan fungsionalitas umum untuk repository implementations, termasuk error handling, mapping, dan retry mechanisms.

### Fitur Utama

- **Safe Execution**: Wrapper untuk operasi async dengan error handling
- **Exception Mapping**: Konversi otomatis dari Exception ke Failure
- **Entity Mapping**: Helper untuk mapping Model ke Entity
- **Retry Logic**: Built-in retry dengan exponential backoff
- **Logging**: Structured logging untuk semua operasi repository

### Metode Utama

1. **safeExecute<T>()**: Wrapper untuk operasi yang mengembalikan nilai
2. **safeExecuteVoid()**: Wrapper untuk operasi void
3. **handleDatasourceResult<T>()**: Handle Either dari datasource
4. **mapToEntity<T, M>()**: Mapping model ke entity
5. **mapToEntities<T, M>()**: Batch mapping model ke entity

### Kapan Menggunakan

✅ **Gunakan RepositoryMixin untuk:**
- Semua repository implementations
- Operasi yang memerlukan error handling konsisten
- Repository yang berinteraksi dengan multiple datasources
- Operasi yang memerlukan retry logic

❌ **Jangan gunakan RepositoryMixin untuk:**
- Service classes (gunakan dependency injection langsung)
- UI logic (gunakan BLoC/Cubit)
- Simple data transformation (gunakan mapper)

### Contoh Penggunaan

```dart
class AuthRepositoryImpl with RepositoryMixin implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    return safeExecute(() async {
      final result = await _remoteDatasource.login(email: email, password: password);

      return result.fold(
        (failure) => throw failure.toException()!,
        (userModel) async {
          await _localDatasource.saveUser(userModel);
          return mapToEntity(userModel, (model) => model.toEntity()).fold(
            (failure) => throw failure.toException()!,
            (entity) => entity,
          );
        },
      );
    }, operationName: 'Login');
  }
}
```

---

## 🎭 **BaseBloc**

### Deskripsi

[`BaseBloc<Event, State>`](../lib/core/blocs/base_bloc.dart:94) adalah kelas abstrak yang menyediakan fungsionalitas umum untuk semua BLoC implementations, termasuk performance tracking, error handling, dan state management patterns.

### Fitur Utama

- **Performance Tracking**: Otomatis tracking untuk BLoC lifecycle
- **Error Handling**: Centralized error handling dengan logging
- **State Management**: Helper methods untuk state emission
- **Use Case Integration**: Built-in methods untuk use case execution
- **Correlation Tracking**: Automatic correlation ID generation

### Base Classes

1. **BaseEvent**: Base class untuk semua BLoC events
2. **BaseState**: Base class untuk semua BLoC states
3. **BaseInitialState**: Initial state untuk BLoCs
4. **BaseLoadingState**: Loading state dengan metadata
5. **BaseSuccessState<T>**: Success state dengan data
6. **BaseErrorState**: Error state dengan failure info

### Metode Utama

1. **executeUseCase<T, P>()**: Execute use case dengan state management
2. **executeVoidUseCase<P>()**: Execute void use case dengan state management
3. **emitError()**: Emit error state dengan logging
4. **emitLoading()**: Emit loading state dengan logging
5. **emitSuccess<T>()**: Emit success state dengan logging

### Kapan Menggunakan

✅ **Gunakan BaseBloc untuk:**
- State management yang kompleks
- BLoC yang memerlukan performance tracking
- BLoC yang berinteraksi dengan use cases
- BLoC yang memerlukan error handling konsisten

❌ **Jangan gunakan BaseBloc untuk:**
- Simple state management (gunakan Cubit)
- Local UI state (gunakan Stateful widget)
- Form validation state (gunakan FormController)

### Contoh Penggunaan

```dart
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    await executeUseCase(
      _loginUseCase.call,
      LoginParams(email: event.email, password: event.password),
      loadingMessage: 'Logging in...',
      successMessage: 'Login successful',
      eventName: 'Login',
      metadata: {'email': event.email},
    );
  }

  @override
  AuthState _createLoadingState(String? message, Map<String, dynamic>? metadata) {
    return AuthLoading(message: message);
  }

  @override
  AuthState _createSuccessState<T>(T? data, String? message, Map<String, dynamic>? metadata) {
    if (data is User) {
      return AuthSuccess(user: data, message: message);
    }
    return AuthSuccess(user: User.empty(), message: message);
  }

  @override
  AuthState _createErrorState(Failure failure, Map<String, dynamic>? metadata) {
    return AuthFailure(failure: failure);
  }
}
```

---

## 🚨 **ErrorHandlerUtils**

### Deskripsi

[`ErrorHandlerUtils`](../lib/core/utils/error_handler_utils.dart:9) adalah utility class yang menyediakan centralized error handling, conversion, dan logging dengan correlation tracking.

### Fitur Utama

- **Error Conversion**: Konversi dari Exception ke Failure
- **Correlation Tracking**: Automatic correlation ID generation
- **User-Friendly Messages**: Konversi error ke user-friendly messages
- **Recoverability Check**: Penentuan apakah error dapat di-retry
- **Structured Logging**: Logging dengan metadata terstruktur

### Metode Utama

1. **handleDioException()**: Handle DioException dengan konversi
2. **convertToFailure()**: Konversi generic Exception ke Failure
3. **generateCorrelationId()**: Generate correlation ID unik
4. **createUserFriendlyMessage()**: Buat user-friendly error message
5. **isRecoverableFailure()**: Check apakah failure dapat di-retry
6. **getRetryDelay()**: Hitung retry delay dengan exponential backoff

### Kapan Menggunakan

✅ **Gunakan ErrorHandlerUtils untuk:**
- Error handling di datasource layer
- Error conversion di repository layer
- User-facing error message generation
- Error logging dengan correlation tracking
- Retry logic implementation

❌ **Jangan gunakan ErrorHandlerUtils untuk:**
- Validation errors (gunakan ValidationFailure langsung)
- Business logic errors (gunakan custom Failure)
- UI error handling (gunakan BLoC error states)

### Contoh Penggunaan

```dart
try {
  final response = await dio.get('/api/data');
  return Right(response.data);
} on DioException catch (e) {
  final correlationId = ErrorHandlerUtils.generateCorrelationId();
  final failure = ErrorHandlerUtils.handleDioException(
    e,
    correlationId: correlationId,
    operation: 'FetchData',
  );

  ErrorHandlerUtils.logError(
    e,
    correlationId: correlationId,
    operation: 'FetchData',
    metadata: {'endpoint': '/api/data'},
  );

  return Left(failure);
}
```

---

## 📡 **DataSourceMixin**

### Deskripsi

[`DataSourceMixin`](../lib/core/mixins/datasource_mixin.dart:10) menyediakan fungsionalitas umum untuk datasource implementations, termasuk API call logging, correlation tracking, dan response handling.

### Fitur Utama

- **API Call Logging**: Structured logging untuk semua API calls
- **Correlation Tracking**: Automatic correlation ID untuk request chains
- **Response Validation**: Built-in response validation
- **Header Extraction**: Helper untuk extracting useful headers
- **Retry Logic**: Built-in retry dengan exponential backoff

### Metode Utama

1. **safeApiCall<T>()**: Safe wrapper untuk API calls
2. **safeApiCallWithResponse()**: Safe wrapper untuk API calls dengan Response object
3. **parseResponse<T>()**: Parse response data dengan error handling
4. **validateResponse()**: Validate response status code
5. **extractResponseHeaders()**: Extract useful headers dari response
6. **createRequestOptions()**: Create request options dengan correlation ID

### Kapan Menggunakan

✅ **Gunakan DataSourceMixin untuk:**
- Remote datasource implementations
- API client wrappers
- HTTP request handling
- Response parsing dan validation
- Network operation logging

❌ **Jangan gunakan DataSourceMixin untuk:**
- Local datasource (gunakan local storage patterns)
- Repository implementations (gunakan RepositoryMixin)
- Service layer (gunakan dependency injection)

### Contoh Penggunaan

```dart
class AuthRemoteDatasourceImpl with DataSourceMixin implements AuthRemoteDatasource {
  final DioClient _dioClient;

  @override
  Future<Either<Exception, User>> login({required String email, required String password}) async {
    final correlationId = generateCorrelationId();

    return await safeApiCall<User>(
      () async {
        final response = await _dioClient.post(
          '/auth/login',
          data: {'email': email, 'password': password},
          options: createRequestOptions(correlationId: correlationId),
        );

        return parseResponse(response, (data) => UserModel.fromJson(data));
      },
      method: 'POST',
      endpoint: '/auth/login',
      correlationId: correlationId,
      metadata: {'email': email},
    );
  }
}
```

---

## 📦 **ResultHandler**

### Deskripsi

[`ResultHandler`](../lib/core/utils/result_handler.dart:7) adalah utility class yang menyediakan helper methods untuk handling Either<Failure, T> results dengan functional programming patterns.

### Fitur Utama

- **Result Inspection**: Methods untuk checking result type
- **Value Extraction**: Methods untuk extracting values safely
- **Transformation**: Methods untuk transforming results
- **Chaining**: Methods untuk chaining operations
- **Side Effects**: Methods untuk executing side effects

### Metode Utama

1. **isSuccess<T>()**: Check apakah result adalah success
2. **isFailure<T>()**: Check apakah result adalah failure
3. **getSuccess<T>()**: Get success value atau null
4. **getFailure<T>()**: Get failure atau null
5. **mapSuccess<T, R>()**: Transform success value
6. **mapFailure<T>()**: Transform failure
7. **chain<T, R>()**: Chain operations
8. **combine<T>()**: Combine multiple results

### Kapan Menggunakan

✅ **Gunakan ResultHandler untuk:**
- Functional programming patterns
- Result transformation dan chaining
- Safe value extraction
- Complex result combinations
- Side effect execution

❌ **Jangan gunakan ResultHandler untuk:**
- Simple if/else logic (gunakan fold langsung)
- UI state management (gunakan BLoC)
- Error handling (gunakan ErrorHandlerUtils)

### Contoh Penggunaan

```dart
final result = await ResultHandler.asyncSafe(() async {
  return await apiService.getData();
});

final transformedResult = result
  .mapSuccess((data) => data.map((item) => item.toEntity()))
  .filter((entities) => entities.isNotEmpty, const ValidationFailure(message: 'No data found'))
  .onSuccess((entities) => logger.info('Loaded ${entities.length} entities'));

if (transformedResult.isFailure) {
  final errorMessage = transformedResult.failure!.userMessage;
  // Show error to user
} else {
  final entities = transformedResult.success!;
  // Use entities
}
```

---

## 🎯 **Best Practices**

### 1. **Consistent Error Handling**

Gunakan error handling patterns yang konsisten di seluruh aplikasi:

```dart
// ✅ GOOD: Consistent error handling
return safeExecute(() async {
  final result = await datasource.getData();
  return mapToEntity(result, (model) => model.toEntity());
}, operationName: 'GetData');

// ❌ BAD: Inconsistent error handling
try {
  final result = await datasource.getData();
  return Right(result.toEntity());
} catch (e) {
  return Left(ServerFailure(message: e.toString()));
}
```

### 2. **Proper Logging**

Gunakan structured logging dengan correlation ID:

```dart
// ✅ GOOD: Structured logging with correlation
final correlationId = generateCorrelationId();
logApiCallStart('POST', '/login', correlationId: correlationId);

// ❌ BAD: Unstructured logging
print('Making login request');
```

### 3. **Validation Separation**

Pisahkan validation logic dari business logic:

```dart
// ✅ GOOD: Separated validation
@override
Failure? validateParams(LoginParams params) {
  return validateEmail(params.email) ?? validatePassword(params.password);
}

@override
Future<Either<Failure, User>> execute(LoginParams params) async {
  // Pure business logic
  return await repository.login(email: params.email, password: params.password);
}

// ❌ BAD: Mixed validation and business logic
@override
Future<Either<Failure, User>> execute(LoginParams params) async {
  if (params.email.isEmpty) return Left(ValidationFailure(...));
  if (params.password.isEmpty) return Left(ValidationFailure(...));
  return await repository.login(...);
}
```

### 4. **Performance Considerations**

Gunakan performance tracking untuk operasi kritis:

```dart
// ✅ GOOD: Performance tracking
await executeUseCase(
  useCase,
  params,
  eventName: 'CriticalOperation',
  metadata: {'priority': 'high'},
);

// ❌ BAD: No performance tracking
final result = await useCase(params);
```

---

## 🔄 **Usage Examples**

### Complete Flow Example

```dart
// 1. Use Case with BaseUseCase
class GetUserUseCase extends BaseUseCase<String, User> {
  final UserRepository _repository;

  GetUserUseCase({required UserRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, User>> execute(String userId) async {
    return await _repository.getUser(userId);
  }

  @override
  Failure? validateParams(String userId) {
    if (userId.isEmpty) {
      return const ValidationFailure(message: 'User ID is required');
    }
    return null;
  }
}

// 2. Repository with RepositoryMixin
class UserRepositoryImpl with RepositoryMixin implements UserRepository {
  final UserRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    return safeExecute(() async {
      final result = await _remoteDatasource.getUser(userId);
      return result.fold(
        (failure) => throw failure.toException()!,
        (userModel) => userModel.toEntity(),
      );
    }, operationName: 'GetUser');
  }
}

// 3. Datasource with DataSourceMixin
class UserRemoteDatasourceImpl with DataSourceMixin implements UserRemoteDatasource {
  final DioClient _dioClient;

  @override
  Future<Either<Exception, UserModel>> getUser(String userId) async {
    return await safeApiCall<UserModel>(
      () async {
        final response = await _dioClient.get('/users/$userId');
        return parseResponse(response, (data) => UserModel.fromJson(data));
      },
      method: 'GET',
      endpoint: '/users/$userId',
      metadata: {'userId': userId},
    );
  }
}

// 4. BLoC with BaseBloc
class UserBloc extends BaseBloc<UserEvent, UserState> {
  final GetUserUseCase _getUserUseCase;

  UserBloc({required GetUserUseCase getUserUseCase})
      : _getUserUseCase = getUserUseCase,
        super(const UserInitial()) {
    on<GetUserEvent>(_onGetUser);
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    await executeUseCase(
      _getUserUseCase.call,
      event.userId,
      loadingMessage: 'Loading user...',
      eventName: 'GetUser',
      metadata: {'userId': event.userId},
    );
  }
}
```

---

## 💡 **Pattern Benefits**

### 1. **Consistency**
- Standardized error handling di seluruh aplikasi
- Consistent logging format dengan correlation tracking
- Uniform validation patterns
- Standardized performance monitoring

### 2. **Maintainability**
- Centralized logic reduces code duplication
- Easy to update behavior in one place
- Clear separation of concerns
- Well-tested utility functions

### 3. **Testability**
- Each utility can be tested independently
- Mock-friendly interfaces
- Deterministic behavior
- Easy error simulation

### 4. **Performance**
- Optimized error handling paths
- Efficient logging mechanisms
- Memory-conscious implementations
- Built-in performance tracking

### 5. **Developer Experience**
- Clear patterns to follow
- Helpful error messages
- Comprehensive documentation
- IDE-friendly method signatures

---

## ⚖️ **Trade-offs**

### 1. **Complexity vs. Simplicity**
- **Pro**: Rich functionality out of the box
- **Con**: Learning curve for new developers
- **Mitigation**: Comprehensive documentation and examples

### 2. **Abstraction vs. Transparency**
- **Pro**: Hides implementation details
- **Con**: Can be harder to debug
- **Mitigation**: Detailed logging and correlation tracking

### 3. **Flexibility vs. Standardization**
- **Pro**: Consistent patterns across codebase
- **Con**: Less flexibility for edge cases
- **Mitigation**: Extension points and customization options

### 4. **Performance vs. Features**
- **Pro**: Built-in performance tracking
- **Con**: Slight overhead for tracking
- **Mitigation**: Configurable monitoring and lazy evaluation

---

## 🔗 **Related Documentation**

- [`architecture-patterns.md`](./architecture-patterns.md) - Architecture patterns and data flow
- [`configuration-management.md`](./configuration-management.md) - Configuration and constants
- [`performance-monitoring.md`](./performance-monitoring.md) - Performance monitoring guide
- [`security-implementation.md`](./security-implementation.md) - Security best practices
- [`code-review-checklist.md`](./code-review-checklist.md) - Code review guidelines

---

## 📞 **Contact Information**

### **Development Team**

| Role | Name | Contact |
|-------|-------|----------|
| **Mobile Lead** | [Name] | [Email] |
| **Tech Lead** | [Name] | [Email] |
| **Senior Developer** | [Name] | [Email] |

### **Support**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Utility Bug** | [Name] | 2 hours |
| **Documentation Update** | [Name] | 4 hours |
| **Pattern Question** | [Name] | 1 day |

---

## 📝 **Notes**

### **Current Status (November 15, 2025)**
- ✅ **BaseUseCase**: Implemented dengan validation dan logging
- ✅ **RepositoryMixin**: Implemented dengan error handling dan retry
- ✅ **BaseBloc**: Implemented dengan performance tracking
- ✅ **ErrorHandlerUtils**: Implemented dengan correlation tracking
- ✅ **DataSourceMixin**: Implemented dengan API logging
- ✅ **ResultHandler**: Implemented dengan functional patterns

### **Future Enhancements**
- 🔄 **Advanced Retry Patterns**: Circuit breaker implementation
- 🔄 **Enhanced Validation**: Custom validation rules
- 🔄 **Performance Analytics**: Advanced performance metrics
- 🔄 **Error Recovery**: Automatic error recovery strategies

---

**Document End**

**Go Digital, Grow Together.**