import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import '../models/menu_item_model.dart';
import '../models/user_dashboard_model.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final AppLogger _logger;

  HomeRemoteDataSourceImpl({
    required AppLogger logger,
  }) : _logger = logger;

  @override
  Future<Either<Failure, List<MenuItemModel>>> getMenuItems() async {
    try {
      // For now, return default menu items
      // In real implementation, this would call API
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      final menuItems = MenuItemModel.getDefaultMenuItems();
      _logger.info('Successfully loaded ${menuItems.length} menu items');

      return Right(menuItems);
    } catch (e) {
      _logger.error('Error getting menu items: $e');
      return Left(NetworkFailure(message: 'Failed to load menu items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserDashboardModel>> getUserDashboard(String userId) async {
    try {
      // For now, return sample data
      // In real implementation, this would call API with userId
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay

      final dashboard = UserDashboardModel.createSample(userId: userId);
      _logger.info('Successfully loaded user dashboard for user: $userId');

      return Right(dashboard);
    } catch (e) {
      _logger.error('Error getting user dashboard: $e');
      return Left(NetworkFailure(message: 'Failed to load user dashboard: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemModel>>> getFeaturedMenuItems() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final allMenuItems = MenuItemModel.getDefaultMenuItems();
      final featuredItems = allMenuItems
          .where((item) => item.sortOrder <= 4) // First 4 items as featured
          .toList();

      _logger.info('Successfully loaded ${featuredItems.length} featured menu items');

      return Right(featuredItems);
    } catch (e) {
      _logger.error('Error getting featured menu items: $e');
      return Left(NetworkFailure(message: 'Failed to load featured menu items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemModel>>> getMenuItemsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final allMenuItems = MenuItemModel.getDefaultMenuItems();
      final filteredItems = allMenuItems
          .where((item) => item.category?.toLowerCase() == category.toLowerCase())
          .toList();

      _logger.info('Successfully loaded ${filteredItems.length} menu items for category: $category');

      return Right(filteredItems);
    } catch (e) {
      _logger.error('Error getting menu items by category: $e');
      return Left(NetworkFailure(message: 'Failed to load menu items for category: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> trackMenuUsage(String menuId, String userId) async {
    try {
      // In real implementation, this would send analytics to API
      await Future.delayed(const Duration(milliseconds: 100));

      _logger.info('Tracked menu usage: menuId=$menuId, userId=$userId');

      return const Right(null);
    } catch (e) {
      _logger.error('Error tracking menu usage: $e');
      return Left(NetworkFailure(message: 'Failed to track menu usage: ${e.toString()}'));
    }
  }
}