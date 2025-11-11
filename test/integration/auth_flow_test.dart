import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/app/app.dart';
import 'package:usago/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago/features/auth/presentation/bloc/auth_state.dart';
import 'package:usago/features/auth/presentation/pages/login_page.dart';
import 'package:usago/features/auth/presentation/pages/register_page.dart';
import '../fixtures/auth_fixtures.dart';
import '../mocks/auth_mocks.dart';

void main() {
  group('Authentication Flow Integration Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    testWidgets('should navigate through complete auth flow', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Start with login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Assert - Login page should be displayed
      expect(find.text('Login'), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      // Act - Navigate to register page
      await tester.tap(find.byKey(const Key('register_link')));
      await tester.pumpAndSettle();

      // Assert - Register page should be displayed
      expect(find.text('Register'), findsOneWidget);
      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);
    });

    testWidgets('should handle login success flow', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Enter valid credentials
      await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
      await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
      await tester.pump();

      // Simulate successful login
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthSuccess(user: AuthFixtures.testUser)));
      when(() => mockAuthBloc.state).thenReturn(AuthSuccess(user: AuthFixtures.testUser));

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Assert - Should show success state
      verify(() => mockAuthBloc.add(const LoginEvent(
        email: AuthFixtures.validEmail,
        password: AuthFixtures.validPassword,
      ))).called(1);
    });

    testWidgets('should handle login failure flow', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Enter invalid credentials
      await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.invalidEmail);
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      await tester.pump();

      // Simulate login failure
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthFailure(message: errorMessage)));
      when(() => mockAuthBloc.state).thenReturn(AuthFailure(message: errorMessage));

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Assert - Should show error message
      expect(find.text(errorMessage), findsOneWidget);
      verify(() => mockAuthBloc.add(const LoginEvent(
        email: AuthFixtures.invalidEmail,
        password: 'wrongpassword',
      ))).called(1);
    });

    testWidgets('should handle registration flow', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load register page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterPage(),
          ),
        ),
      );

      // Assert - Register page should be displayed
      expect(find.text('Register'), findsOneWidget);
      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_field')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);

      // Enter registration details
      await tester.enterText(find.byKey(const Key('name_field')), AuthFixtures.testUserName);
      await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
      await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
      await tester.enterText(find.byKey(const Key('confirm_password_field')), AuthFixtures.validPassword);
      await tester.pump();

      // Simulate successful registration
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthSuccess(user: AuthFixtures.testUser)));
      when(() => mockAuthBloc.state).thenReturn(AuthSuccess(user: AuthFixtures.testUser));

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      // Assert - Should call register event
      verify(() => mockAuthBloc.add(const RegisterEvent(
        email: AuthFixtures.validEmail,
        password: AuthFixtures.validPassword,
        name: AuthFixtures.testUserName,
      ))).called(1);
    });

    testWidgets('should handle loading states', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));
      when(() => mockAuthBloc.state).thenReturn(const AuthLoading());

      // Act - Load login page with loading state
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );
      await tester.pump();

      // Assert - Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsNothing);
    });

    testWidgets('should handle form validation', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Test email validation
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.tap(find.byKey(const Key('password_field')));
      await tester.pump();

      // Assert - Should show email error
      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Clear and test password validation
      await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('email_field')));
      await tester.pump();

      // Assert - Should show password error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);

      // Test valid form
      await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
      await tester.pump();

      // Assert - Login button should be enabled
      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(loginButton.onPressed, isNotNull);
    });

    testWidgets('should handle password visibility toggle', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Find and tap password visibility toggle
      final toggleButton = find.byKey(const Key('password_visibility_toggle'));
      expect(toggleButton, findsOneWidget);

      await tester.tap(toggleButton);
      await tester.pump();

      await tester.tap(toggleButton);
      await tester.pump();

      // Assert - Toggle should work without errors
      expect(toggleButton, findsOneWidget);
    });

    testWidgets('should handle keyboard navigation', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act - Load login page
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

      // Focus email field
      await tester.tap(find.byKey(const Key('email_field')));
      await tester.pump();

      // Test keyboard navigation
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Assert - Focus should move to password field
      expect(tester.binding.focusManager.primaryFocus?.debugLabel, contains('password'));

      // Test form submission
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Should attempt login
      verify(() => mockAuthBloc.add(any())).called(greaterThan(0));
    });
  });
}

// Mock AuthBloc for testing
class MockAuthBloc extends Mock implements AuthBloc {
  MockAuthBloc() : super();

  @override
  AuthState get state => const AuthInitial();

  @override
  Stream<AuthState> get stream => const Stream<AuthState>.empty();

  @override
  void add(AuthEvent event) {
    // Mock implementation
  }
}