// Export all auth-related mocks for convenience
export 'auth_repository_mocks.dart';
export 'auth_datasource_mocks.dart';
export 'auth_usecase_mocks.dart';
export 'auth_utility_mocks.dart';

// Import the setup classes for use in MockSetup
import 'auth_repository_mocks.dart';
import 'auth_datasource_mocks.dart';

// Re-export commonly used classes for backward compatibility
export 'auth_repository_mocks.dart' show MockAuthRepository, MockAuthRepositorySetup;
export 'auth_datasource_mocks.dart' show MockAuthRemoteDatasource, MockAuthLocalDatasource, MockAuthDatasourceSetup;
export 'auth_usecase_mocks.dart'
    show
        MockLoginUsecase,
        MockRegisterUsecase,
        MockLogoutUsecase,
        MockCheckAuthUsecase,
        MockUpdateProfileUsecase,
        MockChangePasswordUsecase,
        MockForgotPasswordUsecase,
        MockResetPasswordUsecase,
        MockVerifyEmailUsecase,
        MockResendVerificationEmailUsecase,
        MockDeleteAccountUsecase;
export 'auth_utility_mocks.dart' show MockErrorHandler, MockAppLogger;

/// Legacy MockSetup class for backward compatibility
/// This class delegates to the appropriate setup classes
class MockSetup {
  /// Setup common mock behaviors for AuthRepository
  static void setupAuthRepositoryMocks(dynamic mock) {
    MockAuthRepositorySetup.setupAuthRepositoryMocks(mock);
  }

  /// Setup common mock behaviors for AuthRemoteDatasource
  static void setupRemoteDatasourceMocks(dynamic mock) {
    MockAuthDatasourceSetup.setupRemoteDatasourceMocks(mock);
  }

  /// Setup common mock behaviors for AuthLocalDatasource
  static void setupLocalDatasourceMocks(dynamic mock) {
    MockAuthDatasourceSetup.setupLocalDatasourceMocks(mock);
  }
}