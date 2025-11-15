import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../models/user_model.dart';

/// Abstract remote datasource
/// Defines contract for remote API calls
abstract interface class AuthRemoteDatasource {
  /// Login with email and password
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Refresh authentication token
  Future<Either<Failure, UserModel>> refreshToken();

  /// Send password reset email
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user profile
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? profilePicture,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend verification email
  Future<Either<Failure, void>> resendVerificationEmail();

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();
}