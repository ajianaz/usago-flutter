import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../utils/logger.dart';
import '../context/context_manager.dart';
import '../services/device_info_service.dart';
import '../services/secure_storage_service.dart';
import '../errors/better_auth_error_handler.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class DioClient {
  late Dio _dio;
  final AppLogger _logger;
  late BetterAuthErrorHandler _errorHandler;

  DioClient({
    AppLogger? logger,
    AuthRepository? authRepository,
  }) : _logger = logger ?? AppLogger() {
    // Initialize error handler
    _errorHandler = BetterAuthErrorHandler(logger: _logger);

    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Ensure Dio handles JSON serialization automatically
      responseType: ResponseType.json,
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(logger: _logger));
    _dio.interceptors
        .add(AuthInterceptor(logger: _logger, authRepository: authRepository));
  }

  Dio get dio => _dio;

  /// Update AuthRepository in AuthInterceptor after dependency injection is complete
  void updateAuthRepository(AuthRepository authRepository) {
    // Find and update the AuthInterceptor
    final authInterceptor =
        _dio.interceptors.whereType<AuthInterceptor>().first;
    authInterceptor._updateAuthRepository(authRepository);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Special method for Better Auth that returns full response to access headers
  Future<Response> postWithHeaders(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
            'Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        // Use Better Auth error handler for Better Auth specific errors
        if (responseData is Map<String, dynamic>) {
          final message = _errorHandler.handleBetterAuthError(
            statusCode ?? 0,
            responseData,
          );
          return Exception(message);
        }

        final message = responseData?['message'] ?? 'Unknown error';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');
      case DioExceptionType.unknown:
        return Exception('An unknown error occurred: ${error.message}');
      default:
        return Exception('An unexpected error occurred: ${error.message}');
    }
  }
}

class LogInterceptor extends Interceptor {
  final AppLogger _logger;

  LogInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug('=== REQUEST START ===');
    _logger.debug('METHOD: ${options.method}');
    _logger.debug('URL: ${options.baseUrl}${options.path}');
    _logger.debug('HEADERS: ${options.headers}');
    _logger.debug('DATA: ${options.data}');
    _logger.debug('QUERY PARAMS: ${options.queryParameters}');
    _logger.debug('=== REQUEST END ===');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.debug('=== RESPONSE START ===');
    _logger.debug('STATUS: ${response.statusCode}');
    _logger.debug(
        'URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    _logger.debug('HEADERS: ${response.headers}');
    _logger.debug('DATA: ${response.data}');
    _logger.debug('=== RESPONSE END ===');
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _logger.error('=== ERROR START ===');
    _logger.error('TYPE: ${error.type}');
    _logger.error('MESSAGE: ${error.message}');
    _logger.error(
        'URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    _logger.error('STATUS: ${error.response?.statusCode}');
    _logger.error('RESPONSE: ${error.response?.data}');
    _logger.error('=== ERROR END ===');
    handler.next(error);
  }
}

class AuthInterceptor extends Interceptor {
  final AppLogger _logger;
  late AuthRepository? _authRepository;
  bool _isRefreshing = false;
  String? _cachedToken;

  AuthInterceptor({
    required AppLogger logger,
    AuthRepository? authRepository,
  })  : _logger = logger,
        _authRepository = authRepository {
    // Load token synchronously at initialization
    _loadToken();
  }

  /// Update AuthRepository after dependency injection is complete
  void _updateAuthRepository(AuthRepository authRepository) {
    _authRepository = authRepository;
  }

  Future<void> _loadToken() async {
    try {
      // Use secure storage for tokens
      final secureStorage = SecureStorageService();
      _cachedToken =
          await secureStorage.get<String>(AppConstants.bearerTokenKey);
    } catch (error) {
      _logger.error('Error loading token', error);
      _cachedToken = null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add context headers first (synchronous)
    final contextManager = ContextManager();
    final context = contextManager.currentContext;

    if (context != null) {
      options.headers['X-Active-Brand-ID'] = context.activeBrand?.id ?? '';
      options.headers['X-Active-Branch-ID'] = context.activeBranch?.id ?? '';
      options.headers['X-User-Role'] = context.role.name;
    } else {
      // Handle case where context is null with default values
      options.headers['X-Active-Brand-ID'] = '';
      options.headers['X-Active-Branch-ID'] = '';
      options.headers['X-User-Role'] = '';
    }

    // Add auth token synchronously from cache
    if (_cachedToken != null) {
      options.headers['Authorization'] = 'Bearer $_cachedToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    // Prevent infinite loop: don't retry if the failed request is the refresh token endpoint itself
    final isRefreshTokenRequest =
        error.requestOptions.path.contains(AppConstants.refreshTokenEndpoint);

    // Handle 401 unauthorized
    if (error.response?.statusCode == 401 &&
        !_isRefreshing &&
        !isRefreshTokenRequest) {
      _logger.warning('Unauthorized - attempting token refresh');
      _isRefreshing = true;

      try {
        // Get current request options
        final options = error.requestOptions;
        _logger.debug(
            'Original request headers before refresh: ${options.headers}');

        // Use RefreshTokenUsecase if available, fallback to manual refresh
        if (_authRepository != null) {
          final result = await _authRepository!.refreshToken();

          result.fold(
            (failure) {
              _logger.error(
                  'Token refresh failed via usecase: ${failure.message}');
              _isRefreshing = false;
              // Don't retry, just pass the error
              handler.next(error);
            },
            (user) async {
              try {
                // Get the new token from local storage
                final secureStorage = SecureStorageService();
                final newToken = await secureStorage
                    .get<String>(AppConstants.bearerTokenKey);

                if (newToken != null) {
                  // Update cached token for immediate use
                  _cachedToken = newToken;
                  _logger.info('Token refreshed and saved via usecase');

                  // Add context headers to the retry request
                  await _addContextHeaders(options);

                  // Update original request with new token
                  options.headers['Authorization'] = 'Bearer $newToken';
                  _logger.debug(
                      'Updated request headers for retry: ${options.headers}');

                  // Create a new Dio instance with the same configuration but without this interceptor to avoid infinite loop
                  final dio = Dio(BaseOptions(
                    baseUrl: AppConstants.apiBaseUrl,
                    connectTimeout: AppConstants.apiTimeout,
                    receiveTimeout: AppConstants.apiTimeout,
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                  ));

                  // Retry original request with new token and context headers
                  try {
                    final retryResponse = await dio.fetch(options);
                    _isRefreshing = false;
                    _logger
                        .info('Retry request successful after token refresh');
                    handler.resolve(retryResponse);
                  } catch (retryError) {
                    _logger.error(
                        'Retry request failed after token refresh', retryError);
                    _isRefreshing = false;
                    handler.next(error);
                  }
                } else {
                  _logger.warning(
                      'Token refresh via usecase succeeded but no token found');
                  _isRefreshing = false;
                  handler.next(error);
                }
              } catch (e) {
                _logger.error('Error during token refresh retry', e);
                _isRefreshing = false;
                handler.next(error);
              }
            },
          );
        } else {
          // Fallback to manual token refresh
          try {
            final dio = Dio(BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: AppConstants.apiTimeout,
              receiveTimeout: AppConstants.apiTimeout,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

            // Get refresh token from secure storage
            final secureStorage = SecureStorageService();
            final refreshToken = await secureStorage
                .get<String>(StorageConstants.refreshTokenKey);

            if (refreshToken == null || refreshToken.isEmpty) {
              _logger.warning('No refresh token available for manual refresh');
              _isRefreshing = false;
              handler.next(error);
              return;
            }

            // Get device info for fingerprint
            final deviceInfoService = DeviceInfoService();
            final deviceInfo = await deviceInfoService.getDeviceInfo();
            final deviceFingerprint =
                deviceInfoService.generateDeviceFingerprint(deviceInfo);

            // Refresh token with proper body for Better Auth including device fingerprint
            final refreshResponse = await dio.post(
              AppConstants.refreshTokenEndpoint,
              data: {
                'refreshToken': refreshToken,
                'deviceFingerprint': deviceFingerprint,
              },
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

            // Extract new token from response body
            String? newToken;
            String? newRefreshToken;

            // Extract from response body (Better Auth format: data.token)
            final responseData = refreshResponse.data;
            if (responseData != null &&
                responseData is Map<String, dynamic> &&
                responseData['data'] != null) {
              final data = responseData['data'] as Map<String, dynamic>;
              newToken = data['token'] as String?;
              newRefreshToken = data['refreshToken'] as String?;
            }

            if (newToken != null && newToken.isNotEmpty) {
              // Save new token to secure storage
              await secureStorage.save(AppConstants.bearerTokenKey, newToken,
                  isSecure: true);

              // Save new refresh token if provided (token rotation)
              if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
                await secureStorage.save(
                    StorageConstants.refreshTokenKey, newRefreshToken,
                    isSecure: true);
                _logger.info('New refresh token saved after manual refresh');
              }

              // Update cached token for immediate use
              _cachedToken = newToken;
              _logger.info('Token refreshed and saved manually');

              // Add context headers to the retry request
              await _addContextHeaders(options);

              // Update original request with new token
              options.headers['Authorization'] = 'Bearer $newToken';
              _logger.debug(
                  'Updated request headers for retry: ${options.headers}');

              // Create a new Dio instance for retry (without interceptor to avoid infinite loop)
              final retryDio = Dio(BaseOptions(
                baseUrl: AppConstants.apiBaseUrl,
                connectTimeout: AppConstants.apiTimeout,
                receiveTimeout: AppConstants.apiTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ));

              // Retry original request with new token and context headers
              try {
                final retryResponse = await retryDio.fetch(options);
                _isRefreshing = false;
                _logger.info(
                    'Retry request successful after manual token refresh');
                handler.resolve(retryResponse);
              } catch (retryError) {
                _logger.error('Retry request failed after manual token refresh',
                    retryError);
                _isRefreshing = false;
                handler.next(error);
              }
            } else {
              _logger
                  .warning('Token refresh failed - no new token in response');
              _logger.debug('Refresh response data: ${refreshResponse.data}');
              _logger.debug(
                  'Refresh response headers: ${refreshResponse.headers}');
              _isRefreshing = false;
              handler.next(error);
            }
          } catch (e) {
            _logger.error('Manual token refresh failed', e);
            _isRefreshing = false;
            handler.next(error);
          }
        }
      } catch (e) {
        _logger.error('Token refresh failed', e);
        _isRefreshing = false;
        handler.next(error);
      }
    } else {
      // For refresh token requests that fail with 401, or if already refreshing, just pass the error
      if (isRefreshTokenRequest) {
        _logger.error(
            'Refresh token request itself failed with 401 - user needs to re-login');
      }
      handler.next(error);
    }
  }

  /// Helper method to add context headers to request options
  Future<void> _addContextHeaders(RequestOptions options) async {
    try {
      final contextManager = ContextManager();
      final context = contextManager.currentContext;

      if (context != null) {
        options.headers['X-Active-Brand-ID'] = context.activeBrand?.id ?? '';
        options.headers['X-Active-Branch-ID'] = context.activeBranch?.id ?? '';
        options.headers['X-User-Role'] = context.role.name;
        _logger.debug(
            'Added context headers: Brand=${context.activeBrand?.id}, Branch=${context.activeBranch?.id}, Role=${context.role.name}');
      } else {
        // Handle case where context is null with default values
        options.headers['X-Active-Brand-ID'] = '';
        options.headers['X-Active-Branch-ID'] = '';
        options.headers['X-User-Role'] = '';
        _logger.debug('Context is null, using empty context headers');
      }
    } catch (e) {
      _logger.error('Error adding context headers', e);
      // Fallback to empty headers
      options.headers['X-Active-Brand-ID'] = '';
      options.headers['X-Active-Branch-ID'] = '';
      options.headers['X-User-Role'] = '';
    }
  }
}
