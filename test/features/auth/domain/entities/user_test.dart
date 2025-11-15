import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';

/// Test suite for User entity
/// Tests the User domain entity functionality
void main() {
  group('User Entity Tests', () {
    test('should create User with required fields', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');
      final updatedAt = DateTime.parse('2023-12-01T00:00:00.000Z');
      final lastLoginAt = DateTime.parse('2023-12-15T10:30:00.000Z');

      // Act
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastLoginAt: lastLoginAt,
      );

      // Assert
      expect(user.id, equals('test-id'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
      expect(user.profilePicture, equals('https://example.com/avatar.jpg'));
      expect(user.isEmailVerified, isTrue);
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
      expect(user.lastLoginAt, equals(lastLoginAt));
    });

    test('should create User with optional fields null', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');

      // Act
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: createdAt,
      );

      // Assert
      expect(user.id, equals('test-id'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
      expect(user.profilePicture, isNull);
      expect(user.isEmailVerified, isTrue);
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, isNull);
      expect(user.lastLoginAt, isNull);
    });

    test('should convert User to JSON', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');
      final updatedAt = DateTime.parse('2023-12-01T00:00:00.000Z');
      final lastLoginAt = DateTime.parse('2023-12-15T10:30:00.000Z');

      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastLoginAt: lastLoginAt,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], equals('test-id'));
      expect(json['email'], equals('test@example.com'));
      expect(json['name'], equals('Test User'));
      expect(json['profilePicture'], equals('https://example.com/avatar.jpg'));
      expect(json['isEmailVerified'], isTrue);
      expect(json['createdAt'], equals(createdAt.toIso8601String()));
      expect(json['updatedAt'], equals(updatedAt.toIso8601String()));
      expect(json['lastLoginAt'], equals(lastLoginAt.toIso8601String()));
    });

    test('should create User from JSON', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'profilePicture': 'https://example.com/avatar.jpg',
        'isEmailVerified': true,
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-12-01T00:00:00.000Z',
        'lastLoginAt': '2023-12-15T10:30:00.000Z',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, equals('test-id'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
      expect(user.profilePicture, equals('https://example.com/avatar.jpg'));
      expect(user.isEmailVerified, isTrue);
      expect(user.createdAt, equals(DateTime.parse('2023-01-01T00:00:00.000Z')));
      expect(user.updatedAt, equals(DateTime.parse('2023-12-01T00:00:00.000Z')));
      expect(user.lastLoginAt, equals(DateTime.parse('2023-12-15T10:30:00.000Z')));
    });

    test('should copy User with modified fields', () {
      // Arrange
      final originalUser = User(
        id: 'original-id',
        email: 'original@example.com',
        name: 'Original User',
        isEmailVerified: false,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Act
      final copiedUser = originalUser.copyWith(
        id: 'new-id',
        email: 'new@example.com',
        name: 'New User',
        isEmailVerified: true,
      );

      // Assert
      expect(copiedUser.id, equals('new-id'));
      expect(copiedUser.email, equals('new@example.com'));
      expect(copiedUser.name, equals('New User'));
      expect(copiedUser.isEmailVerified, isTrue);
      expect(copiedUser.createdAt, equals(originalUser.createdAt));
    });

    test('should return correct display name', () {
      // Test with name
      final userWithName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'John Doe',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithName.displayName, equals('John Doe'));

      // Test with empty name (should return email)
      final userWithEmptyName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithEmptyName.displayName, equals('test@example.com'));
    });

    test('should return correct initials', () {
      // Test with first and last name
      final userWithFullName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'John Doe',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithFullName.initials, equals('JD'));

      // Test with single name
      final userWithSingleName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'John',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithSingleName.initials, equals('J'));

      // Test with empty name (should return email initial)
      final userWithEmptyName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithEmptyName.initials, equals('T'));
    });

    test('should create empty User', () {
      // Act
      final emptyUser = User.empty();

      // Assert
      expect(emptyUser.id, isEmpty);
      expect(emptyUser.email, isEmpty);
      expect(emptyUser.name, isEmpty);
      expect(emptyUser.isEmailVerified, isFalse);
      expect(emptyUser.profilePicture, isNull);
    });

    test('should check if user has profile picture', () {
      // Test with profile picture
      final userWithPic = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithPic.hasProfilePicture, isTrue);

      // Test without profile picture
      final userWithoutPic = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithoutPic.hasProfilePicture, isFalse);

      // Test with empty profile picture
      final userWithEmptyPic = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithEmptyPic.hasProfilePicture, isFalse);
    });

    test('should format join date correctly', () {
      // Arrange
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-12-25T10:30:00.000Z'),
      );

      // Act
      final joinDate = user.joinDateFormatted;

      // Assert
      expect(joinDate, equals('25 Dec 2023'));
    });

    test('should check if user is new', () {
      // Test new user (less than 7 days)
      final newUser = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'New User',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(newUser.isNewUser, isTrue);

      // Test old user (more than 7 days)
      final oldUser = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Old User',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      );
      expect(oldUser.isNewUser, isFalse);
    });

    test('should check if user is active', () {
      // Test active user (logged in within 30 days)
      final activeUser = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Active User',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      );
      expect(activeUser.isActive, isTrue);

      // Test inactive user (last login more than 30 days ago)
      final inactiveUser = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Inactive User',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastLoginAt: DateTime.now().subtract(const Duration(days: 35)),
      );
      expect(inactiveUser.isActive, isFalse);

      // Test user with no last login
      final userWithNoLastLogin = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'No Login User',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      expect(userWithNoLastLogin.isActive, isFalse);
    });

    test('should implement equality', () {
      // Arrange
      final user1 = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final user2 = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final user3 = User(
        id: 'different-id',
        email: 'different@example.com',
        name: 'Different User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should have correct toString', () {
      // Arrange
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(user.toString(), equals('User(id: test-id, email: test@example.com, name: Test User)'));
    });

    test('should handle edge cases for initials', () {
      // Test with whitespace-only name
      final userWithWhitespaceName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: '   ',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithWhitespaceName.initials, equals('T'));

      // Test with empty email
      final userWithEmptyEmail = User(
        id: 'test-id',
        email: '',
        name: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithEmptyEmail.initials, equals('?'));

      // Test with name containing multiple spaces
      final userWithMultipleSpaces = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'John   Doe',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithMultipleSpaces.initials, equals('JD'));
    });

    test('should handle edge cases for display name', () {
      // Test with whitespace-only name
      final userWithWhitespaceName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: '   ',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithWhitespaceName.displayName, equals('test@example.com'));

      // Test with name containing only spaces
      final userWithSpacesName = User(
        id: 'test-id',
        email: 'test@example.com',
        name: '     ',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithSpacesName.displayName, equals('test@example.com'));
    });

    test('should handle edge cases for JSON serialization', () {
      // Test with null optional fields
      final userWithNulls = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = userWithNulls.toJson();
      expect(json['profilePicture'], isNull);
      expect(json['updatedAt'], isNull);
      expect(json['lastLoginAt'], isNull);

      // Test JSON parsing with missing optional fields
      final jsonWithMissingFields = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'isEmailVerified': true,
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      final userFromJson = User.fromJson(jsonWithMissingFields);
      expect(userFromJson.profilePicture, isNull);
      expect(userFromJson.updatedAt, isNull);
      expect(userFromJson.lastLoginAt, isNull);
      expect(userFromJson.isEmailVerified, isTrue);
    });

    test('should handle edge cases for copyWith', () {
      // Test copyWith with all null parameters (should return same object)
      final originalUser = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final copiedUser = originalUser.copyWith();
      expect(copiedUser.id, equals(originalUser.id));
      expect(copiedUser.email, equals(originalUser.email));
      expect(copiedUser.name, equals(originalUser.name));
      expect(copiedUser.isEmailVerified, equals(originalUser.isEmailVerified));
      expect(copiedUser.createdAt, equals(originalUser.createdAt));
    });

    test('should handle edge cases for profile picture validation', () {
      // Test with whitespace-only profile picture
      final userWithWhitespacePic = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: '   ',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithWhitespacePic.hasProfilePicture, isFalse);

      // Test with empty string profile picture
      final userWithEmptyPic = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: '',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userWithEmptyPic.hasProfilePicture, isFalse);
    });
  });
}