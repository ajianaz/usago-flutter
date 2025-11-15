import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

/// Logout use case - handles user logout
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase({required AuthRepository repository}) : _repository = repository;

  /// Execute logout
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}