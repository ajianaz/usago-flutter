// Auth Flow Integration Tests
// Purpose: Test complete authentication flows from UI to backend
// Follows Flutter development guidelines for testing structure and patterns

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago/features/auth/presentation/bloc/auth_state.dart';
import 'package:usago/features/auth/presentation/pages/login_page.dart';
import 'package:usago/features/auth/presentation/pages/register_page.dart';
import '../fixtures/auth_fixtures.dart';
import '../mocks/auth_bloc_mocks.dart';

/// Comprehensive integration tests for authentication flows
///
/// This test suite verifies:
/// - Complete user authentication workflows
/// - Navigation between authentication screens
/// - Form validation and error handling
/// - State management across the authentication flow
/// - User interaction patterns and edge cases
///
/// Test Structure:
/// - Follows Arrange-Act-Assert pattern consistently
/// - Uses proper mocking for external dependencies
/// - Includes comprehensive error scenarios
/// - Tests both happy path and edge cases
/// - Validates UI state changes and user feedback
void main() {
  group('Authentication Flow Integration Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    group('Navigation Flow Tests', () {
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

      testWidgets('should handle back navigation from register to login', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
        when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

        // Act - Start with register page
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>.value(
              value: mockAuthBloc,
              child: const RegisterPage(),
            ),
          ),
        );

        // Verify register page is displayed
        expect(find.text('Register'), findsOneWidget);

        // Act - Navigate back to login
        await tester.tap(find.byKey(const Key('login_link')));
        await tester.pumpAndSettle();

        // Assert - Login page should be displayed
        expect(find.text('Login'), findsOneWidget);
        expect(find.byKey(const Key('email_field')), findsOneWidget);
        expect(find.byKey(const Key('password_field')), findsOneWidget);
      });
    });

    group('Login Flow Tests', () {
      testWidgets('should handle successful login flow', (WidgetTester tester) async {
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

      testWidgets('should handle login failure with invalid credentials', (WidgetTester tester) async {
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

      testWidgets('should handle login with empty fields', (WidgetTester tester) async {
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

        // Try to login without entering credentials
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump();

        // Assert - Should show validation errors
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
      });

      testWidgets('should handle login with network error', (WidgetTester tester) async {
        // Arrange
        const networkErrorMessage = 'Network connection failed';
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

        // Enter credentials and simulate network error
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
        await tester.pump();

        when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthFailure(message: networkErrorMessage)));
        when(() => mockAuthBloc.state).thenReturn(AuthFailure(message: networkErrorMessage));

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Assert - Should show network error message
        expect(find.text(networkErrorMessage), findsOneWidget);
      });
    });

    group('Registration Flow Tests', () {
      testWidgets('should handle successful registration flow', (WidgetTester tester) async {
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

      testWidgets('should handle registration with password mismatch', (WidgetTester tester) async {
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

        // Enter registration details with mismatched passwords
        await tester.enterText(find.byKey(const Key('name_field')), AuthFixtures.testUserName);
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
        await tester.enterText(find.byKey(const Key('confirm_password_field')), 'differentpassword');
        await tester.pump();

        // Try to register
        await tester.tap(find.byKey(const Key('register_button')));
        await tester.pump();

        // Assert - Should show password mismatch error
        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('should handle registration with weak password', (WidgetTester tester) async {
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

        // Enter registration details with weak password
        await tester.enterText(find.byKey(const Key('name_field')), AuthFixtures.testUserName);
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.enterText(find.byKey(const Key('password_field')), '123');
        await tester.enterText(find.byKey(const Key('confirm_password_field')), '123');
        await tester.pump();

        // Try to register
        await tester.tap(find.byKey(const Key('register_button')));
        await tester.pump();

        // Assert - Should show weak password error
        expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      });
    });

    group('Loading State Tests', () {
      testWidgets('should display loading indicator during login', (WidgetTester tester) async {
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

      testWidgets('should display loading indicator during registration', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));
        when(() => mockAuthBloc.state).thenReturn(const AuthLoading());

        // Act - Load register page with loading state
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>.value(
              value: mockAuthBloc,
              child: const RegisterPage(),
            ),
          ),
        );
        await tester.pump();

        // Assert - Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byKey(const Key('register_button')), findsNothing);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should validate email format in real-time', (WidgetTester tester) async {
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

        // Clear and test valid email
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.pump();

        // Assert - Email error should disappear
        expect(find.text('Please enter a valid email'), findsNothing);
      });

      testWidgets('should validate password strength in real-time', (WidgetTester tester) async {
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

        // Test password validation
        await tester.enterText(find.byKey(const Key('password_field')), '123');
        await tester.tap(find.byKey(const Key('email_field')));
        await tester.pump();

        // Assert - Should show password error
        expect(find.text('Password must be at least 6 characters'), findsOneWidget);

        // Test valid password
        await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
        await tester.pump();

        // Assert - Password error should disappear
        expect(find.text('Password must be at least 6 characters'), findsNothing);
      });
    });

    group('User Interaction Tests', () {
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

        // Find and toggle password visibility
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

      testWidgets('should handle form submission with enter key', (WidgetTester tester) async {
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

        // Enter credentials and submit with enter
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        // Assert - Should trigger login
        verify(() => mockAuthBloc.add(const LoginEvent(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        ))).called(1);
      });
    });

    group('Error Recovery Tests', () {
      testWidgets('should recover from login error and retry', (WidgetTester tester) async {
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

        // Enter invalid credentials and trigger error
        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.invalidEmail);
        await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
        await tester.pump();

        when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthFailure(message: errorMessage)));
        when(() => mockAuthBloc.state).thenReturn(AuthFailure(message: errorMessage));

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Assert - Error should be displayed
        expect(find.text(errorMessage), findsOneWidget);

        // Act - Correct credentials and retry
        when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthSuccess(user: AuthFixtures.testUser)));
        when(() => mockAuthBloc.state).thenReturn(AuthSuccess(user: AuthFixtures.testUser));

        await tester.enterText(find.byKey(const Key('email_field')), AuthFixtures.validEmail);
        await tester.enterText(find.byKey(const Key('password_field')), AuthFixtures.validPassword);
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Assert - Should succeed on retry
        verify(() => mockAuthBloc.add(const LoginEvent(
          email: AuthFixtures.validEmail,
          password: AuthFixtures.validPassword,
        ))).called(1);
      });

      testWidgets('should handle multiple consecutive errors', (WidgetTester tester) async {
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

        // Simulate multiple consecutive errors
        for (int i = 0; i < 3; i++) {
          when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthFailure(message: 'Error $i')));
          when(() => mockAuthBloc.state).thenReturn(AuthFailure(message: 'Error $i'));

          await tester.tap(find.byKey(const Key('login_button')));
          await tester.pumpAndSettle();

          // Assert - Each error should be displayed
          expect(find.text('Error $i'), findsOneWidget);
        }
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
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

        // Assert - Check accessibility labels
        expect(find.bySemanticsLabel('Email address'), findsOneWidget);
        expect(find.bySemanticsLabel('Password'), findsOneWidget);
        expect(find.bySemanticsLabel('Login button'), findsOneWidget);
        expect(find.bySemanticsLabel('Create account'), findsOneWidget);
      });

      testWidgets('should support screen reader navigation', (WidgetTester tester) async {
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

        // Test screen reader navigation
        await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          'flutter/accessibility',
          const StringCodec().encodeMessage('Login screen loaded'),
          (data) {},
        );

        // Assert - Screen should be accessible
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}
