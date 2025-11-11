import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

/// Abstract interface for authentication repository
/// Defines contract for all authentication operations
abstract interface class AuthRepository {
  /// Login with email and password
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  /// Returns cached [User] if exists, null if not
  Future<Either<Failure, User?>> checkAuthStatus();

  /// Refresh authentication token
  /// Used when token is expired
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> refreshToken();

  /// Send password reset email
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Reset password with token
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Change password
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user profile
  /// Returns updated [User] on success or [Failure] on error
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? profilePicture,
  });

  /// Verify email with token
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend verification email
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> resendVerificationEmail();

  /// Delete user account
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> deleteAccount();
}