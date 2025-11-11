import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/extensions/string_extension.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for login usecase
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Login use case - handles business logic for user login
class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute login with email and password
  ///
  /// Validates input before calling repository
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Business validation
    final emailValidation = params.email.validateEmail();
    if (emailValidation.isLeft()) {
      return Left(ValidationFailure(message: emailValidation.fold((l) => l, (r) => r)));
    }

    final passwordValidation = params.password.validatePassword();
    if (passwordValidation.isLeft()) {
      return Left(ValidationFailure(message: passwordValidation.fold((l) => l, (r) => r)));
    }

    // Additional business rules
    if (params.email.toLowerCase().contains('admin')) {
      return const Left(ValidationFailure(message: 'Admin login not allowed through this method'));
    }

    // Delegate to repository
    return await _repository.login(
      email: params.email.trim(),
      password: params.password,
    );
  }
}