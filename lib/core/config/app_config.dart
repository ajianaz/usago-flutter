import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _productionBaseUrl = 'https://api-usago.ajianaz.dev';

  static String get apiBaseUrl {
    if (kReleaseMode) {
      return _productionBaseUrl;
    } else {
      // Untuk development, gunakan localhost
      // Dengan CORS wildcard, seharusnya bisa mengakses localhost
      return 'http://127.0.0.1:3000';
    }
  }

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