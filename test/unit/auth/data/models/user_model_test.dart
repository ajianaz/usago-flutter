import 'package:flutter_test/flutter_test.dart';
import 'package:usago/features/auth/data/models/user_model.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import '../../../../fixtures/auth_fixtures.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel with all required fields', () {
      // Act
      final userModel = UserModel(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testUserEmail,
        name: AuthFixtures.testUserName,
        isEmailVerified: true,
        createdAt: AuthFixtures.testCreatedAt,
      );

      // Assert
      expect(userModel.id, AuthFixtures.testUserId);
      expect(userModel.email, AuthFixtures.testUserEmail);
      expect(userModel.name, AuthFixtures.testUserName);
      expect(userModel.isEmailVerified, true);
      expect(userModel.createdAt, AuthFixtures.testCreatedAt);
      expect(userModel.profilePicture, null);
      expect(userModel.updatedAt, null);
      expect(userModel.lastLoginAt, null);
    });

    test('should create UserModel from JSON correctly', () {
      // Act
      final userModel = UserModel.fromJson(AuthFixtures.testUserJson);

      // Assert
      expect(userModel.id, AuthFixtures.testUserId);
      expect(userModel.email, AuthFixtures.testUserEmail);
      expect(userModel.name, AuthFixtures.testUserName);
      expect(userModel.profilePicture, AuthFixtures.testUserProfilePicture);
      expect(userModel.isEmailVerified, true);
      expect(userModel.createdAt, AuthFixtures.testCreatedAt);
      expect(userModel.updatedAt, AuthFixtures.testUpdatedAt);
      expect(userModel.lastLoginAt, AuthFixtures.testLastLoginAt);
    });

    test('should create UserModel from JSON without optional fields', () {
      // Act
      final userModel = UserModel.fromJson(AuthFixtures.testUserJsonWithoutOptional);

      // Assert
      expect(userModel.id, AuthFixtures.testUserId);
      expect(userModel.email, AuthFixtures.testUserEmail);
      expect(userModel.name, AuthFixtures.testUserName);
      expect(userModel.profilePicture, null);
      expect(userModel.isEmailVerified, false);
      expect(userModel.createdAt, AuthFixtures.testCreatedAt);
      expect(userModel.updatedAt, null);
      expect(userModel.lastLoginAt, null);
    });

    test('should create UserModel from JSON with missing fields gracefully', () {
      // Arrange
      const incompleteJson = {
        'id': AuthFixtures.testUserId,
        'email': AuthFixtures.testUserEmail,
        // Missing name and other fields
      };

      // Act
      final userModel = UserModel.fromJson(incompleteJson);

      // Assert
      expect(userModel.id, AuthFixtures.testUserId);
      expect(userModel.email, AuthFixtures.testUserEmail);
      expect(userModel.name, ''); // Default empty string
      expect(userModel.isEmailVerified, false); // Default false
      expect(userModel.createdAt, isA<DateTime>()); // Should use DateTime.now()
    });

    test('should handle JSON parsing errors gracefully', () {
      // Arrange
      const invalidJson = {
        'id': AuthFixtures.testUserId,
        'email': AuthFixtures.testUserEmail,
        'createdAt': 'invalid-date',
      };

      // Act
      final userModel = UserModel.fromJson(invalidJson);

      // Assert
      expect(userModel.id, AuthFixtures.testUserId);
      expect(userModel.email, AuthFixtures.testUserEmail);
      expect(userModel.name, ''); // Default empty string
      expect(userModel.isEmailVerified, false); // Default false
      expect(userModel.createdAt, isA<DateTime>()); // Should use DateTime.now()
    });

    test('should convert UserModel to JSON correctly', () {
      // Act
      final json = AuthFixtures.testUserModel.toJson();

      // Assert
      expect(json, AuthFixtures.testUserJson);
    });

    test('should create UserModel from User entity', () {
      // Act
      final userModel = UserModel.fromEntity(AuthFixtures.testUser);

      // Assert
      expect(userModel.id, AuthFixtures.testUser.id);
      expect(userModel.email, AuthFixtures.testUser.email);
      expect(userModel.name, AuthFixtures.testUser.name);
      expect(userModel.profilePicture, AuthFixtures.testUser.profilePicture);
      expect(userModel.isEmailVerified, AuthFixtures.testUser.isEmailVerified);
      expect(userModel.createdAt, AuthFixtures.testUser.createdAt);
      expect(userModel.updatedAt, AuthFixtures.testUser.updatedAt);
      expect(userModel.lastLoginAt, AuthFixtures.testUser.lastLoginAt);
    });

    test('should convert UserModel to User entity', () {
      // Act
      final user = AuthFixtures.testUserModel.toEntity();

      // Assert
      expect(user.id, AuthFixtures.testUserModel.id);
      expect(user.email, AuthFixtures.testUserModel.email);
      expect(user.name, AuthFixtures.testUserModel.name);
      expect(user.profilePicture, AuthFixtures.testUserModel.profilePicture);
      expect(user.isEmailVerified, AuthFixtures.testUserModel.isEmailVerified);
      expect(user.createdAt, AuthFixtures.testUserModel.createdAt);
      expect(user.updatedAt, AuthFixtures.testUserModel.updatedAt);
      expect(user.lastLoginAt, AuthFixtures.testUserModel.lastLoginAt);
    });

    test('should create empty UserModel correctly', () {
      // Act
      final emptyUserModel = UserModel.empty();

      // Assert
      expect(emptyUserModel.id, '');
      expect(emptyUserModel.email, '');
      expect(emptyUserModel.name, '');
      expect(emptyUserModel.isEmailVerified, false);
      expect(emptyUserModel.createdAt, isA<DateTime>());
      expect(emptyUserModel.profilePicture, null);
      expect(emptyUserModel.updatedAt, null);
      expect(emptyUserModel.lastLoginAt, null);
    });

    test('should check isEmpty correctly', () {
      // Assert
      expect(AuthFixtures.emptyUserModel.isEmpty, true);
      expect(AuthFixtures.testUserModel.isEmpty, false);
    });

    test('should check isNotEmpty correctly', () {
      // Assert
      expect(AuthFixtures.emptyUserModel.isNotEmpty, false);
      expect(AuthFixtures.testUserModel.isNotEmpty, true);
    });

    test('should copy UserModel with modified fields', () {
      // Arrange
      final originalUserModel = AuthFixtures.testUserModel;
      const newEmail = 'newemail@example.com';

      // Act
      final copiedUserModel = originalUserModel.copyWith(email: newEmail);

      // Assert
      expect(copiedUserModel.id, originalUserModel.id);
      expect(copiedUserModel.email, newEmail);
      expect(copiedUserModel.name, originalUserModel.name);
      expect(copiedUserModel.profilePicture, originalUserModel.profilePicture);
      expect(copiedUserModel.isEmailVerified, originalUserModel.isEmailVerified);
      expect(copiedUserModel.createdAt, originalUserModel.createdAt);
      expect(copiedUserModel.updatedAt, originalUserModel.updatedAt);
      expect(copiedUserModel.lastLoginAt, originalUserModel.lastLoginAt);
    });

    test('should maintain UserModel type when copying', () {
      // Act
      final copiedUserModel = AuthFixtures.testUserModel.copyWith();

      // Assert
      expect(copiedUserModel, isA<UserModel>());
    });

    test('should implement equality correctly', () {
      // Arrange
      final userModel1 = AuthFixtures.testUserModel;
      final userModel2 = AuthFixtures.testUserModel;
      final userModel3 = AuthFixtures.testUserModel.copyWith(email: 'different@example.com');

      // Assert
      expect(userModel1, equals(userModel2));
      expect(userModel1, isNot(equals(userModel3)));
    });

    test('should have correct toString implementation', () {
      // Act
      final toString = AuthFixtures.testUserModel.toString();

      // Assert
      expect(toString, 'UserModel(id: ${AuthFixtures.testUserId}, email: ${AuthFixtures.testUserEmail}, name: ${AuthFixtures.testUserName})');
    });

    test('should handle null values in JSON correctly', () {
      // Arrange
      final jsonWithNulls = Map<String, dynamic>.from(AuthFixtures.testUserJson);
      jsonWithNulls['profilePicture'] = null;
      jsonWithNulls['updatedAt'] = null;
      jsonWithNulls['lastLoginAt'] = null;

      // Act
      final userModel = UserModel.fromJson(jsonWithNulls);

      // Assert
      expect(userModel.profilePicture, null);
      expect(userModel.updatedAt, null);
      expect(userModel.lastLoginAt, null);
    });

    test('should handle empty strings in JSON correctly', () {
      // Arrange
      final jsonWithEmptyStrings = Map<String, dynamic>.from(AuthFixtures.testUserJson);
      jsonWithEmptyStrings['profilePicture'] = '';

      // Act
      final userModel = UserModel.fromJson(jsonWithEmptyStrings);

      // Assert
      expect(userModel.profilePicture, '');
    });

    test('should convert to and from entity consistently', () {
      // Arrange
      final originalUserModel = AuthFixtures.testUserModel;

      // Act
      final userEntity = originalUserModel.toEntity();
      final convertedUserModel = UserModel.fromEntity(userEntity);

      // Assert
      expect(convertedUserModel, equals(originalUserModel));
    });
  });
}