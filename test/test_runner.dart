import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/auth/domain/entities/user_test.dart' as user_tests;
import 'unit/auth/data/models/user_model_test.dart' as user_model_tests;
import 'unit/auth/domain/usecases/login_usecase_test.dart' as login_usecase_tests;
import 'unit/auth/presentation/bloc/auth_bloc_test.dart' as auth_bloc_tests;
import 'unit/auth/data/repositories/auth_repository_impl_test.dart' as auth_repository_tests;
import 'integration/auth_flow_test.dart' as auth_flow_tests;

/// Main test runner for all auth feature tests
void main() {
  group('Auth Feature Tests', () {
    // Unit Tests
    user_tests.main();
    user_model_tests.main();
    login_usecase_tests.main();
    auth_bloc_tests.main();
    auth_repository_tests.main();

    // Integration Tests
    auth_flow_tests.main();
  });
}