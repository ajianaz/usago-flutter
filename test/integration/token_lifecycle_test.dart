// Token Lifecycle Integration Tests
// Purpose: Test complete token lifecycle from login to logout
// Follows Flutter development guidelines for testing structure and patterns

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/config/logging_config.dart';
import 'package:usago/core/network/dio_client.dart';
import 'package:usago/core/services/device_info_service.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/core/services/secure_storage_service.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:usago/features/auth/data/models/user_model.dart';
import '../fixtures/auth_fixtures.dart';
import '../mocks/mock_test_utils.dart';

/// Comprehensive integration tests for token lifecycle
///
/// This test suite verifies:
/// - Complete token lifecycle from login to logout
/// - Token extraction from response headers
/// - Token storage and retrieval
/// - Bearer token format in requests
/// - Token refresh mechanism
/// - Token cleanup on logout
///
/// Test Structure:
/// - Follows Arrange-Act-Assert pattern consistently
/// - Uses real SharedPreferences for storage testing
/// - Mocks network calls but tests actual token handling
/// - Validates complete end-to-end token flow
void main() {
  group('Token Lifecycle Integration Tests', () {
    late DioClient dioClient;
    late AuthLocalDatasourceImpl localDatasource;
    late AuthRemoteDatasourceImpl remoteDatasource;
    late SharedPreferences prefs;
    late Dio mockDio;
    late DeviceInfoService deviceInfoService;

    setUpAll(() async {
      // Initialize dotenv for all tests
      await LoggingConfig.initialize();
    });

    setUp(() async {
      // Setup real SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // Setup mock Dio
      mockDio = MockDio();
      dioClient = DioClient();
      deviceInfoService = DeviceInfoService();

      // Setup datasources
      final secureStorageService = SecureStorageService();
      await secureStorageService.initialize();

      localDatasource = AuthLocalDatasourceImpl(
        prefs: prefs,
        logger: AppLogger(),
        secureStorage: secureStorageService,
      );

      remoteDatasource = AuthRemoteDatasourceImpl(
        dioClient: dioClient,
        logger: AppLogger(),
        localDatasource: localDatasource,
        deviceInfoService: deviceInfoService,
      );
    });

    tearDown(() async {
      await prefs.clear();
    });

    group('Complete Token Lifecycle', () {
      testWidgets('should handle complete token lifecycle from login to logout',
          (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer test_token_123';
        final testUser = AuthFixtures.testUserModel;

        // Mock successful login response with token
        final loginResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
        );
        loginResponse.headers.set('set-auth-token', testToken);

        // Mock successful logout response
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

        // Act - Login and extract token
        final user = await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        // Assert - Token should be saved
        final savedToken = await localDatasource.getToken();
        expect(savedToken, equals(testToken));
        expect(user.email, equals(AuthFixtures.validEmail));

        // Act - Logout
        await remoteDatasource.logout();

        // Assert - Token should be cleared
        final clearedToken = await localDatasource.getToken();
        expect(clearedToken, isNull);

        // Verify API calls were made
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
      });

      testWidgets('should handle token refresh and update storage',
          (WidgetTester tester) async {
        // Arrange
        const oldToken = 'Bearer old_token_123';
        const newToken = 'Bearer new_token_456';
        final testUser = AuthFixtures.testUserModel;

        // Save initial token
        await localDatasource.saveToken(oldToken);

        // Mock token refresh response with new token
        final refreshResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions:
              RequestOptions(path: AppConstants.refreshTokenEndpoint),
        );
        refreshResponse.headers.set('set-auth-token', newToken);

        when(() => mockDio.post(
              AppConstants.refreshTokenEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => refreshResponse);

        // Act - Refresh token
        final user = await remoteDatasource.refreshToken();

        // Assert - New token should be saved
        final savedToken = await localDatasource.getToken();
        expect(savedToken, equals(newToken));
        expect(user.email, equals(AuthFixtures.validEmail));

        // Verify API call was made
        verify(() => mockDio.post(
              AppConstants.refreshTokenEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).called(1);
      });
    });

    group('Token Storage and Retrieval', () {
      testWidgets('should save and retrieve Bearer token correctly',
          (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer test_token_abc123';

        // Act - Save token
        await localDatasource.saveToken(testToken);

        // Assert - Token should be retrievable
        final retrievedToken = await localDatasource.getToken();
        expect(retrievedToken, equals(testToken));

        // Verify storage key
        final storedValue = prefs.getString(AppConstants.bearerTokenKey);
        expect(storedValue, equals(testToken));
      });

      testWidgets('should handle token storage with empty token',
          (WidgetTester tester) async {
        // Arrange
        const emptyToken = '';

        // Act - Save empty token
        await localDatasource.saveToken(emptyToken);

        // Assert - Empty token should be saved
        final retrievedToken = await localDatasource.getToken();
        expect(retrievedToken, equals(emptyToken));
      });

      testWidgets('should handle token clearing correctly',
          (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer test_token_to_clear';
        await localDatasource.saveToken(testToken);

        // Verify token is saved
        expect(await localDatasource.getToken(), equals(testToken));

        // Act - Clear token
        await localDatasource.clearToken();

        // Assert - Token should be null
        final retrievedToken = await localDatasource.getToken();
        expect(retrievedToken, isNull);

        // Verify storage key is removed
        final storedValue = prefs.getString(AppConstants.bearerTokenKey);
        expect(storedValue, isNull);
      });
    });

    group('Bearer Token Format Validation', () {
      testWidgets('should validate Bearer token format in storage',
          (WidgetTester tester) async {
        // Arrange
        const validTokens = [
          'Bearer abc123',
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          'Bearer sk-1234567890abcdef',
        ];

        for (final token in validTokens) {
          // Act
          await localDatasource.saveToken(token);

          // Assert
          final retrievedToken = await localDatasource.getToken();
          expect(retrievedToken, equals(token));
          expect(retrievedToken, startsWith('Bearer '));
        }
      });

      testWidgets('should handle tokens without Bearer prefix',
          (WidgetTester tester) async {
        // Arrange
        const tokenWithoutPrefix = 'abc123token';

        // Act
        await localDatasource.saveToken(tokenWithoutPrefix);

        // Assert
        final retrievedToken = await localDatasource.getToken();
        expect(retrievedToken, equals(tokenWithoutPrefix));
        expect(retrievedToken, isNot(startsWith('Bearer ')));
      });
    });

    group('Token Lifecycle with User Data', () {
      testWidgets('should save both token and user data during login',
          (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer user_token_123';
        final testUser = AuthFixtures.testUserModel;

        final loginResponse = Response(
          data: {'user': testUser.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
        );
        loginResponse.headers.set('set-auth-token', testToken);

        when(() => mockDio.post(
              AppConstants.signInEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => loginResponse);

        // Act - Login
        final user = await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        // Assert - Both token and user data should be saved
        final savedToken = await localDatasource.getToken();
        final savedUser = await localDatasource.getUser();

        expect(savedToken, equals(testToken));
        expect(savedUser?.email, equals(testUser.email));
        expect(savedUser?.id, equals(testUser.id));
        expect(user.email, equals(testUser.email));
      });

      testWidgets('should clear both token and user data during logout',
          (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer logout_token_123';
        final testUser = AuthFixtures.testUserModel;

        // Save initial data
        await localDatasource.saveToken(testToken);
        await localDatasource.saveUser(testUser);

        // Verify data is saved
        expect(await localDatasource.getToken(), equals(testToken));
        expect(await localDatasource.getUser(), isNotNull);

        // Mock logout response
        final logoutResponse = Response(
          data: {'message': 'Logout successful'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.signOutEndpoint),
        );

        when(() => mockDio.post(
              AppConstants.signOutEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => logoutResponse);

        // Act - Logout
        await remoteDatasource.logout();

        // Assert - Both token and user data should be cleared
        final clearedToken = await localDatasource.getToken();
        final clearedUser = await localDatasource.getUser();

        expect(clearedToken, isNull);
        expect(clearedUser, isNull);
      });
    });

    group('Error Handling in Token Lifecycle', () {
      testWidgets('should handle login failure without token extraction',
          (WidgetTester tester) async {
        // Arrange
        final errorResponse = Response(
          data: {'message': 'Invalid credentials'},
          statusCode: 401,
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
        );

        when(() => mockDio.post(
              AppConstants.signInEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
          response: errorResponse,
        ));

        // Act & Assert
        expect(
          () => remoteDatasource.login(
            email: 'invalid@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<DioException>()),
        );

        // Verify no token was saved
        final savedToken = await localDatasource.getToken();
        expect(savedToken, isNull);
      });

      testWidgets('should handle token refresh failure',
          (WidgetTester tester) async {
        // Arrange
        const oldToken = 'Bearer old_token_123';
        await localDatasource.saveToken(oldToken);

        final errorResponse = Response(
          data: {'message': 'Invalid refresh token'},
          statusCode: 401,
          requestOptions:
              RequestOptions(path: AppConstants.refreshTokenEndpoint),
        );

        when(() => mockDio.post(
              AppConstants.refreshTokenEndpoint,
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions:
              RequestOptions(path: AppConstants.refreshTokenEndpoint),
          response: errorResponse,
        ));

        // Act & Assert
        expect(
          () => remoteDatasource.refreshToken(),
          throwsA(isA<DioException>()),
        );

        // Verify old token is still saved
        final savedToken = await localDatasource.getToken();
        expect(savedToken, equals(oldToken));
      });
    });

    group('Token Lifecycle Edge Cases', () {
      testWidgets('should handle multiple rapid token refreshes',
          (WidgetTester tester) async {
        // Arrange
        const initialToken = 'Bearer initial_token';
        await localDatasource.saveToken(initialToken);

        final testUser = AuthFixtures.testUserModel;
        final refreshTokens = [
          'Bearer token_1',
          'Bearer token_2',
          'Bearer token_3'
        ];

        for (int i = 0; i < refreshTokens.length; i++) {
          final refreshResponse = Response(
            data: {'user': testUser.toJson()},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: AppConstants.refreshTokenEndpoint),
          );
          refreshResponse.headers.set('set-auth-token', refreshTokens[i]);

          when(() => mockDio.post(
                AppConstants.refreshTokenEndpoint,
                data: any(named: 'data'),
                options: any(named: 'options'),
              )).thenAnswer((_) async => refreshResponse);

          // Act
          await remoteDatasource.refreshToken();

          // Assert
          final savedToken = await localDatasource.getToken();
          expect(savedToken, equals(refreshTokens[i]));
        }
      });

      testWidgets('should handle token storage corruption',
          (WidgetTester tester) async {
        // Arrange - Corrupt the storage directly
        await prefs.setString(AppConstants.bearerTokenKey, 'invalid_json');

        // Act - Try to retrieve token
        final retrievedToken = await localDatasource.getToken();

        // Assert - Should handle corruption gracefully
        expect(retrievedToken, equals('invalid_json'));
      });
    });
  });
}

/// Mock Dio class for testing
class MockDio extends Mock implements Dio {}
