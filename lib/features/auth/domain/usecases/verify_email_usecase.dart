import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for verify email usecase
class VerifyEmailParams extends Equatable {
  final String token;

  const VerifyEmailParams({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

/// Verify email use case - handles business logic for email verification
class VerifyEmailUsecase {
  final AuthRepository _repository;

  VerifyEmailUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute email verification
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(VerifyEmailParams params) async {
    // Delegate to repository
    return await _repository.verifyEmail(params.token);
  }
}