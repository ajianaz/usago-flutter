import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';
import '../errors/exceptions.dart';

/// Utility class for handling Either<Failure, T> results
/// Provides common transformation patterns and helper methods
class ResultHandler {
  /// Check if result is successful
  ///
  /// [result] - Either result to check
  /// Returns [bool] - True if successful
  static bool isSuccess<T>(Either<Failure, T> result) {
    return result.isRight();
  }

  /// Check if result is a failure
  ///
  /// [result] - Either result to check
  /// Returns [bool] - True if failed
  static bool isFailure<T>(Either<Failure, T> result) {
    return result.isLeft();
  }

  /// Get success value or null
  ///
  /// [result] - Either result to extract from
  /// Returns [T?] - Success value or null
  static T? getSuccess<T>(Either<Failure, T> result) {
    return result.fold((l) => null, (r) => r);
  }

  /// Get failure or null
  ///
  /// [result] - Either result to extract from
  /// Returns [Failure?] - Failure or null
  static Failure? getFailure<T>(Either<Failure, T> result) {
    return result.fold((l) => l, (r) => null);
  }

  /// Get success value or default
  ///
  /// [result] - Either result to extract from
  /// [defaultValue] - Default value if result is failure
  /// Returns [T] - Success value or default
  static T getSuccessOrDefault<T>(Either<Failure, T> result, T defaultValue) {
    return result.fold((l) => defaultValue, (r) => r);
  }

  /// Get success value or throw exception
  ///
  /// [result] - Either result to extract from
  /// Returns [T] - Success value
  /// Throws [Exception] - If result is failure
  static T getSuccessOrThrow<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => throw failure.toException() ?? Exception(failure.message),
      (success) => success,
    );
  }

  /// Transform success value
  ///
  /// [result] - Either result to transform
  /// [transformer] - Function to transform success value
  /// Returns [Either<Failure, R>] - Transformed result
  static Either<Failure, R> mapSuccess<T, R>(
    Either<Failure, T> result,
    R Function(T) transformer,
  ) {
    return result.fold(
      (failure) => Left(failure),
      (success) => Right(transformer(success)),
    );
  }

  /// Transform failure
  ///
  /// [result] - Either result to transform
  /// [transformer] - Function to transform failure
  /// Returns [Either<Failure, T>] - Transformed result
  static Either<Failure, T> mapFailure<T>(
    Either<Failure, T> result,
    Failure Function(Failure) transformer,
  ) {
    return result.fold(
      (failure) => Left(transformer(failure)),
      (success) => Right(success),
    );
  }

  /// Chain operations
  ///
  /// [result] - Initial Either result
  /// [chainer] - Function to chain with success value
  /// Returns [Either<Failure, R>] - Chained result
  static Either<Failure, R> chain<T, R>(
    Either<Failure, T> result,
    Either<Failure, R> Function(T) chainer,
  ) {
    return result.fold(
      (failure) => Left(failure),
      (success) => chainer(success),
    );
  }

  /// Filter success value
  ///
  /// [result] - Either result to filter
  /// [predicate] - Predicate to filter with
  /// [failure] - Failure to return if predicate fails
  /// Returns [Either<Failure, T>] - Filtered result
  static Either<Failure, T> filter<T>(
    Either<Failure, T> result,
    bool Function(T) predicate,
    Failure failure,
  ) {
    return result.fold(
      (l) => Left(l),
      (r) => predicate(r) ? Right(r) : Left(failure),
    );
  }

  /// Combine multiple results
  ///
  /// [results] - List of Either results to combine
  /// Returns [Either<Failure, List<T>>] - Combined result or first failure
  static Either<Failure, List<T>> combine<T>(List<Either<Failure, T>> results) {
    final values = <T>[];

    for (final result in results) {
      final foldResult = result.fold(
        (failure) => failure,
        (success) {
          values.add(success);
          return null;
        },
      );

      if (foldResult != null) {
        return Left(foldResult);
      }
    }

    return Right(values);
  }

  /// Combine results with custom combiner
  ///
  /// [results] - List of Either results to combine
  /// [combiner] - Function to combine success values
  /// Returns [Either<Failure, R>] - Combined result or first failure
  static Either<Failure, R> combineWith<T, R>(
    List<Either<Failure, T>> results,
    R Function(List<T>) combiner,
  ) {
    final values = <T>[];

    for (final result in results) {
      final foldResult = result.fold(
        (failure) => failure,
        (success) {
          values.add(success);
          return null;
        },
      );

      if (foldResult != null) {
        return Left(foldResult);
      }
    }

    return Right(combiner(values));
  }

  /// Execute async operation and wrap in Either
  ///
  /// [operation] - Async operation to execute
  /// [onError] - Optional error handler
  /// Returns [Future<Either<Failure, T>>] - Result or error
  static Future<Either<Failure, T>> asyncSafe<T>(
    Future<T> Function() operation, {
    Failure Function(Object error, StackTrace? stackTrace)? onError,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e, stackTrace) {
      if (onError != null) {
        return Left(onError(e, stackTrace));
      }

      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  /// Execute sync operation and wrap in Either
  ///
  /// [operation] - Sync operation to execute
  /// [onError] - Optional error handler
  /// Returns [Either<Failure, T>] - Result or error
  static Either<Failure, T> safe<T>(
    T Function() operation, {
    Failure Function(Object error, StackTrace? stackTrace)? onError,
  }) {
    try {
      final result = operation();
      return Right(result);
    } catch (e, stackTrace) {
      if (onError != null) {
        return Left(onError(e, stackTrace));
      }

      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  /// Retry operation with predicate
  ///
  /// [operation] - Operation to retry
  /// [shouldRetry] - Predicate to determine if should retry
  /// [maxRetries] - Maximum number of retries
  /// Returns [Either<Failure, T>] - Result or error
  static Either<Failure, T> retry<T>(
    Either<Failure, T> Function() operation,
    bool Function(Failure) shouldRetry, {
    int maxRetries = 3,
  }) {
    var attempts = 0;

    while (attempts <= maxRetries) {
      final result = operation();

      if (result.isRight()) {
        return result;
      }

      final failure = result.fold((l) => l, (r) => null)!;

      if (attempts == maxRetries || !shouldRetry(failure)) {
        return result;
      }

      attempts++;
    }

    return const Left(UnknownFailure(message: 'Retry operation failed unexpectedly'));
  }

  /// Convert result to nullable value
  ///
  /// [result] - Either result to convert
  /// Returns [T?] - Success value or null
  static T? toNullable<T>(Either<Failure, T> result) {
    return result.fold((l) => null, (r) => r);
  }

  /// Convert nullable value to result
  ///
  /// [value] - Nullable value to convert
  /// [failure] - Failure to return if value is null
  /// Returns [Either<Failure, T>] - Result or failure
  static Either<Failure, T> fromNullable<T>(
    T? value,
    Failure failure,
  ) {
    return value != null ? Right(value) : Left(failure);
  }

  /// Validate result with custom validator
  ///
  /// [result] - Either result to validate
  /// [validator] - Validator function
  /// [failure] - Failure to return if validation fails
  /// Returns [Either<Failure, T>] - Validated result or failure
  static Either<Failure, T> validate<T>(
    Either<Failure, T> result,
    bool Function(T) validator,
    Failure failure,
  ) {
    return result.fold(
      (l) => Left(l),
      (r) => validator(r) ? Right(r) : Left(failure),
    );
  }

  /// Execute side effect for success
  ///
  /// [result] - Either result to execute side effect on
  /// [sideEffect] - Side effect function
  /// Returns [Either<Failure, T>] - Original result
  static Either<Failure, T> onSuccess<T>(
    Either<Failure, T> result,
    void Function(T) sideEffect,
  ) {
    result.fold(
      (l) => null,
      (r) => sideEffect(r),
    );
    return result;
  }

  /// Execute side effect for failure
  ///
  /// [result] - Either result to execute side effect on
  /// [sideEffect] - Side effect function
  /// Returns [Either<Failure, T>] - Original result
  static Either<Failure, T> onFailure<T>(
    Either<Failure, T> result,
    void Function(Failure) sideEffect,
  ) {
    result.fold(
      (l) => sideEffect(l),
      (r) => null,
    );
    return result;
  }

  /// Execute side effect for both success and failure
  ///
  /// [result] - Either result to execute side effect on
  /// [sideEffect] - Side effect function
  /// Returns [Either<Failure, T>] - Original result
  static Either<Failure, T> onBoth<T>(
    Either<Failure, T> result,
    void Function(Failure?, T?) sideEffect,
  ) {
    final failure = result.fold((l) => l, (r) => null);
    final success = result.fold((l) => null, (r) => r);
    sideEffect(failure, success);
    return result;
  }
}

/// Extension to provide additional functionality for Either<Failure, T>
extension ResultHandlerExtensions<T> on Either<Failure, T> {
  /// Check if result is successful
  bool get isSuccess => ResultHandler.isSuccess(this);

  /// Check if result is a failure
  bool get isFailure => ResultHandler.isFailure(this);

  /// Get success value or null
  T? get success => ResultHandler.getSuccess(this);

  /// Get failure or null
  Failure? get failure => ResultHandler.getFailure(this);

  /// Get success value or throw exception
  T get successOrThrow => ResultHandler.getSuccessOrThrow(this);

  /// Transform success value
  Either<Failure, R> mapSuccess<R>(R Function(T) transformer) {
    return ResultHandler.mapSuccess(this, transformer);
  }

  /// Transform failure
  Either<Failure, T> mapFailure(Failure Function(Failure) transformer) {
    return ResultHandler.mapFailure(this, transformer);
  }

  /// Chain operations
  Either<Failure, R> chain<R>(Either<Failure, R> Function(T) chainer) {
    return ResultHandler.chain(this, chainer);
  }

  /// Filter success value
  Either<Failure, T> filter(bool Function(T) predicate, Failure failure) {
    return ResultHandler.filter(this, predicate, failure);
  }

  /// Validate result with custom validator
  Either<Failure, T> validate(bool Function(T) validator, Failure failure) {
    return ResultHandler.validate(this, validator, failure);
  }

  /// Execute side effect for success
  Either<Failure, T> onSuccess(void Function(T) sideEffect) {
    return ResultHandler.onSuccess(this, sideEffect);
  }

  /// Execute side effect for failure
  Either<Failure, T> onFailure(void Function(Failure) sideEffect) {
    return ResultHandler.onFailure(this, sideEffect);
  }

  /// Execute side effect for both success and failure
  Either<Failure, T> onBoth(void Function(Failure?, T?) sideEffect) {
    return ResultHandler.onBoth(this, sideEffect);
  }

  /// Convert to nullable value
  T? toNullable() {
    return ResultHandler.toNullable(this);
  }
}

/// Example usage:
///
/// final result = await ResultHandler.asyncSafe(() async {
///   return await apiService.getData();
/// });
///
/// final transformedResult = result
///   .mapSuccess((data) => data.map((item) => item.toEntity()))
///   .filter((entities) => entities.isNotEmpty, const ValidationFailure(message: 'No data found'))
///   .onSuccess((entities) => logger.info('Loaded ${entities.length} entities'));
///
/// if (transformedResult.isFailure) {
///   final errorMessage = transformedResult.failure!.userMessage;
///   // Show error to user
/// } else {
///   final entities = transformedResult.success!;
///   // Use entities
/// }