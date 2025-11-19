import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../context/context_manager.dart';

class DioClient {
  late Dio _dio;
  final AppLogger _logger;

  DioClient({AppLogger? logger}) : _logger = logger ?? AppLogger() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(logger: _logger));
    _dio.interceptors.add(AuthInterceptor(logger: _logger));
  }

  Dio get dio => _dio;

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
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';
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
    _logger.debug('URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
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
    _logger.error('URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    _logger.error('STATUS: ${error.response?.statusCode}');
    _logger.error('RESPONSE: ${error.response?.data}');
    _logger.error('=== ERROR END ===');
    handler.next(error);
  }
}

class AuthInterceptor extends Interceptor {
  final AppLogger _logger;
  bool _isRefreshing = false;
  String? _cachedToken;

  AuthInterceptor({required AppLogger logger}) : _logger = logger {
    // Load token synchronously at initialization
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(AppConstants.bearerTokenKey);
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
    // Handle 401 unauthorized
    if (error.response?.statusCode == 401 && !_isRefreshing) {
      _logger.warning('Unauthorized - attempting token refresh');
      _isRefreshing = true;

      try {
        // Get current request options
        final options = error.requestOptions;

        // Create a new Dio instance to avoid infinite loop
        final dio = Dio(BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ));

        // Refresh token
        final refreshResponse = await dio.post(
          AppConstants.refreshTokenEndpoint,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        // Extract new token from response headers
        final newToken = refreshResponse.headers['set-auth-token'];
        if (newToken != null && newToken.isNotEmpty) {
          // Save new token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConstants.bearerTokenKey, newToken.first);

          // Update cached token for immediate use
          _cachedToken = newToken.first;
          _logger.info('Token refreshed and saved');

          // Update original request with new token
          options.headers['Authorization'] = 'Bearer ${newToken.first}';

          // Retry original request with new token
          final retryResponse = await dio.fetch(options);
          handler.resolve(retryResponse);
        } else {
          _logger.warning('Token refresh failed - no new token in response');
          handler.next(error);
        }
      } catch (e) {
        _logger.error('Token refresh failed', e);
        handler.next(error);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(error);
    }
  }
}