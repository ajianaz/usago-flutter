import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../../../../lib/core/errors/exceptions.dart';
import '../../helpers/auth_test_helpers.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/mocks.dart';

/// Test suite for ForgotPasswordUseCase
/// Tests business logic for forgot password functionality
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

      // Act
      when(mockRepository.forgotPassword(anyNamed('email')))
          .thenAnswer((_) async => AuthTestHelpers.createVoidSuccessResult());

      // Assert
      final result = await useCase(params);
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (value) {},
      );

      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when user not found', () async {
      // Arrange
      final params = ForgotPasswordParams(
        email: AuthTestConstants.testUserEmail,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.forbidden,
      );

      // Act
      when(mockRepository.forgotPassword(captureThat(anything)))
          .thenAnswer((_) async => const Left(failure));

      // Assert
      final result = await useCase(params);
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<AuthFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.userNotFoundMessage));
        },
        (value) => fail('Expected success but got failure'),
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

      // Act
      when(mockRepository.forgotPassword(anyNamed('email')))
          .thenAnswer((_) async => const Left(failure));

      // Assert
      final result = await useCase(params);
      expect(result.isLeft(), isTrue);
      result.fold(
        (actualFailure) {
          expect(actualFailure, isA<NetworkFailure>());
          expect(actualFailure.message, equals(AuthTestConstants.networkErrorMessage));
        },
        (value) => fail('Expected success but got failure'),
      );

      verify(mockRepository.forgotPassword(AuthTestConstants.testUserEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}