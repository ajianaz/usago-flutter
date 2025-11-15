import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Parameters for delete account usecase
class DeleteAccountParams extends Equatable {
  const DeleteAccountParams();

  @override
  List<Object?> get props => [];
}

/// Delete account use case - handles business logic for deleting user account
class DeleteAccountUsecase {
  final AuthRepository _repository;

  DeleteAccountUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute delete account
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    // Delegate to repository
    return await _repository.deleteAccount();
  }
}
