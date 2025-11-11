// Mock Configuration for Integration Tests
// Purpose: Centralized configuration for mock behaviors and test scenarios
// Follows Flutter development guidelines for test organization

/// Mock Configuration for Integration Tests
///
/// Centralized configuration for mock behaviors
/// and test scenarios across integration tests.
class MockConfig {
  /// Default test user credentials
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'testpassword123';
  static const String testToken = 'test-token-123';

  /// Invalid test credentials
  static const String invalidEmail = 'invalid@example.com';
  static const String invalidPassword = 'wrongpassword';

  /// API endpoints
  static const String baseUrl = 'http://localhost:3000';
  static const String loginEndpoint = '$baseUrl/api/auth/sign-in/email';
  static const String registerEndpoint = '$baseUrl/api/auth/sign-up/email';
  static const String logoutEndpoint = '$baseUrl/api/auth/sign-out';
  static const String refreshTokenEndpoint = '$baseUrl/api/auth/refresh-token';
  static const String forgotPasswordEndpoint = '$baseUrl/api/auth/forgot-password';
  static const String resetPasswordEndpoint = '$baseUrl/api/auth/reset-password';

  /// Test delays
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(seconds: 2);

  /// Error messages
  static const String invalidCredentialsMessage = 'Invalid credentials';
  static const String userExistsMessage = 'User already exists';
  static const String networkErrorMessage = 'Network connection failed';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String serverErrorMessage = 'Internal server error';
}