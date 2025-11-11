import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for resend verification email usecase
class ResendVerificationEmailParams extends Equatable {
  const ResendVerificationEmailParams();

  @override
  List<Object?> get props => [];
}

/// Resend verification email use case - handles business logic for resending verification email
class ResendVerificationEmailUsecase {
  final AuthRepository _repository;

  ResendVerificationEmailUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute resend verification email
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(ResendVerificationEmailParams params) async {
    // Delegate to repository
    return await _repository.resendVerificationEmail();
  }
}