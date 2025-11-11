import '../../domain/entities/user.dart';

/// User Data Transfer Object
/// Used for API serialization/deserialization
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String name,
    String? profilePicture,
    required bool isEmailVerified,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) : super(
    id: id,
    email: email,
    name: name,
    profilePicture: profilePicture,
    isEmailVerified: isEmailVerified,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastLoginAt: lastLoginAt,
  );

  /// Create from JSON API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'] as String? ?? '',
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        profilePicture: json['profilePicture'] as String?,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
      );
    } catch (e) {
      // Return empty user if JSON parsing fails
      return UserModel(
        id: '',
        email: '',
        name: '',
        isEmailVerified: false,
        createdAt: DateTime.now(),
      );
    }
  }

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Create from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profilePicture: user.profilePicture,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      lastLoginAt: user.lastLoginAt,
    );
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      profilePicture: profilePicture,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
    );
  }

  /// Create empty user model
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      name: '',
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );
  }

  /// Check if user model is empty
  bool get isEmpty => id.isEmpty && email.isEmpty && name.isEmpty;

  /// Check if user model is not empty
  bool get isNotEmpty => !isEmpty;

  /// Create a copy of this UserModel with modified fields
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name)';
  }
}