import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import 'package:usago/features/auth/domain/usecases/login_usecase.dart';
import '../../../../fixtures/auth_fixtures.dart';
import '../../../../mocks/auth_mocks.dart';

void main() {
  group('LoginUsecase', () {
    late LoginUsecase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = LoginUsecase(repository: mockRepository);
    });

    test('should call repository with correct parameters when login is successful', () async {
      // Arrange
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;
      final expectedUser = AuthFixtures.testUser;

      when(() => mockRepository.login(
        email: email,
        password: password,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await usecase(const LoginParams(email: email, password: password));

      // Assert
      expect(result, Right(expectedUser));
      verify(() => mockRepository.login(email: email, password: password)).called(1);
    });

    test('should return ValidationFailure when email is invalid', () async {
      // Arrange
      const invalidEmail = AuthFixtures.invalidEmail;
      const password = AuthFixtures.validPassword;

      // Act
      final result = await usecase(const LoginParams(email: invalidEmail, password: password));

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (user) => fail('Expected failure but got user'),
      );
      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should return ValidationFailure when password is invalid', () async {
      // Arrange
      const email = AuthFixtures.validEmail;
      const invalidPassword = AuthFixtures.invalidPassword;

      // Act
      final result = await usecase(const LoginParams(email: email, password: invalidPassword));

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (user) => fail('Expected failure but got user'),
      );
      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should return ValidationFailure when email contains admin', () async {
      // Arrange
      const adminEmail = AuthFixtures.adminEmail;
      const password = AuthFixtures.validPassword;

      // Act
      final result = await usecase(const LoginParams(email: adminEmail, password: password));

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Admin login not allowed'));
        },
        (user) => fail('Expected failure but got user'),
      );
      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should return repository failure when login fails', () async {
      // Arrange
      const email = AuthFixtures.validEmail;
      const password = AuthFixtures.validPassword;
      const expectedFailure = ServerFailure(message: 'Login failed');

      when(() => mockRepository.login(
        email: email,
        password: password,
      )).thenAnswer((_) async => const Left(expectedFailure));

      // Act
      final result = await usecase(const LoginParams(email: email, password: password));

      // Assert
      expect(result, const Left(expectedFailure));
      verify(() => mockRepository.login(email: email, password: password)).called(1);
    });

    test('should trim email before calling repository', () async {
      // Arrange
      const emailWithSpaces = '  ${AuthFixtures.validEmail}  ';
      const password = AuthFixtures.validPassword;
      final expectedUser = AuthFixtures.testUser;

      when(() => mockRepository.login(
        email: AuthFixtures.validEmail, // Should be trimmed
        password: password,
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await usecase(const LoginParams(email: emailWithSpaces, password: password));

      // Assert
      expect(result, Right(expectedUser));
      verify(() => mockRepository.login(email: AuthFixtures.validEmail, password: password)).called(1);
    });

    test('should handle case-insensitive admin email check', () async {
      // Arrange
      const adminEmailVariations = [
        'admin@example.com',
        'Admin@example.com',
        'ADMIN@example.com',
        'user@admin.com',
        'user@Admin.com',
      ];
      const password = AuthFixtures.validPassword;

      for (final adminEmail in adminEmailVariations) {
        // Act
        final result = await usecase(LoginParams(email: adminEmail, password: password));

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<ValidationFailure>());
            expect(failure.message, contains('Admin login not allowed'));
          },
          (user) => fail('Expected failure but got user for email: $adminEmail'),
        );
      }

      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should validate email format correctly', () async {
      // Arrange
      const invalidEmails = [
        'invalid',
        '@example.com',
        'user@',
        'user..name@example.com',
        'user@.com',
        'user@example.',
      ];
      const password = AuthFixtures.validPassword;

      for (final invalidEmail in invalidEmails) {
        // Act
        final result = await usecase(LoginParams(email: invalidEmail, password: password));

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (user) => fail('Expected failure but got user for email: $invalidEmail'),
        );
      }

      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should validate password requirements correctly', () async {
      // Arrange
      const invalidPasswords = [
        '123', // Too short
        '', // Empty
        'password', // No numbers or special chars
      ];
      const email = AuthFixtures.validEmail;

      for (final invalidPassword in invalidPasswords) {
        // Act
        final result = await usecase(LoginParams(email: email, password: invalidPassword));

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (user) => fail('Expected failure but got user for password: $invalidPassword'),
        );
      }

      verifyNever(() => mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('should allow valid credentials', () async {
      // Arrange
      const validEmails = [
        'user@example.com',
        'test.email@domain.co.uk',
        'user+tag@example.org',
        'user123@test-domain.com',
      ];
      const validPasswords = [
        'ValidPass123!',
        'MySecure@Password',
        'Test123456',
      ];

      for (final email in validEmails) {
        for (final password in validPasswords) {
          final expectedUser = AuthFixtures.testUser;

          when(() => mockRepository.login(
            email: email,
            password: password,
          )).thenAnswer((_) async => Right(expectedUser));

          // Act
          final result = await usecase(LoginParams(email: email, password: password));

          // Assert
          expect(result, Right(expectedUser));
          verify(() => mockRepository.login(email: email, password: password)).called(1);

          // Reset mock for next iteration
          reset(mockRepository);
        }
      }
    });
  });
}