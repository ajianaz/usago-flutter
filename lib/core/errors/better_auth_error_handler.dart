import '../utils/logger.dart';

/// Better Auth specific error codes and messages
class BetterAuthErrorHandler {
  final AppLogger _logger;

  BetterAuthErrorHandler({AppLogger? logger}) : _logger = logger ?? AppLogger();

  /// Handle Better Auth specific error responses
  ///
  /// [statusCode] HTTP status code from response
  /// [responseData] Response data from server
  /// Returns [String] user-friendly error message
  String handleBetterAuthError(
      int statusCode, Map<String, dynamic>? responseData) {
    try {
      final errorCode = responseData?['code'] as String?;
      final message = responseData?['error'] as String? ??
          responseData?['message'] as String?;

      _logger.error('Better Auth Error', {
        'statusCode': statusCode,
        'errorCode': errorCode,
        'message': message,
        'fullResponse': responseData,
      });

      // Handle specific Better Auth error codes
      switch (errorCode) {
        case 'INVALID_CREDENTIALS':
          return 'Email atau password salah. Silakan periksa kembali.';

        case 'INVALID_REFRESH_TOKEN':
          return 'Sesi login telah kadaluarsa. Silakan login kembali.';

        case 'TOKEN_REVOKED':
          return 'Token telah dicabut. Silakan login kembali.';

        case 'TOKEN_EXPIRED':
          return 'Sesi login telah berakhir. Silakan login kembali.';

        case 'DEVICE_VALIDATION_FAILED':
          return 'Validasi perangkat gagal. Silakan login kembali.';

        case 'VALIDATION_ERROR':
          return _getValidationErrorMessage(responseData);

        case 'USER_ALREADY_EXISTS_USE_ANOTHER_EMAIL':
          return 'Email sudah terdaftar. Gunakan email lain.';

        case 'EMAIL_NOT_VERIFIED':
          return 'Email belum diverifikasi. Silakan periksa inbox email Anda.';

        case 'INVALID_EMAIL_OR_PASSWORD':
          return 'Email atau password salah. Silakan periksa kembali.';

        case 'TOO_MANY_ATTEMPTS':
          return 'Terlalu banyak percobaan. Silakan coba lagi dalam beberapa saat.';

        case 'ACCOUNT_BANNED':
          return 'Akun diblokir. Hubungi admin untuk bantuan.';

        case 'ACCESS_DENIED':
          return 'Akses ditolak. Anda tidak memiliki izin untuk melakukan ini.';

        case 'INTERNAL_ERROR':
          return 'Terjadi kesalahan server. Silakan coba lagi nanti.';

        default:
          return _getDefaultErrorMessage(statusCode, message);
      }
    } catch (e) {
      _logger.error('Error handling Better Auth error', e);
      return 'Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.';
    }
  }

  /// Extract validation error details
  ///
  /// [responseData] Response data containing validation errors
  /// Returns [String] formatted validation error message
  String _getValidationErrorMessage(Map<String, dynamic>? responseData) {
    try {
      final errors = responseData?['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final errorMessages = <String>[];
        errors.forEach((field, messages) {
          if (messages is List) {
            for (final message in messages) {
              errorMessages.add('$field: $message');
            }
          } else {
            errorMessages.add('$field: $messages');
          }
        });
        return errorMessages.join('\n');
      }

      return 'Data yang dimasukkan tidak valid. Silakan periksa kembali.';
    } catch (e) {
      _logger.error('Error extracting validation message', e);
      return 'Data yang dimasukkan tidak valid. Silakan periksa kembali.';
    }
  }

  /// Get default error message based on status code
  ///
  /// [statusCode] HTTP status code
  /// [message] Original error message from server
  /// Returns [String] default error message
  String _getDefaultErrorMessage(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return message ??
            'Permintaan tidak valid. Silakan periksa kembali data yang dimasukkan.';
      case 401:
        return message ??
            'Tidak terautentikasi. Silakan login terlebih dahulu.';
      case 403:
        return message ??
            'Akses ditolak. Anda tidak memiliki izin untuk mengakses resource ini.';
      case 404:
        return message ?? 'Resource tidak ditemukan.';
      case 422:
        return message ??
            'Data yang dimasukkan tidak valid. Silakan periksa kembali.';
      case 429:
        return 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
      case 500:
        return message ??
            'Terjadi kesalahan server internal. Silakan coba lagi nanti.';
      case 502:
        return message ??
            'Server sedang dalam perbaikan. Silakan coba lagi nanti.';
      case 503:
        return message ??
            'Layanan tidak tersedia saat ini. Silakan coba lagi nanti.';
      default:
        return message ??
            'Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.';
    }
  }

  /// Check if error is recoverable (can retry)
  ///
  /// [statusCode] HTTP status code
  /// [errorCode] Better Auth error code
  /// Returns [bool] true if error is recoverable
  bool isRecoverableError(int statusCode, String? errorCode) {
    // Recoverable errors that might succeed on retry
    const recoverableCodes = [
      'TOO_MANY_ATTEMPTS',
      'INTERNAL_ERROR',
    ];

    const recoverableStatusCodes = [
      500, // Internal server error
      502, // Bad gateway
      503, // Service unavailable
      504, // Gateway timeout
    ];

    return recoverableCodes.contains(errorCode) ||
        recoverableStatusCodes.contains(statusCode);
  }

  /// Check if user should be logged out
  ///
  /// [errorCode] Better Auth error code
  /// Returns [bool] true if user should be logged out
  bool shouldLogout(String? errorCode) {
    const logoutCodes = [
      'INVALID_REFRESH_TOKEN',
      'TOKEN_REVOKED',
      'TOKEN_EXPIRED',
      'DEVICE_VALIDATION_FAILED',
      'ACCOUNT_BANNED',
    ];

    return logoutCodes.contains(errorCode);
  }

  /// Check if error is network related
  ///
  /// [error] Exception object
  /// Returns [bool] true if error is network related
  bool isNetworkError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    const networkKeywords = [
      'connection',
      'timeout',
      'network',
      'internet',
      'host',
      'unreachable',
      'dns',
    ];

    return networkKeywords.any((keyword) => errorMessage.contains(keyword));
  }
}
