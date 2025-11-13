class StorageConstants {
  // Authentication Keys
  static const String authTokenKey = 'auth_token';
  static const String bearerTokenKey = 'bearer_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String sessionDataKey = 'session_data';

  // User Context Keys
  static const String activeBrandKey = 'active_brand';
  static const String activeBranchKey = 'active_branch';
  static const String userRoleKey = 'user_role';
  static const String permissionsKey = 'user_permissions';

  // App State Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appFirstLaunchKey = 'app_first_launch';
  static const String lastSyncTimeKey = 'last_sync_time';

  // Cache Keys
  static const String cachedBrandsKey = 'cached_brands';
  static const String cachedBranchesKey = 'cached_branches';
  static const String cachedWalletsKey = 'cached_wallets';
  static const String cachedCustomersKey = 'cached_customers';
  static const String cachedProductsKey = 'cached_products';

  // Settings Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String notificationsKey = 'notifications_enabled';
  static const String biometricEnabledKey = 'biometric_enabled';
}