import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

/// Mixin that provides common repository functionality
/// Includes error handling, mapping, and try-catch patterns
mixin RepositoryMixin {
  AppLogger get logger => AppLogger();

  /// Safe execution wrapper for repository operations
  ///
  /// [operation] - The async operation to execute
  /// [operationName] - Name for logging purposes
  /// [metadata] - Additional metadata for logging
  /// Returns [Either<Failure, T>] - Result or error
  Future<Either<Failure, T>> safeExecute<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = operationName ?? 'RepositoryOperation';

    try {
      logger.debug('Starting repository operation: $opName', metadata);

      final result = await operation();

      logger.debug('Repository operation completed successfully: $opName');
      return Right(result);
    } on ServerException catch (e) {
      logger.error(
          'Repository operation failed with server exception: $opName', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      logger.error(
          'Repository operation failed with network exception: $opName', e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        originalError: e.originalError,
      ));
    } on AuthException catch (e) {
      logger.error(
          'Repository operation failed with auth exception: $opName', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on ValidationException catch (e) {
      logger.error(
          'Repository operation failed with validation exception: $opName', e);
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        code: e.code,
        originalError: e.originalError,
      ));
    } on CacheException catch (e) {
      logger.error(
          'Repository operation failed with cache exception: $opName', e);
      return Left(CacheFailure(
        message: e.message,
        operation: e.operation,
        key: e.key,
        code: e.code,
        originalError: e.originalError,
      ));
    } catch (e, stackTrace) {
      logger.error(
          'Repository operation failed with unknown exception: $opName',
          e,
          stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during $opName',
        originalError: e,
      ));
    }
  }

  /// Safe execution wrapper for void operations
  ///
  /// [operation] - The async void operation to execute
  /// [operationName] - Name for logging purposes
  /// [metadata] - Additional metadata for logging
  /// Returns [Either<Failure, void>] - Success or error
  Future<Either<Failure, void>> safeExecuteVoid(
    Future<void> Function() operation, {
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = operationName ?? 'RepositoryVoidOperation';

    try {
      logger.debug('Starting void repository operation: $opName', metadata);

      await operation();

      logger.debug('Void repository operation completed successfully: $opName');
      return const Right(null);
    } on ServerException catch (e) {
      logger.error(
          'Void repository operation failed with server exception: $opName', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        endpoint: e.endpoint,
        code: e.code,
        originalError: e.originalError,
      ));
    } on NetworkException catch (e) {
      logger.error(
          'Void repository operation failed with network exception: $opName',
          e);
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
        originalError: e.originalError,
      ));
    } on AuthException catch (e) {
      logger.error(
          'Void repository operation failed with auth exception: $opName', e);
      return Left(AuthFailure(
        message: e.message,
        type: e.type,
        code: e.code,
        originalError: e.originalError,
      ));
    } on ValidationException catch (e) {
      logger.error(
          'Void repository operation failed with validation exception: $opName',
          e);
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        code: e.code,
        originalError: e.originalError,
      ));
    } on CacheException catch (e) {
      logger.error(
          'Void repository operation failed with cache exception: $opName', e);
      return Left(CacheFailure(
        message: e.message,
        operation: e.operation,
        key: e.key,
        code: e.code,
        originalError: e.originalError,
      ));
    } catch (e, stackTrace) {
      logger.error(
          'Void repository operation failed with unknown exception: $opName',
          e,
          stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during $opName',
        originalError: e,
      ));
    }
  }

  /// Handle Either<Exception, T> result from datasource
  ///
  /// [result] - Either result from datasource
  /// [operationName] - Name for logging purposes
  /// Returns [Either<Failure, T>] - Converted result
  Either<Failure, T> handleDatasourceResult<T>(
    Either<Exception, T> result, {
    String? operationName,
  }) {
    final opName = operationName ?? 'DatasourceOperation';

    return result.fold(
      (exception) {
        logger.error('Datasource operation failed: $opName', exception);

        if (exception is ServerException) {
          return Left(ServerFailure(
            message: exception.message,
            statusCode: exception.statusCode,
            endpoint: exception.endpoint,
            code: exception.code,
            originalError: exception.originalError,
          ));
        } else if (exception is NetworkException) {
          return Left(NetworkFailure(
            message: exception.message,
            code: exception.code,
            originalError: exception.originalError,
          ));
        } else if (exception is AuthException) {
          return Left(AuthFailure(
            message: exception.message,
            type: exception.type,
            code: exception.code,
            originalError: exception.originalError,
          ));
        } else if (exception is ValidationException) {
          return Left(ValidationFailure(
            message: exception.message,
            fieldErrors: exception.fieldErrors,
            code: exception.code,
            originalError: exception.originalError,
          ));
        } else if (exception is CacheException) {
          return Left(CacheFailure(
            message: exception.message,
            operation: exception.operation,
            key: exception.key,
            code: exception.code,
            originalError: exception.originalError,
          ));
        } else {
          return Left(UnknownFailure(
            message: 'An unexpected error occurred during $opName',
            originalError: exception,
          ));
        }
      },
      (data) {
        logger.debug('Datasource operation completed successfully: $opName');
        return Right(data);
      },
    );
  }

  /// Map model to entity with error handling
  ///
  /// [model] - The model to convert
  /// [toEntity] - Function to convert model to entity
  /// [operationName] - Name for logging purposes
  /// Returns [Either<Failure, T>] - Entity or error
  Either<Failure, T> mapToEntity<T, M>(
    M model,
    T Function(M) toEntity, {
    String? operationName,
  }) {
    final opName = operationName ?? 'EntityMapping';

    try {
      final entity = toEntity(model);
      logger.debug('Entity mapping completed successfully: $opName');
      return Right(entity);
    } catch (e, stackTrace) {
      logger.error('Entity mapping failed: $opName', e, stackTrace);
      return Left(ParseFailure(
        message: 'Failed to map model to entity',
        dataType: M.toString(),
        expectedFormat: T.toString(),
        originalError: e,
      ));
    }
  }

  /// Batch map models to entities with error handling
  ///
  /// [models] - List of models to convert
  /// [toEntity] - Function to convert model to entity
  /// [operationName] - Name for logging purposes
  /// Returns [Either<Failure, List<T>>] - List of entities or error
  Either<Failure, List<T>> mapToEntities<T, M>(
    List<M> models,
    T Function(M) toEntity, {
    String? operationName,
  }) {
    final opName = operationName ?? 'BatchEntityMapping';

    try {
      final entities = models.map((model) => toEntity(model)).toList();
      logger.debug(
          'Batch entity mapping completed successfully: $opName (${entities.length} items)');
      return Right(entities);
    } catch (e, stackTrace) {
      logger.error('Batch entity mapping failed: $opName', e, stackTrace);
      return Left(ParseFailure(
        message: 'Failed to map models to entities',
        dataType: 'List<$M>',
        expectedFormat: 'List<$T>',
        originalError: e,
      ));
    }
  }

  /// Validate operation parameters
  ///
  /// [condition] - Validation condition
  /// [failure] - Failure to return if validation fails
  /// Returns [Failure?] - Null if validation passes, failure if it fails
  Failure? validateCondition(bool condition, Failure failure) {
    if (!condition) {
      logger.warning('Validation failed: ${failure.message}');
      return failure;
    }
    return null;
  }

  /// Log repository operation start
  void logOperationStart(String operationName, Map<String, dynamic>? metadata) {
    logger.info('Starting repository operation: $operationName', metadata);
  }

  /// Log repository operation success
  void logOperationSuccess(
      String operationName, Map<String, dynamic>? metadata) {
    logger.info('Repository operation completed successfully: $operationName',
        metadata);
  }

  /// Log repository operation failure
  void logOperationFailure(
      String operationName, Failure failure, Map<String, dynamic>? metadata) {
    final message =
        'Repository operation failed: $operationName - ${failure.message}';
    if (metadata != null) {
      logger.error('$message | Metadata: $metadata', failure);
    } else {
      logger.error(message, failure);
    }
  }
}

/// Extension to provide additional functionality for repositories
extension RepositoryExtensions on RepositoryMixin {
  /// Retry operation with exponential backoff
  ///
  /// [operation] - The operation to retry
  /// [maxRetries] - Maximum number of retries
  /// [initialDelay] - Initial delay between retries
  /// [operationName] - Name for logging purposes
  /// Returns [Either<Failure, T>] - Result or error
  Future<Either<Failure, T>> retryOperation<T>(
    Future<Either<Failure, T>> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    final opName = operationName ?? 'RetryOperation';
    var delay = initialDelay;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      final result = await operation();

      if (result.isRight()) {
        if (attempt > 0) {
          logger.info('Operation succeeded after $attempt retries: $opName');
        }
        return result;
      }

      if (attempt == maxRetries) {
        logger.error('Operation failed after $maxRetries retries: $opName',
            result.fold((l) => l, (r) => null));
        return result;
      }

      logger.warning(
          'Operation failed, retrying in ${delay.inSeconds}s (attempt ${attempt + 1}/$maxRetries): $opName');
      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }

    return const Left(
        UnknownFailure(message: 'Retry operation failed unexpectedly'));
  }
}

/// Example usage:
///
/// class AuthRepositoryImpl with RepositoryMixin implements AuthRepository {
///   final AuthRemoteDatasource _remoteDatasource;
///   final AuthLocalDatasource _localDatasource;
///
///   @override
///   Future<Either<Failure, User>> login({required String email, required String password}) async {
///     return safeExecute(() async {
///       final result = await _remoteDatasource.login(email: email, password: password);
///
///       return result.fold(
///         (failure) => throw failure.toException()!,
///         (userModel) async {
///           await _localDatasource.saveUser(userModel);
///           return mapToEntity(userModel, (model) => model.toEntity()).fold(
///             (failure) => throw failure.toException()!,
///             (entity) => entity,
///           );
///         },
///       );
///     }, operationName: 'Login');
///   }
/// }
