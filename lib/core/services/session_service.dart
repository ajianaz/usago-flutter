import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../services/secure_storage_service.dart';
import '../services/device_info_service.dart';
import '../utils/logger.dart';
import '../errors/better_auth_error_handler.dart';

/// Session management service untuk validasi session dengan server
///
/// Service ini menyediakan fungsi untuk:
/// - Validasi session aktif
/// - Refresh session jika diperlukan
/// - Manajemen token lifecycle
/// - Device fingerprint validation
class SessionService {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final DeviceInfoService _deviceInfoService;
  final BetterAuthErrorHandler _errorHandler;
  final AppLogger _logger;

  SessionService({
    required Dio dio,
    required SecureStorageService secureStorage,
    DeviceInfoService? deviceInfoService,
    BetterAuthErrorHandler? errorHandler,
    AppLogger? logger,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _deviceInfoService = deviceInfoService ?? DeviceInfoService(),
        _errorHandler = errorHandler ?? BetterAuthErrorHandler(),
        _logger = logger ?? AppLogger();

  /// Validate current session with server
  ///
  /// Returns [Map<String, dynamic>] with validation result
  Future<Map<String, dynamic>> validateSession() async {
    try {
      final token =
          await _secureStorage.get<String>(AppConstants.bearerTokenKey);
      if (token == null || token.isEmpty) {
        return {
          'isValid': false,
          'error': 'No active session found',
          'shouldLogout': false,
        };
      }

      // Get session from server
      final sessionResponse = await _dio.get(
        '/api/auth/session',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final sessionData = sessionResponse.data as Map<String, dynamic>;
      final isValid = sessionData['valid'] ?? false;

      _logger.info('Session validation result: $isValid');

      return {
        'isValid': isValid,
        'sessionData': sessionData,
        'shouldLogout': !isValid,
      };
    } on DioException catch (e) {
      _logger.error('Session validation failed', e);

      if (e.response?.statusCode == 401) {
        return {
          'isValid': false,
          'error': 'Session expired or invalid',
          'shouldLogout': true,
        };
      }

      final responseData = e.response?.data as Map<String, dynamic>?;
      final errorMessage = _errorHandler.handleBetterAuthError(
        e.response?.statusCode ?? 0,
        responseData,
      );

      return {
        'isValid': false,
        'error': errorMessage,
        'shouldLogout': _errorHandler.shouldLogout(responseData?['code']),
        'isNetworkError': _errorHandler.isNetworkError(e),
      };
    } catch (e) {
      _logger.error('Unexpected error during session validation', e);
      return {
        'isValid': false,
        'error': 'Session validation failed',
        'shouldLogout': false,
        'isNetworkError': _errorHandler.isNetworkError(e),
      };
    }
  }

  /// Refresh session with device fingerprint validation
  ///
  /// Returns [Map<String, dynamic>] with refresh result
  Future<Map<String, dynamic>> refreshSession() async {
    try {
      final refreshToken =
          await _secureStorage.get<String>(StorageConstants.refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        return {
          'success': false,
          'error': 'No refresh token available',
          'shouldLogout': true,
        };
      }

      // Get device info for fingerprint
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      final deviceFingerprint =
          _deviceInfoService.generateDeviceFingerprint(deviceInfo);

      _logger.debug('Attempting session refresh with device fingerprint');

      // Refresh token with device fingerprint
      final response = await _dio.post(
        '/api/auth/refresh-token',
        data: {
          'refreshToken': refreshToken,
          'deviceFingerprint': deviceFingerprint,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;
        final newToken = data['token'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        final user = data['user'] as Map<String, dynamic>?;

        // Save new tokens
        if (newToken != null && newToken.isNotEmpty) {
          await _secureStorage.save(AppConstants.bearerTokenKey, newToken,
              isSecure: true);
        }

        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await _secureStorage.save(
              StorageConstants.refreshTokenKey, newRefreshToken,
              isSecure: true);
        }

        // Save updated user data if provided
        if (user != null) {
          await _secureStorage.save(StorageConstants.userDataKey, user,
              isSecure: false);
        }

        _logger.info('Session refreshed successfully');

        return {
          'success': true,
          'message': 'Session refreshed successfully',
          'user': user,
        };
      } else {
        final errorMessage = _errorHandler.handleBetterAuthError(
          500, // Default to server error for DioException in post method
          responseData,
        );

        return {
          'success': false,
          'error': errorMessage,
          'shouldLogout': _errorHandler.shouldLogout(responseData['code']),
        };
      }
    } on DioException catch (e) {
      _logger.error('Session refresh failed', e);

      final responseData = e.response?.data as Map<String, dynamic>?;
      final errorMessage = _errorHandler.handleBetterAuthError(
        e.response?.statusCode ?? 0,
        responseData,
      );

      return {
        'success': false,
        'error': errorMessage,
        'shouldLogout': _errorHandler.shouldLogout(responseData?['code']),
        'isNetworkError': _errorHandler.isNetworkError(e),
      };
    } catch (e) {
      _logger.error('Unexpected error during session refresh', e);
      return {
        'success': false,
        'error': 'Session refresh failed',
        'shouldLogout': false,
        'isNetworkError': _errorHandler.isNetworkError(e),
      };
    }
  }

  /// Check if session needs validation based on last validation time
  ///
  /// Returns [bool] true if session should be validated
  Future<bool> shouldValidateSession() async {
    try {
      final lastValidation =
          await _secureStorage.get<String>('last_session_validation');
      if (lastValidation == null) {
        return true; // First time, validate
      }

      final lastValidationTime = DateTime.parse(lastValidation);
      final now = DateTime.now();
      final difference = now.difference(lastValidationTime);

      // Validate if last validation was more than 5 minutes ago
      return difference.inMinutes > 5;
    } catch (e) {
      _logger.error('Error checking session validation time', e);
      return true; // Error occurred, validate to be safe
    }
  }

  /// Update last session validation time
  ///
  /// Saves current timestamp as last validation time
  Future<void> updateLastValidationTime() async {
    try {
      await _secureStorage.save(
        'last_session_validation',
        DateTime.now().toIso8601String(),
        isSecure: false,
      );
      _logger.debug('Session validation time updated');
    } catch (e) {
      _logger.error('Error updating session validation time', e);
    }
  }

  /// Get current session info
  ///
  /// Returns [Map<String, dynamic>?] session data or null if not found
  Future<Map<String, dynamic>?> getCurrentSession() async {
    try {
      final token =
          await _secureStorage.get<String>(AppConstants.bearerTokenKey);
      final userData = await _secureStorage
          .get<Map<String, dynamic>>(StorageConstants.userDataKey);

      if (token == null || userData == null) {
        return null;
      }

      return {
        'token': token,
        'user': userData,
        'lastValidation':
            await _secureStorage.get<String>('last_session_validation'),
      };
    } catch (e) {
      _logger.error('Error getting current session', e);
      return null;
    }
  }

  /// Clear all session data
  ///
  /// Removes tokens, user data, and session metadata
  Future<void> clearSession() async {
    try {
      await _secureStorage.remove(AppConstants.bearerTokenKey, isSecure: true);
      await _secureStorage.remove(StorageConstants.refreshTokenKey,
          isSecure: true);
      await _secureStorage.remove(StorageConstants.userDataKey,
          isSecure: false);
      await _secureStorage.remove('last_session_validation', isSecure: false);

      _logger.info('Session data cleared successfully');
    } catch (e) {
      _logger.error('Error clearing session data', e);
      rethrow;
    }
  }

  /// Check if user has active session
  ///
  /// Returns [bool] true if user has valid session
  Future<bool> hasActiveSession() async {
    try {
      final token =
          await _secureStorage.get<String>(AppConstants.bearerTokenKey);
      final userData = await _secureStorage
          .get<Map<String, dynamic>>(StorageConstants.userDataKey);

      return token != null && token.isNotEmpty && userData != null;
    } catch (e) {
      _logger.error('Error checking active session', e);
      return false;
    }
  }

  /// Get session age in minutes
  ///
  /// Returns [int] session age in minutes, 0 if no session
  Future<int> getSessionAge() async {
    try {
      final lastValidation =
          await _secureStorage.get<String>('last_session_validation');
      if (lastValidation == null) {
        return 0;
      }

      final lastValidationTime = DateTime.parse(lastValidation);
      final now = DateTime.now();
      return now.difference(lastValidationTime).inMinutes;
    } catch (e) {
      _logger.error('Error calculating session age', e);
      return 0;
    }
  }
}
