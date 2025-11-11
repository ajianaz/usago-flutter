import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for update profile usecase
class UpdateProfileParams extends Equatable {
  final String? name;
  final String? profilePicture;

  const UpdateProfileParams({
    this.name,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [name, profilePicture];
}

/// Update profile use case - handles business logic for updating user profile
class UpdateProfileUsecase {
  final AuthRepository _repository;

  UpdateProfileUsecase({required AuthRepository repository}) : _repository = repository;

  /// Execute profile update
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    // Delegate to repository
    return await _repository.updateProfile(
      name: params.name,
      profilePicture: params.profilePicture,
    );
  }
}