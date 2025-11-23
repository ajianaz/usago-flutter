import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for revoke all tokens usecase
class RevokeAllTokensParams extends Equatable {
  const RevokeAllTokensParams();

  @override
  List<Object?> get props => [];
}

/// Revoke all tokens use case - handles business logic for revoking all tokens
class RevokeAllTokensUsecase {
  final AuthRepository _repository;

  RevokeAllTokensUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute revoke all tokens
  ///
  /// Validates current state before calling repository
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(RevokeAllTokensParams params) async {
    // Delegate to repository
    return await _repository.revokeAllTokens();
  }
}
