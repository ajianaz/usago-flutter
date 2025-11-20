import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/logger.dart';
import '../models/menu_item_model.dart';
import '../models/user_dashboard_model.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final AppLogger _logger;
  final ErrorHandler _errorHandler;

  HomeRemoteDataSourceImpl({
    required AppLogger logger,
    required ErrorHandler errorHandler,
  }) : _logger = logger,
       _errorHandler = errorHandler;

  @override
  Future<Either<Failure, List<MenuItemModel>>> getMenuItems() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Loading menu items from remote datasource');

      // For now, return default menu items
      // In real implementation, this would call API
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      final menuItems = MenuItemModel.getDefaultMenuItems();
      _logger.info('Successfully loaded ${menuItems.length} menu items from remote datasource');

      return menuItems;
    });
  }

  @override
  Future<Either<Failure, UserDashboardModel>> getUserDashboard(String userId) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Loading user dashboard for user: $userId from remote datasource');

      // For now, return sample data
      // In real implementation, this would call API with userId
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay

      final dashboard = UserDashboardModel.createSample(userId: userId);
      _logger.info('Successfully loaded user dashboard for user: $userId from remote datasource');

      return dashboard;
    });
  }

  @override
  Future<Either<Failure, List<MenuItemModel>>> getFeaturedMenuItems() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Loading featured menu items from remote datasource');

      await Future.delayed(const Duration(milliseconds: 300));

      final allMenuItems = MenuItemModel.getDefaultMenuItems();
      final featuredItems = allMenuItems
          .where((item) => item.sortOrder <= 4) // First 4 items as featured
          .toList();

      _logger.info('Successfully loaded ${featuredItems.length} featured menu items from remote datasource');

      return featuredItems;
    });
  }

  @override
  Future<Either<Failure, List<MenuItemModel>>> getMenuItemsByCategory(String category) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Loading menu items for category: $category from remote datasource');

      await Future.delayed(const Duration(milliseconds: 300));

      final allMenuItems = MenuItemModel.getDefaultMenuItems();
      final filteredItems = allMenuItems
          .where((item) => item.category?.toLowerCase() == category.toLowerCase())
          .toList();

      _logger.info('Successfully loaded ${filteredItems.length} menu items for category: $category from remote datasource');

      return filteredItems;
    });
  }

  @override
  Future<Either<Failure, void>> trackMenuUsage(String menuId, String userId) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Tracking menu usage: menuId=$menuId, userId=$userId from remote datasource');

      // In real implementation, this would send analytics to API
      await Future.delayed(const Duration(milliseconds: 100));

      _logger.info('Successfully tracked menu usage: menuId=$menuId, userId=$userId from remote datasource');
    });
  }
}