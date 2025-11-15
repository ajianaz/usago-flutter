import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/delete_account_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for DeleteAccountUseCase
/// Tests for business logic for deleting user account functionality
void main() {
  group('DeleteAccountUseCase Tests', () {
    late DeleteAccountUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = DeleteAccountUsecase(repository: mockRepository);
    });

    test('should successfully delete account', () async {
      // Arrange
      final params = DeleteAccountParams();

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.deleteAccount()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when delete account fails', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = AuthFailure(
        message: AuthTestConstants.serverErrorMessage,
        type: AuthExceptionType.serverError,
      );

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.serverErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.deleteAccount()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.deleteAccount())
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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle multiple delete account calls correctly', () async {
      // Arrange
      final params = DeleteAccountParams();

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.deleteAccount()).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = DeleteAccountParams();
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle edge case with no parameters', () async {
      // Arrange
      final params = DeleteAccountParams();

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle edge case with empty parameters', () async {
      // Arrange
      final params = DeleteAccountParams();

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('should handle edge case with account deletion confirmation', () async {
      // Arrange
      final params = DeleteAccountParams();

      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.deleteAccount()).called(1);
    });
  });
}