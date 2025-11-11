class AppConstants {
  // App
  static const String appName = 'Usago';
  static const String appVersion = '1.0.0';

  // API
  static const String apiBaseUrl = 'https://api.usago.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxUsernameLength = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
}