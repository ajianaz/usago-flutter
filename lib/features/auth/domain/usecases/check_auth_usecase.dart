import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Check auth status use case - handles checking if user is authenticated
class CheckAuthUsecase {
  final AuthRepository _repository;

  CheckAuthUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Execute check auth status
  /// Returns Either<Failure, User?>
  Future<Either<Failure, User?>> call() async {
    return await _repository.checkAuthStatus();
  }
}
