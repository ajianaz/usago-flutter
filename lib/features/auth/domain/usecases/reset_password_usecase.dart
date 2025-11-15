import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for reset password usecase
class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

/// Reset password use case - handles business logic for resetting password
class ResetPasswordUsecase {
  final AuthRepository _repository;

  ResetPasswordUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute reset password
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    // Delegate to repository
    return await _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}
