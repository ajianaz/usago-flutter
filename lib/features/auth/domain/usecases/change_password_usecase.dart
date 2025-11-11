import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for change password usecase
class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Change password use case - handles business logic for changing user password
class ChangePasswordUsecase {
  final AuthRepository _repository;

  ChangePasswordUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute password change
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Delegate to repository
    return await _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}