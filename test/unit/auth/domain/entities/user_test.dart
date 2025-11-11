import 'package:flutter_test/flutter_test.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import '../../../../fixtures/auth_fixtures.dart';

void main() {
  group('User Entity', () {
    test('should create User with all required fields', () {
      // Act
      final user = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Assert
      expect(user.id, AuthFixtures.testUserId);
      expect(user.email, AuthFixtures.testUserEmail);
      expect(user.name, AuthFixtures.testUserName);
      expect(user.isEmailVerified, true);
      expect(user.createdAt, AuthFixtures.testCreatedAt);
      expect(user.profilePicture, null);
      expect(user.updatedAt, null);
      expect(user.lastLoginAt, null);
    });

    test('should create User with all fields including optional ones', () {
      // Act
      final user = AuthFixtures.testUser;

      // Assert
      expect(user.id, AuthFixtures.testUserId);
      expect(user.email, AuthFixtures.testUserEmail);
      expect(user.name, AuthFixtures.testUserName);
      expect(user.profilePicture, AuthFixtures.testUserProfilePicture);
      expect(user.isEmailVerified, true);
      expect(user.createdAt, AuthFixtures.testCreatedAt);
      expect(user.updatedAt, AuthFixtures.testUpdatedAt);
      expect(user.lastLoginAt, AuthFixtures.testLastLoginAt);
    });

    test('should convert User to JSON correctly', () {
      // Act
      final json = AuthFixtures.testUser.toJson();

      // Assert
      expect(json, AuthFixtures.testUserJson);
    });

    test('should create User from JSON correctly', () {
      // Act
      final user = User.fromJson(AuthFixtures.testUserJson);

      // Assert
      expect(user.id, AuthFixtures.testUserId);
      expect(user.email, AuthFixtures.testUserEmail);
      expect(user.name, AuthFixtures.testUserName);
      expect(user.profilePicture, AuthFixtures.testUserProfilePicture);
      expect(user.isEmailVerified, true);
      expect(user.createdAt, AuthFixtures.testCreatedAt);
      expect(user.updatedAt, AuthFixtures.testUpdatedAt);
      expect(user.lastLoginAt, AuthFixtures.testLastLoginAt);
    });

    test('should create User from JSON without optional fields', () {
      // Act
      final user = User.fromJson(AuthFixtures.testUserJsonWithoutOptional);

      // Assert
      expect(user.id, AuthFixtures.testUserId);
      expect(user.email, AuthFixtures.testUserEmail);
      expect(user.name, AuthFixtures.testUserName);
      expect(user.profilePicture, null);
      expect(user.isEmailVerified, false);
      expect(user.createdAt, AuthFixtures.testCreatedAt);
      expect(user.updatedAt, null);
      expect(user.lastLoginAt, null);
    });

    test('should copy User with modified fields', () {
      // Arrange
      final originalUser = AuthFixtures.testUser;
      const newEmail = 'newemail@example.com';

      // Act
      final copiedUser = originalUser.copyWith(email: newEmail);

      // Assert
      expect(copiedUser.id, originalUser.id);
      expect(copiedUser.email, newEmail);
      expect(copiedUser.name, originalUser.name);
      expect(copiedUser.profilePicture, originalUser.profilePicture);
      expect(copiedUser.isEmailVerified, originalUser.isEmailVerified);
      expect(copiedUser.createdAt, originalUser.createdAt);
      expect(copiedUser.updatedAt, originalUser.updatedAt);
      expect(copiedUser.lastLoginAt, originalUser.lastLoginAt);
    });

    test('should return displayName correctly when name is not empty', () {
      // Act
      final displayName = AuthFixtures.testUser.displayName;

      // Assert
      expect(displayName, AuthFixtures.testUserName);
    });

    test('should return email as displayName when name is empty', () {
      // Arrange
      final user = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: '',
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Act
      final displayName = user.displayName;

      // Assert
      expect(displayName, AuthFixtures.testUserEmail);
    });

    test('should return initials correctly for full name', () {
      // Act
      final initials = AuthFixtures.testUser.initials;

      // Assert
      expect(initials, 'TU');
    });

    test('should return first letter initial for single name', () {
      // Arrange
      final user = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: 'John',
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Act
      final initials = user.initials;

      // Assert
      expect(initials, 'J');
    });

    test('should return email initial when name is empty', () {
      // Arrange
      final user = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: '',
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Act
      final initials = user.initials;

      // Assert
      expect(initials, 'T');
    });

    test('should create empty user correctly', () {
      // Act
      final emptyUser = User.empty();

      // Assert
      expect(emptyUser.id, '');
      expect(emptyUser.email, '');
      expect(emptyUser.name, '');
      expect(emptyUser.isEmailVerified, false);
      expect(emptyUser.createdAt, isA<DateTime>());
      expect(emptyUser.profilePicture, null);
      expect(emptyUser.updatedAt, null);
      expect(emptyUser.lastLoginAt, null);
    });

    test('should check hasProfilePicture correctly', () {
      // Test with profile picture
      expect(AuthFixtures.testUser.hasProfilePicture, true);

      // Test without profile picture
      expect(AuthFixtures.testUserWithoutOptional.hasProfilePicture, false);

      // Test with empty profile picture
      final userWithEmptyProfilePicture = AuthFixtures.testUser.copyWith(
        profilePicture: '',
      );
      expect(userWithEmptyProfilePicture.hasProfilePicture, false);
    });

    test('should format join date correctly', () {
      // Act
      final joinDateFormatted = AuthFixtures.testUser.joinDateFormatted;

      // Assert
      expect(joinDateFormatted, '01 Jan 2023');
    });

    test('should check if user is new correctly', () {
      // Arrange - user created less than 7 days ago
      final recentUser = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      );

      // Arrange - user created more than 7 days ago
      final oldUser = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      );

      // Assert
      expect(recentUser.isNewUser, true);
      expect(oldUser.isNewUser, false);
    });

    test('should check if user is active correctly', () {
      // Arrange - user logged in within last 30 days
      final activeUser = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      // Arrange - user logged in more than 30 days ago
      final inactiveUser = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 35)),
      );

      // Arrange - user never logged in
      final neverLoggedInUser = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Assert
      expect(activeUser.isActive, true);
      expect(inactiveUser.isActive, false);
      expect(neverLoggedInUser.isActive, false);
    });

    test('should implement equality correctly', () {
      // Arrange
      final user1 = AuthFixtures.testUser;
      final user2 = AuthFixtures.testUser;
      final user3 = AuthFixtures.testUser.copyWith(email: 'different@example.com');

      // Assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should have correct toString implementation', () {
      // Act
      final toString = AuthFixtures.testUser.toString();

      // Assert
      expect(toString, 'User(id: ${AuthFixtures.testUserId}, email: ${AuthFixtures.testUserEmail}, name: ${AuthFixtures.testUserName})');
    });
  });
}