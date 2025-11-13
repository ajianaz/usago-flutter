class AppConstants {
  // App
  static const String appName = 'Usago';
  static const String appVersion = '1.0.0';

  // API
  static const String apiBaseUrl = 'http://192.168.45.66:3000';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Better Auth Endpoints
  static const String signInEndpoint = '/api/auth/sign-in/email';
  static const String signUpEndpoint = '/api/auth/sign-up/email';
  static const String signOutEndpoint = '/api/auth/sign-out';
  static const String refreshTokenEndpoint = '/api/auth/refresh-token';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String verifyEmailEndpoint = '/api/auth/verify-email';
  static const String resendVerificationEmailEndpoint = '/api/auth/resend-verification';
  static const String changePasswordEndpoint = '/api/auth/change-password';
  static const String updateProfileEndpoint = '/api/auth/profile';
  static const String deleteAccountEndpoint = '/api/auth/account';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String bearerTokenKey = 'bearer_token';
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