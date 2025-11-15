import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';
import '../utils/logger.dart';

/// Abstract base class for all use cases in the application
/// Provides common functionality and error handling patterns
///
/// [Params] - Type for input parameters
/// [Type] - Return type of the use case
abstract class BaseUseCase<Params, Type> {
  final AppLogger _logger;

  /// Constructor with optional logger injection
  BaseUseCase({AppLogger? logger}) : _logger = logger ?? AppLogger();

  /// Abstract method that must be implemented by concrete use cases
  ///
  /// [params] - Input parameters for the use case
  /// Returns [Either<Failure, Type>] - Result or error
  Future<Either<Failure, Type>> execute(Params params);

  /// Template method that wraps the actual execution with common patterns
  ///
  /// [params] - Input parameters for the use case
  /// [operationName] - Name for logging and tracking purposes
  /// Returns [Either<Failure, Type>] - Result or error
  Future<Either<Failure, Type>> call(
    Params params, {
    String? operationName,
  }) async {
    final opName = operationName ?? runtimeType.toString();

    try {
      _logger.debug('Starting use case: $opName');

      // Pre-execution validation
      final validationResult = validateParams(params);
      if (validationResult != null) {
        _logger.warning(
            'Validation failed for use case: $opName', validationResult);
        return Left(validationResult);
      }

      // Execute the actual use case logic
      final result = await execute(params);

      _logger.debug('Use case completed successfully: $opName');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in use case: $opName', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during $opName',
        originalError: e,
      ));
    }
  }

  /// Override this method to add parameter validation
  /// Return null if validation passes, or [Failure] if it fails
  Failure? validateParams(Params params) => null;

  /// Helper method to validate common business rules
  /// Can be called from concrete use cases
  Failure? validateBusinessRules(Params params) => null;

  /// Helper method to log use case start with metadata
  void logUseCaseStart(String operationName, Map<String, dynamic>? metadata) {
    _logger.info('Starting use case: $operationName', metadata);
  }

  /// Helper method to log use case success with metadata
  void logUseCaseSuccess(String operationName, Map<String, dynamic>? metadata) {
    _logger.info('Use case completed successfully: $operationName', metadata);
  }

  /// Helper method to log use case failure with metadata
  void logUseCaseFailure(
      String operationName, Failure failure, Map<String, dynamic>? metadata) {
    final message = 'Use case failed: $operationName - ${failure.message}';
    if (metadata != null) {
      _logger.error('$message | Metadata: $metadata', failure);
    } else {
      _logger.error(message, failure);
    }
  }
}

/// Specialized base class for use cases that don't require parameters
abstract class NoParamsUseCase<Type> extends BaseUseCase<void, Type> {
  /// Default implementation for void parameters
  @override
  Future<Either<Failure, Type>> call(void params, {String? operationName}) {
    return super.call(null, operationName: operationName);
  }

  /// Simplified call method without parameters
  Future<Either<Failure, Type>> executeWithoutParams({String? operationName}) {
    return call(null, operationName: operationName);
  }

  @override
  Failure? validateParams(void params) => null;
}

/// Specialized base class for use cases that return void
abstract class VoidReturnUseCase<Params> extends BaseUseCase<Params, void> {
  /// Helper method to return successful void result
  Either<Failure, void> success() => const Right(null);

  /// Helper method to return failure result
  Either<Failure, void> failure(Failure error) => Left(error);
}

/// Mixin that provides common validation utilities
mixin ValidationMixin<T> {
  /// Validate email format
  Failure? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return const ValidationFailure(message: 'Email is required');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const ValidationFailure(message: 'Invalid email format');
    }

    return null;
  }

  /// Validate password strength
  Failure? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return const ValidationFailure(message: 'Password is required');
    }

    if (password.length < 8) {
      return const ValidationFailure(
          message: 'Password must be at least 8 characters long');
    }

    return null;
  }

  /// Validate required field
  Failure? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure(message: '$fieldName is required');
    }
    return null;
  }

  /// Validate numeric value
  Failure? validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure(message: '$fieldName is required');
    }

    if (double.tryParse(value) == null) {
      return ValidationFailure(message: '$fieldName must be a valid number');
    }

    return null;
  }
}

/// Example usage:
///
/// class LoginUseCase extends BaseUseCase<LoginParams, User> with ValidationMixin {
///   final AuthRepository _repository;
///
///   LoginUseCase({required AuthRepository repository}) : _repository = repository;
///
///   @override
///   Future<Either<Failure, User>> execute(LoginParams params) async {
///     // Business logic here
///     return await _repository.login(email: params.email, password: params.password);
///   }
///
///   @override
///   Failure? validateParams(LoginParams params) {
///     final emailError = validateEmail(params.email);
///     if (emailError != null) return emailError;
///
///     final passwordError = validatePassword(params.password);
///     if (passwordError != null) return passwordError;
///
///     return super.validateBusinessRules(params);
///   }
///
///   @override
///   Failure? validateBusinessRules(LoginParams params) {
///     if (params.email.toLowerCase().contains('admin')) {
///       return const ValidationFailure(message: 'Admin login not allowed through this method');
///     }
///     return null;
///   }
/// }
