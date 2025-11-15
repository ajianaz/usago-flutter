import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/core/errors/failure.dart';

/// Helper utilities for auth feature testing
class AuthTestHelpers {
  /// Create a test user with default values
  static User createTestUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String? profilePicture,
    bool isEmailVerified = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      profilePicture: profilePicture,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt ?? DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: updatedAt ?? DateTime.now().subtract(const Duration(days: 1)),
      lastLoginAt: lastLoginAt ?? DateTime.now().subtract(const Duration(hours: 2)),
    );
  }

  /// Create an unverified test user
  static User createUnverifiedTestUser({
    String id = 'unverified-user-id',
    String email = 'unverified@example.com',
    String name = 'Unverified User',
  }) {
    return createTestUser(
      id: id,
      email: email,
      name: name,
      isEmailVerified: false,
    );
  }

  /// Create a test user with profile picture
  static User createTestUserWithProfilePicture({
    String id = 'user-with-pic-id',
    String email = 'withpic@example.com',
    String name = 'User With Pic',
    String profilePicture = 'https://example.com/avatar.jpg',
  }) {
    return createTestUser(
      id: id,
      email: email,
      name: name,
      profilePicture: profilePicture,
    );
  }

  /// Create a newly registered user (less than 7 days)
  static User createNewTestUser({
    String id = 'new-user-id',
    String email = 'newuser@example.com',
    String name = 'New User',
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      isEmailVerified: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Create an inactive user (last login more than 30 days ago)
  static User createInactiveTestUser({
    String id = 'inactive-user-id',
    String email = 'inactive@example.com',
    String name = 'Inactive User',
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      isEmailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now().subtract(const Duration(days: 35)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 35)),
    );
  }

  /// Create a successful Either result with User
  static Either<Failure, User> createSuccessUserResult([User? user]) {
    return Right(user ?? createTestUser());
  }

  /// Create a failure Either result
  static Either<Failure, User> createFailureResult(Failure failure) {
    return Left(failure);
  }

  /// Create a void success result
  static Either<Failure, void> createSuccessVoidResult() {
    return const Right(null);
  }

  /// Create a void failure result
  static Either<Failure, void> createFailureVoidResult(Failure failure) {
    return Left(failure);
  }

  /// Create a nullable user success result
  static Either<Failure, User?> createNullableUserResult([User? user]) {
    return Right(user);
  }

  /// Verify mock interaction was called exactly once
  static void verifyCalledOnce(Mock mock) {
    verify(mock).called(1);
  }

  /// Verify mock interaction was never called
  static void verifyNeverCalled(Mock mock) {
    verifyNever(mock);
  }

  /// Verify mock interaction was called specific number of times
  static void verifyCalledTimes(Mock mock, int count) {
    verify(mock).called(count);
  }

  /// Create test email variations
  static List<String> get testEmails => [
    'valid@example.com',
    'user.name+tag@domain.co.uk',
    'user123@test-domain.com',
    'invalid-email',
    '',
    'no-at-symbol.com',
    '@missing-local.com',
    'missing-domain@',
  ];

  /// Create test password variations
  static List<String> get testPasswords => [
    'ValidPass123!',
    'short',
    'longenoughbutnonumber',
    'longenoughbutnouppercase',
    'longenoughbutnolowercase',
    '12345678',
    '',
  ];

  /// Create test name variations
  static List<String> get testNames => [
    'Valid Name',
    'John Doe',
    'A',
    'Very Long Name That Exceeds Normal Limits',
    '',
    '123',
    'Name with numbers 123',
    'Name-with-dashes',
  ];
}