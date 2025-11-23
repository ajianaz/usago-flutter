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

// Register fallback values for mocktail
void setUpAuthBlocMocks() {
  registerFallbackValue(
      const LoginEvent(email: 'test@example.com', password: 'password'));
  registerFallbackValue(const RegisterEvent(
      email: 'test@example.com', password: 'password', name: 'Test'));
  registerFallbackValue(const LogoutEvent());
  registerFallbackValue(const CheckAuthStatusEvent());
  registerFallbackValue(const UpdateProfileEvent(name: 'Test'));
  registerFallbackValue(
      const ChangePasswordEvent(currentPassword: 'old', newPassword: 'new'));
  registerFallbackValue(const ForgotPasswordEvent(email: 'test@example.com'));
  registerFallbackValue(
      const ResetPasswordEvent(token: 'token', newPassword: 'password'));
  registerFallbackValue(const VerifyEmailEvent(token: 'token'));
  registerFallbackValue(const ResendVerificationEmailEvent());
  registerFallbackValue(const DeleteAccountEvent());
  registerFallbackValue(const RefreshTokenEvent());
  registerFallbackValue(const CreateRefreshTokenEvent());
  registerFallbackValue(const GetRefreshTokensEvent());
  registerFallbackValue(const RevokeTokenEvent(refreshToken: 'token'));
  registerFallbackValue(const RevokeAllTokensEvent());
}

/// Mock Auth BLoC for authentication testing
///
/// Provides controlled behavior for authentication state management
/// including success, failure, loading, and error scenarios.
class MockAuthBloc extends Mock implements AuthBloc {}

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
    final bloc = MockAuthBloc();
    when(() => bloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => bloc.state).thenReturn(const AuthInitial());
    return bloc;
  }

  /// Create a mock Auth BLoC with success state
  static MockAuthBloc createWithSuccessState({User? user}) {
    final bloc = MockAuthBloc();
    when(() => bloc.stream).thenAnswer(
        (_) => Stream.value(AuthSuccess(user: user ?? AuthFixtures.testUser)));
    when(() => bloc.state)
        .thenReturn(AuthSuccess(user: user ?? AuthFixtures.testUser));
    return bloc;
  }

  /// Create a mock Auth BLoC with failure state
  static MockAuthBloc createWithFailureState({String message = 'Test error'}) {
    final bloc = MockAuthBloc();
    when(() => bloc.stream)
        .thenAnswer((_) => Stream.value(AuthFailure(message: message)));
    when(() => bloc.state).thenReturn(AuthFailure(message: message));
    return bloc;
  }

  /// Create a mock Auth BLoC with loading state
  static MockAuthBloc createWithLoadingState() {
    final bloc = MockAuthBloc();
    when(() => bloc.stream)
        .thenAnswer((_) => Stream.value(const AuthLoading()));
    when(() => bloc.state).thenReturn(const AuthLoading());
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
  static void verifyStateTransitions(
      MockAuthBloc bloc, List<AuthState> expectedStates) {
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
