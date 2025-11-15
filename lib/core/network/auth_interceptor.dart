import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../errors/exceptions.dart';

/// Authentication interceptor for handling auth tokens and token refresh
/// Enhanced with specific error handling for better error reporting
class AuthInterceptor extends Interceptor {
  final AppLogger _logger;
  bool _isRefreshing = false;

  AuthInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.bearerTokenKey);

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.debug('Auth token added to request');
      }
    } catch (e) {
      _logger.error('Failed to add auth token to request', e);
      // Continue with request even if token addition fails
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check for auth-related headers in response
    final newToken = response.headers['set-auth-token'];
    if (newToken != null && newToken.isNotEmpty) {
      _saveTokenToStorage(newToken.first);
      _logger.info('New auth token received and saved');
    }

    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    // Handle 401 unauthorized with token refresh
    if (error.response?.statusCode == 401 && !_isRefreshing) {
      _logger.warning('Unauthorized - attempting token refresh');
      _isRefreshing = true;

      try {
        // Attempt to refresh the token
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Update original request with new token
          final options = error.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          _logger.info('Token refreshed successfully, retrying original request');

          // Retry original request with new token
          final retryResponse = await _retryRequest(options);
          handler.resolve(retryResponse);
        } else {
          _logger.warning('Token refresh failed - no new token received');
          handler.next(error);
        }
      } on AuthException catch (e) {
        _logger.error('Token refresh failed with auth exception', e);
        handler.next(_createAuthError(error, e));
      } on NetworkException catch (e) {
        _logger.error('Token refresh failed with network exception', e);
        handler.next(_createNetworkError(error, e));
      } on ServerException catch (e) {
        _logger.error('Token refresh failed with server exception', e);
        handler.next(_createServerError(error, e));
      } catch (e) {
        _logger.error('Token refresh failed with unknown exception', e);
        handler.next(error);
      } finally {
        _isRefreshing = false;
      }
    } else {
      // Handle other error types
      final enhancedError = _enhanceError(error);
      handler.next(enhancedError);
    }
  }

  /// Save token to secure storage
  Future<void> _saveTokenToStorage(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.bearerTokenKey, token);
    } catch (e) {
      _logger.error('Failed to save token to storage', e);
    }
  }

  /// Refresh the authentication token
  Future<String?> _refreshToken() async {
    try {
      _logger.info('Attempting to refresh token');
      _logger.info('Using base URL: ${AppConstants.apiBaseUrl}');
      _logger.info('Using refresh endpoint: ${AppConstants.refreshTokenEndpoint}');

      // Create a new Dio instance to avoid infinite loop
      final dio = Dio(BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final fullUrl = '${AppConstants.apiBaseUrl}${AppConstants.refreshTokenEndpoint}';
      _logger.info('Full refresh token URL: $fullUrl');

      final response = await dio.post(
        AppConstants.refreshTokenEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _logger.info('Token refresh response status: ${response.statusCode}');

      // Extract new token from response headers
      final newToken = response.headers['set-auth-token'];
      if (newToken != null && newToken.isNotEmpty) {
        _logger.info('New token received successfully');
        return newToken.first;
      }

      _logger.warning('No new token received in refresh response');
      return null;
    } on DioException catch (e) {
      // Convert DioException to specific exceptions
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(
          message: 'Token refresh timeout. Please check your internet connection.',
          code: 'TOKEN_REFRESH_TIMEOUT',
          originalError: e,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          message: 'No internet connection for token refresh. Please check your network.',
          code: 'TOKEN_REFRESH_CONNECTION_ERROR',
          originalError: e,
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        String message = 'Token refresh failed';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        if (statusCode == 401) {
          throw AuthException(
            message: message,
            type: AuthExceptionType.refreshTokenFailed,
            code: 'TOKEN_REFRESH_FAILED',
            originalError: e,
          );
        } else if (statusCode == 403) {
          throw AuthException(
            message: message,
            type: AuthExceptionType.forbidden,
            code: 'TOKEN_REFRESH_FORBIDDEN',
            originalError: e,
          );
        } else {
          throw ServerException(
            message: message,
            statusCode: statusCode,
            endpoint: AppConstants.refreshTokenEndpoint,
            code: 'TOKEN_REFRESH_SERVER_ERROR',
            originalError: e,
          );
        }
      } else {
        throw NetworkException(
          message: 'Unknown error during token refresh: ${e.message}',
          code: 'TOKEN_REFRESH_UNKNOWN_ERROR',
          originalError: e,
        );
      }
    }
  }

  /// Retry the original request with new options
  Future<Response> _retryRequest(RequestOptions options) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
      ));

      return await dio.fetch(options);
    } on DioException catch (e) {
      // If retry also fails, convert to specific exceptions
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException(
          message: 'Request retry timeout. Please check your internet connection.',
          operation: 'retry_request',
          code: 'RETRY_TIMEOUT',
          originalError: e,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          message: 'No internet connection for retry. Please check your network.',
          code: 'RETRY_CONNECTION_ERROR',
          originalError: e,
        );
      } else {
        rethrow;
      }
    }
  }

  /// Enhance error with more specific information
  DioException _enhanceError(DioException error) {
    // Add more context to the error
    final enhancedError = DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: error.error,
    );

    // Log additional context
    _logger.error('Enhanced error details', {
      'path': error.requestOptions.path,
      'method': error.requestOptions.method,
      'statusCode': error.response?.statusCode,
      'type': error.type.toString(),
    });

    return enhancedError;
  }

  /// Create auth-specific error
  DioException _createAuthError(DioException originalError, AuthException authException) {
    return DioException(
      requestOptions: originalError.requestOptions,
      response: originalError.response,
      type: originalError.type,
      error: authException,
    );
  }

  /// Create network-specific error
  DioException _createNetworkError(DioException originalError, NetworkException networkException) {
    return DioException(
      requestOptions: originalError.requestOptions,
      response: originalError.response,
      type: originalError.type,
      error: networkException,
    );
  }

  /// Create server-specific error
  DioException _createServerError(DioException originalError, ServerException serverException) {
    return DioException(
      requestOptions: originalError.requestOptions,
      response: originalError.response,
      type: originalError.type,
      error: serverException,
    );
  }
}