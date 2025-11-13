import 'api_constants.dart';
import 'auth_endpoints.dart';
import 'storage_constants.dart';

class AppConstants {
  // App Information
  static const String appName = 'Usago';
  static const String appVersion = '1.0.0';

  // API Configuration (delegated to ApiConstants)
  static String get apiBaseUrl => ApiConstants.apiBaseUrl;
  static Duration get apiTimeout => ApiConstants.apiTimeout;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxUsernameLength = 30;

  // Pagination Constants
  static const int defaultPageSize = 20;

  // Cache Constants
  static const Duration cacheExpiration = Duration(hours: 24);

  // Storage Keys (delegated to StorageConstants)
  static String get authTokenKey => StorageConstants.authTokenKey;
  static String get bearerTokenKey => StorageConstants.bearerTokenKey;
  static String get userDataKey => StorageConstants.userDataKey;
  static String get onboardingCompletedKey => StorageConstants.onboardingCompletedKey;

  // Auth Endpoints (delegated to AuthEndpoints)
  static String get signInEndpoint => AuthEndpoints.signIn;
  static String get signUpEndpoint => AuthEndpoints.signUp;
  static String get signOutEndpoint => AuthEndpoints.signOut;
  static String get refreshTokenEndpoint => AuthEndpoints.refreshToken;
  static String get forgotPasswordEndpoint => AuthEndpoints.forgotPassword;
  static String get resetPasswordEndpoint => AuthEndpoints.resetPassword;
  static String get verifyEmailEndpoint => AuthEndpoints.verifyEmail;
  static String get resendVerificationEmailEndpoint => AuthEndpoints.resendVerificationEmail;
  static String get changePasswordEndpoint => AuthEndpoints.changePassword;
  static String get updateProfileEndpoint => AuthEndpoints.updateProfile;
  static String get deleteAccountEndpoint => AuthEndpoints.deleteAccount;
}