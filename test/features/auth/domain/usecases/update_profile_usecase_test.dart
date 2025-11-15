import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/update_profile_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../helpers/auth_test_base.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';

/// Test suite for UpdateProfileUseCase
/// Tests the business logic for updating user profile functionality
void main() {
  group('UpdateProfileUseCase Tests', () {
    late UpdateProfileUsecase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = UpdateProfileUsecase(repository: mockRepository);
    });

    test('should successfully update profile with name only', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.name, equals(expectedUser.name));
          expect(user.profilePicture, equals(expectedUser.profilePicture));
        },
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should successfully update profile with profile picture only', () async {
      // Arrange
      final params = UpdateProfileParams(
        profilePicture: AuthTestConstants.testUserProfilePicture,
      );
      final expectedUser = AuthTestHelpers.createTestUserWithProfilePicture();

      when(mockRepository.updateProfile(
        name: null,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.name, equals(expectedUser.name));
          expect(user.profilePicture, equals(expectedUser.profilePicture));
        },
      );
      verify(mockRepository.updateProfile(
        name: null,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should successfully update profile with both name and profile picture', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      );
      final expectedUser = AuthTestHelpers.createTestUserWithProfilePicture();

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.name, equals(AuthTestConstants.validName));
          expect(user.profilePicture, equals(AuthTestConstants.testUserProfilePicture));
        },
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should successfully update profile with empty parameters (no changes)', () async {
      // Arrange
      final params = UpdateProfileParams();
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.updateProfile(
        name: null,
        profilePicture: null,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.name, equals(expectedUser.name));
          expect(user.profilePicture, equals(expectedUser.profilePicture));
        },
      );
      verify(mockRepository.updateProfile(
        name: null,
        profilePicture: null,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return repository failure when update profile fails', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.validationErrorMessage,
        type: AuthExceptionType.invalidCredentials,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals(AuthTestConstants.validationErrorMessage));
        },
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle network failure from repository', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = NetworkFailure(
        message: AuthTestConstants.networkErrorMessage,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
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
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });

    test('should handle server failure from repository', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = ServerFailure(
        message: AuthTestConstants.serverErrorMessage,
        statusCode: 500,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });

    test('should handle validation failure from repository', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = ValidationFailure(
        message: AuthTestConstants.validationErrorMessage,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });

    test('should handle unauthorized failure from repository', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.unauthorizedMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });

    test('should handle forbidden failure from repository', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.forbiddenMessage,
        type: AuthExceptionType.loginRequired,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });

    test('should handle edge case with empty profile picture string', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
        profilePicture: '',
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: '',
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (user) {
          expect(user.id, equals(expectedUser.id));
          expect(user.name, equals(expectedUser.name));
          expect(user.profilePicture, equals(''));
        },
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: '',
      )).called(1);
    });

    test('should handle multiple update profile calls correctly', () async {
      // Arrange
      final params1 = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      final params2 = UpdateProfileParams(
        profilePicture: AuthTestConstants.testUserProfilePicture,
      );
      final expectedUser = AuthTestHelpers.createTestUser();

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).thenAnswer((_) async => Right(expectedUser));

      when(mockRepository.updateProfile(
        name: null,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result1 = await useCase(params1);
      final result2 = await useCase(params2);

      // Assert
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
      verify(mockRepository.updateProfile(
        name: null,
        profilePicture: AuthTestConstants.testUserProfilePicture,
      )).called(1);
    });

    test('should preserve repository failure type', () async {
      // Arrange
      final params = UpdateProfileParams(
        name: AuthTestConstants.validName,
      );
      const failure = AuthFailure(
        message: AuthTestConstants.userNotFoundMessage,
        type: AuthExceptionType.userNotFound,
      );

      when(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).thenAnswer((_) async => const Left(failure));

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
        (user) => fail('Expected failure but got success'),
      );
      verify(mockRepository.updateProfile(
        name: AuthTestConstants.validName,
        profilePicture: null,
      )).called(1);
    });
  });
}