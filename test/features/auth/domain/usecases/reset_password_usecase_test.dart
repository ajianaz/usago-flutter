import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/reset_password_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for ResetPasswordUseCase
/// Tests for business logic for resetting password functionality
void main() {
  group('ResetPasswordUseCase Tests', () {
    late ResetPasswordUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ResetPasswordUsecase(repository: mockRepository);
    });

    test('should successfully reset password with valid token and password', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when reset password fails', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.passwordResetTokenExpiredMessage,
        type: AuthExceptionType.tokenExpired,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.passwordResetTokenExpiredMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(AuthTestConstants.serverErrorMessage));
          expect(failure.statusCode, equals(500));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals(AuthTestConstants.validationErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.unauthorizedMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.forbiddenMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle multiple reset password calls correctly', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<AuthFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.userNotFoundMessage));
          expect(actualFailure.type, equals(AuthExceptionType.userNotFound));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle edge case with empty token', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: '',
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.resetPassword(
        token: '',
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resetPassword(
        token: '',
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle edge case with empty new password', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.testAccessToken,
        newPassword: '',
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: '',
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.testAccessToken,
        newPassword: '',
      )).called(1);
    });

    test('should handle edge case with expired token', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.expiredToken,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.expiredToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.expiredToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle edge case with invalid token format', () async {
      // Arrange
      final params = ResetPasswordParams(
        token: AuthTestConstants.invalidToken,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.resetPassword(
        token: AuthTestConstants.invalidToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resetPassword(
        token: AuthTestConstants.invalidToken,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });
  });
}