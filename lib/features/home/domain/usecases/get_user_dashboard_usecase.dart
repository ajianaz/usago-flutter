import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_dashboard.dart';
import '../repositories/home_repository.dart';

class GetUserDashboardParams {
  final String userId;

  const GetUserDashboardParams({
    required this.userId,
  });
}

class GetUserDashboardUseCase {
  final HomeRepository _repository;

  GetUserDashboardUseCase(this._repository);

  Future<Either<Failure, UserDashboard>> call(
      GetUserDashboardParams params) async {
    return await _repository.getUserDashboard();
  }
}
