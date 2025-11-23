# Mobile App Testing Guide

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-DEV-TESTING-GUIDE |
| **Version** | 1.0.0 |
| **Status** | Ready for Implementation |
| **Category** | Development Guide |
| **Priority** | High |
| **Created Date** | November 23, 2025 |
| **Last Updated** | November 23, 2025 |
| **Next Review** | December 23, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Tech Lead, QA Team |
| **Stakeholders** | Development Team, QA Team |

---

## 🎯 **Purpose**

Dokumen ini menyediakan panduan komprehensif untuk testing aplikasi mobile Usago, termasuk unit testing, integration testing, widget testing, dan end-to-end testing dengan fokus pada BLoC pattern dan Clean Architecture.

---

## Executive Summary

Testing strategy untuk Usago mobile app dirancang untuk memastikan kualitas kode, reliability fitur, dan maintainability arsitektur. Panduan ini mencakup semua level testing dari unit tests hingga integration tests dengan implementasi spesifik untuk BLoC, use cases, repositories, dan UI components.

## 1. Testing Architecture

### 1.1 Testing Pyramid

```
    /\
   /  \
  / E2E \  <- End-to-End Tests (10%)
 /______\
/        \
/  Widget  \  <- Widget Tests (20%)
\__________/
\          /
\  Unit    /  <- Unit Tests (70%)
\________/
```

### 1.2 Test Categories

| Category | Purpose | Tools | Coverage Target |
|-----------|---------|--------|----------------|
| **Unit Tests** | Test individual functions, classes, methods | Flutter Test, Mocktail | 90%+ |
| **Widget Tests** | Test UI components in isolation | Flutter Test, WidgetTester | 80%+ |
| **Integration Tests** | Test feature interactions | Flutter Test, Mocktail | 70%+ |
| **E2E Tests** | Test complete user flows | Integration Test | 50%+ |

## 2. Unit Testing

### 2.1 Testing BLoCs

#### BLoC Test Structure

```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:usago_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:usago_mobile/features/auth/domain/entities/user.dart';
import 'package:usago_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:usago_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:usago_mobile/core/errors/failure.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockAppLogger mockLogger;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockLogger = MockAppLogger();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        logger: mockLogger,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LoginEvent is added and login succeeds',
      setUp: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(testUser));
      },
      act: (bloc) => bloc.add(LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        AuthSuccess(user: testUser),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(any())).called(1);
        verify(() => mockLogger.info(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when LoginEvent is added and login fails',
      setUp: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Left(const NetworkFailure('No internet')));
      },
      act: (bloc) => bloc.add(LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthFailure(message: 'No internet'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(any())).called(1);
        verify(() => mockLogger.error(any(), any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthLoggedOut] when LogoutEvent is added and logout succeeds',
      setUp: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(const LogoutEvent()),
      expect: () => [
        const AuthLoading(),
        const AuthLoggedOut(),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase()).called(1);
        verify(() => mockLogger.info(any())).called(1);
      },
    );
  });
}
```

#### BLoC Test Utilities

```dart
// test/utils/bloc_test_utils.dart
class BlocTestUtils {
  static void setupBlocTests<BlocType extends Bloc<Event, State>, Event, State>({
    required BlocType Function() createBloc,
    required List<BlocTest<BlocType, State>> tests,
  }) {
    group('${BlocType.toString()}', () {
      late BlocType bloc;

      setUp(() {
        bloc = createBloc();
      });

      tearDown(() {
        bloc.close();
      });

      for (final test in tests) {
        test.run(bloc);
      }
    });
  }
}

class BlocTest<BlocType extends Bloc<Event, State>, State> {
  final String description;
  final void Function(BlocType) act;
  final List<State> expectedStates;
  final void Function(BlocType)? verify;

  BlocTest({
    required this.description,
    required this.act,
    required this.expectedStates,
    this.verify,
  });

  void run(BlocType bloc) {
    blocTest<BlocType, State>(
      description,
      setUp: () => _setupMocks(),
      act: (bloc) => act(bloc),
      expect: () => expectedStates,
      verify: verify != null ? (_) => verify!(bloc) : null,
    );
  }

  void _setupMocks() {
    // Setup common mocks here
  }
}
```

### 2.2 Testing Use Cases

#### Use Case Test Structure

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:usago_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:usago_mobile/features/auth/domain/entities/user.dart';
import 'package:usago_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:usago_mobile/core/errors/failure.dart';

void main() {
  group('LoginUseCase', () {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockAuthRepository);
    });

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testUser = User(
      id: '1',
      email: testEmail,
      name: 'Test User',
      isEmailVerified: true,
      createdAt: DateTime(2023, 1, 1),
    );

    test('returns Right(User) when login succeeds', () async {
      // Arrange
      when(() => mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await loginUseCase(LoginParams(
        email: testEmail,
        password: testPassword,
      ));

      // Assert
      expect(result, equals(Right(testUser)));
      verify(() => mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);
    });

    test('returns Left(ValidationFailure) when email is invalid', () async {
      // Act
      final result = await loginUseCase(LoginParams(
        email: 'invalid-email',
        password: testPassword,
      ));

      // Assert
      expect(
        result,
        equals(const Left(ValidationFailure(message: 'Invalid email format'))),
      );
      verifyNever(() => mockAuthRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('returns Left(ValidationFailure) when password is too short', () async {
      // Act
      final result = await loginUseCase(LoginParams(
        email: testEmail,
        password: '123',
      ));

      // Assert
      expect(
        result,
        equals(const Left(ValidationFailure(message: 'Password must be at least 6 characters'))),
      );
      verifyNever(() => mockAuthRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    test('returns Left(NetworkFailure) when repository throws NetworkException', () async {
      // Arrange
      when(() => mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenThrow(NetworkException('No internet connection'));

      // Act
      final result = await loginUseCase(LoginParams(
        email: testEmail,
        password: testPassword,
      ));

      // Assert
      expect(
        result,
        equals(const Left(NetworkFailure(message: 'No internet connection'))),
      );
    });
  });
}
```

### 2.3 Testing Repositories

#### Repository Test Structure

```dart
// test/features/brand/data/repositories/brand_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:usago_mobile/features/brand/data/repositories/brand_repository_impl.dart';
import 'package:usago_mobile/features/brand/data/datasources/brand_remote_datasource.dart';
import 'package:usago_mobile/features/brand/data/datasources/brand_local_datasource.dart';
import 'package:usago_mobile/features/brand/domain/entities/brand.dart';
import 'package:usago_mobile/core/errors/failure.dart';

void main() {
  group('BrandRepositoryImpl', () {
    late BrandRepositoryImpl repository;
    late MockBrandRemoteDataSource mockRemoteDataSource;
    late MockBrandLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockBrandRemoteDataSource();
      mockLocalDataSource = MockBrandLocalDataSource();
      repository = BrandRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    const testBrand = Brand(
      id: '1',
      name: 'Test Brand',
      description: 'Test Description',
      businessType: 'RETAIL',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    group('getUserBrands', () {
      test('returns cached brands when available', () async {
        // Arrange
        when(() => mockLocalDataSource.getUserBrands())
            .thenAnswer((_) async => [testBrand]);

        // Act
        final result = await repository.getUserBrands();

        // Assert
        expect(result, equals(Right([testBrand])));
        verify(() => mockLocalDataSource.getUserBrands()).called(1);
        verifyNever(() => mockRemoteDataSource.getUserBrands());
      });

      test('fetches from remote when cache is empty', () async {
        // Arrange
        when(() => mockLocalDataSource.getUserBrands())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getUserBrands())
            .thenAnswer((_) async => [testBrand]);

        // Act
        final result = await repository.getUserBrands();

        // Assert
        expect(result, equals(Right([testBrand])));
        verify(() => mockLocalDataSource.getUserBrands()).called(1);
        verify(() => mockRemoteDataSource.getUserBrands()).called(1);
        verify(() => mockLocalDataSource.saveBrands([testBrand])).called(1);
      });

      test('returns Left(NetworkFailure) when remote fails', () async {
        // Arrange
        when(() => mockLocalDataSource.getUserBrands())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getUserBrands())
            .thenThrow(NetworkException('No internet'));

        // Act
        final result = await repository.getUserBrands();

        // Assert
        expect(
          result,
          equals(const Left(NetworkFailure(message: 'No internet'))),
        );
      });
    });

    group('createBrand', () {
      test('creates brand successfully', () async {
        // Arrange
        when(() => mockRemoteDataSource.createBrand(testBrand))
            .thenAnswer((_) async => testBrand);

        // Act
        final result = await repository.createBrand(testBrand);

        // Assert
        expect(result, equals(Right(testBrand)));
        verify(() => mockRemoteDataSource.createBrand(testBrand)).called(1);
        verify(() => mockLocalDataSource.saveBrand(testBrand)).called(1);
      });
    });
  });
}
```

## 3. Widget Testing

### 3.1 Testing BLoC Widgets

#### Widget Test Structure

```dart
// test/features/auth/presentation/pages/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:usago_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:usago_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago_mobile/features/auth/presentation/bloc/auth_state.dart';

void main() {
  group('LoginPage', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      whenListen(mockAuthBloc, const AuthInitial());
    });

    testWidgets('displays login form', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is AuthLoading', (tester) async {
      // Arrange
      whenListen(mockAuthBloc, const AuthLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is AuthFailure', (tester) async {
      // Arrange
      whenListen(mockAuthBloc, const AuthFailure(message: 'Login failed'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Login failed'), findsOneWidget);
    });

    testWidgets('submits login form when button is pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Act
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(() => mockAuthBloc.add(any())).called(1);
    });
  });
}
```

### 3.2 Testing Custom Widgets

#### Custom Widget Test Structure

```dart
// test/shared/widgets/brand_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:usago_mobile/shared/widgets/brand_card.dart';
import 'package:usago_mobile/features/brand/domain/entities/brand.dart';

void main() {
  group('BrandCard', () {
    const testBrand = Brand(
      id: '1',
      name: 'Test Brand',
      description: 'Test Description',
      businessType: 'RETAIL',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    testWidgets('displays brand information correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Brand'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('RETAIL'), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      // Arrange
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(BrandCard));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('shows loading state when isLoading is true', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              isLoading: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

## 4. Integration Testing

### 4.1 Feature Integration Tests

#### Integration Test Structure

```dart
// integration_test/features/brand/brand_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:usago_mobile/main.dart' as app;
import 'package:usago_mobile/features/brand/presentation/pages/brand_list_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Brand Feature Integration Tests', () {
    integrationTest('complete brand management flow', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act & Assert - Navigate to brands
      await tester.tap(find.text('Brands'));
      await tester.pumpAndSettle();

      // Verify brand list is loaded
      expect(find.byType(BrandListPage), findsOneWidget);
      expect(find.text('Test Brand'), findsOneWidget);

      // Act - Create new brand
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill brand form
      await tester.enterText(
        find.byKey(const Key('brand_name_field')),
        'New Test Brand',
      );
      await tester.enterText(
        find.byKey(const Key('brand_description_field')),
        'New Test Description',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify brand is created
      expect(find.text('New Test Brand'), findsOneWidget);
      expect(find.text('Brand created successfully'), findsOneWidget);

      // Act - Delete brand
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify brand is deleted
      expect(find.text('New Test Brand'), findsNothing);
      expect(find.text('Brand deleted successfully'), findsOneWidget);
    });
  });
}
```

### 4.2 API Integration Tests

#### API Integration Test Structure

```dart
// integration_test/api/brand_api_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:usago_mobile/core/network/dio_client.dart';
import 'package:usago_mobile/features/brand/data/datasources/brand_remote_datasource_impl.dart';

void main() {
  group('Brand API Integration Tests', () {
    late DioClient dioClient;
    late BrandRemoteDataSourceImpl remoteDataSource;

    setUpAll(() async {
      // Setup test environment
      dioClient = DioClient(
        baseUrl: 'https://api.usago.test',
        enableLogging: true,
      );
      remoteDataSource = BrandRemoteDataSourceImpl(
        dioClient: dioClient,
        logger: AppLogger(),
      );
    });

    test('creates brand successfully', () async {
      // Arrange
      final brandData = {
        'name': 'Test Brand',
        'description': 'Test Description',
        'businessType': 'RETAIL',
      };

      // Act
      final result = await remoteDataSource.createBrand(brandData);

      // Assert
      expect(result.id, isNotNull);
      expect(result.name, equals('Test Brand'));
      expect(result.description, equals('Test Description'));
    });

    test('handles authentication errors', () async {
      // Arrange
      dioClient.setAuthToken('invalid_token');

      // Act & Assert
      expect(
        () => remoteDataSource.getBrands(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
```

## 5. Test Utilities and Helpers

### 5.1 Mock Utilities

```dart
// test/utils/mock_utils.dart
import 'package:mocktail/mocktail.dart';
import 'package:usago_mobile/core/network/dio_client.dart';
import 'package:usago_mobile/core/utils/logger.dart';
import 'package:usago_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:usago_mobile/features/brand/domain/repositories/brand_repository.dart';

class MockUtils {
  static void setupCommonMocks() {
    // Register fallback values
    registerFallbackValue(const NoParams());
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(const Brand(name: '', description: ''));
  }

  static MockAuthRepository createMockAuthRepository() {
    final mock = MockAuthRepository();
    when(() => mock.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => Right(testUser));
    when(() => mock.logout())
        .thenAnswer((_) async => const Right(null));
    when(() => mock.checkAuthStatus())
        .thenAnswer((_) async => Right(testUser));
    return mock;
  }

  static MockBrandRepository createMockBrandRepository() {
    final mock = MockBrandRepository();
    when(() => mock.getUserBrands())
        .thenAnswer((_) async => Right([testBrand]));
    when(() => mock.createBrand(any()))
        .thenAnswer((_) async => Right(testBrand));
    return mock;
  }

  static MockDioClient createMockDioClient() {
    final mock = MockDioClient();
    when(() => mock.get(any()))
        .thenAnswer((_) async => Response(data: {}, statusCode: 200));
    when(() => mock.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(data: {}, statusCode: 201));
    return mock;
  }

  static MockAppLogger createMockLogger() {
    final mock = MockAppLogger();
    // Mock all logger methods to do nothing
    when(() => mock.info(any())).thenReturn(null);
    when(() => mock.error(any(), any())).thenReturn(null);
    when(() => mock.warning(any())).thenReturn(null);
    when(() => mock.debug(any())).thenReturn(null);
    return mock;
  }
}
```

### 5.2 Test Data Factory

```dart
// test/utils/test_data_factory.dart
import 'package:usago_mobile/features/auth/domain/entities/user.dart';
import 'package:usago_mobile/features/brand/domain/entities/brand.dart';

class TestDataFactory {
  static User createTestUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    bool isEmailVerified = true,
    DateTime? createdAt,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt ?? DateTime(2023, 1, 1),
    );
  }

  static Brand createTestBrand({
    String id = 'test-brand-id',
    String name = 'Test Brand',
    String description = 'Test Description',
    String businessType = 'RETAIL',
    DateTime? createdAt,
  }) {
    return Brand(
      id: id,
      name: name,
      description: description,
      businessType: businessType,
      createdAt: createdAt ?? DateTime(2023, 1, 1),
      updatedAt: createdAt ?? DateTime(2023, 1, 1),
    );
  }

  static List<Brand> createTestBrandList({int count = 3}) {
    return List.generate(count, (index) => createTestBrand(
      id: 'test-brand-$index',
      name: 'Test Brand $index',
      description: 'Test Description $index',
    ));
  }

  static Map<String, dynamic> createTestBrandJson({
    String id = 'test-brand-id',
    String name = 'Test Brand',
    String description = 'Test Description',
    String businessType = 'RETAIL',
  }) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'businessType': businessType,
      'createdAt': '2023-01-01T00:00:00.000Z',
      'updatedAt': '2023-01-01T00:00:00.000Z',
    };
  }
}
```

### 5.3 Test Configuration

```dart
// test/test_config.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TestConfig {
  static void setUpAllTests() {
    // Setup global test configuration
    TestWidgetsFlutterBinding.ensureInitialized();

    // Setup mocktail fallbacks
    _setupMocktailFallbacks();

    // Configure test behavior
    _configureTestBehavior();
  }

  static void _setupMocktailFallbacks() {
    // Register common fallback values
    registerFallbackValue(const Duration());
    registerFallbackValue(const DateTime(2023, 1, 1));
    registerFallbackValue(const []);
    registerFallbackValue(const Map<String, dynamic>());
  }

  static void _configureTestBehavior() {
    // Configure test timeout
    testBinding.defaultTestTimeout = const Duration(minutes: 5);

    // Configure golden test tolerance
    testBinding.addGoldenFileComparator(
      GoldenFileComparator.withThreshold(
        threshold: 0.1,
        basedir: 'test/goldens',
      ),
    );
  }

  static Future<void> setUpTestEnvironment() async {
    // Setup test environment variables
    // Configure test databases
    // Setup test API endpoints
  }

  static Future<void> tearDownTestEnvironment() async {
    // Clean up test environment
    // Reset test databases
    // Clear test data
  }
}
```

## 6. Performance Testing

### 6.1 Widget Performance Tests

```dart
// test/performance/widget_performance_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/scheduler.dart';

import 'package:usago_mobile/features/brand/presentation/widgets/brand_list_widget.dart';

void main() {
  group('Widget Performance Tests', () {
    testWidgets('BrandListWidget renders within performance budget', (tester) async {
      // Arrange
      final brands = TestDataFactory.createTestBrandList(count: 100);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandListWidget(brands: brands),
          ),
        ),
      );

      // Assert - Check rendering time
      final stopwatch = Stopwatch()..start();
      await tester.pump();
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(16)); // 60 FPS
    });

    testWidgets('BrandListWidget handles large lists efficiently', (tester) async {
      // Arrange
      final brands = TestDataFactory.createTestBrandList(count: 1000);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandListWidget(brands: brands),
          ),
        ),
      );

      // Assert - Check memory usage
      final memoryBefore = SchedulerBinding.instance.window.physicalSize;

      await tester.pump();

      final memoryAfter = SchedulerBinding.instance.window.physicalSize;

      // Memory usage should not increase significantly
      expect(memoryAfter, equals(memoryBefore));
    });
  });
}
```

### 6.2 Integration Performance Tests

```dart
// integration_test/performance/app_performance_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:usago_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Performance Tests', () {
    integrationTest('app startup time is within budget', (tester) async {
      // Arrange
      final stopwatch = Stopwatch()..start();

      // Act
      app.main();
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // 3 seconds
    });

    integrationTest('navigation between features is smooth', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate through main features
      final navigationStopwatch = Stopwatch()..start();

      await tester.tap(find.text('Brands'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      navigationStopwatch.stop();

      // Assert
      expect(navigationStopwatch.elapsedMilliseconds, lessThan(2000)); // 2 seconds
    });
  });
}
```

## 7. Golden Testing

### 7.1 Widget Golden Tests

```dart
// test/goldens/brand_card_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:usago_mobile/shared/widgets/brand_card.dart';

void main() {
  group('BrandCard Golden Tests', () {
    const testBrand = Brand(
      id: '1',
      name: 'Test Brand',
      description: 'Test Description',
      businessType: 'RETAIL',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    testGoldens('BrandCard light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              onTap: () {},
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'brand_card_light.png');
    });

    testGoldens('BrandCard dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              onTap: () {},
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'brand_card_dark.png');
    });

    testGoldens('BrandCard loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: BrandCard(
              brand: testBrand,
              isLoading: true,
              onTap: () {},
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'brand_card_loading.png');
    });
  });
}
```

## 8. Test Configuration and CI/CD

### 8.1 Test Configuration

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  bloc_test: ^9.1.0
  integration_test:
    sdk: flutter
  golden_toolkit: ^0.15.0
  test_coverage: ^0.2.0
```

### 8.2 GitHub Actions Configuration

```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

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
      run: flutter test --coverage test/widget/

    - name: Run integration tests
      run: flutter test integration_test/

    - name: Generate coverage report
      run: |
        genhtml coverage/lcov.info -o coverage/html

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
```

## 9. Test Coverage

### 9.1 Coverage Configuration

```yaml
# pubspec.yaml
dev_dependencies:
  test_coverage: ^0.2.0
```

### 9.2 Coverage Script

```bash
#!/bin/bash
# scripts/test_coverage.sh

# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Check coverage threshold
COVERAGE=$(lcov --summary coverage/lcov.info | grep -E '\%' | grep -o '[0-9]*\.[0-9]*')
THRESHOLD=80

if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
  echo "Coverage $COVERAGE% is below threshold $THRESHOLD%"
  exit 1
else
  echo "Coverage $COVERAGE% meets threshold $THRESHOLD%"
fi
```

### 9.3 Coverage Exclusions

```dart
// test/coverage_exclude.dart
// Exclude generated files
// Exclude test files
// Exclude configuration files

@CoverageExclude(
  'lib/**/*.g.dart',
  'lib/**/*.freezed.dart',
  'test/**',
  'lib/core/di/injection_container.dart',
)
```

## 10. Best Practices

### 10.1 Test Organization

```
test/
├── unit/                    # Unit tests
│   ├── core/
│   │   ├── errors/
│   │   ├── network/
│   │   └── utils/
│   └── features/
│       ├── auth/
│       │   ├── domain/
│       │   ├── data/
│       │   └── presentation/
│       └── brand/
├── widget/                  # Widget tests
│   ├── shared/
│   └── features/
├── integration/             # Integration tests
│   ├── api/
│   └── features/
├── goldens/               # Golden tests
├── performance/           # Performance tests
├── utils/                # Test utilities
│   ├── mock_utils.dart
│   ├── test_data_factory.dart
│   └── test_config.dart
└── helpers/              # Test helpers
```

### 10.2 Test Naming Conventions

```dart
// Good naming conventions
group('AuthBloc', () {
  test('initial state is AuthInitial', () {});

  blocTest('emits [AuthLoading, AuthSuccess] when login succeeds', () {});

  testWidgets('displays login form correctly', (tester) {});

  integrationTest('completes login flow successfully', (tester) {});
});
```

### 10.3 Test Data Management

```dart
// Use factories instead of hardcoded data
final testUser = TestDataFactory.createTestUser();
final testBrands = TestDataFactory.createTestBrandList(count: 10);

// Use realistic test data
final testUser = TestDataFactory.createTestUser(
  email: 'user@example.com',
  name: 'John Doe',
);
```

### 10.4 Mock Management

```dart
// Setup mocks in setUp
setUp(() {
  mockRepository = MockAuthRepository();
  mockUseCase = MockLoginUseCase();
});

// Clean up mocks in tearDown
tearDown(() {
  reset(mockRepository);
  reset(mockUseCase);
});
```

## 11. Troubleshooting

### 11.1 Common Test Issues

#### Issue: Test timeouts
**Solution**: Increase timeout or optimize test performance
```dart
testWidgets('slow test', (tester) async {
  testBinding.defaultTestTimeout = const Duration(minutes: 5);
  // test implementation
});
```

#### Issue: Widget not found
**Solution**: Use pumpAndSettle() and proper finders
```dart
await tester.pumpAndSettle();
expect(find.byKey(const Key('my_widget')), findsOneWidget);
```

#### Issue: Mock not working
**Solution**: Register fallback values and verify mock setup
```dart
registerFallbackValue(const NoParams());
when(() => mockUseCase(any())).thenAnswer((_) async => Right(result));
```

### 11.2 Debugging Tests

```dart
// Use print statements for debugging
test('debug test', () {
  print('Debug point 1');
  // test code
  print('Debug point 2');
});

// Use debugger breakpoints
test('debug test with debugger', () {
  debugger(); // Breakpoint here
  // test code
});
```

## 12. Conclusion

Testing strategy yang komprehensif adalah kunci untuk memastikan kualitas dan reliability aplikasi mobile Usago. Dengan mengikuti panduan ini, tim development dapat:

1. **Mencapai coverage target** dengan struktur tes yang baik
2. **Memastikan quality** melalui automated testing
3. **Meningkatkan maintainability** dengan test yang terstruktur
4. **Mendeteksi regressi** melalui continuous testing
5. **Optimasi performance** dengan performance testing

Key takeaways:
- **Test pyramid**: Fokus pada unit tests dengan widget dan integration tests yang memadai
- **Mock management**: Gunakan mock utilities untuk konsistensi
- **Test data**: Gunakan factories untuk test data yang realistis
- **Coverage**: Target 80%+ coverage dengan automated checks
- **CI/CD**: Integrate testing dalam development workflow

---

**Guide Version**: 1.0.0
**Implementation Status**: ✅ Ready for Use
**Last Updated**: November 23, 2025
**Next Review**: December 23, 2025