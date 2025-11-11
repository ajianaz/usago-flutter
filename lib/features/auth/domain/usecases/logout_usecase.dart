import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Logout use case - handles user logout
class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute logout
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}