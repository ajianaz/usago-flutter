import 'package:usago/features/auth/data/models/user_model.dart';
import 'package:usago/features/auth/domain/entities/user.dart';

/// Test fixtures for auth feature
class AuthFixtures {
  // Sample user data
  static const String testUserId = 'test-user-123';
  static const String testUserEmail = 'test@example.com';
  static const String testUserName = 'Test User';
  static const String testUserPassword = 'password123';
  static const String testUserProfilePicture = 'https://example.com/avatar.jpg';

  static final DateTime testCreatedAt = DateTime.parse('2023-01-01T00:00:00Z');
  static final DateTime testUpdatedAt = DateTime.parse('2023-01-02T00:00:00Z');
  static final DateTime testLastLoginAt = DateTime.parse('2023-01-03T00:00:00Z');

  // Sample JSON data
  static const Map<String, dynamic> testUserJson = {
    'id': testUserId,
    'email': testUserEmail,
    'name': testUserName,
    'profilePicture': testUserProfilePicture,
    'isEmailVerified': true,
    'createdAt': '2023-01-01T00:00:00.000Z',
    'updatedAt': '2023-01-02T00:00:00.000Z',
    'lastLoginAt': '2023-01-03T00:00:00.000Z',
  };

  static const Map<String, dynamic> testUserJsonWithoutOptional = {
    'id': testUserId,
    'email': testUserEmail,
    'name': testUserName,
    'isEmailVerified': false,
    'createdAt': '2023-01-01T00:00:00.000Z',
  };

  // Sample User entity
  static User get testUser => User(
    id: testUserId,
    email: testUserEmail,
    name: testUserName,
    profilePicture: testUserProfilePicture,
    isEmailVerified: true,
    createdAt: testCreatedAt,
    updatedAt: testUpdatedAt,
    lastLoginAt: testLastLoginAt,
  );

  static User get testUserWithoutOptional => User(
    id: testUserId,
    email: testUserEmail,
    name: testUserName,
    isEmailVerified: false,
    createdAt: testCreatedAt,
  );

  // Sample UserModel
  static UserModel get testUserModel => UserModel(
    id: testUserId,
    email: testUserEmail,
    name: testUserName,
    profilePicture: testUserProfilePicture,
    isEmailVerified: true,
    createdAt: testCreatedAt,
    updatedAt: testUpdatedAt,
    lastLoginAt: testLastLoginAt,
  );

  static UserModel get testUserModelWithoutOptional => UserModel(
    id: testUserId,
    email: testUserEmail,
    name: testUserName,
    isEmailVerified: false,
    createdAt: testCreatedAt,
  );

  // Empty user
  static User get emptyUser => User.empty();
  static UserModel get emptyUserModel => UserModel.empty();

  // Test credentials
  static const String validEmail = 'valid@example.com';
  static const String invalidEmail = 'invalid-email';
  static const String validPassword = 'ValidPass123!';
  static const String invalidPassword = '123';
  static const String adminEmail = 'admin@example.com';

  // Test tokens
  static const String testToken = 'test-token-123';
  static const String testResetToken = 'reset-token-123';
  static const String testVerificationToken = 'verification-token-123';

  // Test session data
  static const Map<String, dynamic> testSessionData = {
    'userId': testUserId,
    'token': testToken,
    'expiresAt': '2023-12-31T23:59:59Z',
  };
}