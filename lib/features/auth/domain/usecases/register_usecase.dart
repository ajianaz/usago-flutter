import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/extensions/string_extension.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for register usecase
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Register use case - handles business logic for user registration
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase({required AuthRepository repository}) : _repository = repository;

  /// Execute registration with email, password and name
  ///
  /// Validates input before calling repository
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Business validation
    final emailValidation = params.email.validateEmail();
    if (emailValidation.isLeft()) {
      return Left(ValidationFailure(message: emailValidation.fold((l) => l, (r) => r)));
    }

    final passwordValidation = params.password.validatePassword();
    if (passwordValidation.isLeft()) {
      return Left(ValidationFailure(message: passwordValidation.fold((l) => l, (r) => r)));
    }

    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Name cannot be empty'));
    }

    // Additional business rules
    if (params.email.toLowerCase().contains('admin')) {
      return const Left(ValidationFailure(message: 'Admin registration not allowed through this method'));
    }

    // Delegate to repository
    return await _repository.register(
      email: params.email.trim(),
      password: params.password,
      name: params.name.trim(),
    );
  }
}