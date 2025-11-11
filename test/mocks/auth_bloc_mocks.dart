// Auth BLoC Mocks for Integration Testing
// Purpose: Mock Auth BLoC and related classes for authentication testing
// Follows Flutter development guidelines for test organization

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/auth_event.dart';
import 'package:usago/features/auth/presentation/bloc/auth_state.dart';
import 'package:usago/features/auth/domain/entities/user.dart';
import '../fixtures/auth_fixtures.dart';

/// Mock Auth BLoC for authentication testing
///
/// Provides controlled behavior for authentication state management
/// including success, failure, loading, and error scenarios.
class MockAuthBloc extends Mock implements AuthBloc {
  AuthState _currentState = const AuthInitial();
  final StreamController<AuthState> _stateController = StreamController<AuthState>.broadcast();

  MockAuthBloc() {
    // Setup default behaviors
    when(() => stream).thenAnswer((_) => _stateController.stream);
    when(() => state).thenAnswer((_) => _currentState);
  }

  @override
  AuthState get state => _currentState;

  @override
  Stream<AuthState> get stream => _stateController.stream;

  @override
  void add(AuthEvent event) {
    // Mock implementation that simulates real BLoC behavior
    _handleEvent(event);
  }

  @override
  Future<void> close() async {
    await _stateController.close();
  }

  /// Simulate successful login
  void simulateLoginSuccess(User user) {
    _currentState = AuthSuccess(user: user);
    _stateController.add(_currentState);
  }

  /// Simulate login failure
  void simulateLoginFailure(String message) {
    _currentState = AuthFailure(message: message);
    _stateController.add(_currentState);
  }

  /// Simulate loading state
  void simulateLoading() {
    _currentState = const AuthLoading();
    _stateController.add(_currentState);
  }

  /// Simulate initial state
  void simulateInitial() {
    _currentState = const AuthInitial();
    _stateController.add(_currentState);
  }

  /// Handle events and update state accordingly
  void _handleEvent(AuthEvent event) {
    if (event is LoginEvent) {
      simulateLoading();

      // Simulate async operation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (event.email.contains('invalid') || event.password.contains('wrong')) {
          simulateLoginFailure('Invalid credentials');
        } else {
          simulateLoginSuccess(AuthFixtures.testUser);
        }
      });
    } else if (event is RegisterEvent) {
      simulateLoading();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (event.email.contains('existing')) {
          simulateLoginFailure('User already exists');
        } else {
          simulateLoginSuccess(AuthFixtures.testUser);
        }
      });
    } else if (event is LogoutEvent) {
      simulateLoading();
      Future.delayed(const Duration(milliseconds: 300), () {
        simulateInitial();
      });
    }
  }
}

/// Mock User for testing user-related operations
///
/// Provides controlled user data for testing various
/// user scenarios and states.
class MockUser extends Mock implements User {
  @override
  String get id => 'mock-user-123';

  @override
  String get email => 'mock@example.com';

  @override
  String get name => 'Mock User';

  @override
  String? get profilePicture => null;

  @override
  bool get isEmailVerified => true;

  @override
  DateTime get createdAt => DateTime.parse('2023-01-01T00:00:00Z');
}

/// Auth BLoC Mock Utilities
///
/// Collection of utility functions for creating and configuring
/// mock Auth BLoC objects in integration tests.
class AuthBlocMockUtils {
  /// Create a mock Auth BLoC with initial state
  static MockAuthBloc createWithInitialState() {
    return MockAuthBloc();
  }

  /// Create a mock Auth BLoC with success state
  static MockAuthBloc createWithSuccessState({User? user}) {
    final bloc = MockAuthBloc();
    bloc.simulateLoginSuccess(user ?? AuthFixtures.testUser);
    return bloc;
  }

  /// Create a mock Auth BLoC with failure state
  static MockAuthBloc createWithFailureState({String message = 'Test error'}) {
    final bloc = MockAuthBloc();
    bloc.simulateLoginFailure(message);
    return bloc;
  }

  /// Create a mock Auth BLoC with loading state
  static MockAuthBloc createWithLoadingState() {
    final bloc = MockAuthBloc();
    bloc.simulateLoading();
    return bloc;
  }

  /// Simulate authentication delay
  static Future<void> simulateAuthDelay({Duration? duration}) {
    return Future.delayed(duration ?? const Duration(milliseconds: 500));
  }

  /// Create test user with custom properties
  static User createTestUser({
    String id = 'test-user-123',
    String email = 'test@example.com',
    String name = 'Test User',
    String? profilePicture,
    bool isEmailVerified = true,
  }) {
    return MockUser();
  }

  /// Verify BLoC state transitions
  static void verifyStateTransitions(MockAuthBloc bloc, List<AuthState> expectedStates) {
    final emittedStates = <AuthState>[];

    bloc.stream.listen((state) {
      emittedStates.add(state);
    });

    // Verify all expected states were emitted
    for (int i = 0; i < expectedStates.length; i++) {
      expect(emittedStates[i], equals(expectedStates[i]));
    }
  }
}