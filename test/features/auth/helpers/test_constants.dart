/// Test constants and fixtures for auth feature testing
class AuthTestConstants {
  // User test data
  static const String testUserId = 'test-user-123';
  static const String testUserEmail = 'test@example.com';
  static const String testUserName = 'Test User';
  static const String testUserPassword = 'TestPassword123!';
  static const String testUserProfilePicture = 'https://example.com/avatar.jpg';

  static const String unverifiedUserId = 'unverified-user-456';
  static const String unverifiedUserEmail = 'unverified@example.com';
  static const String unverifiedUserName = 'Unverified User';

  static const String newUserId = 'new-user-789';
  static const String newUserEmail = 'newuser@example.com';
  static const String newUserName = 'New User';

  // Test tokens
  static const String testAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.access.token';
  static const String testRefreshToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.refresh.token';
  static const String expiredToken = 'expired.token.here';
  static const String invalidToken = 'invalid.token.format';

  // Test passwords
  static const String validPassword = 'ValidPassword123!';
  static const String weakPassword = '123';
  static const String shortPassword = 'short';
  static const String commonPassword = 'password123';
  static const String noNumberPassword = 'NoNumbersHere!';
  static const String noUppercasePassword = 'nouppercase123';
  static const String noLowercasePassword = 'NOLOWERCASE123';
  static const String noSpecialCharPassword = 'NoSpecialChar123';

  // Test emails
  static const String validEmail = 'valid@example.com';
  static const String invalidEmail = 'invalid-email';
  static const String emptyEmail = '';
  static const String longEmail = 'very.long.email.address.that.exceeds.normal.limits@example.com';
  static const String emailWithPlus = 'user+tag@example.com';
  static const String emailWithSubdomain = 'user@sub.domain.com';

  // Test names
  static const String validName = 'John Doe';
  static const String emptyName = '';
  static const String longName = 'Very Long Name That Exceeds Normal Character Limits For Testing Purposes';
  static const String nameWithNumbers = 'John Doe 123';
  static const String nameWithSpecialChars = 'John-Doe Jr.';
  static const String singleCharName = 'A';

  // API endpoints (for testing)
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String updateProfileEndpoint = '/auth/profile';
  static const String verifyEmailEndpoint = '/auth/verify-email';
  static const String resendVerificationEndpoint = '/auth/resend-verification';
  static const String deleteAccountEndpoint = '/auth/delete-account';

  // Error messages
  static const String invalidCredentialsMessage = 'Invalid email or password';
  static const String userNotFoundMessage = 'User not found';
  static const String emailAlreadyExistsMessage = 'Email already exists';
  static const String weakPasswordMessage = 'Password is too weak';
  static const String invalidEmailMessage = 'Invalid email format';
  static const String tokenExpiredMessage = 'Token has expired';
  static const String invalidTokenMessage = 'Invalid token';
  static const String networkErrorMessage = 'Network error occurred';
  static const String serverErrorMessage = 'Internal server error';
  static const String unauthorizedMessage = 'Unauthorized access';
  static const String forbiddenMessage = 'Access forbidden';
  static const String rateLimitMessage = 'Too many requests, try again later';
  static const String validationErrorMessage = 'Validation failed';
  static const String emailNotVerifiedMessage = 'Email not verified';
  static const String passwordResetTokenExpiredMessage = 'Password reset token has expired';
  static const String currentPasswordIncorrectMessage = 'Current password is incorrect';

  // Time-based test constants
  static const Duration testTokenExpiry = Duration(hours: 1);
  static const Duration testRefreshTokenExpiry = Duration(days: 7);
  static const Duration testSessionTimeout = Duration(minutes: 30);
  static const Duration testPasswordResetExpiry = Duration(hours: 2);
  static const Duration testEmailVerificationExpiry = Duration(hours: 24);

  // Pagination and limits
  static const int maxLoginAttempts = 5;
  static const int maxPasswordResetAttempts = 3;
  static const int maxEmailVerificationAttempts = 5;
  static const int maxNameLength = 100;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  // Test dates
  static final DateTime testCreatedAt = DateTime.now().subtract(const Duration(days: 30));
  static final DateTime testUpdatedAt = DateTime.now().subtract(const Duration(days: 1));
  static final DateTime testLastLoginAt = DateTime.now().subtract(const Duration(hours: 2));
  static final DateTime testRecentLogin = DateTime.now().subtract(const Duration(minutes: 30));
  static final DateTime testOldLogin = DateTime.now().subtract(const Duration(days: 35));
  static final DateTime testFutureDate = DateTime.now().add(const Duration(days: 1));

  // Test session data
  static const String sessionDeviceId = 'test-device-123';
  static const String sessionDeviceType = 'mobile';
  static const String sessionUserAgent = 'TestApp/1.0 (Test)';
  static const String sessionIpAddress = '127.0.0.1';

  // Feature flags (for testing different scenarios)
  static const bool emailVerificationRequired = true;
  static const bool passwordStrengthCheck = true;
  static const bool twoFactorAuthEnabled = false;
  static const bool rememberMeEnabled = true;
  static const bool socialLoginEnabled = false;

  // Mock API responses
  static const Map<String, dynamic> successLoginResponse = {
    'user': {
      'id': testUserId,
      'email': testUserEmail,
      'name': testUserName,
      'profilePicture': testUserProfilePicture,
      'isEmailVerified': true,
      'createdAt': '2023-01-01T00:00:00.000Z',
      'updatedAt': '2023-12-01T00:00:00.000Z',
      'lastLoginAt': '2023-12-15T10:30:00.000Z',
    },
    'accessToken': testAccessToken,
    'refreshToken': testRefreshToken,
    'expiresIn': 3600,
  };

  static const Map<String, dynamic> successRegisterResponse = {
    'user': {
      'id': newUserId,
      'email': newUserEmail,
      'name': newUserName,
      'profilePicture': null,
      'isEmailVerified': false,
      'createdAt': '2023-12-15T10:30:00.000Z',
      'updatedAt': '2023-12-15T10:30:00.000Z',
      'lastLoginAt': null,
    },
    'message': 'Registration successful. Please verify your email.',
  };

  static const Map<String, dynamic> errorResponse = {
    'error': invalidCredentialsMessage,
    'code': 'INVALID_CREDENTIALS',
    'timestamp': '2023-12-15T10:30:00.000Z',
  };

  static const Map<String, dynamic> validationErrorResponse = {
    'error': validationErrorMessage,
    'code': 'VALIDATION_ERROR',
    'errors': {
      'email': [invalidEmailMessage],
      'password': [weakPasswordMessage],
    },
    'timestamp': '2023-12-15T10:30:00.000Z',
  };
}