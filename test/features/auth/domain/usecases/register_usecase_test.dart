import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/register_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../../../../lib/core/errors/exceptions.dart';
import '../../helpers/auth_test_helpers.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/mocks.dart';

/// Test suite for RegisterUseCase
/// Tests business logic for user registration functionality
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

      // Act
      when(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
      )).thenAnswer((_) async => Right(expectedUser));

      // Assert
      final result = await useCase(params);
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

    test('should return validation failure when password is weak', () async {
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
  });
}