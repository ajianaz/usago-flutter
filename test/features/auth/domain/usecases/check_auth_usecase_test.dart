import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for CheckAuthUseCase
/// Tests for business logic for checking authentication status
void main() {
  group('CheckAuthUseCase Tests', () {
    late CheckAuthUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = CheckAuthUsecase(repository: mockRepository);
    });

    test('should successfully check auth status with authenticated user', () async {
      // Arrange
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => AuthTestHelpers.createNullableUserResult(expectedUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user, isNotNull);
          expect(user!.id, equals(expectedUser.id));
          expect(user.email, equals(expectedUser.email));
          expect(user.name, equals(expectedUser.name));
        },
      );
      verify(mockRepository.checkAuthStatus()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should successfully check auth status with null user', () async {
      // Arrange
      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => AuthTestHelpers.createNullableUserResult(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) => expect(user, isNull),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when check auth fails', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.tokenExpiredMessage,
        type: AuthExceptionType.tokenExpired,
      );

      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.tokenExpiredMessage));
        },
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle multiple check auth calls correctly', () async {
      // Arrange
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => AuthTestHelpers.createNullableUserResult(expectedUser));

      // Act
      final result1 = await useCase();
      final result2 = await useCase();

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.checkAuthStatus()).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<AuthFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.userNotFoundMessage));
          expect(actualFailure.type, equals(AuthExceptionType.userNotFound));
        },
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.checkAuthStatus())
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });

    test('should handle edge case with unverified user', () async {
      // Arrange
      final expectedUser = AuthTestHelpers.createUnverifiedTestUser();

      when(mockRepository.checkAuthStatus())
          .thenAnswer((_) async => AuthTestHelpers.createNullableUserResult(expectedUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user, isNotNull);
          expect(user!.id, equals(expectedUser.id));
          expect(user.email, equals(expectedUser.email));
          expect(user.name, equals(expectedUser.name));
          expect(user.isEmailVerified, isFalse);
        },
      );
      verify(mockRepository.checkAuthStatus()).called(1);
    });
  });
}