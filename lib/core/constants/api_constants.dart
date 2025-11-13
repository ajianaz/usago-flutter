class ApiConstants {
  // Base Configuration
  static const String apiBaseUrl = 'http://127.0.0.1:3000';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String apiVersion = 'v1';

  // Headers
  static const String contentTypeHeader = 'application/json';
  static const String acceptHeader = 'application/json';
  static const String bearerTokenHeader = 'Authorization';

  // Response Codes
  static const int successCode = 200;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;
}