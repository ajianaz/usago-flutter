import 'package:mocktail/mocktail.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource.dart';
import '../fixtures/auth_fixtures.dart';

/// Mock AuthRemoteDatasource
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

/// Mock AuthLocalDatasource
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

/// Mock setup utilities for Auth datasources
class MockAuthDatasourceSetup {
  /// Setup common mock behaviors for AuthRemoteDatasource
  static void setupRemoteDatasourceMocks(MockAuthRemoteDatasource mock) {
    // Login
    when(() => mock.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Register
    when(() => mock.register(
      email: any(named: 'email'),
      password: any(named: 'password'),
      name: any(named: 'name'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Logout
    when(() => mock.logout()).thenAnswer((_) async {});

    // Refresh token
    when(() => mock.refreshToken()).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Forgot password
    when(() => mock.forgotPassword(any(named: 'email'))).thenAnswer((_) async {});

    // Reset password
    when(() => mock.resetPassword(
      token: any(named: 'token'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async {});

    // Change password
    when(() => mock.changePassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async {});

    // Update profile
    when(() => mock.updateProfile(
      name: any(named: 'name'),
      profilePicture: any(named: 'profilePicture'),
    )).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Verify email
    when(() => mock.verifyEmail(any(named: 'token'))).thenAnswer((_) async {});

    // Resend verification email
    when(() => mock.resendVerificationEmail()).thenAnswer((_) async {});

    // Delete account
    when(() => mock.deleteAccount()).thenAnswer((_) async {});
  }

  /// Setup common mock behaviors for AuthLocalDatasource
  static void setupLocalDatasourceMocks(MockAuthLocalDatasource mock) {
    // Save user
    when(() => mock.saveUser(any())).thenAnswer((_) async {});

    // Get user
    when(() => mock.getUser()).thenAnswer((_) async => AuthFixtures.testUserModel);

    // Clear user
    when(() => mock.clearUser()).thenAnswer((_) async {});

    // Save token
    when(() => mock.saveToken(any())).thenAnswer((_) async {});

    // Get token
    when(() => mock.getToken()).thenAnswer((_) async => AuthFixtures.testToken);

    // Clear token
    when(() => mock.clearToken()).thenAnswer((_) async {});

    // Save session data
    when(() => mock.saveSessionData(any())).thenAnswer((_) async {});

    // Get session data
    when(() => mock.getSessionData()).thenAnswer((_) async => AuthFixtures.testSessionData);

    // Clear session data
    when(() => mock.clearSessionData()).thenAnswer((_) async {});

    // Check if user is logged in
    when(() => mock.isUserLoggedIn()).thenAnswer((_) async => true);

    // Get last login time
    when(() => mock.getLastLoginTime()).thenAnswer((_) async => AuthFixtures.testLastLoginAt);

    // Save last login time
    when(() => mock.saveLastLoginTime(any())).thenAnswer((_) async {});

    // Clear all auth data
    when(() => mock.clearAllAuthData()).thenAnswer((_) async {});
  }
}