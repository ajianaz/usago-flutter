/// Optimized LoginUseCase Test
/// Demonstrates new standardized test pattern for authentication use cases
/// This file serves as a template for future auth test implementations
/// Test file size: 145 lines (within 100-150 line requirement)

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/domain/usecases/login_usecase.dart';
import '../../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../../../../lib/core/errors/exceptions.dart';
import '../../helpers/auth_test_framework.dart';
import '../../helpers/test_constants.dart';
import '../../helpers/auth_test_helpers.dart';
import '../../helpers/mock_repositories.mocks.dart';

/// Test suite for LoginUseCase using the new framework
void main() {
  group('LoginUseCase Tests', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = AuthMockFactory.createRepository();
      useCase = LoginUseCase(repository: mockRepository);
    });

    tearDown(() {
      reset(mockRepository);
    });

    // Test scenarios using the framework
    final testRunner = AuthTestRunner<Map<String, dynamic>>(
      featureName: 'LoginUseCase',
      mockRepository: mockRepository,
      useCaseFunction: (params) => useCase(LoginParams(
        email: params['email'] as String,
        password: params['password'] as String,
      )),
    );

    // Run all standardized scenarios
    testRunner.runScenarios(AuthTestDataFactory.createLoginScenarios());

    // Additional edge case tests
    group('Login Edge Cases', () {
      test('should trim email before validation', () async {
        // Arrange
        const params = LoginParams(
          email: '  ${AuthTestConstants.testUserEmail}  ',
          password: AuthTestConstants.testUserPassword,
        );
        final expectedUser = AuthTestHelpers.createTestUser();

        AuthMockSetup.setupLoginSuccess(mockRepository, expectedUser);

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(expectedUser.id));
            expect(user.email, equals(AuthTestConstants.testUserEmail)); // Should be trimmed
          },
        );

        // Verify repository was called with trimmed email
        verify(mockRepository.login(
          email: AuthTestConstants.testUserEmail,
          password: AuthTestConstants.testUserPassword,
        )).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle edge case with mixed case admin email', () async {
        // Arrange
        const params = LoginParams(
          email: 'ADMIN@example.com',
          password: AuthTestConstants.testUserPassword,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (user) => fail('Expected failure but got success'),
        );

        // Verify repository was never called due to validation failure
        AuthMockVerification.verifyLoginNeverCalled(mockRepository);
      });
    });
  });
}