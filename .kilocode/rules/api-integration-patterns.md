# API Integration Patterns
# Pola Integrasi API

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-API-INTEGRATION-PATTERNS |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | API Rules |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Backend Lead, Mobile Lead |
| **Stakeholders** | Development Team, QA Team, DevOps Team |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan pola dan aturan integrasi API yang wajib diikuti dalam pengembangan aplikasi Usago Mobile. Pola ini berdasarkan struktur API yang ada di [`../docs/04-api/endpoints-structure.md`](../docs/04-api/endpoints-structure.md).

---

## 📚 **Table of Contents**

1. [API Client Architecture](#api-client-architecture)
2. [Request/Response Patterns](#requestresponse-patterns)
3. [Error Handling Patterns](#error-handling-patterns)
4. [Authentication Patterns](#authentication-patterns)
5. [Caching Patterns](#caching-patterns)
6. [Retry Patterns](#retry-patterns)
7. [Security Patterns](#security-patterns)
8. [Performance Patterns](#performance-patterns)

---

## 🏗️ **API Client Architecture**

### **Pattern 1.1: Centralized API Client**

Gunakan centralized API client untuk semua HTTP operations:

```dart
// ✅ BENAR: Centralized API client
class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;

  ApiClient({
    required Dio dio,
    required TokenManager tokenManager,
  }) : _dio = dio,
       _tokenManager = tokenManager {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(_tokenManager),
      LoggingInterceptor(),
      ErrorInterceptor(),
      PerformanceInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

// ❌ SALAH: Scattered API calls
class UserRepository {
  final Dio _dio = Dio(); // Multiple Dio instances

  Future<User> getUser(String id) async {
    return await _dio.get('/users/$id'); // No centralized configuration
  }

  Future<User> updateUser(String id, User user) async {
    return await _dio.put('/users/$id', data: user.toJson());
  }
}
```

### **Pattern 1.2: Repository Pattern**

Gunakan repository pattern untuk data access abstraction:

```dart
// ✅ BENAR: Repository pattern
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, User>> updateUser(String id, User user);
  Future<Either<Failure, void>> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  final UserMapper _mapper;

  UserRepositoryImpl(this._apiClient, this._mapper);

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      final user = _mapper.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final response = await _apiClient.get('/users');
      final users = (response.data as List)
          .map((json) => _mapper.fromJson(json))
          .toList();
      return Right(users);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

// ❌ SALAH: Direct API calls without abstraction
class UserService {
  final Dio _dio = Dio();

  Future<User> getUser(String id) async {
    final response = await _dio.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<List<User>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}
```

---

## 📨 **Request/Response Patterns**

### **Pattern 2.1: Standardized Request Format**

Gunakan format request yang konsisten:

```dart
// ✅ BENAR: Standardized request format
class StandardRequest {
  final Map<String, dynamic> data;
  final Map<String, String> headers;
  final Map<String, dynamic> queryParameters;

  const StandardRequest({
    required this.data,
    this.headers = const {},
    this.queryParameters = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'headers': headers,
      'queryParameters': queryParameters,
      'timestamp': DateTime.now().toIso8601String(),
      'requestId': _generateRequestId(),
    };
  }

  String _generateRequestId() {
    return 'req_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}

class ApiRequestBuilder {
  String _path = '';
  RequestMethod _method = RequestMethod.get;
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _queryParameters = {};
  Map<String, String> _headers = {};

  ApiRequestBuilder path(String path) {
    _path = path;
    return this;
  }

  ApiRequestBuilder method(RequestMethod method) {
    _method = method;
    return this;
  }

  ApiRequestBuilder data(Map<String, dynamic> data) {
    _data = data;
    return this;
  }

  ApiRequestBuilder queryParameters(Map<String, dynamic> params) {
    _queryParameters = params;
    return this;
  }

  ApiRequestBuilder headers(Map<String, String> headers) {
    _headers = headers;
    return this;
  }

  StandardRequest build() {
    return StandardRequest(
      data: _data,
      headers: _headers,
      queryParameters: _queryParameters,
    );
  }
}

// Usage
final request = ApiRequestBuilder()
    .path('/users')
    .method(RequestMethod.post)
    .data({'name': 'John', 'email': 'john@example.com'})
    .headers({'Content-Type': 'application/json'})
    .build();
```

### **Pattern 2.2: Standardized Response Handling**

Gunakan response handling yang konsisten:

```dart
// ✅ BENAR: Standardized response handling
class ApiResponse<T> {
  final bool success;
  final T? data;
  final ApiError? error;
  final Map<String, dynamic>? metadata;
  final String? correlationId;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.metadata,
    this.correlationId,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'],
      error: json['error'] != null ? ApiError.fromJson(json['error']) : null,
      metadata: json['metadata'],
      correlationId: json['correlationId'],
    );
  }

  bool get isSuccess => success && error == null;
  bool get isError => !success || error != null;
}

class ApiError {
  final String code;
  final String message;
  final String? userMessage;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.code,
    required this.message,
    this.userMessage,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'Unknown error occurred',
      userMessage: json['userMessage'],
      details: json['details'],
    );
  }
}

class ResponseHandler {
  static Either<Failure, T> handleResponse<T>(
    ApiResponse<T> response,
  ) {
    if (response.isSuccess) {
      return Right(response.data as T);
    } else {
      return Left(_mapApiErrorToFailure(response.error!));
    }
  }

  static Failure _mapApiErrorToFailure(ApiError error) {
    switch (error.code) {
      case 'VALIDATION_ERROR':
        return ValidationFailure(message: error.userMessage ?? error.message);
      case 'AUTHENTICATION_ERROR':
        return AuthenticationFailure(message: error.userMessage ?? error.message);
      case 'AUTHORIZATION_ERROR':
        return AuthorizationFailure(message: error.userMessage ?? error.message);
      case 'NOT_FOUND':
        return NotFoundFailure(message: error.userMessage ?? error.message);
      case 'SERVER_ERROR':
        return ServerFailure(message: error.userMessage ?? error.message);
      default:
        return UnknownFailure(message: error.userMessage ?? error.message);
    }
  }
}

// ❌ SALAH: Inconsistent response handling
class InconsistentHandler {
  Future<User> getUser(String id) async {
    final response = await _dio.get('/users/$id');

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Unknown error');
    }
  }
}
```

---

## ⚠️ **Error Handling Patterns**

### **Pattern 3.1: Centralized Error Handling**

Gunakan centralized error handling dengan correlation tracking:

```dart
// ✅ BENAR: Centralized error handling
class ErrorHandler {
  static Future<Either<Failure, T>> safeApiCall<T>(
    Future<T> Function() apiCall, {
    required String operation,
    Map<String, dynamic>? metadata,
  }) async {
    final correlationId = _generateCorrelationId();

    try {
      _logOperationStart(operation, correlationId, metadata);

      final result = await apiCall();

      _logOperationSuccess(operation, correlationId, metadata);
      return Right(result);
    } on DioException catch (e) {
      final failure = _handleDioException(e, correlationId);
      _logOperationError(operation, correlationId, failure, metadata);
      return Left(failure);
    } catch (e, stackTrace) {
      final failure = UnknownFailure(
        message: e.toString(),
        correlationId: correlationId,
      );
      _logOperationError(operation, correlationId, failure, metadata, stackTrace);
      return Left(failure);
    }
  }

  static String _generateCorrelationId() {
    return 'corr_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  static Failure _handleDioException(DioException e, String correlationId) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkTimeoutFailure(
          message: 'Connection timeout',
          correlationId: correlationId,
        );
      case DioExceptionType.sendTimeout:
        return NetworkTimeoutFailure(
          message: 'Send timeout',
          correlationId: correlationId,
        );
      case DioExceptionType.receiveTimeout:
        return NetworkTimeoutFailure(
          message: 'Receive timeout',
          correlationId: correlationId,
        );
      case DioExceptionType.badResponse:
        return _handleHttpError(e.response!, correlationId);
      case DioExceptionType.cancel:
        return RequestCancelledFailure(
          message: 'Request was cancelled',
          correlationId: correlationId,
        );
      case DioExceptionType.connectionError:
        return NetworkConnectionFailure(
          message: 'Connection error',
          correlationId: correlationId,
        );
      case DioExceptionType.unknown:
        return UnknownFailure(
          message: e.message ?? 'Unknown network error',
          correlationId: correlationId,
        );
    }
  }

  static Failure _handleHttpError(Response response, String correlationId) {
    final statusCode = response.statusCode ?? 0;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: response.data['message'] ?? 'Bad request',
          correlationId: correlationId,
        );
      case 401:
        return AuthenticationFailure(
          message: response.data['message'] ?? 'Unauthorized',
          correlationId: correlationId,
        );
      case 403:
        return AuthorizationFailure(
          message: response.data['message'] ?? 'Forbidden',
          correlationId: correlationId,
        );
      case 404:
        return NotFoundFailure(
          message: response.data['message'] ?? 'Not found',
          correlationId: correlationId,
        );
      case 500:
        return ServerFailure(
          message: response.data['message'] ?? 'Server error',
          correlationId: correlationId,
        );
      default:
        return UnknownFailure(
          message: response.data['message'] ?? 'Unknown error',
          correlationId: correlationId,
        );
    }
  }
}

// ❌ SALAH: Scattered error handling
class ScatteredErrorHandler {
  Future<User> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode == 404) {
          throw Exception('User not found');
        } else if (e.response?.statusCode == 500) {
          throw Exception('Server error');
        }
      }
      throw Exception('Unknown error');
    } catch (e) {
      throw Exception('Unknown error');
    }
  }
}
```

---

## 🔐 **Authentication Patterns**

### **Pattern 4.1: Token Management**

Gunakan token management yang aman dan otomatis:

```dart
// ✅ BENAR: Secure token management
class TokenManager {
  final EnhancedSecureStorageService _secureStorage;
  final ApiClient _apiClient;

  TokenManager(this._secureStorage, this._apiClient);

  Future<String?> getValidAccessToken() async {
    final tokenData = await _secureStorage.getSecureData('access_token');
    if (tokenData == null) return null;

    final token = TokenData.fromJson(jsonDecode(tokenData));

    if (_isTokenExpired(token)) {
      return await _refreshAccessToken();
    }

    return token.accessToken;
  }

  Future<String?> _refreshAccessToken() async {
    final refreshTokenData = await _secureStorage.getSecureData('refresh_token');
    if (refreshTokenData == null) return null;

    final refreshToken = TokenData.fromJson(jsonDecode(refreshTokenData));

    try {
      final response = await _apiClient.post('/auth/refresh', data: {
        'refresh_token': refreshToken.refreshToken,
      });

      final newTokenData = TokenData.fromJson(response.data);
      await _storeTokens(newTokenData);

      return newTokenData.accessToken;
    } catch (e) {
      await clearTokens();
      return null;
    }
  }

  Future<void> storeTokens(TokenData tokenData) async {
    await _secureStorage.storeSecureData(
      'access_token',
      jsonEncode(tokenData.toJson()),
    );
    await _secureStorage.storeSecureData(
      'refresh_token',
      jsonEncode(tokenData.toJson()),
    );
  }

  Future<void> clearTokens() async {
    await _secureStorage.deleteSecureData('access_token');
    await _secureStorage.deleteSecureData('refresh_token');
  }

  bool _isTokenExpired(TokenData token) {
    return DateTime.now().isAfter(token.expiresAt);
  }
}

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManager.getValidAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try refresh
      final newToken = await _tokenManager._refreshAccessToken();
      if (newToken != null) {
        // Retry request with new token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await _dio.fetch(retryOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Refresh failed, proceed with error
        }
      }
    }

    handler.next(err);
  }
}

// ❌ SALAH: Insecure token management
class InsecureTokenManager {
  final SharedPreferences _prefs;

  InsecureTokenManager(this._prefs);

  Future<String?> getAccessToken() async {
    return _prefs.getString('access_token'); // No encryption
  }

  Future<void> storeToken(String token) async {
    await _prefs.setString('access_token', token); // No encryption
  }

  Future<void> clearToken() async {
    await _prefs.remove('access_token');
  }
}
```

---

## 💾 **Caching Patterns**

### **Pattern 5.1: Response Caching**

Gunakan response caching untuk performance improvement:

```dart
// ✅ BENAR: Response caching implementation
class CacheManager {
  final Map<String, CacheItem> _cache = {};
  final Duration _defaultExpiry;

  CacheManager({Duration defaultExpiry = const Duration(hours: 1)})
      : _defaultExpiry = defaultExpiry;

  Future<T?> get<T>(String key) async {
    final item = _cache[key];
    if (item == null) return null;

    if (item.isExpired) {
      _cache.remove(key);
      return null;
    }

    return item.data as T?;
  }

  Future<void> set<T>(
    String key,
    T data, {
    Duration? expiry,
  }) async {
    final item = CacheItem(
      data: data,
      timestamp: DateTime.now(),
      expiry: expiry ?? _defaultExpiry,
    );

    _cache[key] = item;
  }

  Future<void> invalidate(String key) async {
    _cache.remove(key);
  }

  Future<void> clear() async {
    _cache.clear();
  }

  Future<void> cleanupExpired() async {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }
}

class CachedRepository<T> {
  final Repository<T> _repository;
  final CacheManager _cacheManager;
  final Duration _cacheExpiry;

  CachedRepository(
    this._repository,
    this._cacheManager, {
    Duration cacheExpiry = const Duration(hours: 1),
  }) : _cacheExpiry = cacheExpiry;

  Future<Either<Failure, T>> get(String id, {bool forceRefresh = false}) async {
    final cacheKey = '${T.toString()}_$id';

    if (!forceRefresh) {
      final cachedData = await _cacheManager.get<T>(cacheKey);
      if (cachedData != null) {
        return Right(cachedData);
      }
    }

    final result = await _repository.get(id);

    return result.fold(
      (failure) => Left(failure),
      (data) async {
        await _cacheManager.set(cacheKey, data, expiry: _cacheExpiry);
        return Right(data);
      },
    );
  }
}

class CacheInterceptor extends Interceptor {
  final CacheManager _cacheManager;
  final Set<String> _cacheableMethods = {'GET'};
  final Set<String> _nonCacheablePaths = {'/auth/', '/users/me'};

  CacheInterceptor(this._cacheManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_shouldCache(options)) {
      final cacheKey = _generateCacheKey(options);
      final cachedResponse = await _cacheManager.get<Response>(cacheKey);

      if (cachedResponse != null) {
        handler.resolve(cachedResponse);
        return;
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (_shouldCache(response.requestOptions)) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      final expiry = _getCacheExpiry(response);

      await _cacheManager.set(cacheKey, response, expiry: expiry);
    }

    handler.next(response);
  }

  bool _shouldCache(RequestOptions options) {
    return _cacheableMethods.contains(options.method.toUpperCase()) &&
        !_nonCacheablePaths.any((path) => options.path.startsWith(path));
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.method}_${options.path}_${jsonEncode(options.queryParameters)}';
  }

  Duration _getCacheExpiry(Response response) {
    final cacheControl = response.headers['cache-control']?.first;
    if (cacheControl != null) {
      final maxAge = _parseMaxAge(cacheControl);
      if (maxAge != null) {
        return Duration(seconds: maxAge);
      }
    }

    return const Duration(hours: 1);
  }

  int? _parseMaxAge(String cacheControl) {
    final maxAgeRegex = RegExp(r'max-age=(\d+)');
    final match = maxAgeRegex.firstMatch(cacheControl);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}

// ❌ SALAH: No caching
class NoCacheRepository {
  final ApiClient _apiClient;

  NoCacheRepository(this._apiClient);

  Future<Either<Failure, User>> getUser(String id) async {
    final response = await _apiClient.get('/users/$id');
    return Right(User.fromJson(response.data));
  }

  Future<Either<Failure, List<User>>> getUsers() async {
    final response = await _apiClient.get('/users');
    final users = (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
    return Right(users);
  }
}
```

---

## 🔄 **Retry Patterns**

### **Pattern 6.1: Exponential Backoff Retry**

Gunakan exponential backoff untuk failed requests:

```dart
// ✅ BENAR: Exponential backoff retry
class RetryManager {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final List<String> retryableErrorCodes;

  RetryManager({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.retryableErrorCodes = const ['TIMEOUT', 'CONNECTION_ERROR', 'SERVER_ERROR'],
  });

  Future<Either<Failure, T>> executeWithRetry<T>(
    Future<Either<Failure, T>> Function() operation, {
    String? operationName,
  }) async {
    var delay = initialDelay;
    var attempt = 0;

    while (attempt <= maxRetries) {
      final result = await operation();

      if (result.isRight()) {
        return result;
      }

      final failure = result.fold((l) => l, (r) => null)!;

      if (!_shouldRetry(failure) || attempt >= maxRetries) {
        return result;
      }

      attempt++;

      await Future.delayed(delay);
      delay = Duration(
        milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
      );

      _logRetryAttempt(operationName ?? 'Unknown', attempt, failure, delay);
    }

    return const Left(ServerFailure(message: 'Max retries exceeded'));
  }

  bool _shouldRetry(Failure failure) {
    if (failure is NetworkFailure) {
      return true;
    }

    if (failure is ServerFailure) {
      return retryableErrorCodes.contains(failure.code);
    }

    return false;
  }

  void _logRetryAttempt(String operation, int attempt, Failure failure, Duration delay) {
    logger.info(
      'Retrying operation: $operation (attempt $attempt/$maxRetries) after ${delay.inMilliseconds}ms',
      extra: {
        'operation': operation,
        'attempt': attempt,
        'maxRetries': maxRetries,
        'delay': delay.inMilliseconds,
        'failure': failure.message,
      },
    );
  }
}

class RetryInterceptor extends Interceptor {
  final RetryManager _retryManager;

  RetryInterceptor(this._retryManager);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < _retryManager.maxRetries) {
        final delay = _calculateDelay(retryCount);

        await Future.delayed(delay);

        final retryOptions = err.requestOptions;
        retryOptions.extra['retryCount'] = retryCount + 1;

        try {
          final response = await _dio.fetch(retryOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Retry failed, continue with error
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        return statusCode != null && (statusCode! >= 500 || statusCode == 429);
      default:
        return false;
    }
  }

  Duration _calculateDelay(int retryCount) {
    return Duration(
      milliseconds: (1000 * pow(2, retryCount)).round(),
    );
  }
}

// ❌ SALAH: No retry mechanism
class NoRetryRepository {
  final ApiClient _apiClient;

  NoRetryRepository(this._apiClient);

  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      return Right(User.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

---

## 🛡️ **Security Patterns**

### **Pattern 7.1: Request Signing**

Gunakan request signing untuk critical endpoints:

```dart
// ✅ BENAR: Request signing implementation
class RequestSigner {
  final String _secretKey;

  RequestSigner(this._secretKey);

  Map<String, String> signRequest({
    required String method,
    required String path,
    required Map<String, dynamic> data,
    String? timestamp,
  }) {
    final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch.toString();

    final payload = _createPayload(method, path, data, ts);
    final signature = _generateSignature(payload);

    return {
      'X-Timestamp': ts,
      'X-Signature': signature,
      'X-Algorithm': 'HMAC-SHA256',
    };
  }

  String _createPayload(String method, String path, Map<String, dynamic> data, String timestamp) {
    final sortedData = Map.from(data);
    sortedData.removeWhere((key, value) => key.startsWith('_'));

    final sortedKeys = sortedData.keys.toList()..sort();
    final queryString = sortedKeys.map((key) => '$key=${sortedData[key]}').join('&');

    return '$method\n$path\n$timestamp\n$queryString';
  }

  String _generateSignature(String payload) {
    final hmac = Hmac(sha256, utf8.encode(_secretKey));
    final digest = hmac.convert(utf8.encode(payload));
    return base64.encode(digest.bytes);
  }
}

class SecureApiClient {
  final Dio _dio;
  final RequestSigner _requestSigner;
  final Set<String> _secureEndpoints;

  SecureApiClient(
    this._dio,
    this._requestSigner, {
    Set<String> secureEndpoints = const {'/auth/', '/payment/', '/sensitive/'},
  }) : _secureEndpoints = secureEndpoints;

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final requestOptions = options ?? Options();

    if (_isSecureEndpoint(path)) {
      final signatureHeaders = _requestSigner.signRequest(
        method: 'POST',
        path: path,
        data: data ?? {},
      );

      requestOptions.headers = {
        ...?requestOptions.headers,
        ...signatureHeaders,
      };
    }

    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
    );
  }

  bool _isSecureEndpoint(String path) {
    return _secureEndpoints.any((securePath) => path.startsWith(securePath));
  }
}

// ❌ SALAH: No request signing
class InsecureApiClient {
  final Dio _dio;

  InsecureApiClient(this._dio);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
```

### **Pattern 7.2: Certificate Pinning**

Gunakan certificate pinning untuk production:

```dart
// ✅ BENAR: Certificate pinning
class CertificatePinningInterceptor extends Interceptor {
  final Map<String, String> _pinnedCertificates;

  CertificatePinningInterceptor(this._pinnedCertificates);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.baseUrl.startsWith('https://')) {
      final hostname = Uri.parse(options.baseUrl).host;

      if (_pinnedCertificates.containsKey(hostname)) {
        (options.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
          client.badCertificateCallback = (cert, host, port) {
            if (host != hostname) return false;

            final pinnedCert = _pinnedCertificates[hostname]!;
            final certFingerprint = _getCertificateFingerprint(cert);
            final pinnedFingerprint = _getCertificateFingerprintFromString(pinnedCert);

            return certFingerprint == pinnedFingerprint;
          };

          return client;
        };
      }
    }

    handler.next(options);
  }

  String _getCertificateFingerprint(X509Certificate cert) {
    final bytes = cert.der;
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  String _getCertificateFingerprintFromString(String certString) {
    final bytes = base64.decode(certString);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }
}

// ❌ SALAH: No certificate pinning
class InsecureApiClient {
  final Dio _dio;

  InsecureApiClient(this._dio) {
    // No certificate pinning
  }
}
```

---

## ⚡ **Performance Patterns**

### **Pattern 8.1: Request Batching**

Gunakan request batching untuk multiple API calls:

```dart
// ✅ BENAR: Request batching
class BatchRequestManager {
  final ApiClient _apiClient;
  final Duration _batchTimeout;
  final Map<String, List<BatchRequest>> _pendingRequests = {};
  Timer? _batchTimer;

  BatchRequestManager(
    this._apiClient, {
    Duration batchTimeout = const Duration(milliseconds: 100),
  }) : _batchTimeout = batchTimeout;

  Future<T> batchRequest<T>(
    String batchKey,
    BatchRequest<T> request,
  ) async {
    final completer = Completer<T>();

    _pendingRequests.putIfAbsent(batchKey, () => []).add(request);

    if (_batchTimer == null) {
      _batchTimer = Timer(_batchTimeout, _processBatch);
    }

    return completer.future;
  }

  Future<void> _processBatch() async {
    _batchTimer?.cancel();
    _batchTimer = null;

    final requests = Map<String, List<BatchRequest>>.from(_pendingRequests);
    _pendingRequests.clear();

    for (final entry in requests.entries) {
      await _executeBatch(entry.key, entry.value);
    }
  }

  Future<void> _executeBatch(String batchKey, List<BatchRequest> requests) async {
    try {
      final batchData = {
        'requests': requests.map((r) => r.toJson()).toList(),
        'batchId': _generateBatchId(),
      };

      final response = await _apiClient.post('/batch', data: batchData);
      final results = response.data['results'] as List;

      for (int i = 0; i < requests.length; i++) {
        final request = requests[i];
        final result = results[i];

        if (result['success']) {
          request.completer.complete(result['data']);
        } else {
          request.completer.completeError(Exception(result['error']));
        }
      }
    } catch (e) {
      for (final request in requests) {
        request.completer.completeError(e);
      }
    }
  }

  String _generateBatchId() {
    return 'batch_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}

class BatchRequest<T> {
  final String method;
  final String path;
  final Map<String, dynamic> data;
  final Completer<T> completer;

  BatchRequest({
    required this.method,
    required this.path,
    required this.data,
    required Completer<T> completer,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'path': path,
      'data': data,
    };
  }
}

// Usage example
class UserRepository {
  final BatchRequestManager _batchManager;

  UserRepository(this._batchManager);

  Future<User> getUser(String id) async {
    return await _batchManager.batchRequest(
      'users',
      BatchRequest(
        method: 'GET',
        path: '/users/$id',
        data: {'id': id},
        completer: Completer<User>(),
      ),
    );
  }

  Future<List<User>> getUsers(List<String> ids) async {
    final futures = ids.map((id) => getUser(id)).toList();
    return await Future.wait(futures);
  }
}

// ❌ SALAH: No request batching
class NoBatchRepository {
  final ApiClient _apiClient;

  NoBatchRepository(this._apiClient);

  Future<User> getUser(String id) async {
    final response = await _apiClient.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<List<User>> getUsers(List<String> ids) async {
    final futures = ids.map((id) => getUser(id)).toList();
    return await Future.wait(futures); // Multiple individual requests
  }
}
```

### **Pattern 8.2: Connection Pooling**

Gunakan connection pooling untuk efficient network usage:

```dart
// ✅ BENAR: Connection pooling
class ConnectionPoolManager {
  final int maxConnections;
  final Duration connectionTimeout;
  final List<Dio> _connections = [];
  final Queue<Completer<Dio>> _waitingQueue = Queue();

  ConnectionPoolManager({
    this.maxConnections = 5,
    this.connectionTimeout = const Duration(seconds: 30),
  });

  Future<Dio> getConnection() async {
    if (_connections.isNotEmpty) {
      return _connections.removeLast();
    }

    if (_connections.length < maxConnections) {
      return _createConnection();
    }

    final completer = Completer<Dio>();
    _waitingQueue.add(completer);
    return completer.future;
  }

  void releaseConnection(Dio connection) {
    if (_waitingQueue.isNotEmpty) {
      final completer = _waitingQueue.removeFirst();
      completer.complete(connection);
    } else {
      _connections.add(connection);
    }
  }

  Dio _createConnection() {
    return Dio(BaseOptions(
      connectTimeout: connectionTimeout,
      receiveTimeout: connectionTimeout,
    ));
  }
}

class PooledApiClient {
  final ConnectionPoolManager _connectionPool;

  PooledApiClient(this._connectionPool);

  Future<Response<T>> get<T>(String path) async {
    final connection = await _connectionPool.getConnection();

    try {
      final response = await connection.get<T>(path);
      return response;
    } finally {
      _connectionPool.releaseConnection(connection);
    }
  }
}

// ❌ SALAH: No connection pooling
class NoPoolApiClient {
  final Dio _dio;

  NoPoolApiClient(this._dio);

  Future<Response<T>> get<T>(String path) async {
    return await _dio.get<T>(path); // New connection every time
  }
}
```

---

## ✅ **API Integration Checklist**

### **Before Implementation**
- [ ] API documentation reviewed
- [ ] Endpoints structure understood
- [ ] Authentication flow defined
- [ ] Error handling strategy planned
- [ ] Performance requirements identified

### **During Implementation**
- [ ] Repository pattern used
- [ ] Centralized API client implemented
- [ ] Proper error handling implemented
- [ ] Authentication integrated
- [ ] Caching strategy implemented
- [ ] Retry mechanism added
- [ ] Security measures implemented
- [ ] Performance optimizations applied

### **After Implementation**
- [ ] API integration tested
- [ ] Error scenarios tested
- [ ] Performance benchmarks met
- [ ] Security review completed
- [ ] Documentation updated

---

## 🔗 **Related Documentation**

- [`../docs/04-api/endpoints-structure.md`](../docs/04-api/endpoints-structure.md) - API endpoints structure
- [`../docs/04-api/README.md`](../docs/04-api/README.md) - API documentation overview
- [`../security-implementation-rules.md`](./security-implementation-rules.md) - Security implementation rules
- [`../performance-monitoring-rules.md`](./performance-monitoring-rules.md) - Performance monitoring rules
- [`../testing-strategies-rules.md`](./testing-strategies-rules.md) - Testing strategies rules

---

## 📞 **Contact Information**

### **API Team**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **API Integration** | api-team@usago.id | 4 hours |
| **Authentication Issues** | auth-team@usago.id | 2 hours |
| **Performance Issues** | performance@usago.id | 2 hours |
| **Security Issues** | security@usago.id | 1 hour |

---

## 📝 **Notes**

### **Best Practices**
- Always use HTTPS in production
- Implement proper error handling
- Use caching for frequently accessed data
- Implement retry mechanisms for failed requests
- Secure sensitive data with encryption
- Monitor API performance
- Use correlation IDs for request tracking
- Implement rate limiting

### **Performance Targets**
- API response time < 2 seconds (average)
- API response time < 5 seconds (95th percentile)
- Cache hit rate > 80%
- Retry success rate > 90%
- Connection reuse rate > 70%

---

**Document End**

**Go Digital, Grow Together.**