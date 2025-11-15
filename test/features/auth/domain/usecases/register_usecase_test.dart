import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/register_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for RegisterUseCase
/// Tests the business logic for user registration functionality
void main() {
  group('RegisterUseCase Tests', () {
    late RegisterUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = RegisterUseCase(repository: mockRepository);
    });

    test('should successfully register with valid credentials', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
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
      verify(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return validation failure when email is invalid', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.invalidEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
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
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when password is invalid', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.weakPassword,
        name: AuthTestConstants.testUserName,
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
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when name is empty', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.emptyName,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Name cannot be empty'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when name contains only whitespace', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: '   ',
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Name cannot be empty'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when email contains admin', () async {
      // Arrange
      final params = RegisterParams(
        email: 'admin@example.com',
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Admin registration not allowed'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when email is empty', () async {
      // Arrange
      final params = RegisterParams(
        email: '',
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
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
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return validation failure when password is empty', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: '',
        name: AuthTestConstants.testUserName,
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
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should return repository failure when registration fails', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.emailAlreadyExistsMessage,
        type: AuthExceptionType.emailAlreadyExists,
      );

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.emailAlreadyExistsMessage));
        },
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim email and name before validation', () async {
      // Arrange
      final params = RegisterParams(
        email: '  ${AuthTestConstants.testUserEmail}  ',
        password: AuthTestConstants.testUserPassword,
        name: '  ${AuthTestConstants.testUserName}  ',
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockRepository.register(
        email: AuthTestConstants.testUserEmail, // Should be trimmed
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName, // Should be trimmed
      )).called(1);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
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
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
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
      final params = RegisterParams(
        email: 'ADMIN@example.com',
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.testUserName,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Admin registration not allowed'));
        },
        (user) => fail('Expected failure but got success'),
      );
      verifyNever(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      ));
    });

    test('should handle edge case with single character name', () async {
      // Arrange
      final params = RegisterParams(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.singleCharName,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.singleCharName,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockRepository.register(
        email: AuthTestConstants.testUserEmail,
        password: AuthTestConstants.testUserPassword,
        name: AuthTestConstants.singleCharName,
      )).called(1);
    });
  });
}