import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:usago/core/services/enhanced_secure_storage_service.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/core/platform/platform_detector.dart';

import '../../mocks/mock_dependencies.dart';

@GenerateMocks([MockSharedPreferences, MockFlutterSecureStorage, MockAppLogger])
void main() {
  group('EnhancedSecureStorageService', () {
    late EnhancedSecureStorageService secureStorageService;
    late MockSharedPreferences mockPrefs;
    late MockFlutterSecureStorage mockSecureStorage;
    late MockAppLogger mockLogger;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockSecureStorage = MockFlutterSecureStorage();
      mockLogger = MockAppLogger();

      secureStorageService = EnhancedSecureStorageService(
        secureStorage: mockSecureStorage,
        prefs: mockPrefs,
        logger: mockLogger,
      );
    });

    group('saveSensitiveData', () {
      test('should encrypt and save sensitive data successfully', () async {
        // Arrange
        const testData = 'sensitive_data';
        const testKey = 'test_key';

        when(() => mockSecureStorage.write(
          key: testKey,
          value: any(named: 'value'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async {});

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async => 'encrypted_data');

        // Act
        await secureStorageService.saveSensitiveData(testKey, testData);

        // Assert
        verify(() => mockSecureStorage.write(
          key: testKey,
          value: argThat(isA<String>()),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);

        verify(mockLogger).info('Sensitive data encrypted and saved for key: $testKey');
      });

      test('should handle encryption errors gracefully', () async {
        // Arrange
        const testData = 'sensitive_data';
        const testKey = 'test_key';

        when(() => mockSecureStorage.write(
          key: testKey,
          value: any(named: 'value'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenThrow(Exception('Encryption failed'));

        // Act & Assert
        expect(
          () async => await secureStorageService.saveSensitiveData(testKey, testData),
          throwsA(isA<Exception>()),
        );

        verify(mockLogger).error(
          'Failed to save sensitive data for key: $testKey',
          any(named: 'error'),
        );
      });
    });

    group('getSensitiveData', () {
      test('should decrypt and retrieve sensitive data successfully', () async {
        // Arrange
        const testKey = 'test_key';
        const expectedData = 'sensitive_data';

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async => 'encrypted_data');

        // Act
        final result = await secureStorageService.getSensitiveData(testKey);

        // Assert
        expect(result, equals(expectedData));
        verify(mockLogger).info('Sensitive data decrypted and retrieved for key: $testKey');
      });

      test('should handle decryption errors gracefully', () async {
        // Arrange
        const testKey = 'test_key';

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenThrow(Exception('Decryption failed'));

        // Act
        final result = await secureStorageService.getSensitiveData(testKey);

        // Assert
        expect(result, isNull);
        verify(mockLogger).error(
          'Failed to get sensitive data for key: $testKey',
          any(named: 'error'),
        );
      });

      test('should return null when no data exists', () async {
        // Arrange
        const testKey = 'test_key';

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async => null);

        // Act
        final result = await secureStorageService.getSensitiveData(testKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('token management', () {
      test('should save and retrieve token securely', () async {
        // Arrange
        const testToken = 'test_token';

        when(() => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async {});

        when(() => mockSecureStorage.read(
          key: any(named: 'key'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async => 'encrypted_token');

        // Act
        await secureStorageService.saveToken(testToken);
        final retrievedToken = await secureStorageService.getToken();

        // Assert
        expect(retrievedToken, equals(testToken));
        verify(mockLogger).info('Sensitive data encrypted and saved for key: bearer_token');
        verify(mockLogger).info('Sensitive data decrypted and retrieved for key: bearer_token');
      });

      test('should clear token securely', () async {
        // Arrange
        when(() => mockSecureStorage.delete(
          key: any(named: 'key'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async {});

        // Act
        await secureStorageService.clearToken();

        // Assert
        verify(() => mockSecureStorage.delete(
          key: 'bearer_token',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(mockLogger).info('Sensitive data removed for key: bearer_token');
      });
    });

    group('data integrity validation', () {
      test('should validate data integrity successfully', () async {
        // Arrange
        const testKey = 'test_key';

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async => 'valid_encrypted_data');

        // Act
        final result = await secureStorageService.validateDataIntegrity(testKey);

        // Assert
        expect(result, isTrue);
        verify(mockLogger).info('Sensitive data decrypted and retrieved for key: $testKey');
      });

      test('should return false for invalid data', () async {
        // Arrange
        const testKey = 'test_key';

        when(() => mockSecureStorage.read(
          key: testKey,
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenThrow(Exception('Data corrupted'));

        // Act
        final result = await secureStorageService.validateDataIntegrity(testKey);

        // Assert
        expect(result, isFalse);
        verify(mockLogger).error(
          'Data integrity validation failed for key: $testKey',
          any(named: 'error'),
        );
      });
    });

    group('storage info', () {
      test('should return correct storage information', () {
        // Act
        final storageInfo = secureStorageService.getStorageInfo();

        // Assert
        expect(storageInfo['secureStorageAvailable'], isA<bool>());
        expect(storageInfo['platform'], isA<String>());
        expect(storageInfo['encryptionEnabled'], isTrue);
        expect(storageInfo['encryptionAlgorithm'], equals('AES-256-GCM'));
        expect(storageInfo['keyCipherAlgorithm'], equals('RSA_ECB_OAEPwithSHA_256andMGF1Padding'));
        expect(storageInfo['storageCipherAlgorithm'], equals('AES_GCM_NoPadding'));
      });
    });

    group('platform detection', () {
      test('should detect mobile platform correctly', () {
        // Act
        final isMobile = secureStorageService.isSecureStorageAvailable;

        // Assert
        expect(isMobile, isA<bool>());
      });

      test('should log platform information', () {
        // Act
        secureStorageService.logPlatformInfo();

        // Assert
        verify(mockLogger).info(any<String>());
      });
    });

    group('clear operations', () {
      test('should clear all sensitive data', () async {
        // Arrange
        when(() => mockSecureStorage.deleteAll(
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async {});

        // Act
        await secureStorageService.clearAllSensitiveData();

        // Assert
        verify(() => mockSecureStorage.deleteAll(
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(mockLogger).info('All sensitive data cleared');
      });

      test('should clear all auth data', () async {
        // Arrange
        when(() => mockSecureStorage.delete(
          key: any(named: 'key'),
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).thenAnswer((_) async {});

        // Act
        await secureStorageService.clearAllAuthData();

        // Assert
        verify(() => mockSecureStorage.delete(
          key: 'bearer_token',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(() => mockSecureStorage.delete(
          key: 'refresh_token',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(() => mockSecureStorage.delete(
          key: 'user_data',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(() => mockSecureStorage.delete(
          key: 'session_data',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(() => mockSecureStorage.delete(
          key: 'api_key',
          aOptions: any(named: 'aOptions'),
          iOptions: any(named: 'iOptions'),
        )).called(1);
        verify(mockLogger).info('All auth data cleared from enhanced secure storage');
      });
    });
  });
}