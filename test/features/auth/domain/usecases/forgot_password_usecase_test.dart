import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for ForgotPasswordUseCase
/// Tests for business logic for forgot password functionality
void main() {
  group('ForgotPasswordUseCase Tests', () {
    late ForgotPasswordUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ForgotPasswordUsecase(repository: mockRepository);
    });

    test('should successfully send forgot password email', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when forgot password fails', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle multiple forgot password calls correctly', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.rateLimitMessage,
        type: AuthExceptionType.tooManyRequests,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.testUserEmail))
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
      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
    });

    test('should handle edge case with empty email', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: '',
      );

      when(mockRepository.forgotPassword(''))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.forgotPassword('')).called(1);
    });

    test('should handle edge case with invalid email format', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.invalidEmail,
      );

      when(mockRepository.forgotPassword(AuthTestConstants.invalidEmail))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.forgotPassword(AuthTestConstants.invalidEmail)).called(1);
    });

    test('should handle edge case with email containing admin', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: 'admin@example.com',
      );

      when(mockRepository.forgotPassword('admin@example.com'))
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.forgotPassword('admin@example.com')).called(1);
    });
  });
}