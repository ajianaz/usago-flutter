# Testing Strategies Rules
# Aturan Strategi Testing

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-TESTING-STRATEGIES |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | Testing Rules |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | QA Lead, Tech Lead |
| **Stakeholders** | Development Team, QA Team, Product Team |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan strategi dan aturan testing yang wajib diikuti dalam pengembangan aplikasi Usago Mobile. Strategi ini mencakup unit testing, widget testing, integration testing, dan end-to-end testing.

---

## 📚 **Table of Contents**

1. [Testing Pyramid Strategy](#testing-pyramid-strategy)
2. [Unit Testing Rules](#unit-testing-rules)
3. [Widget Testing Rules](#widget-testing-rules)
4. [Integration Testing Rules](#integration-testing-rules)
5. [End-to-End Testing Rules](#end-to-end-testing-rules)
6. [Test Data Management](#test-data-management)
7. [Test Environment Setup](#test-environment-setup)
8. [Test Automation Rules](#test-automation-rules)

---

## 🏔️ **Testing Pyramid Strategy**

### **Strategy 1.1: Testing Pyramid Composition**

Ikuti testing pyramid dengan distribusi yang tepat:

```
    ┌─────────────────────────────────────┐
    │         E2E Tests (10%)          │
    │     Critical User Journeys        │
    └─────────────────────────────────────┘
           ┌─────────────────────────────┐
           │      Integration (20%)      │
           │    Component Interactions    │
           └─────────────────────────────┘
                  ┌─────────────────────┐
                  │    Unit Tests (70%)   │
                  │  Business Logic & Utils │
                  └─────────────────────┘
```

### **Strategy 1.2: Test Coverage Requirements**

- **Unit Tests**: Minimum 80% coverage untuk business logic
- **Widget Tests**: Minimum 70% coverage untuk UI components
- **Integration Tests**: Minimum 60% coverage untuk user flows
- **E2E Tests**: Minimum 50% coverage untuk critical paths

```dart
// ✅ BENAR: Test coverage configuration
void main() {
  group('Test Coverage Example', () {
    test('should have adequate test coverage', () async {
      final coverage = await TestCoverageAnalyzer.analyze();

      expect(coverage.unitTestCoverage, greaterThanOrEqualTo(0.8));
      expect(coverage.widgetTestCoverage, greaterThanOrEqualTo(0.7));
      expect(coverage.integrationTestCoverage, greaterThanOrEqualTo(0.6));
      expect(coverage.e2eTestCoverage, greaterThanOrEqualTo(0.5));
    });
  });
}

// ❌ SALAH: No coverage requirements
void main() {
  test('some test', () {
    expect(1 + 1, equals(2));
  });
}
```

---

## 🧪 **Unit Testing Rules**

### **Rule 2.1: Test Structure**

Gunakan AAA pattern (Arrange, Act, Assert):

```dart
// ✅ BENAR: AAA pattern
void main() {
  group('PasswordValidator', () {
    test('should return false when password is shorter than 8 characters', () {
      // Arrange
      const password = '123';
      final validator = PasswordValidator();

      // Act
      final result = validator.isValid(password);

      // Assert
      expect(result, isFalse);
    });

    test('should return true when password meets all requirements', () {
      // Arrange
      const password = 'ValidPass123!';
      final validator = PasswordValidator();

      // Act
      final result = validator.isValid(password);

      // Assert
      expect(result, isTrue);
    });
  });
}

// ❌ SALAH: No clear structure
void main() {
  test('password validation', () {
    final validator = PasswordValidator();
    expect(validator.isValid('123'), false);
    expect(validator.isValid('ValidPass123!'), true);
  });
}
```

### **Rule 2.2: Test Naming Convention**

Gunakan descriptive test names dengan format: `should [expected behavior] when [condition]`:

```dart
// ✅ BENAR: Descriptive test names
void main() {
  group('UserRepository', () {
    group('getUser', () {
      test('should return user when user exists', () async {
        // Implementation
      });

      test('should return failure when user does not exist', () async {
        // Implementation
      });

      test('should return network failure when connection fails', () async {
        // Implementation
      });
    });
  });
}

// ❌ SALAH: Poor test names
void main() {
  group('UserRepository', () {
    test('test1', () async {
      // What is this testing?
    });

    test('getUser test', () async {
      // Not descriptive enough
    });
  });
}
```

### **Rule 2.3: Mock Usage**

Gunakan mocks dengan benar dan hanya untuk external dependencies:

```dart
// ✅ BENAR: Proper mock usage
void main() {
  group('AuthBloc', () {
    late MockAuthenticateUser mockAuthenticateUser;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthenticateUser = MockAuthenticateUser();
      authBloc = AuthBloc(mockAuthenticateUser);
    });

    tearDown(() {
      authBloc.close();
    });

    test('should emit AuthState.loaded when authentication succeeds', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final user = User.test();

      when(mockAuthenticateUser.call(any))
          .thenAnswer((_) async => const Right(user));

      // Act
      authBloc.add(const AuthenticateEvent(email: email, password: password));

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([
          const AuthState.loading(),
          const AuthState.loaded(user),
        ]),
      );
    });

    test('should emit AuthState.error when authentication fails', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrongpassword';
      final failure = AuthFailure.invalidCredentials();

      when(mockAuthenticateUser.call(any))
          .thenAnswer((_) async => const Left(failure));

      // Act
      authBloc.add(const AuthenticateEvent(email: email, password: password));

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([
          const AuthState.loading(),
          AuthState.error(failure),
        ]),
      );
    });
  });
}

// ❌ SALAH: Over-mocking
void main() {
  group('AuthBloc', () {
    test('should authenticate user', () async {
      // Mocking everything including the class being tested
      final mockAuthBloc = MockAuthBloc();

      when(mockAuthBloc.add(any)).thenReturn(null);

      mockAuthBloc.add(const AuthenticateEvent(email: 'test', password: 'test'));

      verify(mockAuthBloc.add(any)).called(1);
    });
  });
}
```

### **Rule 2.4: Edge Cases Testing**

Test edge cases dan boundary conditions:

```dart
// ✅ BENAR: Edge cases testing
void main() {
  group('EmailValidator', () {
    group('isValid', () {
      test('should handle null input', () {
        final validator = EmailValidator();
        expect(() => validator.isValid(null), throwsA(isA<ArgumentError>()));
      });

      test('should handle empty string', () {
        final validator = EmailValidator();
        expect(validator.isValid(''), isFalse);
      });

      test('should handle whitespace only', () {
        final validator = EmailValidator();
        expect(validator.isValid('   '), isFalse);
      });

      test('should handle maximum length email', () {
        final validator = EmailValidator();
        final longEmail = '${'a' * 240}@example.com';
        expect(validator.isValid(longEmail), isTrue);
      });

      test('should reject email exceeding maximum length', () {
        final validator = EmailValidator();
        final tooLongEmail = '${'a' * 250}@example.com';
        expect(validator.isValid(tooLongEmail), isFalse);
      });
    });
  });
}

// ❌ SALAH: No edge cases testing
void main() {
  group('EmailValidator', () {
    test('should validate email', () {
      final validator = EmailValidator();
      expect(validator.isValid('test@example.com'), isTrue);
    });
  });
}
```

---

## 🎨 **Widget Testing Rules**

### **Rule 3.1: Widget Test Structure**

Gunakan pumpAndSettle untuk async operations:

```dart
// ✅ BENAR: Proper widget test structure
void main() {
  group('LoginForm', () {
    testWidgets('should show validation error when email is invalid', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(MockAuthenticateUser()),
            child: const LoginForm(),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType<TextFormField>().first, 'invalid-email');
      await tester.tap(find.byType<ElevatedButton>());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should navigate to home when login succeeds', (tester) async {
      // Arrange
      final mockNavigatorObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(MockAuthenticateUser()),
            child: const LoginForm(),
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      // Act
      await tester.enterText(find.byType<TextFormField>().first, 'test@example.com');
      await tester.enterText(find.byType<TextFormField>().at(1), 'password123');
      await tester.tap(find.byType<ElevatedButton>());
      await tester.pumpAndSettle();

      // Assert
      verify(mockNavigatorObserver.didPush(any, any));
    });
  });
}

// ❌ SALAH: Incomplete widget test
void main() {
  testWidgets('login form test', (tester) async {
    await tester.pumpWidget(const LoginForm());

    await tester.tap(find.byType<ElevatedButton>());

    // No assertions
  });
}
```

### **Rule 3.2: Widget Testing Utilities**

Gunakan helper functions untuk common testing patterns:

```dart
// ✅ BENAR: Widget testing utilities
class WidgetTestHelpers {
  static Future<void> pumpAppWithBloc(
    WidgetTester tester, {
    required Widget child,
    AuthBloc? authBloc,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => authBloc ?? AuthBloc(MockAuthenticateUser()),
          child: child,
        ),
      ),
    );
  }

  static Future<void> enterTextAndDismissKeyboard(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  static Future<void> waitForAndTap(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle();
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }
}

// Usage
void main() {
  group('LoginForm', () {
    testWidgets('should submit form with valid data', (tester) async {
      await WidgetTestHelpers.pumpAppWithBloc(
        tester,
        child: const LoginForm(),
      );

      await WidgetTestHelpers.enterTextAndDismissKeyboard(
        tester,
        find.byType<TextFormField>().first,
        'test@example.com',
      );

      await WidgetTestHelpers.enterTextAndDismissKeyboard(
        tester,
        find.byType<TextFormField>().at(1),
        'password123',
      );

      await WidgetTestHelpers.waitForAndTap(
        tester,
        find.byType<ElevatedButton>(),
      );

      // Assertions
    });
  });
}

// ❌ SALAH: No testing utilities
void main() {
  testWidgets('login form test', (tester) async {
    await tester.pumpWidget(MaterialApp(home: const LoginForm()));

    await tester.enterText(find.byType<TextFormField>().first, 'test@example.com');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.enterText(find.byType<TextFormField>().at(1), 'password123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.byType<ElevatedButton>());
    await tester.pump();

    // Repetitive code without utilities
  });
}
```

### **Rule 3.3: Accessibility Testing**

Test accessibility features:

```dart
// ✅ BENAR: Accessibility testing
void main() {
  group('LoginForm Accessibility', () {
    testWidgets('should have proper semantic labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(MockAuthenticateUser()),
            child: const LoginForm(),
          ),
        ),
      );

      // Check semantic labels
      expect(
        find.bySemanticsLabel('Email'),
        findsOneWidget,
      );

      expect(
        find.bySemanticsLabel('Password'),
        findsOneWidget,
      );

      expect(
        find.bySemanticsLabel('Login'),
        findsOneWidget,
      );
    });

    testWidgets('should support screen reader', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(MockAuthenticateUser()),
            child: const LoginForm(),
          ),
        ),
      );

      // Check accessibility
      final semantics = tester.binding.pipelineOwner.semanticsOwner?.semantics;
      expect(semantics, isNotNull);

      // Check focusable elements
      final emailField = find.byType<TextFormField>().first;
      expect(tester.getSemantics(emailField), matchesSemantics(
        isFocusable: true,
        hasLabel: 'Email',
      ));
    });
  });
}

// ❌ SALAH: No accessibility testing
void main() {
  testWidgets('login form test', (tester) async {
    await tester.pumpWidget(const LoginForm());

    // No accessibility checks
  });
}
```

---

## 🔗 **Integration Testing Rules**

### **Rule 4.1: Integration Test Structure**

Gunakan integration tests untuk testing component interactions:

```dart
// ✅ BENAR: Integration test structure
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('should complete login flow successfully', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Act - Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Act - Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should be on home screen
      expect(find.byType<HomeScreen>(), findsOneWidget);
      expect(find.text('Welcome, test@example.com'), findsOneWidget);
    });

    testWidgets('should show error when login fails', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Act - Enter invalid credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');

      // Act - Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Assert - Should show error message
      expect(find.text('Invalid email or password'), findsOneWidget);
    });
  });
}

// ❌ SALAH: Incomplete integration test
void main() {
  testWidgets('login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // No complete flow testing
  });
}
```

### **Rule 4.2: Mock Services for Integration Tests**

Gunakan mock services untuk controlled testing:

```dart
// ✅ BENAR: Mock services for integration tests
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Profile Integration', () {
    late MockUserService mockUserService;

    setUp(() {
      mockUserService = MockUserService();
      GetIt.instance.registerSingleton<UserService>(mockUserService);
    });

    tearDown(() {
      GetIt.instance.unregister<UserService>();
    });

    testWidgets('should load and display user profile', (tester) async {
      // Arrange
      final user = User.test();
      when(mockUserService.getCurrentUser())
          .thenAnswer((_) async => user);

      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate to profile
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle();

      // Assert - Profile should be displayed
      expect(find.text(user.name), findsOneWidget);
      expect(find.text(user.email), findsOneWidget);
      verify(mockUserService.getCurrentUser()).called(1);
    });
  });
}

// ❌ SALAH: Real services in integration tests
void main() {
  testWidgets('user profile test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Using real API calls - unreliable for testing
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    // Test might fail due to network issues
  });
}
```

---

## 🌐 **End-to-End Testing Rules**

### **Rule 5.1: E2E Test Scenarios**

Test critical user journeys:

```dart
// ✅ BENAR: E2E test scenarios
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Critical User Journeys', () {
    testWidgets('complete user registration and login flow', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Register new user
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('name_field')), 'John Doe');
      await tester.enterText(find.byKey(const Key('email_field')), 'john@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'Password123!');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Registration successful
      expect(find.text('Registration successful'), findsOneWidget);

      // Act - Login with new account
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('email_field')), 'john@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Login successful
      expect(find.byType<HomeScreen>(), findsOneWidget);
      expect(find.text('Welcome, John Doe'), findsOneWidget);
    });

    testWidgets('complete product purchase flow', (tester) async {
      // Arrange - Login first
      await _loginUser(tester, 'buyer@example.com', 'Password123!');

      // Act - Browse products
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Product 1'));
      await tester.pumpAndSettle();

      // Act - Add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Act - Checkout
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();

      // Act - Complete payment
      await tester.enterText(find.byKey(const Key('card_number')), '4111111111111111');
      await tester.enterText(find.byKey(const Key('card_expiry')), '12/25');
      await tester.enterText(find.byKey(const Key('card_cvv')), '123');

      await tester.tap(find.text('Complete Purchase'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert - Purchase successful
      expect(find.text('Purchase successful'), findsOneWidget);
      expect(find.text('Order #12345'), findsOneWidget);
    });
  });
}

// ❌ SALAH: Incomplete E2E tests
void main() {
  testWidgets('user flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // No complete user journey testing
  });
}
```

### **Rule 5.2: Performance Testing in E2E**

Test performance metrics:

```dart
// ✅ BENAR: Performance testing in E2E
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Tests', () {
    testWidgets('should load home screen within performance limits', (tester) async {
      // Arrange
      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Assert - Load time should be under 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('should maintain 60 FPS during scrolling', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to product list
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();

      // Act - Scroll through list
      await tester.fling(
        find.byType<ListView>(),
        const Offset(0, -500),
        1000,
      );
      await tester.pumpAndSettle();

      // Assert - No frame drops
      final timeline = await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/scheduler',
        StringCodec().encodeMessage({'type': 'get_frame_timing'}),
        (data) {},
      );

      // Check for frame drops
      expect(timeline['dropped_frames'], lessThan(5));
    });
  });
}

// ❌ SALAH: No performance testing
void main() {
  testWidgets('performance test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // No performance metrics
  });
}
```

---

## 📊 **Test Data Management**

### **Rule 6.1: Test Data Factory**

Gunakan factory pattern untuk test data:

```dart
// ✅ BENAR: Test data factory
class UserFactory {
  static User create({
    String id = 'test-user-id',
    String name = 'Test User',
    String email = 'test@example.com',
    String avatar = 'https://example.com/avatar.jpg',
    bool isActive = true,
    DateTime? createdAt,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static List<User> createList(int count, {User? base}) {
    return List.generate(count, (index) {
      if (base != null) {
        return base.copyWith(
          id: '${base.id}_$index',
          email: 'user$index@example.com',
        );
      }

      return create(
        id: 'user_$index',
        name: 'User $index',
        email: 'user$index@example.com',
      );
    });
  }

  static User createWithInvalidEmail() {
    return create(email: 'invalid-email');
  }

  static User createInactive() {
    return create(isActive: false);
  }
}

// Usage in tests
void main() {
  group('UserRepository', () {
    test('should return user when user exists', () async {
      // Arrange
      final user = UserFactory.create();
      final repository = MockUserRepository();

      when(repository.getUser(user.id))
          .thenAnswer((_) async => Right(user));

      // Act
      final result = await repository.getUser(user.id);

      // Assert
      expect(result, Right(user));
    });
  });
}

// ❌ SALAH: Hardcoded test data
void main() {
  test('should return user when user exists', () async {
    final user = User(
      id: 'test-user-id',
      name: 'Test User',
      email: 'test@example.com',
      avatar: 'https://example.com/avatar.jpg',
      isActive: true,
      createdAt: DateTime.now(),
    );

    // Repetitive code for different test scenarios
  });
}
```

### **Rule 6.2: Test Data Cleanup**

Cleanup test data after each test:

```dart
// ✅ BENAR: Test data cleanup
void main() {
  group('UserRepository', () {
    late UserRepository repository;
    late DatabaseHelper databaseHelper;

    setUp(() async {
      databaseHelper = DatabaseHelper(inMemory: true);
      await databaseHelper.initialize();
      repository = UserRepository(databaseHelper);
    });

    tearDown(() async {
      await databaseHelper.cleanup();
    });

    test('should create and retrieve user', () async {
      // Arrange
      final user = UserFactory.create();

      // Act
      await repository.createUser(user);
      final retrievedUser = await repository.getUser(user.id);

      // Assert
      expect(retrievedUser, Right(user));
    });
  });
}

// ❌ SALAH: No test data cleanup
void main() {
  test('should create and retrieve user', () async {
    final repository = UserRepository(DatabaseHelper());

    final user = UserFactory.create();
    await repository.createUser(user);

    final retrievedUser = await repository.getUser(user.id);
    expect(retrievedUser, Right(user));

    // Test data remains in database
  });
}
```

---

## 🛠️ **Test Environment Setup**

### **Rule 7.1: Test Configuration**

Gunakan test configuration yang konsisten:

```dart
// ✅ BENAR: Test configuration
class TestConfiguration {
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(minutes: 2);

  static void setupTestEnvironment() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Configure test timeout
    TestWidgetsFlutterBinding.instance.defaultTestTimeout = defaultTimeout;

    // Configure logging
    Logger.level = Level.WARNING;

    // Configure mock services
    _setupMockServices();
  }

  static void _setupMockServices() {
    GetIt.instance.registerSingleton<ApiService>(MockApiService());
    GetIt.instance.registerSingleton<StorageService>(MockStorageService());
    GetIt.instance.registerSingleton<AuthService>(MockAuthService());
  }

  static void cleanupTestEnvironment() {
    GetIt.instance.reset();
  }
}

// Usage
void main() {
  setUpAll(() {
    TestConfiguration.setupTestEnvironment();
  });

  tearDownAll(() {
    TestConfiguration.cleanupTestEnvironment();
  });

  group('Test Group', () {
    // Tests
  });
}

// ❌ SALAH: No test configuration
void main() {
  testWidgets('some test', (tester) async {
    // No environment setup
  });
}
```

### **Rule 7.2: Test Isolation**

Ensure tests are isolated from each other:

```dart
// ✅ BENAR: Test isolation
void main() {
  group('Isolated Tests', () {
    late MockService mockService;

    setUp(() {
      mockService = MockService();
      GetIt.instance.registerSingleton<MockService>(mockService);
    });

    tearDown(() {
      GetIt.instance.unregister<MockService>();
    });

    test('test 1', () async {
      when(mockService.getData()).thenReturn('data1');
      final result = await mockService.getData();
      expect(result, 'data1');
    });

    test('test 2', () async {
      when(mockService.getData()).thenReturn('data2');
      final result = await mockService.getData();
      expect(result, 'data2');
    });
  });
}

// ❌ SALAH: Test leakage
void main() {
  late MockService mockService;

  setUp(() {
    mockService = MockService();
    GetIt.instance.registerSingleton<MockService>(mockService);
  });

  // No tearDown - tests will interfere with each other

  test('test 1', () async {
    when(mockService.getData()).thenReturn('data1');
    final result = await mockService.getData();
    expect(result, 'data1');
  });

  test('test 2', () async {
    // This test might be affected by test 1
    final result = await mockService.getData();
    expect(result, 'data2');
  });
}
```

---

## 🤖 **Test Automation Rules**

### **Rule 8.1: Continuous Integration**

Integrate tests in CI/CD pipeline:

```yaml
# ✅ BENAR: CI configuration
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run unit tests
        run: flutter test --coverage

      - name: Run widget tests
        run: flutter test integration_test/widget_tests/

      - name: Run integration tests
        run: flutter test integration_test/

      - name: Generate coverage report
        run: |
          flutter test --coverage
          genhtml coverage/lcov.info -o coverage/html

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### **Rule 8.2: Test Reporting**

Generate comprehensive test reports:

```dart
// ✅ BENAR: Test reporting
class TestReporter {
  static Future<void> generateReport() async {
    final unitTests = await _runUnitTests();
    final widgetTests = await _runWidgetTests();
    final integrationTests = await _runIntegrationTests();

    final report = TestReport(
      unitTests: unitTests,
      widgetTests: widgetTests,
      integrationTests: integrationTests,
      timestamp: DateTime.now(),
    );

    await _saveReport(report);
    await _uploadToDashboard(report);
  }

  static Future<TestResults> _runUnitTests() async {
    final results = await Process.run('flutter', ['test', '--coverage']);
    return TestResults(
      passed: _extractPassedCount(results.stdout),
      failed: _extractFailedCount(results.stdout),
      coverage: _extractCoverage(results.stdout),
    );
  }

  static Future<void> _saveReport(TestReport report) async {
    final file = File('test_report_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(report.toJson()));
  }
}
```

---

## ✅ **Testing Checklist**

### **Unit Testing**
- [ ] Test structure follows AAA pattern
- [ ] Test names are descriptive
- [ ] Edge cases are tested
- [ ] Mocks are used appropriately
- [ ] Test isolation is maintained
- [ ] Coverage requirements met

### **Widget Testing**
- [ ] pumpAndSettle used for async operations
- [ ] Accessibility features tested
- [ ] User interactions tested
- [ ] Widget states tested
- [ ] Error states tested
- [ ] Loading states tested

### **Integration Testing**
- [ ] Component interactions tested
- [ ] Mock services used
- [ ] Data flow tested
- [ ] Error scenarios tested
- [ ] Performance considered
- [ ] Cleanup performed

### **E2E Testing**
- [ ] Critical user journeys tested
- [ ] Performance metrics measured
- [ ] Realistic test data used
- [ ] Multiple devices tested
- [ ] Network conditions tested
- [ ] Error recovery tested

---

## 🔗 **Related Documentation**

- [`../code-review-checklist-rules.md`](./code-review-checklist-rules.md) - Code review checklist
- [`../flutter-development-guidelines.md`](./flutter-development-guidelines.md) - Flutter development guidelines
- [`../api-integration-patterns.md`](./api-integration-patterns.md) - API integration patterns
- [`../security-implementation-rules.md`](./security-implementation-rules.md) - Security implementation rules
- [`../performance-monitoring-rules.md`](./performance-monitoring-rules.md) - Performance monitoring rules

---

## 📞 **Contact Information**

### **Testing Team**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Test Strategy** | qa-team@usago.id | 4 hours |
| **Test Automation** | qa-team@usago.id | 2 hours |
| **Test Environment** | qa-team@usago.id | 4 hours |
| **Test Coverage** | qa-team@usago.id | 2 hours |

---

## 📝 **Notes**

### **Testing Tools**
- Flutter Test Framework
- Mockito for mocking
- Integration Test Framework
- Golden Tests for UI
- Code Coverage Tools
- Performance Testing Tools

### **Test Metrics**
- Code coverage percentage
- Test execution time
- Test success rate
- Performance benchmarks
- Accessibility compliance

---

**Document End**

**Go Digital, Grow Together.**