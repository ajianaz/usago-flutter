import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/error_handler.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/core/utils/logger.dart';

/// Mock ErrorHandler
class MockErrorHandler extends Mock implements ErrorHandler {
  @override
  Future<Either<Failure, T>> safeExecute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

/// Mock AppLogger
class MockAppLogger extends Mock implements AppLogger {}