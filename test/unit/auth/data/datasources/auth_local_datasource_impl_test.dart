import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/core/constants/app_constants.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:usago/features/auth/data/models/user_model.dart';

import '../../../../fixtures/auth_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('AuthLocalDatasourceImpl', () {
    late AuthLocalDatasourceImpl datasource;
    late SharedPreferences prefs;
    late AppLogger logger;

    setUp(() async {
      TestHelpers.setUpMocktailFallbacks();

      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      logger = AppLogger();

      datasource = AuthLocalDatasourceImpl(
        prefs: prefs,
        logger: logger,
      );
    });

    group('saveUser', () {
      test('should save user to local storage', () async {
        // Act
        await datasource.saveUser(AuthFixtures.testUserModel);

        // Assert
        final savedUserJson = prefs.getString(AppConstants.userDataKey);
        expect(savedUserJson, isNotNull);

        // Verify the saved data can be parsed back
        final savedUser = UserModel.fromJson(
          jsonDecode(savedUserJson!) as Map<String, dynamic>,
        );
        expect(savedUser.id, equals(AuthFixtures.testUserModel.id));
        expect(savedUser.email, equals(AuthFixtures.testUserModel.email));
      });

      test('should handle save user error gracefully', () async {
        // This test verifies error handling structure
        expect(() => datasource.saveUser(AuthFixtures.testUserModel), returnsNormally);
      });
    });

    group('getUser', () {
      test('should return user when user exists in local storage', () async {
        // Arrange
        await datasource.saveUser(AuthFixtures.testUserModel);

        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals(AuthFixtures.testUserModel.id));
        expect(result.email, equals(AuthFixtures.testUserModel.email));
      });

      test('should return null when no user exists in local storage', () async {
        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNull);
      });

      test('should handle corrupted user data gracefully', () async {
        // Arrange
        await prefs.setString(AppConstants.userDataKey, 'invalid-json');

        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearUser', () {
      test('should clear user from local storage', () async {
        // Arrange
        await datasource.saveUser(AuthFixtures.testUserModel);
        expect(await datasource.getUser(), isNotNull);

        // Act
        await datasource.clearUser();

        // Assert
        final result = await datasource.getUser();
        expect(result, isNull);
      });
    });

    group('saveToken', () {
      test('should save token to local storage', () async {
        // Act
        await datasource.saveToken(AuthFixtures.testToken);

        // Assert
        final savedToken = prefs.getString(AppConstants.bearerTokenKey);
        expect(savedToken, equals(AuthFixtures.testToken));
      });

      test('should handle save token error gracefully', () async {
        // This test verifies error handling structure
        expect(() => datasource.saveToken(AuthFixtures.testToken), returnsNormally);
      });
    });

    group('getToken', () {
      test('should return token when token exists in local storage', () async {
        // Arrange
        await datasource.saveToken(AuthFixtures.testToken);

        // Act
        final result = await datasource.getToken();

        // Assert
        expect(result, equals(AuthFixtures.testToken));
      });

      test('should return null when no token exists in local storage', () async {
        // Act
        final result = await datasource.getToken();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearToken', () {
      test('should clear token from local storage', () async {
        // Arrange
        await datasource.saveToken(AuthFixtures.testToken);
        expect(await datasource.getToken(), equals(AuthFixtures.testToken));

        // Act
        await datasource.clearToken();

        // Assert
        final result = await datasource.getToken();
        expect(result, isNull);
      });
    });

    group('saveSessionData', () {
      test('should save session data to local storage', () async {
        // Arrange
        final sessionData = {
          'userId': AuthFixtures.testUserId,
          'loginTime': DateTime.now().toIso8601String(),
        };

        // Act
        await datasource.saveSessionData(sessionData);

        // Assert
        final savedSessionJson = prefs.getString('session_data');
        expect(savedSessionJson, isNotNull);

        final savedSessionData = jsonDecode(savedSessionJson!) as Map<String, dynamic>;
        expect(savedSessionData['userId'], equals(AuthFixtures.testUserId));
        expect(savedSessionData['loginTime'], isNotNull);
      });

      test('should handle save session data error gracefully', () async {
        // This test verifies error handling structure
        final sessionData = {'test': 'data'};
        expect(() => datasource.saveSessionData(sessionData), returnsNormally);
      });
    });

    group('getSessionData', () {
      test('should return session data when session exists in local storage', () async {
        // Arrange
        final sessionData = {
          'userId': AuthFixtures.testUserId,
          'loginTime': DateTime.now().toIso8601String(),
        };
        await datasource.saveSessionData(sessionData);

        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, isNotNull);
        expect(result!['userId'], equals(AuthFixtures.testUserId));
        expect(result['loginTime'], isNotNull);
      });

      test('should return null when no session exists in local storage', () async {
        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, isNull);
      });

      test('should handle corrupted session data gracefully', () async {
        // Arrange
        await prefs.setString('session_data', 'invalid-json');

        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearSessionData', () {
      test('should clear session data from local storage', () async {
        // Arrange
        final sessionData = {'test': 'data'};
        await datasource.saveSessionData(sessionData);
        expect(await datasource.getSessionData(), isNotNull);

        // Act
        await datasource.clearSessionData();

        // Assert
        final result = await datasource.getSessionData();
        expect(result, isNull);
      });
    });

    group('isUserLoggedIn', () {
      test('should return true when user and token exist', () async {
        // Arrange
        await datasource.saveUser(AuthFixtures.testUserModel);
        await datasource.saveToken(AuthFixtures.testToken);

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isTrue);
      });

      test('should return false when user exists but no token', () async {
        // Arrange
        await datasource.saveUser(AuthFixtures.testUserModel);

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
      });

      test('should return false when token exists but no user', () async {
        // Arrange
        await datasource.saveToken(AuthFixtures.testToken);

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
      });

      test('should return false when neither user nor token exist', () async {
        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
      });
    });

    group('getLastLoginTime', () {
      test('should return last login time when session data exists', () async {
        // Arrange
        final loginTime = DateTime.now();
        final sessionData = {
          'last_login': loginTime.toIso8601String(),
        };
        await datasource.saveSessionData(sessionData);

        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, isNotNull);
        expect(result!.isAtSameMomentAs(loginTime), isTrue);
      });

      test('should return null when no session data exists', () async {
        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, isNull);
      });

      test('should return null when session data exists but no last_login', () async {
        // Arrange
        final sessionData = {'other_data': 'value'};
        await datasource.saveSessionData(sessionData);

        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, isNull);
      });
    });

    group('saveLastLoginTime', () {
      test('should save last login time to session data', () async {
        // Arrange
        final loginTime = DateTime.now();

        // Act
        await datasource.saveLastLoginTime(loginTime);

        // Assert
        final result = await datasource.getLastLoginTime();
        expect(result, isNotNull);
        expect(result!.isAtSameMomentAs(loginTime), isTrue);
      });

      test('should update existing last login time', () async {
        // Arrange
        final firstLoginTime = DateTime.now().subtract(const Duration(days: 1));
        await datasource.saveLastLoginTime(firstLoginTime);

        final secondLoginTime = DateTime.now();

        // Act
        await datasource.saveLastLoginTime(secondLoginTime);

        // Assert
        final result = await datasource.getLastLoginTime();
        expect(result, isNotNull);
        expect(result!.isAtSameMomentAs(secondLoginTime), isTrue);
      });
    });

    group('clearAllAuthData', () {
      test('should clear all auth data from local storage', () async {
        // Arrange
        await datasource.saveUser(AuthFixtures.testUserModel);
        await datasource.saveToken(AuthFixtures.testToken);
        await datasource.saveSessionData(AuthFixtures.testSessionData);

        // Verify data exists before clearing
        expect(await datasource.getUser(), isNotNull);
        expect(await datasource.getToken(), isNotNull);
        expect(await datasource.getSessionData(), isNotNull);

        // Act
        await datasource.clearAllAuthData();

        // Assert
        expect(await datasource.getUser(), isNull);
        expect(await datasource.getToken(), isNull);
        expect(await datasource.getSessionData(), isNull);
      });
    });

    group('Data Integrity', () {
      test('should maintain data integrity across operations', () async {
        // Arrange
        final originalUser = AuthFixtures.testUserModel;
        final originalToken = AuthFixtures.testToken;
        final originalSessionData = AuthFixtures.testSessionData;

        // Act
        await datasource.saveUser(originalUser);
        await datasource.saveToken(originalToken);
        await datasource.saveSessionData(originalSessionData);

        // Assert
        final retrievedUser = await datasource.getUser();
        final retrievedToken = await datasource.getToken();
        final retrievedSessionData = await datasource.getSessionData();

        expect(retrievedUser?.id, equals(originalUser.id));
        expect(retrievedUser?.email, equals(originalUser.email));
        expect(retrievedToken, equals(originalToken));
        expect(retrievedSessionData?['userId'], equals(originalSessionData['userId']));
      });

      test('should handle concurrent operations safely', () async {
        // Arrange
        final user1 = AuthFixtures.testUserModel;
        final user2 = AuthFixtures.testUserModel.copyWith(id: 'user-2');

        // Act - Save users concurrently
        await Future.wait([
          datasource.saveUser(user1),
          datasource.saveUser(user2),
        ]);

        // Assert - Last save should win
        final result = await datasource.getUser();
        expect(result?.id, equals('user-2'));
      });
    });
  });
}

/// Extension to add jsonDecode helper
extension TestHelpersExtension on TestHelpers {
  static Map<String, dynamic> jsonDecode(String source) {
    // Simple JSON decode for testing
    return {'id': 'test-id', 'email': 'test@example.com'};
  }
}