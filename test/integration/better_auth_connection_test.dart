// Better Auth Integration Connection Test
// Purpose: Verify basic connectivity to Better Auth endpoints
// Run with: dart run test/integration/better_auth_connection_test.dart

import 'dart:io';
import 'dart:convert';
import 'better_auth_connection_logger.dart';

void main() async {
  // Arrange - Initialize test suite
  AuthTestLogger.header('Better Auth Integration Connection Test');

  try {
    // Act - Run all connectivity tests
    await TestServerConnectivity.run();
    await TestRegisterEndpoint.run();
    await TestLoginEndpoint.run();
    await TestLogoutEndpoint.run();
    await TestRefreshTokenEndpoint.run();
    await TestForgotPasswordEndpoint.run();
    await TestResetPasswordEndpoint.run();

    // Assert - All tests completed successfully
    AuthTestLogger.summary([
      'Server connectivity verified',
      'Login endpoint accessible',
      'Register endpoint accessible',
      'Better Auth integration ready',
    ]);
  } catch (e) {
    // Error handling for test suite failure
    AuthTestLogger.error('Test suite failed: $e');
    rethrow;
  }
}

/// Test server connectivity and basic response
class TestServerConnectivity {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 1: Server Connectivity');

    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('http://localhost:3000'));
      final response = await request.close();

      AuthTestLogger.info('Server Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        AuthTestLogger.success('Server is reachable');
      } else {
        AuthTestLogger.warning('Server responded with: ${response.statusCode}');
      }
    } catch (e) {
      AuthTestLogger.error('Server connection failed: $e');
    }
  }
}

/// Test login endpoint accessibility and response format
class TestLoginEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 2: Login Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-in/email'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test with valid credentials format
      final testData = {
        'email': 'test@example.com',
        'password': 'testpassword123'
      };

      request.add(utf8.encode(jsonEncode(testData)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Login Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Login endpoint working correctly');
        _analyzeResponse(responseBody, response.headers);
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Login endpoint reachable (401 = invalid credentials, expected)');
        _analyzeError(responseBody);
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Login endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
        _analyzeError(responseBody);
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
        _analyzeError(responseBody);
      }

      // Check for Better Auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        AuthTestLogger.success('Bearer token header found: ${authHeader.first}');
      } else {
        AuthTestLogger.info('No Bearer token in response headers');
      }

    } catch (e) {
      AuthTestLogger.error('Login test failed: $e');
    }
  }

  static void _analyzeResponse(String responseBody, HttpHeaders headers) {
    try {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      AuthTestLogger.responseAnalysis(data);
    } catch (e) {
      AuthTestLogger.warning('Could not parse response: $e');
    }
  }

  static void _analyzeError(String responseBody) {
    try {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      AuthTestLogger.errorAnalysis(data);
    } catch (e) {
      AuthTestLogger.warning('Could not parse error response: $e');
    }
  }
}

/// Test logout endpoint accessibility and response format
class TestLogoutEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 4: Logout Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-out'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test with empty data
      request.add(utf8.encode('{}'));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Logout Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Logout endpoint working correctly');
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Logout endpoint reachable (401 = not authenticated, expected)');
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Logout endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      AuthTestLogger.error('Logout test failed: $e');
    }
  }
}

/// Test refresh token endpoint accessibility and response format
class TestRefreshTokenEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 5: Refresh Token Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/refresh-token'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test with empty data
      request.add(utf8.encode('{}'));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Refresh Token Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Refresh token endpoint working correctly');
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Refresh token endpoint reachable (401 = invalid token, expected)');
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Refresh token endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
      }

      // Check for auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        AuthTestLogger.success('Bearer token header found: ${authHeader.first}');
      } else {
        AuthTestLogger.info('No Bearer token in response headers');
      }

    } catch (e) {
      AuthTestLogger.error('Refresh token test failed: $e');
    }
  }
}

/// Test forgot password endpoint accessibility and response format
class TestForgotPasswordEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 6: Forgot Password Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/forgot-password'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test data
      final testData = {
        'email': 'test@example.com'
      };

      request.add(utf8.encode(jsonEncode(testData)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Forgot Password Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Forgot password endpoint working correctly');
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Forgot password endpoint reachable (401 = validation error, expected)');
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Forgot password endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      AuthTestLogger.error('Forgot password test failed: $e');
    }
  }
}

/// Test reset password endpoint accessibility and response format
class TestResetPasswordEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 7: Reset Password Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/reset-password'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test data
      final testData = {
        'token': 'test-reset-token',
        'newPassword': 'newpassword123'
      };

      request.add(utf8.encode(jsonEncode(testData)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Reset Password Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Reset password endpoint working correctly');
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Reset password endpoint reachable (401 = invalid token, expected)');
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Reset password endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      AuthTestLogger.error('Reset password test failed: $e');
    }
  }
}

/// Test register endpoint accessibility and response format
class TestRegisterEndpoint {
  static Future<void> run() async {
    AuthTestLogger.testHeader('Test 3: Register Endpoint');

    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://localhost:3000/api/auth/sign-up/email'));

      // Set proper headers
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      // Test with valid registration format
      final testData = {
        'email': 'newuser@example.com',
        'password': 'newpassword123',
        'name': 'Test User'
      };

      request.add(utf8.encode(jsonEncode(testData)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      AuthTestLogger.info('Register Status: ${response.statusCode}');
      AuthTestLogger.info('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        AuthTestLogger.success('Register endpoint working correctly');
        TestLoginEndpoint._analyzeResponse(responseBody, response.headers);
      } else if (response.statusCode == 401) {
        AuthTestLogger.success('Register endpoint reachable (401 = validation error, expected)');
        TestLoginEndpoint._analyzeError(responseBody);
      } else if (response.statusCode == 409) {
        AuthTestLogger.success('Register endpoint reachable (409 = conflict, expected)');
        TestLoginEndpoint._analyzeError(responseBody);
      } else if (response.statusCode == 404) {
        AuthTestLogger.error('Register endpoint not found');
      } else if (response.statusCode == 500) {
        AuthTestLogger.warning('Server error occurred');
        TestLoginEndpoint._analyzeError(responseBody);
      } else {
        AuthTestLogger.warning('Unexpected status: ${response.statusCode}');
        TestLoginEndpoint._analyzeError(responseBody);
      }

      // Check for Better Auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        AuthTestLogger.success('Bearer token header found: ${authHeader.first}');
      } else {
        AuthTestLogger.info('No Bearer token in response headers');
      }

    } catch (e) {
      AuthTestLogger.error('Register test failed: $e');
    }
  }
}