import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/logout_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for LogoutUseCase
/// Tests the business logic for user logout functionality
void main() {
  group('LogoutUseCase Tests', () {
    late LogoutUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LogoutUseCase(repository: mockRepository);
    });

    test('should successfully logout', () async {
      // Arrange
      when(mockRepository.logout())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) => expect(value, isNull),
      );
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when logout fails', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.networkErrorMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

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
      verify(mockRepository.logout()).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals(AuthTestConstants.validationErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.unauthorizedMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.forbiddenMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.logout()).called(1);
    });

    test('should handle multiple logout calls correctly', () async {
      // Arrange
      when(mockRepository.logout())
          .thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase();
      final result2 = await useCase();

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.logout()).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.tokenExpiredMessage,
        type: AuthExceptionType.tokenExpired,
      );

      when(mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

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
      verify(mockRepository.logout()).called(1);
    });
  });
}