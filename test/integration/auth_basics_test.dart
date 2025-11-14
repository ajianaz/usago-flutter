// Auth Basics Integration Tests
// Purpose: Test basic auth functionality with focused scenarios
// Follows Flutter development guidelines for testing structure and patterns

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/network/dio_client.dart';
import 'package:usago/core/services/secure_storage_service.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:usago/features/auth/data/models/user_model.dart';
import 'package:usago/core/utils/logger.dart';
import '../fixtures/auth_fixtures.dart';

/// Focused integration tests for basic auth functionality
///
/// This test suite verifies:
/// - Basic login/logout flow
/// - Token storage and retrieval
/// - API endpoint connectivity
/// - Error handling
///
/// Test Structure:
/// - Focused on essential scenarios only
/// - 100-150 lines per file
/// - Clear and concise test cases
void main() {
  group('Auth Basics Integration Tests', () {
    late DioClient dioClient;
    late AuthLocalDatasourceImpl localDatasource;
    late AuthRemoteDatasourceImpl remoteDatasource;
    late SharedPreferences prefs;
    late Dio mockDio;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      mockDio = MockDio();
      dioClient = DioClient();

      // Create secure storage service for testing
      final secureStorage = SecureStorageService(
        secureStorage: FlutterSecureStorage(),
        prefs: prefs,
        logger: AppLogger(),
      );

      localDatasource = AuthLocalDatasourceImpl(
        secureStorage: secureStorage,
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

    group('Basic Login Flow', () {
      testWidgets('should login and save token', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer login_test_token';
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

        // Act
        final user = await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        // Assert
        expect(user.email, equals(AuthFixtures.validEmail));
        final savedToken = await localDatasource.getToken();
        expect(savedToken, equals(testToken));
      });

      testWidgets('should handle login failure', (WidgetTester tester) async {
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
      });
    });

    group('Token Storage', () {
      testWidgets('should save and retrieve token', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer storage_test_token';

        // Act
        await localDatasource.saveToken(testToken);
        final retrievedToken = await localDatasource.getToken();

        // Assert
        expect(retrievedToken, equals(testToken));
        expect(prefs.getString(AppConstants.bearerTokenKey), equals(testToken));
      });

      testWidgets('should clear token on logout', (WidgetTester tester) async {
        // Arrange
        await localDatasource.saveToken('Bearer logout_test_token');
        expect(await localDatasource.getToken(), isNotNull);

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

        // Act
        await remoteDatasource.logout();

        // Assert
        final clearedToken = await localDatasource.getToken();
        expect(clearedToken, isNull);
      });
    });

    group('User Data Storage', () {
      testWidgets('should save and retrieve user data', (WidgetTester tester) async {
        // Arrange
        final testUser = AuthFixtures.testUserModel;

        // Act
        await localDatasource.saveUser(testUser);
        final retrievedUser = await localDatasource.getUser();

        // Assert
        expect(retrievedUser?.email, equals(testUser.email));
        expect(retrievedUser?.id, equals(testUser.id));
        expect(prefs.getString(AppConstants.userDataKey), isNotNull);
      });

      testWidgets('should clear user data', (WidgetTester tester) async {
        // Arrange
        await localDatasource.saveUser(AuthFixtures.testUserModel);
        expect(await localDatasource.getUser(), isNotNull);

        // Act
        await localDatasource.clearUser();

        // Assert
        final clearedUser = await localDatasource.getUser();
        expect(clearedUser, isNull);
      });
    });

    group('API Endpoints', () {
      testWidgets('should use correct endpoints', (WidgetTester tester) async {
        // Assert endpoint constants
        expect(AppConstants.signInEndpoint, equals('/api/auth/sign-in/email'));
        expect(AppConstants.signUpEndpoint, equals('/api/auth/sign-up/email'));
        expect(AppConstants.signOutEndpoint, equals('/api/auth/sign-out'));
        expect(AppConstants.refreshTokenEndpoint, equals('/api/auth/refresh-token'));
      });

      testWidgets('should handle endpoint not found', (WidgetTester tester) async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/invalid-endpoint'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/invalid-endpoint'),
          ),
        ));

        // Act & Assert
        expect(
          () => remoteDatasource.login(
            email: AuthFixtures.validEmail,
            password: AuthFixtures.validPassword,
          ),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('Error Handling', () {
      testWidgets('should handle network timeout', (WidgetTester tester) async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
          type: DioExceptionType.receiveTimeout,
        ));

        // Act & Assert
        expect(
          () => remoteDatasource.login(
            email: AuthFixtures.validEmail,
            password: AuthFixtures.validPassword,
          ),
          throwsA(isA<DioException>()),
        );
      });

      testWidgets('should handle server error', (WidgetTester tester) async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: AppConstants.signInEndpoint),
          ),
        ));

        // Act & Assert
        expect(
          () => remoteDatasource.login(
            email: AuthFixtures.validEmail,
            password: AuthFixtures.validPassword,
          ),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('Complete Auth Flow', () {
      testWidgets('should handle complete auth cycle', (WidgetTester tester) async {
        // Arrange
        const testToken = 'Bearer cycle_test_token';
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

        // Act - Login
        final user = await remoteDatasource.login(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        );

        // Assert - Login success
        expect(user.email, equals(AuthFixtures.validEmail));
        final savedToken = await localDatasource.getToken();
        expect(savedToken, equals(testToken));

        // Act - Logout
        await remoteDatasource.logout();

        // Assert - Logout success
        final clearedToken = await localDatasource.getToken();
        expect(clearedToken, isNull);
      });
    });
  });
}

/// Mock Dio class for testing
class MockDio extends Mock implements Dio {}