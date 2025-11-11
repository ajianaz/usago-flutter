import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Test helper utilities
class TestHelpers {
  /// Creates a mock response with delay
  static Future<T> delayedResponse<T>(T value, {int milliseconds = 100}) {
    return Future.delayed(
      Duration(milliseconds: milliseconds),
      () => value,
    );
  }

  /// Creates a mock error response with delay
  static Future<T> delayedError<T>(Exception error, {int milliseconds = 100}) {
    return Future.delayed(
      Duration(milliseconds: milliseconds),
      () => throw error,
    );
  }

  /// Sets up mocktail fallback values
  static void setUpMocktailFallbacks() {
    // Register fallback values for mocktail
    registerFallbackValue(DateTime.now());
  }
}

/// Custom test matcher for better error messages
Matcher throwsAWithMessage(String expectedMessage) {
  return throwsA(allOf(
    isA<Exception>(),
    predicate((Exception e) => e.toString().contains(expectedMessage)),
  ));
}