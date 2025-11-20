class AuthEndpoints {
  // Authentication
  static const String signIn = '/api/auth/sign-in/email';
  static const String signUp = '/api/auth/sign-up/email';
  static const String signOut = '/api/auth/sign-out';
  static const String refreshToken = '/api/auth/refresh';

  // Email Verification
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendVerificationEmail = '/api/auth/resend-verification';

  // Password Management
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String changePassword = '/api/auth/change-password';

  // Profile Management
  static const String updateProfile = '/api/auth/profile';
  static const String deleteAccount = '/api/auth/account';
  static const String getUserProfile = '/api/auth/profile';

  // Session Management
  static const String getSession = '/api/auth/session';
  static const String validateSession = '/api/auth/validate';
  static const String switchSession = '/api/auth/switch';
}
