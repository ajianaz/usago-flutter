import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';

/// Test suite for UserModel
/// Tests the UserModel data transfer object functionality
void main() {
  group('UserModel Tests', () {
    test('should create UserModel with required fields', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');
      final updatedAt = DateTime.parse('2023-12-01T00:00:00.000Z');
      final lastLoginAt = DateTime.parse('2023-12-15T10:30:00.000Z');

      // Act
      final userModel = UserModel(
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
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.profilePicture, equals('https://example.com/avatar.jpg'));
      expect(userModel.isEmailVerified, isTrue);
      expect(userModel.createdAt, equals(createdAt));
      expect(userModel.updatedAt, equals(updatedAt));
      expect(userModel.lastLoginAt, equals(lastLoginAt));
    });

    test('should create UserModel with optional fields null', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');

      // Act
      final userModel = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: createdAt,
      );

      // Assert
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.profilePicture, isNull);
      expect(userModel.isEmailVerified, isTrue);
      expect(userModel.createdAt, equals(createdAt));
      expect(userModel.updatedAt, isNull);
      expect(userModel.lastLoginAt, isNull);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');
      final updatedAt = DateTime.parse('2023-12-01T00:00:00.000Z');
      final lastLoginAt = DateTime.parse('2023-12-15T10:30:00.000Z');

      final userModel = UserModel(
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
      final json = userModel.toJson();

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

    test('should create UserModel from JSON', () {
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
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.profilePicture, equals('https://example.com/avatar.jpg'));
      expect(userModel.isEmailVerified, isTrue);
      expect(userModel.createdAt, equals(DateTime.parse('2023-01-01T00:00:00.000Z')));
      expect(userModel.updatedAt, equals(DateTime.parse('2023-12-01T00:00:00.000Z')));
      expect(userModel.lastLoginAt, equals(DateTime.parse('2023-12-15T10:30:00.000Z')));
    });

    test('should handle JSON parsing with missing fields gracefully', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        // Missing isEmailVerified and other fields
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.isEmailVerified, isFalse); // Default value
      expect(userModel.createdAt, isNotNull); // Should use current time
      expect(userModel.updatedAt, isNull);
      expect(userModel.lastLoginAt, isNull);
    });

    test('should handle JSON parsing with invalid date format', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'isEmailVerified': true,
        'createdAt': 'invalid-date-format',
        'updatedAt': '2023-12-01T00:00:00.000Z',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.isEmailVerified, isTrue); // Should use value from JSON even on error
      expect(userModel.createdAt, isNotNull); // Should use current time on error
      expect(userModel.updatedAt, isNull); // Should be null due to parsing error
    });

    test('should copy UserModel with modified fields', () {
      // Arrange
      final originalUserModel = UserModel(
        id: 'original-id',
        email: 'original@example.com',
        name: 'Original User',
        isEmailVerified: false,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Act
      final copiedUserModel = originalUserModel.copyWith(
        id: 'new-id',
        email: 'new@example.com',
        name: 'New User',
        isEmailVerified: true,
      );

      // Assert
      expect(copiedUserModel.id, equals('new-id'));
      expect(copiedUserModel.email, equals('new@example.com'));
      expect(copiedUserModel.name, equals('New User'));
      expect(copiedUserModel.isEmailVerified, isTrue);
      expect(copiedUserModel.createdAt, equals(originalUserModel.createdAt));
    });

    test('should create UserModel from User entity', () {
      // Arrange
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-12-01T00:00:00.000Z'),
        lastLoginAt: DateTime.parse('2023-12-15T10:30:00.000Z'),
      );

      // Act
      final userModel = UserModel.fromEntity(user);

      // Assert
      expect(userModel.id, equals(user.id));
      expect(userModel.email, equals(user.email));
      expect(userModel.name, equals(user.name));
      expect(userModel.profilePicture, equals(user.profilePicture));
      expect(userModel.isEmailVerified, equals(user.isEmailVerified));
      expect(userModel.createdAt, equals(user.createdAt));
      expect(userModel.updatedAt, equals(user.updatedAt));
      expect(userModel.lastLoginAt, equals(user.lastLoginAt));
    });

    test('should convert UserModel to User entity', () {
      // Arrange
      final userModel = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        profilePicture: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-12-01T00:00:00.000Z'),
        lastLoginAt: DateTime.parse('2023-12-15T10:30:00.000Z'),
      );

      // Act
      final user = userModel.toEntity();

      // Assert
      expect(user.id, equals(userModel.id));
      expect(user.email, equals(userModel.email));
      expect(user.name, equals(userModel.name));
      expect(user.profilePicture, equals(userModel.profilePicture));
      expect(user.isEmailVerified, equals(userModel.isEmailVerified));
      expect(user.createdAt, equals(userModel.createdAt));
      expect(user.updatedAt, equals(userModel.updatedAt));
      expect(user.lastLoginAt, equals(userModel.lastLoginAt));
    });

    test('should create empty UserModel', () {
      // Act
      final emptyUserModel = UserModel.empty();

      // Assert
      expect(emptyUserModel.id, isEmpty);
      expect(emptyUserModel.email, isEmpty);
      expect(emptyUserModel.name, isEmpty);
      expect(emptyUserModel.isEmailVerified, isFalse);
      expect(emptyUserModel.profilePicture, isNull);
      expect(emptyUserModel.createdAt, isNotNull);
    });

    test('should check if UserModel is empty', () {
      // Test empty model
      final emptyUserModel = UserModel.empty();
      expect(emptyUserModel.isEmpty, isTrue);
      expect(emptyUserModel.isNotEmpty, isFalse);

      // Test non-empty model
      final userModel = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      expect(userModel.isEmpty, isFalse);
      expect(userModel.isNotEmpty, isTrue);
    });

    test('should implement equality correctly', () {
      // Arrange
      final userModel1 = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final userModel2 = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final userModel3 = UserModel(
        id: 'different-id',
        email: 'different@example.com',
        name: 'Different User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Assert
      expect(userModel1, equals(userModel2));
      expect(userModel1, isNot(equals(userModel3)));
    });

    test('should have correct toString', () {
      // Arrange
      final userModel = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(userModel.toString(), equals('UserModel(id: test-id, email: test@example.com, name: Test User)'));
    });

    test('should handle copyWith with all null parameters', () {
      // Arrange
      final originalUserModel = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Act
      final copiedUserModel = originalUserModel.copyWith();

      // Assert
      expect(copiedUserModel.id, equals(originalUserModel.id));
      expect(copiedUserModel.email, equals(originalUserModel.email));
      expect(copiedUserModel.name, equals(originalUserModel.name));
      expect(copiedUserModel.isEmailVerified, equals(originalUserModel.isEmailVerified));
      expect(copiedUserModel.createdAt, equals(originalUserModel.createdAt));
    });

    test('should handle JSON parsing with null values', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'profilePicture': null,
        'isEmailVerified': true,
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': null,
        'lastLoginAt': null,
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, equals('test-id'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
      expect(userModel.profilePicture, isNull);
      expect(userModel.isEmailVerified, isTrue);
      expect(userModel.updatedAt, isNull);
      expect(userModel.lastLoginAt, isNull);
    });
  });
}