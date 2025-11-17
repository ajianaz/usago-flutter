import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/core/errors/failure.dart';
import '../../../../lib/core/errors/exceptions.dart';

/// Helper class for creating test data and utilities for authentication tests
class AuthTestHelpers {
  /// Creates a test user entity for testing purposes
  static User createTestUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String? profilePicture,
    bool isEmailVerified = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      profilePicture: profilePicture,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt ?? DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Creates a test failure for testing error scenarios
  static Failure createTestFailure({
    String message = 'Test failure',
    String code = 'TEST_ERROR',
    int? statusCode,
  }) {
    return ServerFailure(
      message: message,
      code: code,
      statusCode: statusCode ?? 400,
    );
  }

  /// Creates a test network failure
  static Failure createNetworkFailure({
    String message = 'Network error',
  }) {
    return NetworkFailure(message: message);
  }

  /// Creates a test validation failure
  static Failure createValidationFailure({
    String message = 'Validation error',
    String field = 'email',
  }) {
    return ValidationFailure(
      message: message,
      fieldErrors: field != null ? {field: message} : null,
    );
  }

  /// Creates a test authentication failure
  static Failure createAuthFailure({
    String message = 'Authentication failed',
  }) {
    return AuthFailure(
      message: message,
      type: AuthExceptionType.invalidCredentials,
    );
  }

  /// Creates a successful Either result with a test user
  static Either<Failure, User> createSuccessResult({User? user}) {
    return Right(user ?? createTestUser());
  }

  /// Creates a failure Either result
  static Either<Failure, User> createFailureResult({Failure? failure}) {
    return Left(failure ?? createTestFailure());
  }

  /// Creates a successful Either result with void
  static Either<Failure, void> createVoidSuccessResult() {
    return const Right(null);
  }

  /// Creates a failure Either result with void
  static Either<Failure, void> createVoidFailureResult({Failure? failure}) {
    return Left(failure ?? createTestFailure());
  }

  /// Creates a successful Either result with void (alias for createVoidSuccessResult)
  static Either<Failure, void> createSuccessVoidResult() {
    return const Right(null);
  }

  /// Valid test email
  static const String validEmail = 'test@example.com';

  /// Valid test password
  static const String validPassword = 'Password123!';

  /// Invalid test email
  static const String invalidEmail = 'invalid-email';

  /// Invalid test password (too short)
  static const String invalidPassword = '123';

  /// Test name
  static const String testName = 'Test User';

  /// Test profile picture URL
  static const String testProfilePicture = 'https://example.com/avatar.jpg';

  /// Test token
  static const String testToken = 'test-token-12345';

  /// Test reset token
  static const String testResetToken = 'reset-token-67890';
}