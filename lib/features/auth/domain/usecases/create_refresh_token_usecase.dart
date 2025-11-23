import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for create refresh token usecase
class CreateRefreshTokenParams extends Equatable {
  const CreateRefreshTokenParams();

  @override
  List<Object?> get props => [];
}

/// Create refresh token use case - handles business logic for creating refresh tokens
class CreateRefreshTokenUsecase {
  final AuthRepository _repository;

  CreateRefreshTokenUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute create refresh token
  ///
  /// Validates current state before calling repository
  /// Returns Either<Failure, Map<String, dynamic>>
  Future<Either<Failure, Map<String, dynamic>>> call(
      CreateRefreshTokenParams params) async {
    // Delegate to repository
    return await _repository.createRefreshToken();
  }
}
