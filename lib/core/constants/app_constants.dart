import 'api_constants.dart';
import 'auth_endpoints.dart';
import 'storage_constants.dart';
import 'ui_constants.dart';
import 'animation_constants.dart';
import 'validation_constants.dart';
import 'performance_constants.dart';

class AppConstants {
  // App Information
  static const String appName = 'Usago';
  static const String appVersion = '1.0.0';

  // API Configuration (delegated to ApiConstants)
  static String get apiBaseUrl => ApiConstants.apiBaseUrl;
  static Duration get apiTimeout => ApiConstants.apiTimeout;

  // UI Constants
  static double get defaultPadding => UIConstants.paddingDefault;
  static double get defaultBorderRadius => UIConstants.borderRadiusDefault;
  static Duration get defaultAnimationDuration => AnimationConstants.defaultDuration;

  // Validation Constants
  static int get minPasswordLength => ValidationConstants.passwordMinLength;
  static int get maxPasswordLength => ValidationConstants.passwordMaxLength;
  static int get maxUsernameLength => ValidationConstants.usernameMaxLength;

  // Pagination Constants
  static int get defaultPageSize => PerformanceConstants.defaultPageSize;

  // Cache Constants
  static Duration get cacheExpiration => PerformanceConstants.defaultCacheExpiry;

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