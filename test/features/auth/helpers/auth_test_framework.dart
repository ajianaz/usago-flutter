/// Authentication Test Framework
/// Provides standardized testing patterns for auth feature
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/core/errors/failure.dart';
import 'mock_repositories.mocks.dart';
import 'auth_test_helpers.dart';

/// Factory for creating mock repositories
class AuthMockFactory {
  /// Creates a mock repository with default setup
  static MockAuthRepository createRepository() {
    return MockAuthRepository();
  }
}

/// Setup methods for mocks
class AuthMockSetup {
  /// Setup successful login mock
  static void setupLoginSuccess(MockAuthRepository mock, User user) {
    when(mock.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(user));
  }
}

/// Verification methods for mocks
class AuthMockVerification {
  /// Verify login was never called
  static void verifyLoginNeverCalled(MockAuthRepository mock) {
    verifyNever(mock.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    ));
  }
}

/// Test runner for standardized test scenarios
class AuthTestRunner<T> {
  final String featureName;
  final MockAuthRepository mockRepository;
  final Future<Either<Failure, dynamic>> Function(T) useCaseFunction;

  AuthTestRunner({
    required this.featureName,
    required this.mockRepository,
    required this.useCaseFunction,
  });

  /// Run all test scenarios
  void runScenarios(List<Map<String, dynamic>> scenarios) {
    group('$featureName Standard Scenarios', () {
      for (final scenario in scenarios) {
        test(scenario['description'], () async {
          final result = await useCaseFunction(scenario['params'] as T);

          if (scenario['shouldSucceed']) {
            expect(result.isRight(), isTrue);
          } else {
            expect(result.isLeft(), isTrue);
          }
        });
      }
    });
  }
}

/// Factory for creating test data
class AuthTestDataFactory {
  /// Create login test scenarios
  static List<Map<String, dynamic>> createLoginScenarios() {
    return [
      {
        'description': 'Valid credentials',
        'params': {'email': 'test@example.com', 'password': 'Password123!'},
        'shouldSucceed': true,
      },
      {
        'description': 'Invalid email',
        'params': {'email': 'invalid-email', 'password': 'Password123!'},
        'shouldSucceed': false,
      },
      {
        'description': 'Invalid password',
        'params': {'email': 'test@example.com', 'password': '123'},
        'shouldSucceed': false,
      },
    ];
  }
}