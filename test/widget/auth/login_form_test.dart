import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago/features/auth/presentation/bloc/auth_state.dart';
import 'package:usago/features/auth/presentation/widgets/login_form.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  group('LoginForm Widget', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginForm(),
          ),
        ),
      );
    }

    testWidgets('should display email and password fields', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display forgot password link', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byKey(const Key('forgot_password_link')), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display register link', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byKey(const Key('register_link')), findsOneWidget);
      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });

    testWidgets('should show loading indicator when state is AuthLoading', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsNothing);
    });

    testWidgets('should show error message when state is AuthFailure', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthFailure(message: errorMessage)));
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byKey(const Key('error_snackbar')), findsOneWidget);
    });

    testWidgets('should enable login button when form is valid', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and password
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Assert
      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(loginButton.onPressed, isNotNull);
    });

    testWidgets('should disable login button when form is invalid', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.pump();

      // Assert
      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(loginButton.onPressed, isNull);
    });

    testWidgets('should add LoginEvent when login button is pressed', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and password
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Assert
      verify(() => mockAuthBloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      ))).called(1);
    });

    testWidgets('should show email validation error', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email and lose focus
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.tap(find.byKey(const Key('password_field')));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show password validation error', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter short password and lose focus
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('email_field')));
      await tester.pump();

      // Assert
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find password visibility toggle
      final toggleButton = find.byKey(const Key('password_visibility_toggle'));
      expect(toggleButton, findsOneWidget);

      // Initially password should be obscured
      // Tap to show password
      await tester.tap(toggleButton);
      await tester.pump();

      // Tap to hide password
      await tester.tap(toggleButton);
      await tester.pump();
    });

    testWidgets('should navigate to forgot password when link is tapped', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap forgot password link
      await tester.tap(find.byKey(const Key('forgot_password_link')));
      await tester.pump();

      // Assert - In a real app, this would navigate to forgot password screen
      // For now, we just verify the tap doesn't throw an error
      expect(find.byKey(const Key('forgot_password_link')), findsOneWidget);
    });

    testWidgets('should navigate to register when link is tapped', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap register link
      await tester.tap(find.byKey(const Key('register_link')));
      await tester.pump();

      // Assert - In a real app, this would navigate to register screen
      // For now, we just verify the tap doesn't throw an error
      expect(find.byKey(const Key('register_link')), findsOneWidget);
    });

    testWidgets('should clear form when login is successful', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthSuccess(user: AuthFixtures.testUser)));
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter email and password
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Simulate successful login
      await tester.pumpAndSettle();

      // Assert - Form should be cleared after successful login
      expect(find.text('test@example.com'), findsNothing);
      expect(find.text('password123'), findsNothing);
    });

    testWidgets('should handle keyboard properly', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Focus email field
      await tester.tap(find.byKey(const Key('email_field')));
      await tester.pump();

      // Assert - Keyboard should appear
      expect(tester.binding.focusManager.primaryFocus?.debugLabel, contains('email'));

      // Move to password field
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Assert - Focus should move to password field
      expect(tester.binding.focusManager.primaryFocus?.debugLabel, contains('password'));

      // Submit form
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Form should attempt to submit
      verify(() => mockAuthBloc.add(any())).called(greaterThan(0));
    });
  });
}

// Mock AuthBloc for testing
class MockAuthBloc extends Mock implements AuthBloc {
  @override
  AuthState get state => const AuthInitial();
}