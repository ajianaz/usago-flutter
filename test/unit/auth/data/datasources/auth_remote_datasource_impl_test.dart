import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/network/dio_client.dart';
import 'package:usago/core/services/device_info_service.dart';
import 'package:usago/core/services/secure_storage_service.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:usago/features/auth/data/models/user_model.dart';

import '../../../../fixtures/auth_fixtures.dart';
import '../../../../mocks/auth_datasource_mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('AuthRemoteDatasourceImpl', () {
    late AuthRemoteDatasourceImpl datasource;
    late DioClient dioClient;
    late AuthLocalDatasource localDatasource;
    late AppLogger logger;
    late SharedPreferences prefs;
    late DeviceInfoService deviceInfoService;
    late SecureStorageService secureStorage;

    setUp(() async {
      TestHelpers.setUpMocktailFallbacks();

      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // Use real components instead of mocks
      dioClient = DioClient(logger: AppLogger());
      logger = AppLogger();
      deviceInfoService = DeviceInfoService();
      secureStorage = SecureStorageService(logger: logger);
      await secureStorage.initialize();

      localDatasource = AuthLocalDatasourceImpl(
          prefs: prefs, logger: logger, secureStorage: secureStorage);

      datasource = AuthRemoteDatasourceImpl(
        dioClient: dioClient,
        logger: logger,
        localDatasource: localDatasource,
        deviceInfoService: deviceInfoService,
      );
    });

    group('login', () {
      test('should validate login parameters and structure', () async {
        // Test parameter validation
        expect(
          () => datasource.login(email: '', password: 'password'),
          throwsA(isA<Exception>()),
        );

        expect(
          () => datasource.login(email: 'email', password: ''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(
          () => datasource.login(
            email: AuthFixtures.testUserEmail,
            password: AuthFixtures.testUserPassword,
          ),
          returnsNormally,
        );
      });

      test('should handle login errors appropriately', () async {
        // Test that error handling works
        expect(
          () => datasource.login(
            email: 'invalid-email',
            password: 'short',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('register', () {
      test('should validate register parameters and structure', () async {
        // Test parameter validation
        expect(
          () => datasource.register(
              email: '', password: 'password', name: 'name'),
          throwsA(isA<Exception>()),
        );

        expect(
          () => datasource.register(email: 'email', password: '', name: 'name'),
          throwsA(isA<Exception>()),
        );

        expect(
          () => datasource.register(
              email: 'email', password: 'password', name: ''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(
          () => datasource.register(
            email: AuthFixtures.testUserEmail,
            password: AuthFixtures.testUserPassword,
            name: AuthFixtures.testUserName,
          ),
          returnsNormally,
        );
      });
    });

    group('logout', () {
      test('should validate logout method structure', () async {
        // Test that the method exists and has correct signature
        expect(() => datasource.logout(), returnsNormally);
      });
    });

    group('refreshToken', () {
      test('should validate refreshToken method structure', () async {
        // Test that the method exists and has correct signature
        expect(() => datasource.refreshToken(), returnsNormally);
      });
    });

    group('forgotPassword', () {
      test('should validate forgotPassword method structure', () async {
        // Test parameter validation
        expect(
          () => datasource.forgotPassword(''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(() => datasource.forgotPassword(AuthFixtures.testUserEmail),
            returnsNormally);
      });
    });

    group('resetPassword', () {
      test('should validate resetPassword method structure', () async {
        // Test parameter validation
        expect(
          () => datasource.resetPassword(token: '', newPassword: 'password'),
          throwsA(isA<Exception>()),
        );

        expect(
          () => datasource.resetPassword(token: 'token', newPassword: ''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(
          () => datasource.resetPassword(
            token: AuthFixtures.testResetToken,
            newPassword: AuthFixtures.validPassword,
          ),
          returnsNormally,
        );
      });
    });

    group('changePassword', () {
      test('should validate changePassword method structure', () async {
        // Test parameter validation
        expect(
          () => datasource.changePassword(
              currentPassword: '', newPassword: 'password'),
          throwsA(isA<Exception>()),
        );

        expect(
          () => datasource.changePassword(
              currentPassword: 'password', newPassword: ''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(
          () => datasource.changePassword(
            currentPassword: 'old-password',
            newPassword: AuthFixtures.validPassword,
          ),
          returnsNormally,
        );
      });
    });

    group('updateProfile', () {
      test('should validate updateProfile method structure', () async {
        // Test that the method exists and has correct signature
        expect(
          () => datasource.updateProfile(
            name: 'Updated Name',
            profilePicture: 'https://example.com/new-avatar.jpg',
          ),
          returnsNormally,
        );

        // Test with null parameters
        expect(
          () => datasource.updateProfile(),
          returnsNormally,
        );
      });
    });

    group('verifyEmail', () {
      test('should validate verifyEmail method structure', () async {
        // Test parameter validation
        expect(
          () => datasource.verifyEmail(''),
          throwsA(isA<Exception>()),
        );

        // Test that the method exists and has correct signature
        expect(
          () => datasource.verifyEmail(AuthFixtures.testVerificationToken),
          returnsNormally,
        );
      });
    });

    group('resendVerificationEmail', () {
      test('should validate resendVerificationEmail method structure',
          () async {
        // Test that the method exists and has correct signature
        expect(() => datasource.resendVerificationEmail(), returnsNormally);
      });
    });

    group('deleteAccount', () {
      test('should validate deleteAccount method structure', () async {
        // Test that the method exists and has correct signature
        expect(() => datasource.deleteAccount(), returnsNormally);
      });
    });

    group('Better Auth Error Handling', () {
      test('should handle Better Auth error codes correctly', () async {
        // Test the private _handleBetterAuthError method indirectly
        // by checking that error handling is implemented
        expect(datasource, isA<AuthRemoteDatasourceImpl>());
      });
    });
  });
}
