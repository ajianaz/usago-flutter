import '../config/app_config.dart';

class ApiConstants {
  // Base Configuration (delegated to AppConfig)
  static String get apiBaseUrl => AppConfig.apiBaseUrl;
  static Duration get apiTimeout => AppConfig.apiTimeout;
  static String get apiVersion => AppConfig.apiVersion;

  // Headers (delegated to AppConfig)
  static String get contentTypeHeader => AppConfig.contentTypeHeader;
  static String get acceptHeader => AppConfig.acceptHeader;
  static String get bearerTokenHeader => AppConfig.bearerTokenHeader;

  // Response Codes (delegated to AppConfig)
  static int get successCode => AppConfig.successCode;
  static int get unauthorizedCode => AppConfig.unauthorizedCode;
  static int get forbiddenCode => AppConfig.forbiddenCode;
  static int get notFoundCode => AppConfig.notFoundCode;
  static int get serverErrorCode => AppConfig.serverErrorCode;
}