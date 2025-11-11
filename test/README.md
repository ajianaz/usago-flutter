# Auth Feature Tests

This directory contains comprehensive tests for the authentication feature of the USAGO application.

## Test Structure

```
test/
├── helpers/
│   └── test_helpers.dart          # Common test utilities and helpers
├── fixtures/
│   └── auth_fixtures.dart         # Test data and fixtures
├── mocks/
│   └── auth_mocks.dart           # Mock classes for testing
├── unit/
│   └── auth/
│       ├── domain/
│       │   └── entities/
│       │       └── user_test.dart           # User entity tests
│       ├── data/
│       │   ├── models/
│       │   │   └── user_model_test.dart    # UserModel tests
│       │   └── repositories/
│       │       └── auth_repository_impl_test.dart # Repository implementation tests
│       ├── domain/
│       │   └── usecases/
│       │       └── login_usecase_test.dart # Login usecase tests
│       └── presentation/
│           └── bloc/
│               └── auth_bloc_test.dart      # AuthBloc tests
├── widget/
│   └── auth/
│       └── login_form_test.dart          # LoginForm widget tests
├── integration/
│   ├── auth_flow_test.dart            # Auth flow integration tests
│   └── better_auth_connection_test.dart # Existing integration tests
├── test_runner.dart                   # Test runner for all tests
└── README.md                        # This file
```

## Test Categories

### Unit Tests

#### Domain Layer Tests
- **User Entity Tests** (`test/unit/auth/domain/entities/user_test.dart`)
  - Tests User entity creation, JSON serialization, copyWith, and utility methods
  - Validates business logic like `isNewUser`, `isActive`, `displayName`, `initials`

- **UserModel Tests** (`test/unit/auth/data/models/user_model_test.dart`)
  - Tests UserModel creation, JSON parsing, entity conversion
  - Handles error cases and edge cases in data transformation

- **Login Usecase Tests** (`test/unit/auth/domain/usecases/login_usecase_test.dart`)
  - Tests login business logic and validation
  - Validates email format, password requirements, and admin restrictions

#### Data Layer Tests
- **AuthRepositoryImpl Tests** (`test/unit/auth/data/repositories/auth_repository_impl_test.dart`)
  - Tests repository implementation with all CRUD operations
  - Mocks datasources and tests error handling

#### Presentation Layer Tests
- **AuthBloc Tests** (`test/unit/auth/presentation/bloc/auth_bloc_test.dart`)
  - Tests BLoC state management for all auth events
  - Validates state transitions and error handling

### Widget Tests

- **LoginForm Widget Tests** (`test/widget/auth/login_form_test.dart`)
  - Tests UI interactions, form validation, and user experience
  - Validates widget behavior in different states

### Integration Tests

- **Auth Flow Tests** (`test/integration/auth_flow_test.dart`)
  - Tests complete authentication flows end-to-end
  - Validates navigation between screens and state persistence

## Running Tests

### Run All Tests
```bash
dart run test/test_runner.dart
```

### Run Specific Test Categories
```bash
# Unit tests only
dart test test/unit/

# Widget tests only
dart test test/widget/

# Integration tests only
dart test test/integration/

# Specific test file
dart test test/unit/auth/domain/entities/user_test.dart
```

### Run with Coverage
```bash
dart run --coverage=test/test_runner.dart
```

## Test Utilities

### Fixtures
Located in `test/fixtures/auth_fixtures.dart`:
- Test user data
- Sample JSON responses
- Test credentials and tokens
- Common test scenarios

### Mocks
Located in `test/mocks/auth_mocks.dart`:
- Mock implementations for all auth interfaces
- Pre-configured mock behaviors
- Easy setup for test scenarios

### Helpers
Located in `test/helpers/test_helpers.dart`:
- Common test utilities
- Custom matchers
- Async test helpers

## Test Coverage Areas

### Authentication Operations
- [x] User login
- [x] User registration
- [x] Password reset
- [x] Email verification
- [x] Profile management
- [x] Account deletion

### Data Validation
- [x] Email format validation
- [x] Password strength validation
- [x] Form field validation
- [x] Business rule validation

### State Management
- [x] Loading states
- [x] Success states
- [x] Error states
- [x] State transitions

### User Interface
- [x] Form interactions
- [x] Navigation flows
- [x] Error display
- [x] Loading indicators

## Best Practices Followed

1. **Test Organization**
   - Tests grouped by feature and layer
   - Clear naming conventions
   - Logical file structure

2. **Test Isolation**
   - Each test is independent
   - Mocks used for external dependencies
   - No shared state between tests

3. **Comprehensive Coverage**
   - Happy path scenarios
   - Error conditions
   - Edge cases
   - Boundary conditions

4. **Readable Tests**
   - Arrange-Act-Assert pattern
   - Descriptive test names
   - Clear assertions

5. **Maintainable Tests**
   - Reusable fixtures
   - Common mock setup
   - Helper utilities

## Contributing

When adding new tests for the auth feature:

1. Follow the existing file structure
2. Use the provided fixtures and mocks
3. Add tests to the appropriate category
4. Update this README with new test coverage
5. Update the test runner if adding new test files

## Notes

- Tests use `mocktail` for mocking
- `flutter_test` for widget and integration tests
- `fpdart` patterns for repository testing
- All tests are designed to be fast and reliable
- Mock implementations are pre-configured for common scenarios