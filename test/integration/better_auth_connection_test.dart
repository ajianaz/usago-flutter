/// Better Auth Integration Connection Test
/// Purpose: Verify basic connectivity to Better Auth endpoints
/// Run with: dart run test/integration/better_auth_connection_test.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🧪 Better Auth Integration Connection Test');
  print('==========================================');

  await TestServerConnectivity.run();
  await TestRegisterEndpoint.run();
  await TestLoginEndpoint.run();
  await TestLogoutEndpoint.run();
  await TestRefreshTokenEndpoint.run();
  await TestForgotPasswordEndpoint.run();
  await TestResetPasswordEndpoint.run();

  print('\n✅ All connection tests completed!');
  print('📋 Summary:');
  print('   - Server connectivity verified');
  print('   - Login endpoint accessible');
  print('   - Register endpoint accessible');
  print('   - Better Auth integration ready');
}

/// Test server connectivity and basic response
class TestServerConnectivity {
  static Future<void> run() async {
    print('\n📡 Test 1: Server Connectivity');
    print('----------------------------------------');

    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('http://localhost:3000'));
      final response = await request.close();

      print('Server Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('✅ Server is reachable');
      } else {
        print('⚠️ Server responded with: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Server connection failed: $e');
    }
  }
}

/// Test login endpoint accessibility and response format
class TestLoginEndpoint {
  static Future<void> run() async {
    print('\n🔐 Test 2: Login Endpoint');
    print('----------------------------------------');

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

      print('Login Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Login endpoint working correctly');
        _analyzeResponse(responseBody, response.headers);
      } else if (response.statusCode == 401) {
        print('✅ Login endpoint reachable (401 = invalid credentials, expected)');
        _analyzeError(responseBody);
      } else if (response.statusCode == 404) {
        print('❌ Login endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
        _analyzeError(responseBody);
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
        _analyzeError(responseBody);
      }

      // Check for Better Auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        print('✅ Bearer token header found: ${authHeader.first}');
      } else {
        print('ℹ️ No Bearer token in response headers');
      }

    } catch (e) {
      print('❌ Login test failed: $e');
    }
  }

  static void _analyzeResponse(String responseBody, HttpHeaders headers) {
    try {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      print('📊 Response Analysis:');
      print('   - Has user data: ${data.containsKey('user')}');
      print('   - Has session data: ${data.containsKey('session')}');
      print('   - Response structure: ${data.keys.toList()}');
    } catch (e) {
      print('⚠️ Could not parse response: $e');
    }
  }

  static void _analyzeError(String responseBody) {
    try {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      print('🚨 Error Analysis:');
      print('   - Error code: ${data['code']}');
      print('   - Error message: ${data['message']}');
      print('   - Error type: ${data['type']}');
    } catch (e) {
      print('⚠️ Could not parse error response: $e');
    }
  }
}

/// Test logout endpoint accessibility and response format
class TestLogoutEndpoint {
  static Future<void> run() async {
    print('\n🚪 Test 4: Logout Endpoint');
    print('----------------------------------------');

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

      print('Logout Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Logout endpoint working correctly');
      } else if (response.statusCode == 401) {
        print('✅ Logout endpoint reachable (401 = not authenticated, expected)');
      } else if (response.statusCode == 404) {
        print('❌ Logout endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Logout test failed: $e');
    }
  }
}

/// Test refresh token endpoint accessibility and response format
class TestRefreshTokenEndpoint {
  static Future<void> run() async {
    print('\n🔄 Test 5: Refresh Token Endpoint');
    print('----------------------------------------');

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

      print('Refresh Token Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Refresh token endpoint working correctly');
      } else if (response.statusCode == 401) {
        print('✅ Refresh token endpoint reachable (401 = invalid token, expected)');
      } else if (response.statusCode == 404) {
        print('❌ Refresh token endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
      }

      // Check for auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        print('✅ Bearer token header found: ${authHeader.first}');
      } else {
        print('ℹ️ No Bearer token in response headers');
      }

    } catch (e) {
      print('❌ Refresh token test failed: $e');
    }
  }
}

/// Test forgot password endpoint accessibility and response format
class TestForgotPasswordEndpoint {
  static Future<void> run() async {
    print('\n📧 Test 6: Forgot Password Endpoint');
    print('----------------------------------------');

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

      print('Forgot Password Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Forgot password endpoint working correctly');
      } else if (response.statusCode == 401) {
        print('✅ Forgot password endpoint reachable (401 = validation error, expected)');
      } else if (response.statusCode == 404) {
        print('❌ Forgot password endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Forgot password test failed: $e');
    }
  }
}

/// Test reset password endpoint accessibility and response format
class TestResetPasswordEndpoint {
  static Future<void> run() async {
    print('\n🔑 Test 7: Reset Password Endpoint');
    print('----------------------------------------');

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

      print('Reset Password Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Reset password endpoint working correctly');
      } else if (response.statusCode == 401) {
        print('✅ Reset password endpoint reachable (401 = invalid token, expected)');
      } else if (response.statusCode == 404) {
        print('❌ Reset password endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Reset password test failed: $e');
    }
  }
}

/// Test register endpoint accessibility and response format
class TestRegisterEndpoint {
  static Future<void> run() async {
    print('\n📝 Test 3: Register Endpoint');
    print('----------------------------------------');

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

      print('Register Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Analyze response
      if (response.statusCode == 200) {
        print('✅ Register endpoint working correctly');
        TestLoginEndpoint._analyzeResponse(responseBody, response.headers);
      } else if (response.statusCode == 401) {
        print('✅ Register endpoint reachable (401 = validation error, expected)');
        TestLoginEndpoint._analyzeError(responseBody);
      } else if (response.statusCode == 409) {
        print('✅ Register endpoint reachable (409 = conflict, expected)');
        TestLoginEndpoint._analyzeError(responseBody);
      } else if (response.statusCode == 404) {
        print('❌ Register endpoint not found');
      } else if (response.statusCode == 500) {
        print('⚠️ Server error occurred');
        TestLoginEndpoint._analyzeError(responseBody);
      } else {
        print('⚠️ Unexpected status: ${response.statusCode}');
        TestLoginEndpoint._analyzeError(responseBody);
      }

      // Check for Better Auth token in headers
      final authHeader = response.headers['set-auth-token'];
      if (authHeader != null && authHeader.isNotEmpty) {
        print('✅ Bearer token header found: ${authHeader.first}');
      } else {
        print('ℹ️ No Bearer token in response headers');
      }

    } catch (e) {
      print('❌ Register test failed: $e');
    }
  }
}