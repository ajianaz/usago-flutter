import 'package:flutter_test/flutter_test.dart';
import 'package:usago/core/utils/log_sanitizer.dart';

void main() {
  group('LogSanitizer Tests', () {
    group('Sensitive Field Detection', () {
      test('should detect password fields', () {
        final testData = {
          'password': 'secret123',
          'user_password': 'userpass',
          'pwd': 'mypwd',
          'normal_field': 'normal_value',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['password'], '[REDACTED]');
        expect(sanitized['user_password'], '[REDACTED]');
        expect(sanitized['pwd'], '[REDACTED]');
        expect(sanitized['normal_field'], 'normal_value');
      });

      test('should detect token fields', () {
        final testData = {
          'token': 'secret_token_123',
          'access_token': 'access123',
          'authorization': 'Bearer token123',
          'api_key': 'api_key_123',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['token'], '[REDACTED]');
        expect(sanitized['access_token'], '[REDACTED]');
        expect(sanitized['authorization'], '[REDACTED]');
        expect(sanitized['api_key'], '[REDACTED]');
      });

      test('should detect credit card fields', () {
        final testData = {
          'credit_card': '4111-1111-1111-1111',
          'card_number': '4111111111111111',
          'cvv': '123',
          'normal_field': 'normal_value',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['credit_card'], '[REDACTED]');
        expect(sanitized['card_number'], '[REDACTED]');
        expect(sanitized['cvv'], '[REDACTED]');
        expect(sanitized['normal_field'], 'normal_value');
      });

      test('should detect email and phone fields', () {
        final testData = {
          'email': 'user@example.com',
          'phone': '555-123-4567',
          'phone_number': '5551234567',
          'normal_field': 'normal_value',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['email'], '[REDACTED]');
        expect(sanitized['phone'], '[REDACTED]');
        expect(sanitized['phone_number'], '[REDACTED]');
        expect(sanitized['normal_field'], 'normal_value');
      });
    });

    group('Pattern Detection', () {
      test('should detect credit card numbers in strings', () {
        final testString = 'My credit card is 4111-1111-1111-1111 and my CVV is 123';
        final sanitized = LogSanitizer.sanitizeString(testString);

        expect(sanitized, '[FILTERED]');
      });

      test('should detect JWT tokens', () {
        final testString = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        final sanitized = LogSanitizer.sanitizeString(testString);

        expect(sanitized, '[FILTERED]');
      });

      test('should detect email addresses', () {
        final testString = 'Contact us at support@example.com for help';
        final sanitized = LogSanitizer.sanitizeString(testString);

        expect(sanitized, '[FILTERED]');
      });

      test('should detect phone numbers', () {
        final testString = 'Call me at 555-123-4567 for details';
        final sanitized = LogSanitizer.sanitizeString(testString);

        expect(sanitized, '[FILTERED]');
      });

      test('should detect long alphanumeric strings (potential API keys)', () {
        final testString = 'API key: abcdef1234567890abcdef1234567890abcdef12';
        final sanitized = LogSanitizer.sanitizeString(testString);

        expect(sanitized, '[FILTERED]');
      });
    });

    group('Nested Data Structures', () {
      test('should sanitize nested maps', () {
        final testData = {
          'user': {
            'name': 'John Doe',
            'email': 'john@example.com',
            'password': 'secret123',
            'profile': {
              'phone': '555-123-4567',
              'address': '123 Main St',
            },
          },
          'api_key': 'secret_api_key',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['user']['name'], 'John Doe');
        expect(sanitized['user']['email'], '[REDACTED]');
        expect(sanitized['user']['password'], '[REDACTED]');
        expect(sanitized['user']['profile']['phone'], '[REDACTED]');
        expect(sanitized['user']['profile']['address'], '123 Main St');
        expect(sanitized['api_key'], '[REDACTED]');
      });

      test('should sanitize lists containing maps', () {
        final testData = {
          'users': [
            {
              'name': 'John',
              'email': 'john@example.com',
              'password': 'john123',
            },
            {
              'name': 'Jane',
              'email': 'jane@example.com',
              'password': 'jane123',
            },
          ],
          'normal_list': [1, 2, 3],
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['users'][0]['name'], 'John');
        expect(sanitized['users'][0]['email'], '[REDACTED]');
        expect(sanitized['users'][0]['password'], '[REDACTED]');
        expect(sanitized['users'][1]['name'], 'Jane');
        expect(sanitized['users'][1]['email'], '[REDACTED]');
        expect(sanitized['users'][1]['password'], '[REDACTED]');
        expect(sanitized['normal_list'], [1, 2, 3]);
      });

      test('should sanitize lists containing strings', () {
        final testData = {
          'items': [ // Use non-sensitive field name to test string sanitization
            'secret_token_1',
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
            'normal_string',
          ],
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['items'][0], '[FILTERED]');
        expect(sanitized['items'][1], '[FILTERED]');
        expect(sanitized['items'][2], 'normal_string');
      });
    });

    group('Header Sanitization', () {
      test('should sanitize sensitive headers', () {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer token123',
          'X-API-Key': 'secret_api_key',
          'Cookie': 'session=abc123',
          'User-Agent': 'Mozilla/5.0',
        };

        final sanitized = LogSanitizer.sanitizeHeaders(headers);

        expect(sanitized['Content-Type'], 'application/json');
        expect(sanitized['Authorization'], '[REDACTED]');
        expect(sanitized['X-API-Key'], '[REDACTED]');
        expect(sanitized['Cookie'], '[REDACTED]');
        expect(sanitized['User-Agent'], 'Mozilla/5.0');
      });
    });

    group('JSON String Sanitization', () {
      test('should sanitize JSON strings', () {
        final jsonString = '{"user": {"email": "test@example.com", "password": "secret123"}}';
        final sanitized = LogSanitizer.sanitizeJsonString(jsonString);

        expect(sanitized, contains('[REDACTED]'));
        expect(sanitized, contains('[REDACTED]'));
        expect(sanitized, isNot(contains('test@example.com')));
        expect(sanitized, isNot(contains('secret123')));
      });

      test('should handle invalid JSON gracefully', () {
        final invalidJson = 'This is not valid JSON with email test@example.com';
        final sanitized = LogSanitizer.sanitizeJsonString(invalidJson);

        expect(sanitized, '[FILTERED]');
      });
    });

    group('Custom Sanitization Rules', () {
      test('should respect custom sensitive fields', () {
        final testData = {
          'custom_field': 'sensitive_value',
          'email': 'test@example.com',
          'normal_field': 'normal_value',
        };

        final sanitized = LogSanitizer.sanitizeWithCustomRules(
          testData,
          additionalSensitiveFields: ['custom_field'],
          sanitizeEmails: false, // Don't sanitize emails
        );

        expect(sanitized['custom_field'], '[REDACTED]');
        expect(sanitized['email'], 'test@example.com'); // Not sanitized
        expect(sanitized['normal_field'], 'normal_value');
      });

      test('should respect custom patterns', () {
        final testData = {
          'custom_data': 'CUSTOM_PATTERN_12345',
          'normal_data': 'normal_value',
        };

        final customPattern = RegExp(r'CUSTOM_PATTERN_\d+');
        final sanitized = LogSanitizer.sanitizeWithCustomRules(
          testData,
          additionalPatterns: [customPattern],
        );

        expect(sanitized['custom_data'], '[FILTERED]');
        expect(sanitized['normal_data'], 'normal_value');
      });
    });

    group('Edge Cases', () {
      test('should handle null and empty data', () {
        expect(LogSanitizer.sanitizeMap(null), {});
        expect(LogSanitizer.sanitizeMap({}), {});
        expect(LogSanitizer.sanitizeHeaders(null), {});
        expect(LogSanitizer.sanitizeHeaders({}), {});
        expect(LogSanitizer.sanitizeString(''), '');
      });

      test('should handle mixed data types', () {
        final testData = {
          'string_field': 'normal_string',
          'int_field': 123,
          'double_field': 123.45,
          'bool_field': true,
          'null_field': null,
          'list_field': [1, 2, 3],
          'password': 'secret123',
        };

        final sanitized = LogSanitizer.sanitizeMap(testData);

        expect(sanitized['string_field'], 'normal_string');
        expect(sanitized['int_field'], 123);
        expect(sanitized['double_field'], 123.45);
        expect(sanitized['bool_field'], true);
        expect(sanitized['null_field'], null);
        expect(sanitized['list_field'], [1, 2, 3]);
        expect(sanitized['password'], '[REDACTED]');
      });
    });
  });
}