import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../models/menu_item_model.dart';
import '../models/user_dashboard_model.dart';

abstract class HomeRemoteDataSource {
  /// Get menu items from remote API
  Future<Either<Failure, List<MenuItemModel>>> getMenuItems();

  /// Get user dashboard from remote API
  Future<Either<Failure, UserDashboardModel>> getUserDashboard(String userId);

  /// Get featured menu items
  Future<Either<Failure, List<MenuItemModel>>> getFeaturedMenuItems();

  /// Get menu items by category
  Future<Either<Failure, List<MenuItemModel>>> getMenuItemsByCategory(String category);

  /// Track menu usage analytics
  Future<Either<Failure, void>> trackMenuUsage(String menuId, String userId);
}