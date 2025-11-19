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
    _logger.debug('REQUEST: ${options.method} ${options.path}');
    _logger.debug('DATA: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.debug('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    _logger.debug('DATA: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _logger.error('NETWORK ERROR: ${error.message}', error);
    handler.next(error);
  }
}

class AuthInterceptor extends Interceptor {
  final AppLogger _logger;
  bool _isRefreshing = false;

  AuthInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.bearerTokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add context headers
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