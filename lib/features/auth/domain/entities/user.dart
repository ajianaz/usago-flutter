import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
/// This is a pure domain entity without any implementation details
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.isEmailVerified,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  /// Create User from JSON (for API responses)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Convert User to JSON (for API requests)
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

  /// Returns a copy of this User with modified fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return User(
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

  /// Get user's display name
  String get displayName => name.trim().isNotEmpty ? name : email;

  /// Get user's initials
  String get initials {
    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      final nameParts = trimmedName.split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty) {
        return nameParts[0][0].toUpperCase();
      }
    }

    final trimmedEmail = email.trim();
    if (trimmedEmail.isNotEmpty) {
      return trimmedEmail[0].toUpperCase();
    }

    return '?';
  }

  /// Create empty user
  static User empty() {
    return User(
      id: '',
      email: '',
      name: '',
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );
  }

  /// Check if user has profile picture
  bool get hasProfilePicture =>
      profilePicture != null && profilePicture!.trim().isNotEmpty;

  /// Get user's join date formatted
  String get joinDateFormatted {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = months[createdAt.month - 1];
    final year = createdAt.year;

    return '$day $month $year';
  }

  /// Check if user is newly created (less than 7 days)
  bool get isNewUser {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }

  /// Check if user is active (logged in within last 30 days)
  bool get isActive {
    if (lastLoginAt == null) return false;

    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    return difference.inDays < 30;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profilePicture,
        isEmailVerified,
        createdAt,
        updatedAt,
        lastLoginAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}