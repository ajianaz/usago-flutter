/// Enum untuk API status codes yang digunakan di seluruh aplikasi
enum ApiStatusCode {
  // ==================== Success Codes ====================

  /// OK - Request berhasil
  ok(200, 'OK'),

  /// Created - Resource berhasil dibuat
  created(201, 'Created'),

  /// Accepted - Request diterima untuk diproses
  accepted(202, 'Accepted'),

  /// No Content - Request berhasil tanpa content
  noContent(204, 'No Content'),

  // ==================== Client Error Codes ====================

  /// Bad Request - Request tidak valid
  badRequest(400, 'Bad Request'),

  /// Unauthorized - Tidak terautentikasi
  unauthorized(401, 'Unauthorized'),

  /// Forbidden - T memiliki akses
  forbidden(403, 'Forbidden'),

  /// Not Found - Resource tidak ditemukan
  notFound(404, 'Not Found'),

  /// Method Not Allowed - Method tidak diizinkan
  methodNotAllowed(405, 'Method Not Allowed'),

  /// Conflict - Conflict dengan resource yang ada
  conflict(409, 'Conflict'),

  /// Unprocessable Entity - Request tidak dapat diproses
  unprocessableEntity(422, 'Unprocessable Entity'),

  /// Too Many Requests - Rate limit terlampaui
  tooManyRequests(429, 'Too Many Requests'),

  // ==================== Server Error Codes ====================

  /// Internal Server Error - Error server internal
  internalServerError(500, 'Internal Server Error'),

  /// Bad Gateway - Gateway error
  badGateway(502, 'Bad Gateway'),

  /// Service Unavailable - Service tidak tersedia
  serviceUnavailable(503, 'Service Unavailable'),

  /// Gateway Timeout - Gateway timeout
  gatewayTimeout(504, 'Gateway Timeout');

  const ApiStatusCode(this.code, this.message);

  /// HTTP status code
  final int code;

  /// Status message
  final String message;

  // ==================== Helper Methods ====================

  /// Cek apakah status code merupakan success (2xx)
  bool isSuccess() {
    return code >= 200 && code < 300;
  }

  /// Cek apakah status code merupakan client error (4xx)
  bool isClientError() {
    return code >= 400 && code < 500;
  }

  /// Cek apakah status code merupakan server error (5xx)
  bool isServerError() {
    return code >= 500 && code < 600;
  }

  /// Cek apakah status code merupakan error (4xx atau 5xx)
  bool isError() {
    return isClientError() || isServerError();
  }

  /// Cek apakah status code merupakan redirection (3xx)
  bool isRedirection() {
    return code >= 300 && code < 400;
  }

  /// Cek apakah status code merupakan informational (1xx)
  bool isInformational() {
    return code >= 100 && code < 200;
  }

  /// Cek apakah request dapat di-retry
  bool canRetry() {
    return isServerError() || code == 429 || code == 408;
  }

  /// Cek apakah error terkait authentication
  bool isAuthenticationError() {
    return code == 401;
  }

  /// Cek apakah error terkait authorization
  bool isAuthorizationError() {
    return code == 403;
  }

  /// Cek apakah error terkait resource tidak ditemukan
  bool isNotFoundError() {
    return code == 404;
  }

  /// Cek apakah error terkait validation
  bool isValidationError() {
    return code == 400 || code == 422;
  }

  /// Cek apakah error terkait rate limiting
  bool isRateLimitError() {
    return code == 429;
  }

  // ==================== Static Helper Methods ====================

  /// Get ApiStatusCode dari integer code
  static ApiStatusCode? fromCode(int code) {
    try {
      return ApiStatusCode.values.firstWhere((status) => status.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Cek apakah code merupakan success code
  static bool isSuccessCode(int code) {
    return code >= 200 && code < 300;
  }

  /// Cek apakah code merupakan client error code
  static bool isClientErrorCode(int code) {
    return code >= 400 && code < 500;
  }

  /// Cek apakah code merupakan server error code
  static bool isServerErrorCode(int code) {
    return code >= 500 && code < 600;
  }

  /// Cek apakah code merupakan error code
  static bool isErrorCode(int code) {
    return isClientErrorCode(code) || isServerErrorCode(code);
  }

  /// Get semua success codes
  static List<ApiStatusCode> getSuccessCodes() {
    return ApiStatusCode.values.where((code) => code.isSuccess()).toList();
  }

  /// Get semua client error codes
  static List<ApiStatusCode> getClientErrorCodes() {
    return ApiStatusCode.values.where((code) => code.isClientError()).toList();
  }

  /// Get semua server error codes
  static List<ApiStatusCode> getServerErrorCodes() {
    return ApiStatusCode.values.where((code) => code.isServerError()).toList();
  }
}