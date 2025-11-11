// Mock Test Utilities
// Purpose: Collection of utility functions for creating and configuring mock objects
// Follows Flutter development guidelines for test organization

import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import '../fixtures/auth_fixtures.dart';
import 'mock_config.dart';

/// Mock Test Utilities
///
/// Collection of utility functions for creating and configuring
/// mock objects in integration tests.
class MockTestUtils {
  /// Create a mock JSON response
  static Map<String, dynamic> createJsonResponse({
    int statusCode = 200,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    final response = <String, dynamic>{
      'statusCode': statusCode,
    };

    if (body != null) {
      response.addAll(body);
    }

    if (headers != null) {
      response['headers'] = headers;
    }

    return response;
  }

  /// Create a mock error response
  static Map<String, dynamic> createErrorResponse({
    int statusCode = 400,
    String message = 'Bad Request',
    String type = 'error',
  }) {
    return createJsonResponse(
      statusCode: statusCode,
      body: {
        'code': statusCode,
        'message': message,
        'type': type,
      },
    );
  }

  /// Create a mock success response with user data
  static Map<String, dynamic> createUserResponse({
    User? user,
    String? token,
  }) {
    return createJsonResponse(
      statusCode: 200,
      body: {
        'user': user != null ? {
          'id': user.id,
          'email': user.email,
          'name': user.name,
          'isEmailVerified': user.isEmailVerified,
          'createdAt': user.createdAt.toIso8601String(),
        } : null,
        'token': token,
      },
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );
  }

  /// Simulate network delay
  static Future<void> simulateDelay({Duration? duration}) {
    return Future.delayed(duration ?? MockConfig.mediumDelay);
  }

  /// Create mock auth headers
  static Map<String, String> createAuthHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Create mock JSON headers
  static Map<String, String> createJsonHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Create test user with custom properties
  static User createTestUser({
    String id = 'test-user-123',
    String email = 'test@example.com',
    String name = 'Test User',
    String? profilePicture,
    bool isEmailVerified = true,
  }) {
    return AuthFixtures.testUser;
  }

  /// Verify mock was called with specific parameters
  static void verifyMockCall<T extends Mock>(
    T mock,
    String methodName,
    List<dynamic> expectedArgs,
  ) {
    verify(() => mock.noSuchMethod(
      Invocation.method(
        Symbol(methodName),
        expectedArgs,
      ),
    )).called(1);
  }

  /// Verify mock was never called
  static void verifyMockNeverCalled<T extends Mock>(T mock) {
    verifyNever(() => mock.noSuchMethod(Invocation.method(#noSuchMethod, [])));
  }

  /// Reset all mocks
  static void resetAllMocks(List<Mock> mocks) {
    for (final mock in mocks) {
      reset(mock);
    }
  }

  /// Create mock stream with specific values
  static Stream<T> createMockStream<T>(List<T> values) {
    return Stream.fromIterable(values);
  }

  /// Create mock stream that emits error
  static Stream<T> createErrorStream<T>(Object error) {
    return Stream.error(error);
  }

  /// Create mock stream that completes without value
  static Stream<T> createEmptyStream<T>() {
    return const Stream.empty();
  }

  /// Wait for async operation to complete
  static Future<void> waitForAsync({Duration? duration}) {
    return Future.delayed(duration ?? MockConfig.shortDelay);
  }

  /// Create mock future with value
  static Future<T> createMockFuture<T>(T value, {Duration? delay}) {
    return Future.delayed(delay ?? Duration.zero, () => value);
  }

  /// Create mock future that throws error
  static Future<T> createErrorFuture<T>(Object error, {Duration? delay}) {
    return Future.delayed(delay ?? Duration.zero, () => throw error);
  }

  /// Generate random test data
  static String generateRandomString({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return String.fromCharCodes(
      Iterable.generate(length, (i) => chars.codeUnitAt((random + i) % chars.length)),
    );
  }

  /// Generate random email
  static String generateRandomEmail() {
    final random = generateRandomString(length: 8);
    return '$random@example.com';
  }

  /// Generate random password
  static String generateRandomPassword({int length = 12}) {
    return generateRandomString(length: length);
  }

  /// Validate JSON structure
  static bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extract error message from response
  static String extractErrorMessage(Map<String, dynamic> response) {
    return response['message'] as String? ?? 'Unknown error';
  }

  /// Extract status code from response
  static int extractStatusCode(Map<String, dynamic> response) {
    return response['statusCode'] as int? ?? 500;
  }

  /// Check if response is successful
  static bool isSuccessfulResponse(Map<String, dynamic> response) {
    final statusCode = extractStatusCode(response);
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if response is error
  static bool isErrorResponse(Map<String, dynamic> response) {
    return !isSuccessfulResponse(response);
  }

  /// Create test scenario data
  static Map<String, dynamic> createTestScenario({
    required String name,
    required Map<String, dynamic> setup,
    required Map<String, dynamic> expected,
  }) {
    return {
      'name': name,
      'setup': setup,
      'expected': expected,
    };
  }

  /// Run test scenario
  static Future<void> runTestScenario(
    Map<String, dynamic> scenario,
    Future<void> Function() testFunction,
  ) async {
    print('Running scenario: ${scenario['name']}');
    print('Setup: ${scenario['setup']}');
    print('Expected: ${scenario['expected']}');

    await testFunction();

    print('Scenario completed: ${scenario['name']}');
  }

  /// Create performance test data
  static Map<String, dynamic> createPerformanceTest({
    required String name,
    required Duration maxDuration,
    required int minIterations,
  }) {
    return {
      'name': name,
      'maxDuration': maxDuration.inMilliseconds,
      'minIterations': minIterations,
      'startTime': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Measure performance
  static Future<Map<String, dynamic>> measurePerformance(
    Map<String, dynamic> testData,
    Future<void> Function() testFunction,
  ) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    final iterations = <int>[];

    for (int i = 0; i < testData['minIterations']; i++) {
      final iterationStart = DateTime.now().millisecondsSinceEpoch;
      await testFunction();
      final iterationEnd = DateTime.now().millisecondsSinceEpoch;
      iterations.add(iterationEnd - iterationStart);
    }

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final totalTime = endTime - startTime;
    final averageTime = iterations.reduce((a, b) => a + b) / iterations.length;

    return {
      'name': testData['name'],
      'totalTime': totalTime,
      'averageTime': averageTime,
      'iterations': iterations.length,
      'withinLimit': averageTime <= testData['maxDuration'],
    };
  }
}