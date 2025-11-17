import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/core/errors/failure.dart';
import '../../../../lib/core/errors/exceptions.dart';
import 'auth_test_helpers.dart';

/// Mock implementation of AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #login,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: Future.value(Right(AuthTestHelpers.createTestUser())),
      );

  @override
  Future<Either<Failure, User>> register({
    required String? email,
    required String? password,
    required String? name,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #register,
          [],
          {
            #email: email,
            #password: password,
            #name: name,
          },
        ),
        returnValue: Future.value(Right(AuthTestHelpers.createTestUser())),
      );

  @override
  Future<Either<Failure, void>> logout() =>
      super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, User?>> checkAuthStatus() =>
      super.noSuchMethod(
        Invocation.method(
          #checkAuthStatus,
          [],
        ),
        returnValue: Future.value(Right(AuthTestHelpers.createTestUser())),
      );

  @override
  Future<Either<Failure, User>> refreshToken() =>
      super.noSuchMethod(
        Invocation.method(
          #refreshToken,
          [],
        ),
        returnValue: Future.value(Right(AuthTestHelpers.createTestUser())),
      );

  @override
  Future<Either<Failure, void>> forgotPassword(String? email) =>
      super.noSuchMethod(
        Invocation.method(
          #forgotPassword,
          [email],
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, void>> resetPassword({
    required String? token,
    required String? newPassword,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #resetPassword,
          [],
          {
            #token: token,
            #newPassword: newPassword,
          },
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, void>> changePassword({
    required String? currentPassword,
    required String? newPassword,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #changePassword,
          [],
          {
            #currentPassword: currentPassword,
            #newPassword: newPassword,
          },
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? profilePicture,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #updateProfile,
          [],
          {
            #name: name,
            #profilePicture: profilePicture,
          },
        ),
        returnValue: Future.value(Right(AuthTestHelpers.createTestUser())),
      );

  @override
  Future<Either<Failure, void>> verifyEmail(String? token) =>
      super.noSuchMethod(
        Invocation.method(
          #verifyEmail,
          [token],
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, void>> resendVerificationEmail() =>
      super.noSuchMethod(
        Invocation.method(
          #resendVerificationEmail,
          [],
        ),
        returnValue: Future.value(const Right(null)),
      );

  @override
  Future<Either<Failure, void>> deleteAccount() =>
      super.noSuchMethod(
        Invocation.method(
          #deleteAccount,
          [],
        ),
        returnValue: Future.value(const Right(null)),
      );
}