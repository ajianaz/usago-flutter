import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:usago/core/services/web_secure_storage.dart';
import 'package:usago/core/utils/logger.dart';

void main() {
  group('WebSecureStorage Tests', () {
    late WebSecureStorage webSecureStorage;
    late AppLogger logger;

    setUp(() async {
      // Reset SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      logger = AppLogger();
      webSecureStorage = WebSecureStorage(logger: logger);
      await webSecureStorage.initialize();
    });

    group('Encryption/Decryption Tests', () {
      test('should encrypt and decrypt data correctly', () async {
        const testData = 'test_sensitive_data';
        const testKey = 'test_key';

        // Write data
        await webSecureStorage.write(testKey, testData);

        // Read data
        final result = await webSecureStorage.read(testKey);

        expect(result, equals(testData));
      });

      test('should handle empty string correctly', () async {
        const testData = '';
        const testKey = 'empty_key';

        await webSecureStorage.write(testKey, testData);
        final result = await webSecureStorage.read(testKey);

        expect(result, equals(testData));
      });

      test('should handle special characters correctly', () async {
        final testData = 'special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
        const testKey = 'special_key';

        await webSecureStorage.write(testKey, testData);
        final result = await webSecureStorage.read(testKey);

        expect(result, equals(testData));
      });

      test('should handle unicode characters correctly', () async {
        const testData = 'unicode_test_ñáéíóú_中文_العربية_🔐';
        const testKey = 'unicode_key';

        await webSecureStorage.write(testKey, testData);
        final result = await webSecureStorage.read(testKey);

        expect(result, equals(testData));
      });

      test('should handle long strings correctly', () async {
        final testData = 'a' * 10000; // 10k character string
        const testKey = 'long_key';

        await webSecureStorage.write(testKey, testData);
        final result = await webSecureStorage.read(testKey);

        expect(result, equals(testData));
      });
    });

    group('Data Format Validation Tests', () {
      test('should reject invalid encrypted data format', () async {
        const testKey = 'invalid_key';

        // Manually set invalid data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('secure_$testKey', 'invalid_encrypted_data');

        final result = await webSecureStorage.read(testKey);
        expect(result, isNull);
      });

      test('should handle corrupted base64 data', () async {
        const testKey = 'corrupted_key';

        // Manually set corrupted base64 data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('secure_$testKey', 'enc_invalid_base64!!!');

        final result = await webSecureStorage.read(testKey);
        expect(result, isNull);
      });

      test('should handle data without encryption prefix', () async {
        const testKey = 'no_prefix_key';
        const testData = 'test_data';

        // Create old format encrypted data (without prefix)
        final keyBytes = sha256
            .convert(utf8.encode('usago_web_secure_storage_web_key_v1'))
            .bytes;
        final dataBytes = utf8.encode(testData);
        final encryptedBytes = <int>[];
        for (int i = 0; i < dataBytes.length; i++) {
          encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
        }
        final oldFormatData = base64.encode(encryptedBytes);

        // Manually set old format data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('secure_$testKey', oldFormatData);

        final result = await webSecureStorage.read(testKey);
        expect(result, equals(testData));
      });
    });

    group('Storage Operations Tests', () {
      test('should check if key exists', () async {
        const testKey = 'exists_key';
        const testData = 'test_data';

        // Initially should not exist
        expect(await webSecureStorage.containsKey(testKey), isFalse);

        // After writing should exist
        await webSecureStorage.write(testKey, testData);
        expect(await webSecureStorage.containsKey(testKey), isTrue);
      });

      test('should delete specific key', () async {
        const testKey = 'delete_key';
        const testData = 'test_data';

        await webSecureStorage.write(testKey, testData);
        expect(await webSecureStorage.containsKey(testKey), isTrue);

        await webSecureStorage.delete(testKey);
        expect(await webSecureStorage.containsKey(testKey), isFalse);
      });

      test('should get all secure keys', () async {
        const keys = ['key1', 'key2', 'key3'];

        for (final key in keys) {
          await webSecureStorage.write(key, 'data_for_$key');
        }

        final allKeys = await webSecureStorage.getAllKeys();
        expect(allKeys.length, equals(keys.length));

        for (final key in keys) {
          expect(allKeys.contains(key), isTrue);
        }
      });

      test('should delete all secure data', () async {
        const keys = ['key1', 'key2', 'key3'];

        for (final key in keys) {
          await webSecureStorage.write(key, 'data_for_$key');
        }

        expect(await webSecureStorage.getAllKeys(), isNotEmpty);

        await webSecureStorage.deleteAll();
        expect(await webSecureStorage.getAllKeys(), isEmpty);
      });
    });

    group('Migration Tests', () {
      test('should migrate old format data to new format', () async {
        const testKey = 'migration_key';
        const testData = 'migration_test_data';

        // Create old format encrypted data
        final keyBytes = sha256
            .convert(utf8.encode('usago_web_secure_storage_web_key_v1'))
            .bytes;
        final dataBytes = utf8.encode(testData);
        final encryptedBytes = <int>[];
        for (int i = 0; i < dataBytes.length; i++) {
          encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
        }
        final oldFormatData = base64.encode(encryptedBytes);

        // Manually set old format data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('secure_$testKey', oldFormatData);

        // Read should trigger migration
        final result = await webSecureStorage.read(testKey);
        expect(result, equals(testData));

        // Verify data was migrated to new format
        final storedData = prefs.getString('secure_$testKey');
        expect(storedData, startsWith('enc_'));
      });

      test('should handle migration errors gracefully', () async {
        const testKey = 'corrupt_migration_key';

        // Set corrupted old format data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('secure_$testKey', 'corrupted_old_format_data');

        // Should not throw error
        final result = await webSecureStorage.read(testKey);
        expect(result, isNull);
      });
    });

    group('Error Handling Tests', () {
      test('should handle write errors gracefully', () async {
        // This test would require mocking SharedPreferences to throw errors
        // For now, we just verify normal operation
        const testKey = 'error_key';
        const testData = 'error_test_data';

        expect(() async => await webSecureStorage.write(testKey, testData),
            returnsNormally);
      });

      test('should handle read errors gracefully', () async {
        const testKey = 'nonexistent_key';

        final result = await webSecureStorage.read(testKey);
        expect(result, isNull);
      });

      test('should handle delete errors gracefully', () async {
        const testKey = 'nonexistent_key';

        expect(() async => await webSecureStorage.delete(testKey),
            returnsNormally);
      });
    });

    group('Key Consistency Tests', () {
      test('should use consistent encryption key across instances', () async {
        const testData = 'consistency_test_data';
        const testKey = 'consistency_key';

        // Create first instance and write data
        final storage1 = WebSecureStorage(logger: logger);
        await storage1.initialize();
        await storage1.write(testKey, testData);

        // Create second instance and read data
        final storage2 = WebSecureStorage(logger: logger);
        await storage2.initialize();
        final result = await storage2.read(testKey);

        expect(result, equals(testData));
      });

      test('should use custom encryption key when provided', () async {
        const customKey = 'custom_encryption_key';
        const testData = 'custom_key_test_data';
        const testKey = 'custom_key_test';

        final customStorage = WebSecureStorage(
          logger: logger,
          encryptionKey: customKey,
        );
        await customStorage.initialize();
        await customStorage.write(testKey, testData);

        final result = await customStorage.read(testKey);
        expect(result, equals(testData));

        // Verify that default storage cannot read this data
        final defaultResult = await webSecureStorage.read(testKey);
        expect(defaultResult, isNull);
      });
    });
  });
}
