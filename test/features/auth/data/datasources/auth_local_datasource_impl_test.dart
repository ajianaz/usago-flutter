import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';
import '../../../../../lib/features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../../lib/core/services/secure_storage_service.dart';
import '../../../../../lib/core/utils/logger.dart';
import '../../../../../lib/core/errors/exceptions.dart';

import 'auth_local_datasource_impl_test.mocks.dart';

/// Test suite for AuthLocalDatasourceImpl
/// Tests the local storage operations for authentication data
void main() {
  group('AuthLocalDatasourceImpl Tests', () {
    late AuthLocalDatasourceImpl datasource;
    late MockSecureStorageService mockSecureStorage;
    late MockAppLogger mockLogger;

    setUp(() {
      mockSecureStorage = MockSecureStorageService();
      mockLogger = MockAppLogger();
      datasource = AuthLocalDatasourceImpl(
        secureStorage: mockSecureStorage,
        logger: mockLogger,
      );
    });

    group('saveUser', () {
      test('should save user to secure storage successfully', () async {
        // Arrange
        final user = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );
        final userJson = jsonEncode(user.toJson());

        when(mockSecureStorage.saveUserData(userJson))
            .thenAnswer((_) async {});

        // Act
        await datasource.saveUser(user);

        // Assert
        verify(mockSecureStorage.saveUserData(userJson)).called(1);
        verify(mockLogger.info('User saved to secure storage')).called(1);
      });

      test('should throw exception when save fails', () async {
        // Arrange
        final user = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );
        final exception = Exception('Storage error');

        when(mockSecureStorage.saveUserData(any))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.saveUser(user),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to save user to secure storage', exception)).called(1);
      });
    });

    group('getUser', () {
      test('should return user when found in storage', () async {
        // Arrange
        final user = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );
        final userJson = jsonEncode(user.toJson());

        when(mockSecureStorage.getUserData())
            .thenAnswer((_) async => userJson);

        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals(user.id));
        expect(result.email, equals(user.email));
        expect(result.name, equals(user.name));
        verify(mockLogger.info('User retrieved from secure storage')).called(1);
      });

      test('should return null when user not found', () async {
        // Arrange
        when(mockSecureStorage.getUserData())
            .thenAnswer((_) async => null);

        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNull);
        verify(mockLogger.info('User retrieved from secure storage')).called(1);
      });

      test('should return null on storage error', () async {
        // Arrange
        when(mockSecureStorage.getUserData())
            .thenThrow(Exception('Storage error'));

        // Act
        final result = await datasource.getUser();

        // Assert
        expect(result, isNull);
        verify(mockLogger.error('Failed to get user from secure storage', any)).called(1);
      });
    });

    group('clearUser', () {
      test('should clear user from secure storage successfully', () async {
        // Arrange
        when(mockSecureStorage.clearUserData())
            .thenAnswer((_) async {});

        // Act
        await datasource.clearUser();

        // Assert
        verify(mockSecureStorage.clearUserData()).called(1);
        verify(mockLogger.info('User cleared from secure storage')).called(1);
      });

      test('should throw exception when clear fails', () async {
        // Arrange
        final exception = Exception('Clear error');
        when(mockSecureStorage.clearUserData())
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.clearUser(),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to clear user from secure storage', exception)).called(1);
      });
    });

    group('saveToken', () {
      test('should save token to secure storage successfully', () async {
        // Arrange
        const token = 'Bearer test-token-123';
        when(mockSecureStorage.saveToken(token))
            .thenAnswer((_) async {});

        // Act
        await datasource.saveToken(token);

        // Assert
        verify(mockSecureStorage.saveToken(token)).called(1);
        verify(mockLogger.info('Bearer token saved to secure storage')).called(1);
      });

      test('should throw exception when save token fails', () async {
        // Arrange
        const token = 'Bearer test-token-123';
        final exception = Exception('Token save error');
        when(mockSecureStorage.saveToken(token))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.saveToken(token),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to save bearer token to secure storage', exception)).called(1);
      });
    });

    group('getToken', () {
      test('should return token when found in storage', () async {
        // Arrange
        const token = 'Bearer test-token-123';
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => token);

        // Act
        final result = await datasource.getToken();

        // Assert
        expect(result, equals(token));
        verify(mockLogger.info('Bearer token retrieved from secure storage')).called(1);
      });

      test('should return null when token not found', () async {
        // Arrange
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);

        // Act
        final result = await datasource.getToken();

        // Assert
        expect(result, isNull);
        verify(mockLogger.info('Bearer token retrieved from secure storage')).called(1);
      });

      test('should return null on storage error', () async {
        // Arrange
        when(mockSecureStorage.getToken())
            .thenThrow(Exception('Token retrieval error'));

        // Act
        final result = await datasource.getToken();

        // Assert
        expect(result, isNull);
        verify(mockLogger.error('Failed to get bearer token from secure storage', any)).called(1);
      });
    });

    group('clearToken', () {
      test('should clear token from secure storage successfully', () async {
        // Arrange
        when(mockSecureStorage.clearToken())
            .thenAnswer((_) async {});

        // Act
        await datasource.clearToken();

        // Assert
        verify(mockSecureStorage.clearToken()).called(1);
        verify(mockLogger.info('Bearer token cleared from secure storage')).called(1);
      });

      test('should throw exception when clear token fails', () async {
        // Arrange
        final exception = Exception('Clear token error');
        when(mockSecureStorage.clearToken())
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.clearToken(),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to clear bearer token from secure storage', exception)).called(1);
      });
    });

    group('saveSessionData', () {
      test('should save session data to secure storage successfully', () async {
        // Arrange
        final sessionData = {
          'key1': 'value1',
          'key2': 'value2',
          'timestamp': DateTime.now().toIso8601String(),
        };
        when(mockSecureStorage.saveSessionData(sessionData))
            .thenAnswer((_) async {});

        // Act
        await datasource.saveSessionData(sessionData);

        // Assert
        verify(mockSecureStorage.saveSessionData(sessionData)).called(1);
        verify(mockLogger.info('Session data saved to secure storage')).called(1);
      });

      test('should throw exception when save session data fails', () async {
        // Arrange
        final sessionData = {'key': 'value'};
        final exception = Exception('Session save error');
        when(mockSecureStorage.saveSessionData(sessionData))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.saveSessionData(sessionData),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to save session data to secure storage', exception)).called(1);
      });
    });

    group('getSessionData', () {
      test('should return session data when found in storage', () async {
        // Arrange
        final sessionData = {
          'key1': 'value1',
          'key2': 'value2',
          'timestamp': DateTime.now().toIso8601String(),
        };
        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, equals(sessionData));
        verify(mockLogger.info('Session data retrieved from secure storage')).called(1);
      });

      test('should return null when session data not found', () async {
        // Arrange
        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => null);

        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, isNull);
        verify(mockLogger.info('Session data retrieved from secure storage')).called(1);
      });

      test('should return null on storage error', () async {
        // Arrange
        when(mockSecureStorage.getSessionData())
            .thenThrow(Exception('Session retrieval error'));

        // Act
        final result = await datasource.getSessionData();

        // Assert
        expect(result, isNull);
        verify(mockLogger.error('Failed to get session data from secure storage', any)).called(1);
      });
    });

    group('clearSessionData', () {
      test('should clear session data from secure storage successfully', () async {
        // Arrange
        when(mockSecureStorage.clearSessionData())
            .thenAnswer((_) async {});

        // Act
        await datasource.clearSessionData();

        // Assert
        verify(mockSecureStorage.clearSessionData()).called(1);
        verify(mockLogger.info('Session data cleared from secure storage')).called(1);
      });

      test('should throw exception when clear session data fails', () async {
        // Arrange
        final exception = Exception('Clear session error');
        when(mockSecureStorage.clearSessionData())
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.clearSessionData(),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to clear session data from secure storage', exception)).called(1);
      });
    });

    group('isUserLoggedIn', () {
      test('should return true when user and token exist', () async {
        // Arrange
        const token = 'Bearer test-token';
        final user = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => token);
        when(mockSecureStorage.getUserData())
            .thenAnswer((_) async => jsonEncode(user.toJson()));

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isTrue);
        verify(mockLogger.info('User login status checked: true')).called(1);
      });

      test('should return false when token is null', () async {
        // Arrange
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockSecureStorage.getUserData())
            .thenAnswer((_) async => '{}');

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
        verify(mockLogger.info('User login status checked: false')).called(1);
      });

      test('should return false when user is null', () async {
        // Arrange
        const token = 'Bearer test-token';
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => token);
        when(mockSecureStorage.getUserData())
            .thenAnswer((_) async => null);

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
        verify(mockLogger.info('User login status checked: false')).called(1);
      });

      test('should return false on storage error', () async {
        // Arrange
        when(mockSecureStorage.getToken())
            .thenThrow(Exception('Storage error'));
        when(mockSecureStorage.getUserData())
            .thenThrow(Exception('Storage error'));

        // Act
        final result = await datasource.isUserLoggedIn();

        // Assert
        expect(result, isFalse);
        verify(mockLogger.error('Failed to check user login status', any)).called(1);
      });
    });

    group('getLastLoginTime', () {
      test('should return last login time when found in session data', () async {
        // Arrange
        final loginTime = DateTime.now();
        final sessionData = {
          'last_login': loginTime.toIso8601String(),
        };
        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, equals(loginTime));
        verify(mockLogger.info('Last login time retrieved from secure storage')).called(1);
      });

      test('should return null when last login not found', () async {
        // Arrange
        final sessionData = <String, dynamic>{};
        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, isNull);
        verify(mockLogger.info('Last login time retrieved from secure storage')).called(1);
      });

      test('should return null on storage error', () async {
        // Arrange
        when(mockSecureStorage.getSessionData())
            .thenThrow(Exception('Session error'));

        // Act
        final result = await datasource.getLastLoginTime();

        // Assert
        expect(result, isNull);
        verify(mockLogger.error('Failed to get last login time from secure storage', any)).called(1);
      });
    });

    group('saveLastLoginTime', () {
      test('should save last login time successfully', () async {
        // Arrange
        final loginTime = DateTime.now();
        final existingSessionData = <String, dynamic>{};
        final updatedSessionData = {
          'last_login': loginTime.toIso8601String(),
        };

        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => existingSessionData);
        when(mockSecureStorage.saveSessionData(updatedSessionData))
            .thenAnswer((_) async {});

        // Act
        await datasource.saveLastLoginTime(loginTime);

        // Assert
        verify(mockSecureStorage.getSessionData()).called(1);
        verify(mockSecureStorage.saveSessionData(updatedSessionData)).called(1);
        verify(mockLogger.info('Last login time saved to secure storage')).called(1);
      });

      test('should throw exception when save fails', () async {
        // Arrange
        final loginTime = DateTime.now();
        final exception = Exception('Save login time error');
        when(mockSecureStorage.getSessionData())
            .thenAnswer((_) async => {});
        when(mockSecureStorage.saveSessionData(any))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.saveLastLoginTime(loginTime),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to save last login time to secure storage', exception)).called(1);
      });
    });

    group('clearAllAuthData', () {
      test('should clear all auth data successfully', () async {
        // Arrange
        when(mockSecureStorage.clearUserData())
            .thenAnswer((_) async {});
        when(mockSecureStorage.clearToken())
            .thenAnswer((_) async {});
        when(mockSecureStorage.clearSessionData())
            .thenAnswer((_) async {});

        // Act
        await datasource.clearAllAuthData();

        // Assert
        verify(mockSecureStorage.clearUserData()).called(1);
        verify(mockSecureStorage.clearToken()).called(1);
        verify(mockSecureStorage.clearSessionData()).called(1);
        verify(mockLogger.info('All auth data cleared from secure storage')).called(1);
      });

      test('should throw exception when clear operation fails', () async {
        // Arrange
        final exception = Exception('Clear all data error');
        when(mockSecureStorage.clearUserData())
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.clearAllAuthData(),
          throwsA(isA<Exception>()),
        );
        verify(mockLogger.error('Failed to clear all auth data from secure storage', exception)).called(1);
      });
    });
  });
}