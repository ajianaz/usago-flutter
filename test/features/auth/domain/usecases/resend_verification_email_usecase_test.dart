import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for ResendVerificationEmailUseCase
/// Tests for business logic for resending verification email functionality
void main() {
  group('ResendVerificationEmailUseCase Tests', () {
    late ResendVerificationEmailUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ResendVerificationEmailUsecase(repository: mockRepository);
    });

    test('should successfully resend verification email', () async {
      // Arrange
      final params = ResendVerificationEmailParams();

      when(mockRepository.resendVerificationEmail())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resendVerificationEmail()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when resend verification email fails', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.resendVerificationEmail())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.userNotFoundMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resendVerificationEmail()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.resendVerificationEmail())
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
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle multiple resend verification email calls correctly', () async {
      // Arrange
      final params = ResendVerificationEmailParams();

      when(mockRepository.resendVerificationEmail())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.resendVerificationEmail()).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = ResendVerificationEmailParams();
      const failure = AuthFailure(
        message: AuthTestConstants.rateLimitMessage,
        type: AuthExceptionType.tooManyRequests,
      );

      when(mockRepository.resendVerificationEmail())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<AuthFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.rateLimitMessage));
          expect(actualFailure.type, equals(AuthExceptionType.tooManyRequests));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.resendVerificationEmail()).called(1);
    });

    test('should handle edge case with no parameters', () async {
      // Arrange
      final params = ResendVerificationEmailParams();

      when(mockRepository.resendVerificationEmail())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.resendVerificationEmail()).called(1);
    });
  });
}