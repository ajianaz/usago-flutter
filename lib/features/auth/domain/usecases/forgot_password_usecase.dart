import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for forgot password usecase
class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

/// Forgot password use case - handles business logic for password reset
class ForgotPasswordUsecase {
  final AuthRepository _repository;

  ForgotPasswordUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute forgot password
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    // Delegate to repository
    return await _repository.forgotPassword(params.email);
  }
}