import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/login_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for LoginUseCase
/// Tests the business logic for user login functionality
void main() {
  group('LoginUseCase Tests', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(repository: mockRepository);
    });

    test('should successfully login with valid credentials', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.email, equals(expectedUser.email));
          expect(user.name, equals(expectedUser.name));
        },
      );
      verify(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return validation failure when email is invalid', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.invalidEmail,
        password: AuthTestConstants.testUserPassword,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('valid email'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    test('should return validation failure when password is invalid', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.weakPassword,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Password'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    test('should return validation failure when email contains admin', () async {
      // Arrange
      final params = LoginParams(
        email: 'admin@example.com',
        password: AuthTestConstants.testUserPassword,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Admin login not allowed'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    test('should return validation failure when email is empty', () async {
      // Arrange
      final params = LoginParams(
        email: '',
        password: AuthTestConstants.testUserPassword,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Email cannot be empty'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    test('should return validation failure when password is empty', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: '',
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Password cannot be empty'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    test('should return repository failure when login fails', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.invalidCredentialsMessage,
        type: AuthExceptionType.invalidCredentials,
      );

      when(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.invalidCredentialsMessage));
        },
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim email before validation', () async {
      // Arrange
      final params = LoginParams(
        email: '  ${AuthTestConstants.testUserEmail}  ',
        password: AuthTestConstants.testUserPassword,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockRepository.login(
        email: AuthTestConstants.testUserEmail, // Should be trimmed
        password: AuthTestConstants.testUserPassword,
      )).called(1);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
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
        (user) => fail('Expected failure but got success'),
      );
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = LoginParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.login(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(AuthTestConstants.serverErrorMessage));
        },
        (user) => fail('Expected failure but got success'),
      );
    });

    test('should handle edge case with mixed case admin email', () async {
      // Arrange
      final params = LoginParams(
        email: 'ADMIN@example.com',
        password: AuthTestConstants.testUserPassword,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Admin login not allowed'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });
  });
}