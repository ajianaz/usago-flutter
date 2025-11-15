import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/change_password_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for ChangePasswordUseCase
/// Tests for business logic for changing user password functionality
void main() {
  group('ChangePasswordUseCase Tests', () {
    late ChangePasswordUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ChangePasswordUsecase(repository: mockRepository);
    });

    test('should successfully change password with valid credentials', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when change password fails', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.currentPasswordIncorrectMessage,
        type: AuthExceptionType.invalidCredentials,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.currentPasswordIncorrectMessage));
        },
        (value) => fail('Expected failure but got success'),
      );
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle timeout failure from repository', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle multiple change password calls correctly', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => AuthTestHelpers.createSuccessVoidResult());

      // Act
      final result1 = await useCase(params);
      final result2 = await useCase(params);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(2);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.tokenExpiredMessage,
        type: AuthExceptionType.tokenExpired,
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle edge case with same current and new password', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.testUserPassword,
        newPassword: AuthTestConstants.testUserPassword, // Same password
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.testUserPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.testUserPassword,
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle edge case with empty new password', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: '',
      );

      when(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
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
      verify(mockRepository.changePassword(
        currentPassword: AuthTestConstants.validPassword,
        newPassword: '',
      )).called(1);
    });

    test('should handle edge case with empty current password', () async {
      // Arrange
      final params = ChangePasswordParams(
        currentPassword: '',
        newPassword: AuthTestConstants.testUserPassword,
      );

      when(mockRepository.changePassword(
        currentPassword: '',
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
      verify(mockRepository.changePassword(
        currentPassword: '',
        newPassword: AuthTestConstants.testUserPassword,
      )).called(1);
    });
  });
}