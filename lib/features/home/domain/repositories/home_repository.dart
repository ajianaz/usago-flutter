import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/menu_item.dart';
import '../entities/user_dashboard.dart';

/// Repository contract for home feature
abstract class HomeRepository {
  /// Get available menu items for the current user
  Future<Either<Failure, List<MenuItem>>> getMenuItems();

  /// Get user dashboard information
  Future<Either<Failure, UserDashboard>> getUserDashboard();

  /// Get menu items by category
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
      String category);

  /// Check if user has permission for specific menu
  Future<Either<Failure, bool>> hasMenuPermission(String menuId, String userId);

  /// Update user's quick stats
  Future<Either<Failure, void>> updateQuickStats(
    String userId,
    Map<String, dynamic> stats,
  );

  /// Get featured/recommended menu items
  Future<Either<Failure, List<MenuItem>>> getFeaturedMenuItems();

  /// Track menu item usage for analytics
  Future<Either<Failure, void>> trackMenuUsage(String menuId, String userId);
}
