import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/models/user_model.dart';

import '../../../../fixtures/auth_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

class MockSecureStorage {
  final Map<String, String> _storage = {};

  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> read(String key) async {
    return _storage[key];
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  Future<void> deleteAll() async {
    _storage.clear();
  }

  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  Future<Set<String>> getAllKeys() async {
    return _storage.keys.toSet();
  }
}

void main() {
  group('AuthLocalDatasourceImpl with Mock Secure Storage', () {
    late AuthLocalDatasourceImpl datasource;
    late SharedPreferences prefs;
    late AppLogger logger;
    late MockSecureStorage mockSecureStorage;

    setUp(() async {
      TestHelpers.setUpMocktailFallbacks();

      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      logger = AppLogger();
      mockSecureStorage = MockSecureStorage();

      datasource = AuthLocalDatasourceImpl(
        prefs: prefs,
        logger: logger,
        secureStorage: mockSecureStorage,
      );
    });

    group('saveToken', () {
      test('should save token without throwing LateInitializationError',
          () async {
        // Act
        await datasource.saveToken(AuthFixtures.testToken);

        // Assert - Should not throw exception
        expect(() => datasource.saveToken(AuthFixtures.testToken),
            returnsNormally);
      });

      test('should save token to mock secure storage', () async {
        // Act
        await datasource.saveToken(AuthFixtures.testToken);

        // Assert - Verify mock was called
        expect(
            mockSecureStorage._storage.containsKey(AppConstants.bearerTokenKey),
            isTrue);
        expect(mockSecureStorage._storage[AppConstants.bearerTokenKey],
            equals(AuthFixtures.testToken));
      });
    });

    group('getToken', () {
      test('should get token without throwing LateInitializationError',
          () async {
        // Act
        final result = await datasource.getToken();

        // Assert - Should not throw exception
        expect(() => datasource.getToken(), returnsNormally);
        expect(result, isNull); // Mock returns null
      });

      test('should get token from mock secure storage', () async {
        // Arrange
        mockSecureStorage._storage[AppConstants.bearerTokenKey] =
            AuthFixtures.testToken;

        // Act
        final result = await datasource.getToken();

        // Assert - Verify mock was called and result is correct
        expect(result, equals(AuthFixtures.testToken));
      });
    });

    group('clearToken', () {
      test('should clear token without throwing LateInitializationError',
          () async {
        // Act
        await datasource.clearToken();

        // Assert - Should not throw exception
        expect(() => datasource.clearToken(), returnsNormally);
      });

      test('should clear token from mock secure storage', () async {
        // Act
        await datasource.clearToken();

        // Assert - Verify mock was called
        expect(
            mockSecureStorage._storage.containsKey(AppConstants.bearerTokenKey),
            isFalse);
      });
    });

    group('saveUser', () {
      test('should save user without throwing LateInitializationError',
          () async {
        // Act
        await datasource.saveUser(AuthFixtures.testUserModel);

        // Assert - Should not throw exception
        expect(() => datasource.saveUser(AuthFixtures.testUserModel),
            returnsNormally);
      });

      test('should save user to SharedPreferences', () async {
        // Act
        await datasource.saveUser(AuthFixtures.testUserModel);

        // Assert - Verify user was saved to SharedPreferences
        final savedUserJson = prefs.getString(AppConstants.userDataKey);
        expect(savedUserJson, isNotNull);

        final savedUser = UserModel.fromJson(
            jsonDecode(savedUserJson!) as Map<String, dynamic>);
        expect(savedUser.id, equals(AuthFixtures.testUserModel.id));
        expect(savedUser.email, equals(AuthFixtures.testUserModel.email));
      });
    });

    group('getUser', () {
      test('should get user without throwing LateInitializationError',
          () async {
        // Act
        final result = await datasource.getUser();

        // Assert - Should not throw exception
        expect(() => datasource.getUser(), returnsNormally);
        expect(result, isNull); // No user saved initially
      });

      test('should get user from SharedPreferences', () async {
        // Arrange
        final userJson = jsonEncode(AuthFixtures.testUserModel.toJson());
        await prefs.setString(AppConstants.userDataKey, userJson);

        // Act
        final result = await datasource.getUser();

        // Assert - Verify user was retrieved from SharedPreferences
        expect(result, isNotNull);
        expect(result!.id, equals(AuthFixtures.testUserModel.id));
        expect(result!.email, equals(AuthFixtures.testUserModel.email));
      });
    });

    group('isUserLoggedIn', () {
      test('should check login status without throwing LateInitializationError',
          () async {
        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert - Should not throw exception
        expect(() => datasource.isUserLoggedIn(), returnsNormally);
        expect(result, isFalse); // No token and no user
      });

      test('should return false when no token and user', () async {
        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
      });

      test('should return true when token and user exist', () async {
        // Arrange
        mockSecureStorage._storage[AppConstants.bearerTokenKey] =
            AuthFixtures.testToken;

        final userJson = jsonEncode(AuthFixtures.testUserModel.toJson());
        await prefs.setString(AppConstants.userDataKey, userJson);

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isTrue);
      });
    });
  });
}
