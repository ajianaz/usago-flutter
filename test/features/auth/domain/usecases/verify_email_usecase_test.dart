import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/verify_email_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for VerifyEmailUseCase
/// Tests for business logic for email verification functionality
void main() {
  group('VerifyEmailUseCase Tests', () {
    late VerifyEmailUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = VerifyEmailUsecase(repository: mockRepository);
    });

    test('should successfully verify email with valid token', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when verify email fails', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.emailNotVerifiedMessage,
        type: AuthExceptionType.emailNotVerified,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.emailNotVerifiedMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle multiple verify email calls correctly', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.testAccessToken,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.tokenExpiredMessage,
        type: AuthExceptionType.tokenExpired,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.testAccessToken))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<AuthFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.tokenExpiredMessage));
          expect(actualFailure.type, equals(AuthExceptionType.tokenExpired));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.verifyEmail(AuthTestConstants.testAccessToken)).called(1);
    });

    test('should handle edge case with empty token', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: '',
      );

      when(mockRepository.verifyEmail(''))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.verifyEmail('')).called(1);
    });

    test('should handle edge case with expired token', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.expiredToken,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.expiredToken))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.verifyEmail(AuthTestConstants.expiredToken)).called(1);
    });

    test('should handle edge case with invalid token format', () async {
      // Arrange
      final params = VerifyEmailParams(
        token: AuthTestConstants.invalidToken,
      );

      when(mockRepository.verifyEmail(AuthTestConstants.invalidToken))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.verifyEmail(AuthTestConstants.invalidToken)).called(1);
    });
  });
}