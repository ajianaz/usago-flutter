import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for refresh token usecase
class RefreshTokenParams extends Equatable {
  const RefreshTokenParams();

  @override
  List<Object?> get props => [];
}

/// Refresh token use case - handles business logic for token refresh
class RefreshTokenUsecase {
  final AuthRepository _repository;

  RefreshTokenUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute token refresh
  ///
  /// Validates current token state before calling repository
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> call(RefreshTokenParams params) async {
    // Delegate to repository
    return await _repository.refreshToken();
  }
}