import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for get refresh tokens usecase
class GetRefreshTokensParams extends Equatable {
  const GetRefreshTokensParams();

  @override
  List<Object?> get props => [];
}

/// Get refresh tokens use case - handles business logic for getting refresh tokens
class GetRefreshTokensUsecase {
  final AuthRepository _repository;

  GetRefreshTokensUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute get refresh tokens
  ///
  /// Validates current state before calling repository
  /// Returns Either<Failure, List<Map<String, dynamic>>>
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      GetRefreshTokensParams params) async {
    // Delegate to repository
    return await _repository.getRefreshTokens();
  }
}
