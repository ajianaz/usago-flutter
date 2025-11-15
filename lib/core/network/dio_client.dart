import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../errors/exceptions.dart';
import '../services/enhanced_secure_storage_service.dart';
import 'auth_interceptor.dart';

class DioClient {
  late Dio _dio;
  final AppLogger _logger;
  final EnhancedSecureStorageService _secureStorage;

  DioClient({
    AppLogger? logger,
    required EnhancedSecureStorageService secureStorage,
  })  : _logger = logger ?? AppLogger(),
        _secureStorage = secureStorage {
    // Log the base URL for debugging
    _logger.info(
        'Initializing DioClient with base URL: ${AppConstants.apiBaseUrl}');

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
    _dio.interceptors.add(AuthInterceptor(
      logger: _logger,
      secureStorage: _secureStorage,
    ));

    _logger.info('DioClient initialized successfully');
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
        return TimeoutException(
          message: 'Connection timeout. Please check your internet connection.',
          operation: 'network',
          timeout: const Duration(seconds: 30),
          originalError: error,
          code: 'CONNECTION_TIMEOUT',
        );
      case DioExceptionType.badResponse:
        return _handleHttpError(error);
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          code: 'CANCELLED',
          originalError: error,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
          code: 'CONNECTION_ERROR',
          originalError: error,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          message: 'An unknown error occurred: ${error.message}',
          code: 'UNKNOWN',
          originalError: error,
        );
      default:
        return NetworkException(
          message: 'An unexpected error occurred: ${error.message}',
          code: 'UNEXPECTED',
          originalError: error,
        );
    }
  }

  /// Handle HTTP error responses and convert to specific exceptions
  Exception _handleHttpError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final endpoint = error.requestOptions.path;

    String message = 'Unknown error';
    Map<String, String>? fieldErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? 'Unknown error';

      // Extract field errors for validation failures
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        fieldErrors = <String, String>{};
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            fieldErrors![key] = value.first.toString();
          } else if (value is String) {
            fieldErrors![key] = value;
          }
        });
      }
    } else if (data != null) {
      message = data.toString();
    }

    switch (statusCode) {
      case 400:
      case 422:
        return ValidationException(
          message: message,
          fieldErrors: fieldErrors,
          code: statusCode == 400 ? 'BAD_REQUEST' : 'VALIDATION_ERROR',
          originalError: error,
        );
      case 401:
        return AuthException(
          message: message,
          type: AuthExceptionType.unauthorized,
          code: 'UNAUTHORIZED',
          originalError: error,
        );
      case 403:
        return AuthException(
          message: message,
          type: AuthExceptionType.forbidden,
          code: 'FORBIDDEN',
          originalError: error,
        );
      case 404:
        return ServerException(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'NOT_FOUND',
          originalError: error,
        );
      case 429:
        return ServerException(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'RATE_LIMIT_EXCEEDED',
          originalError: error,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'SERVER_ERROR',
          originalError: error,
        );
      default:
        return ServerException(
          message: 'HTTP $statusCode: $message',
          statusCode: statusCode,
          endpoint: endpoint,
          code: 'HTTP_ERROR',
          originalError: error,
        );
    }
  }
}

class LogInterceptor extends Interceptor {
  final AppLogger _logger;

  LogInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final fullUrl = '${options.baseUrl}${options.path}';
    _logger.debug('REQUEST: ${options.method} $fullUrl');
    _logger.debug('BASE URL: ${options.baseUrl}');
    _logger.debug('PATH: ${options.path}');
    _logger.debug('HEADERS: ${options.headers}');
    _logger.debug('DATA: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final fullUrl =
        '${response.requestOptions.baseUrl}${response.requestOptions.path}';
    _logger.debug('RESPONSE: ${response.statusCode} $fullUrl');
    _logger.debug('HEADERS: ${response.headers}');
    _logger.debug('DATA: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _logger.error('NETWORK ERROR: ${error.message}', error);
    handler.next(error);
  }
}
