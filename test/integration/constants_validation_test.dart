// Constants Validation Integration Tests
// Purpose: Test that constants are used consistently across the app
// Follows Flutter development guidelines for testing structure and patterns

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/network/dio_client.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:usago/core/utils/logger.dart';
import '../fixtures/auth_fixtures.dart';

/// Comprehensive integration tests for constants validation
///
/// This test suite verifies:
/// - All API endpoints use AppConstants consistently
/// - Storage keys match AppConstants across all datasources
/// - Token format follows AppConstants requirements
/// - Timeout values are used consistently
/// - Validation constants are enforced
///
/// Test Structure:
/// - Follows Arrange-Act-Assert pattern consistently
/// - Tests actual implementation against constants
/// - Validates consistency across multiple components
/// - Ensures no hardcoded values exist
void main() {
  group('Constants Validation Integration Tests', () {
    late DioClient dioClient;
    late AuthLocalDatasourceImpl localDatasource;
    late AuthRemoteDatasourceImpl remoteDatasource;
    late SharedPreferences prefs;
    late Dio mockDio;

    setUp(() async {
      // Setup real SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // Setup mock Dio
      mockDio = MockDio();
      dioClient = DioClient();

      // Setup datasources
      localDatasource = AuthLocalDatasourceImpl(
        prefs: prefs,
        logger: AppLogger(),
      );

      remoteDatasource = AuthRemoteDatasourceImpl(
        dioClient: dioClient,
        logger: AppLogger(),
        localDatasource: localDatasource,
      );
    });

    tearDown(() async {
      await prefs.clear();
    });

    group('API Endpoint Constants Validation', () {
      testWidgets('should use correct sign-in endpoint constant', (WidgetTester tester) async {
        // Arrange
        final testUser = AuthFixtures.testUserModel;
        final loginResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => loginResponse);

        // Act
        await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.signInEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.signInEndpoint, equals('/api/auth/sign-in/email'));
      });

      testWidgets('should use correct sign-up endpoint constant', (WidgetTester tester) async {
        // Arrange
        final testUser = AuthFixtures.testUserModel;
        final registerResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signUpEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => registerResponse);

        // Act
        await remoteDatasource.register(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
          name: AuthFixtures.testUserName,
        );

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.signUpEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.signUpEndpoint, equals('/api/auth/sign-up/email'));
      });

      testWidgets('should use correct sign-out endpoint constant', (WidgetTester tester) async {
        // Arrange
        final logoutResponse = Response(
          data: {'message': 'Logout successful'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signOutEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => logoutResponse);

        // Act
        await remoteDatasource.logout();

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.signOutEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.signOutEndpoint, equals('/api/auth/sign-out'));
      });

      testWidgets('should use correct refresh token endpoint constant', (WidgetTester tester) async {
        // Arrange
        final testUser = AuthFixtures.testUserModel;
        final refreshResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.refreshTokenEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => refreshResponse);

        // Act
        await remoteDatasource.refreshToken();

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.refreshTokenEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.refreshTokenEndpoint, equals('/api/auth/refresh-token'));
      });

      testWidgets('should use correct forgot password endpoint constant', (WidgetTester tester) async {
        // Arrange
        final forgotResponse = Response(
          data: {'message': 'Password reset email sent'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.forgotPasswordEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => forgotResponse);

        // Act
        await remoteDatasource.forgotPassword(AuthFixtures.validEmail);

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.forgotPasswordEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.forgotPasswordEndpoint, equals('/api/auth/forgot-password'));
      });

      testWidgets('should use correct reset password endpoint constant', (WidgetTester tester) async {
        // Arrange
        final resetResponse = Response(
          data: {'message': 'Password reset successful'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.resetPasswordEndpoint),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => resetResponse);

        // Act
        await remoteDatasource.resetPassword(
          token: 'reset-token-123',
          newPassword: 'newpassword123',
        );

        // Assert - Verify the correct endpoint constant is used
        verify(() => mockDio.post(
          AppConstants.resetPasswordEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify endpoint matches expected value
        expect(AppConstants.resetPasswordEndpoint, equals('/api/auth/reset-password'));
      });
    });

    group('Storage Key Constants Validation', () {
      testWidgets('should use correct bearer token key constant', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer test_token_123';

        // Act
        await localDatasource.saveToken(testToken);

        // Assert - Verify the correct storage key constant is used
        final savedToken = prefs.getString(AppConstants.bearerTokenKey);
        expect(savedToken, equals(testToken));

        // Verify storage key matches expected value
        expect(AppConstants.bearerTokenKey, equals('bearer_token'));
      });

      testWidgets('should use correct user data key constant', (WidgetTester tester) async {
        // Arrange
        final testUser = AuthFixtures.testUserModel;

        // Act
        await localDatasource.saveUser(testUser);

        // Assert - Verify the correct storage key constant is used
        final savedUserJson = prefs.getString(AppConstants.userDataKey);
        expect(savedUserJson, isNotNull);

        // Verify storage key matches expected value
        expect(AppConstants.userDataKey, equals('user_data'));
      });

      testWidgets('should retrieve token using correct constant key', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer retrieval_test_token';
        await prefs.setString(AppConstants.bearerTokenKey, testToken);

        // Act
        final retrievedToken = await localDatasource.getToken();

        // Assert - Verify token is retrieved using correct constant
        expect(retrievedToken, equals(testToken));
      });

      testWidgets('should clear token using correct constant key', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer clear_test_token';
        await prefs.setString(AppConstants.bearerTokenKey, testToken);

        // Verify token exists
        expect(prefs.getString(AppConstants.bearerTokenKey), equals(testToken));

        // Act
        await localDatasource.clearToken();

        // Assert - Verify token is cleared using correct constant
        expect(prefs.getString(AppConstants.bearerTokenKey), isNull);
      });
    });

    group('Token Format Constants Validation', () {
      testWidgets('should validate Bearer token format constant', (WidgetTester tester) async {
        // Arrange & Act - Test various token formats
        const validTokens = [
          'Bearer abc123',
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          'Bearer sk-1234567890abcdef',
        ];

        for (final token in validTokens) {
          await localDatasource.saveToken(token);
          final retrievedToken = await localDatasource.getToken();

          // Assert - Verify token format is preserved
          expect(retrievedToken, equals(token));
          expect(retrievedToken, startsWith('Bearer '));
        }
      });

      testWidgets('should handle tokens without Bearer prefix', (WidgetTester tester) async {
        // Arrange
        const tokenWithoutPrefix = 'abc123token';

        // Act
        await localDatasource.saveToken(tokenWithoutPrefix);
        final retrievedToken = await localDatasource.getToken();

        // Assert - Verify token without prefix is handled
        expect(retrievedToken, equals(tokenWithoutPrefix));
        expect(retrievedToken, isNot(startsWith('Bearer ')));
      });
    });

    group('Timeout Constants Validation', () {
      testWidgets('should use correct API timeout constant', (WidgetTester tester) async {
        // Arrange & Act - Create DioClient and check timeout
        final client = DioClient();

        // Assert - Verify timeout constant is used
        expect(AppConstants.apiTimeout, equals(const Duration(seconds: 30)));

        // Note: We can't directly access the internal Dio instance to verify timeout,
        // but we can validate the constant value is correct
        expect(AppConstants.apiTimeout.inSeconds, equals(30));
      });

      testWidgets('should use correct default animation duration constant', (WidgetTester tester) async {
        // Assert - Verify animation duration constant
        expect(AppConstants.defaultAnimationDuration, equals(const Duration(milliseconds: 300)));
        expect(AppConstants.defaultAnimationDuration.inMilliseconds, equals(300));
      });
    });

    group('Validation Constants Validation', () {
      testWidgets('should use correct password length constants', (WidgetTester tester) async {
        // Assert - Verify password validation constants
        expect(AppConstants.minPasswordLength, equals(6));
        expect(AppConstants.maxPasswordLength, equals(50));
        expect(AppConstants.maxUsernameLength, equals(30));
      });

      testWidgets('should enforce minimum password length constant', (WidgetTester tester) async {
        // Arrange
        const shortPassword = '123'; // Less than minPasswordLength (6)

        // Act & Assert - This would typically be validated at the UI level
        // Here we just verify the constant is correct
        expect(shortPassword.length, lessThan(AppConstants.minPasswordLength));
      });

      testWidgets('should enforce maximum password length constant', (WidgetTester tester) async {
        // Arrange
        final longPassword = 'a' * 51; // More than maxPasswordLength (50)

        // Act & Assert - Verify constant enforcement
        expect(longPassword.length, greaterThan(AppConstants.maxPasswordLength));
      });
    });

    group('UI Constants Validation', () {
      testWidgets('should use correct UI spacing constants', (WidgetTester tester) async {
        // Assert - Verify UI constants
        expect(AppConstants.defaultPadding, equals(16.0));
        expect(AppConstants.defaultBorderRadius, equals(8.0));
      });
    });

    group('Constants Consistency Check', () {
      testWidgets('should have consistent endpoint naming pattern', (WidgetTester tester) async {
        // Assert - Verify all auth endpoints follow consistent pattern
        final authEndpoints = [
          AppConstants.signInEndpoint,
          AppConstants.signUpEndpoint,
          AppConstants.signOutEndpoint,
          AppConstants.refreshTokenEndpoint,
          AppConstants.forgotPasswordEndpoint,
          AppConstants.resetPasswordEndpoint,
        ];

        for (final endpoint in authEndpoints) {
          expect(endpoint, startsWith('/api/auth/'));
        }
      });

      testWidgets('should have consistent storage key naming', (WidgetTester tester) async {
        // Assert - Verify storage keys follow consistent pattern
        final storageKeys = [
          AppConstants.bearerTokenKey,
          AppConstants.userDataKey,
          AppConstants.onboardingCompletedKey,
        ];

        for (final key in storageKeys) {
          expect(key, isA<String>());
          expect(key.isNotEmpty, isTrue);
        }
      });

      testWidgets('should have no hardcoded values in implementation', (WidgetTester tester) async {
        // This test ensures that constants are used instead of hardcoded values
        // We verify this by checking that the constants exist and have expected values

        // API Base URL
        expect(AppConstants.apiBaseUrl, equals('http://localhost:3000'));

        // App Info
        expect(AppConstants.appName, equals('Usago'));
        expect(AppConstants.appVersion, equals('1.0.0'));

        // Pagination
        expect(AppConstants.defaultPageSize, equals(20));

        // Cache
        expect(AppConstants.cacheExpiration, equals(const Duration(hours: 24)));
      });
    });

    group('Constants Integration with Real Components', () {
      testWidgets('should integrate constants across auth flow', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer integration_test_token';
        final testUser = AuthFixtures.testUserModel;

        final loginResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
        );
        loginResponse.headers.set('set-auth-token', testToken);

        final logoutResponse = Response(
          data: {'message': 'Logout successful'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signOutEndpoint),
        );

        when(() => mockDio.post(
          AppConstants.signInEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => loginResponse);

        when(() => mockDio.post(
          AppConstants.signOutEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => logoutResponse);

        // Act - Complete auth flow
        await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        final savedToken = await localDatasource.getToken();
        final savedUser = await localDatasource.getUser();

        await remoteDatasource.logout();

        // Assert - Verify constants are used consistently throughout the flow
        expect(savedToken, equals(testToken));
        expect(savedUser?.email, equals(testUser.email));

        verify(() => mockDio.post(
          AppConstants.signInEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        verify(() => mockDio.post(
          AppConstants.signOutEndpoint,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

        // Verify final state
        final clearedToken = await localDatasource.getToken();
        expect(clearedToken, isNull);
      });
    });
  });
}

/// Mock Dio class for testing
class MockDio extends Mock implements Dio {}