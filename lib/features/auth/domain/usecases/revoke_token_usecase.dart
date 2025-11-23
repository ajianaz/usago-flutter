import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for revoke token usecase
class RevokeTokenParams extends Equatable {
  final String refreshToken;

  const RevokeTokenParams({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}

/// Revoke token use case - handles business logic for revoking tokens
class RevokeTokenUsecase {
  final AuthRepository _repository;

  RevokeTokenUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute revoke token
  ///
  /// Validates token ID before calling repository
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(RevokeTokenParams params) async {
    // Validate refresh token
    if (params.refreshToken.isEmpty) {
      return left(
          const ValidationFailure(message: 'Refresh token cannot be empty'));
    }

    // Delegate to repository
    return await _repository.revokeToken(params.refreshToken);
  }
}
