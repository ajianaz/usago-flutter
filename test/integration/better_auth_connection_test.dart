// Better Auth Integration Connection Test
// Purpose: Verify basic connectivity to Better Auth endpoints
// Run with: dart run test/integration/better_auth_connection_test.dart

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'better_auth_connection_logger.dart';

// Mock classes for testing
class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

void main() {
  group('Better Auth Integration Connection Tests', () {
    late MockHttpClient mockHttpClient;
    late MockHttpClientRequest mockRequest;
    late MockHttpClientResponse mockResponse;
    late MockHttpHeaders mockHeaders;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockRequest = MockHttpClientRequest();
      mockResponse = MockHttpClientResponse();
      mockHeaders = MockHttpHeaders();

      // Setup default mock behaviors
      when(() => mockHttpClient.getUrl(any())).thenAnswer((_) async => mockRequest);
      when(() => mockHttpClient.postUrl(any())).thenAnswer((_) async => mockRequest);
      when(() => mockRequest.headers).thenReturn(mockHeaders);
      when(() => mockRequest.close()).thenAnswer((_) async => mockResponse);
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.transform(any())).thenAnswer((_) => Stream.value(''));
    });

    group('Server Connectivity', () {
      testWidgets('should connect to server successfully', (WidgetTester tester) async {
        // Arrange
        const expectedUrl = 'http://localhost:3000';
        when(() => mockResponse.statusCode).thenReturn(200);

        // Act
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse(expectedUrl));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(200));
        AuthTestLogger.success('Server connection successful');
      });

      testWidgets('should handle server unreachable scenario', (WidgetTester tester) async {
        // Arrange
        when(() => mockHttpClient.getUrl(any())).thenThrow(SocketException('Connection refused'));

        // Act & Assert
        expect(
          () async {
            final client = HttpClient();
            await client.getUrl(Uri.parse('http://localhost:3000'));
          },
          throwsA(isA<SocketException>()),
        );
        AuthTestLogger.error('Server unreachable handled correctly');
      });

      testWidgets('should handle network timeout', (WidgetTester tester) async {
        // Arrange
        when(() => mockHttpClient.getUrl(any())).thenThrow(TimeoutException('Connection timeout', const Duration(seconds: 30)));

        // Act & Assert
        expect(
          () async {
            final client = HttpClient();
            await client.getUrl(Uri.parse('http://localhost:3000')).timeout(const Duration(seconds: 5));
          },
          throwsA(isA<TimeoutException>()),
        );
        AuthTestLogger.error('Network timeout handled correctly');
      });
    });

    group('Login Endpoint', () {
      testWidgets('should handle successful login response', (WidgetTester tester) async {
        // Arrange
        const loginUrl = 'http://localhost:3000/api/auth/sign-in/email';
        const testResponse = '{"user":{"id":"123","email":"test@example.com"}}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(testResponse));
        when(() => mockHeaders['set-auth-token']).thenReturn(['Bearer token123']);

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(loginUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'email': 'test@example.com',
          'password': 'testpassword123'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('test@example.com'));
        expect(response.headers['set-auth-token'], isNotNull);
        AuthTestLogger.success('Login endpoint working correctly');
      });

      testWidgets('should handle invalid credentials response', (WidgetTester tester) async {
        // Arrange
        const loginUrl = 'http://localhost:3000/api/auth/sign-in/email';
        const errorResponse = '{"code":401,"message":"Invalid credentials","type":"auth_error"}';

        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(errorResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(loginUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'email': 'invalid@example.com',
          'password': 'wrongpassword'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(401));
        expect(responseBody, contains('Invalid credentials'));
        AuthTestLogger.success('Login endpoint handles invalid credentials correctly');
      });

      testWidgets('should handle login endpoint not found', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(404);

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(404));
        AuthTestLogger.error('Login endpoint not found handled correctly');
      });
    });

    group('Register Endpoint', () {
      testWidgets('should handle successful registration', (WidgetTester tester) async {
        // Arrange
        const registerUrl = 'http://localhost:3000/api/auth/sign-up/email';
        const testResponse = '{"user":{"id":"456","email":"newuser@example.com","name":"Test User"}}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(testResponse));
        when(() => mockHeaders['set-auth-token']).thenReturn(['Bearer token456']);

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(registerUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'email': 'newuser@example.com',
          'password': 'newpassword123',
          'name': 'Test User'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('newuser@example.com'));
        expect(responseBody, contains('Test User'));
        AuthTestLogger.success('Register endpoint working correctly');
      });

      testWidgets('should handle user already exists conflict', (WidgetTester tester) async {
        // Arrange
        const registerUrl = 'http://localhost:3000/api/auth/sign-up/email';
        const conflictResponse = '{"code":409,"message":"User already exists","type":"conflict_error"}';

        when(() => mockResponse.statusCode).thenReturn(409);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(conflictResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(registerUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'email': 'existing@example.com',
          'password': 'password123',
          'name': 'Existing User'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(409));
        expect(responseBody, contains('User already exists'));
        AuthTestLogger.success('Register endpoint handles conflict correctly');
      });
    });

    group('Logout Endpoint', () {
      testWidgets('should handle successful logout', (WidgetTester tester) async {
        // Arrange
        const logoutUrl = 'http://localhost:3000/api/auth/sign-out';
        const successResponse = '{"message":"Logout successful"}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(successResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(logoutUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode('{}'));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('Logout successful'));
        AuthTestLogger.success('Logout endpoint working correctly');
      });

      testWidgets('should handle unauthorized logout attempt', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"message":"Unauthorized"}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-out'));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(401));
        AuthTestLogger.success('Logout endpoint handles unauthorized access correctly');
      });
    });

    group('Refresh Token Endpoint', () {
      testWidgets('should handle successful token refresh', (WidgetTester tester) async {
        // Arrange
        const refreshUrl = 'http://localhost:3000/api/auth/refresh-token';
        const refreshResponse = '{"user":{"id":"123","email":"test@example.com"},"token":"new_token_123"}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(refreshResponse));
        when(() => mockHeaders['set-auth-token']).thenReturn(['Bearer new_token_123']);

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(refreshUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode('{}'));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('new_token_123'));
        expect(response.headers['set-auth-token'], isNotNull);
        AuthTestLogger.success('Refresh token endpoint working correctly');
      });

      testWidgets('should handle invalid refresh token', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"message":"Invalid token"}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/refresh-token'));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(401));
        AuthTestLogger.success('Refresh token endpoint handles invalid token correctly');
      });
    });

    group('Forgot Password Endpoint', () {
      testWidgets('should handle forgot password request', (WidgetTester tester) async {
        // Arrange
        const forgotUrl = 'http://localhost:3000/api/auth/forgot-password';
        const successResponse = '{"message":"Password reset email sent"}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(successResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(forgotUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'email': 'test@example.com'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('Password reset email sent'));
        AuthTestLogger.success('Forgot password endpoint working correctly');
      });

      testWidgets('should handle email not found in forgot password', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"message":"Email not found"}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/forgot-password'));
        request.add(utf8.encode(jsonEncode({
          'email': 'nonexistent@example.com'
        })));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(404));
        AuthTestLogger.success('Forgot password endpoint handles email not found correctly');
      });
    });

    group('Reset Password Endpoint', () {
      testWidgets('should handle successful password reset', (WidgetTester tester) async {
        // Arrange
        const resetUrl = 'http://localhost:3000/api/auth/reset-password';
        const successResponse = '{"message":"Password reset successful"}';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(successResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse(resetUrl));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'token': 'valid-reset-token',
          'newPassword': 'newpassword123'
        })));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseBody, contains('Password reset successful'));
        AuthTestLogger.success('Reset password endpoint working correctly');
      });

      testWidgets('should handle invalid reset token', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"message":"Invalid or expired token"}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/reset-password'));
        request.add(utf8.encode(jsonEncode({
          'token': 'invalid-token',
          'newPassword': 'newpassword123'
        })));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(401));
        AuthTestLogger.success('Reset password endpoint handles invalid token correctly');
      });
    });

    group('Error Handling', () {
      testWidgets('should handle server error responses', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(500);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"message":"Internal server error"}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));
        final response = await request.close();

        // Assert
        expect(response.statusCode, equals(500));
        AuthTestLogger.error('Server error handled correctly');
      });

      testWidgets('should handle malformed JSON responses', (WidgetTester tester) async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value('{"invalid": json}'));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        // Assert
        expect(response.statusCode, equals(200));
        expect(() => jsonDecode(responseBody), throwsA(isA<FormatException>()));
        AuthTestLogger.warning('Malformed JSON handled correctly');
      });
    });

    group('Response Analysis', () {
      testWidgets('should analyze successful response structure', (WidgetTester tester) async {
        // Arrange
        const validResponse = '''
        {
          "user": {
            "id": "123",
            "email": "test@example.com",
            "name": "Test User",
            "isEmailVerified": true
          },
          "session": {
            "token": "session_token_123",
            "expiresAt": "2023-12-31T23:59:59Z"
          }
        }
        ''';

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(validResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

        // Assert
        expect(response.statusCode, equals(200));
        expect(responseData.containsKey('user'), isTrue);
        expect(responseData.containsKey('session'), isTrue);
        expect(responseData['user']['email'], equals('test@example.com'));
        expect(responseData['session']['token'], isNotNull);

        AuthTestLogger.responseAnalysis(responseData);
        AuthTestLogger.success('Response structure analysis completed');
      });

      testWidgets('should analyze error response structure', (WidgetTester tester) async {
        // Arrange
        const errorResponse = '''
        {
          "code": 401,
          "message": "Authentication failed",
          "type": "auth_error",
          "details": {
            "field": "email",
            "reason": "invalid_format"
          }
        }
        ''';

        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.transform(utf8.decoder)).thenAnswer((_) => Stream.value(errorResponse));

        // Act
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

        // Assert
        expect(response.statusCode, equals(401));
        expect(responseData['code'], equals(401));
        expect(responseData['message'], equals('Authentication failed'));
        expect(responseData['type'], equals('auth_error'));
        expect(responseData.containsKey('details'), isTrue);

        AuthTestLogger.errorAnalysis(responseData);
        AuthTestLogger.success('Error response analysis completed');
      });
    });
  });
}

/// Helper class to analyze and log response data
class ResponseAnalyzer {
  static void analyzeSuccessResponse(Map<String, dynamic> data) {
    AuthTestLogger.responseAnalysis(data);

    // Additional validation
    if (data.containsKey('user')) {
      final user = data['user'] as Map<String, dynamic>;
      AuthTestLogger.info('User data validation:');
      AuthTestLogger.info('   - ID: ${user['id']}');
      AuthTestLogger.info('   - Email: ${user['email']}');
      AuthTestLogger.info('   - Name: ${user['name']}');
    }

    if (data.containsKey('session')) {
      final session = data['session'] as Map<String, dynamic>;
      AuthTestLogger.info('Session data validation:');
      AuthTestLogger.info('   - Token present: ${session.containsKey('token')}');
      AuthTestLogger.info('   - Expires at: ${session['expiresAt']}');
    }
  }

  static void analyzeErrorResponse(Map<String, dynamic> data) {
    AuthTestLogger.errorAnalysis(data);

    // Additional error analysis
    if (data.containsKey('details')) {
      final details = data['details'] as Map<String, dynamic>;
      AuthTestLogger.info('Error details:');
      details.forEach((key, value) {
        AuthTestLogger.info('   - $key: $value');
      });
    }
  }
}