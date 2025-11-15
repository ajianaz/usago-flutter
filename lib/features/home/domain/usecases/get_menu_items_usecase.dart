import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/menu_item.dart';
import '../repositories/home_repository.dart';

class GetMenuItemsParams {
  final String? category;
  final bool? featuredOnly;
  final String? userId;

  const GetMenuItemsParams({
    this.category,
    this.featuredOnly,
    this.userId,
  });
}

class GetMenuItemsUseCase {
  final HomeRepository _repository;

  GetMenuItemsUseCase(this._repository);

  Future<Either<Failure, List<MenuItem>>> call(
      GetMenuItemsParams params) async {
    if (params.category != null) {
      return await _repository.getMenuItemsByCategory(params.category!);
    } else if (params.featuredOnly == true) {
      return await _repository.getFeaturedMenuItems();
    } else {
      return await _repository.getMenuItems();
    }
  }
}
