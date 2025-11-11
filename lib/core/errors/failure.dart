import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, originalError];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message, statusCode, originalError];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message, originalError];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message, originalError];
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message, originalError];
}