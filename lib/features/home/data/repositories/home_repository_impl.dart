import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/logger.dart';
import '../datasources/home_remote_datasource.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/user_dashboard.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final ErrorHandler _errorHandler;
  final AppLogger _logger;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
    required AppLogger logger,
  }) : _remoteDataSource = remoteDataSource,
       _errorHandler = errorHandler,
       _logger = logger;

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Getting menu items');

      final result = await _remoteDataSource.getMenuItems();

      return result.fold(
        (failure) {
          _logger.error('Failed to get menu items from datasource: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          _logger.info('Successfully retrieved ${entities.length} menu items');
          return entities;
        },
      );
    });
  }

  @override
  Future<Either<Failure, UserDashboard>> getUserDashboard() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Getting user dashboard');

      final result = await _remoteDataSource.getUserDashboard('');

      return result.fold(
        (failure) {
          _logger.error('Failed to get user dashboard from datasource: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (dashboard) {
          final entity = dashboard.toEntity();
          _logger.info('Successfully retrieved user dashboard');
          return entity;
        },
      );
    });
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(String category) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Getting menu items for category: $category');

      final result = await _remoteDataSource.getMenuItemsByCategory(category);

      return result.fold(
        (failure) {
          _logger.error('Failed to get menu items by category from datasource: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          _logger.info('Successfully retrieved ${entities.length} menu items for category: $category');
          return entities;
        },
      );
    });
  }

  @override
  Future<Either<Failure, bool>> hasMenuPermission(String menuId, String userId) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Checking menu permission for menuId: $menuId, userId: $userId');

      final result = await _remoteDataSource.getMenuItems();

      return result.fold(
        (failure) {
          _logger.error('Failed to get menu items for permission check: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (menuItems) {
          final menuItem = menuItems
              .where((item) => item.id == menuId)
              .firstOrNull;

          if (menuItem == null) {
            _logger.warning('Menu item not found for menuId: $menuId');
            return false;
          }

          // For now, assume all authenticated users have permission
          // In real implementation, this would check user permissions
          _logger.info('Permission granted for menuId: $menuId, userId: $userId');
          return true;
        },
      );
    });
  }

  @override
  Future<Either<Failure, void>> updateQuickStats(
    String userId,
    Map<String, dynamic> stats,
  ) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Updating quick stats for userId: $userId');

      // For now, just return success
      // In real implementation, this would update user stats
      await Future.delayed(const Duration(milliseconds: 100));

      _logger.info('Successfully updated quick stats for userId: $userId');
    });
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getFeaturedMenuItems() async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Getting featured menu items');

      final result = await _remoteDataSource.getFeaturedMenuItems();

      return result.fold(
        (failure) {
          _logger.error('Failed to get featured menu items from datasource: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          _logger.info('Successfully retrieved ${entities.length} featured menu items');
          return entities;
        },
      );
    });
  }

  @override
  Future<Either<Failure, void>> trackMenuUsage(String menuId, String userId) async {
    return _errorHandler.safeExecute(() async {
      _logger.info('Tracking menu usage for menuId: $menuId, userId: $userId');

      final result = await _remoteDataSource.trackMenuUsage(menuId, userId);

      return result.fold(
        (failure) {
          _logger.error('Failed to track menu usage: ${failure.message}', failure);
          throw failure.originalError ?? Exception(failure.message);
        },
        (_) {
          _logger.info('Successfully tracked menu usage for menuId: $menuId, userId: $userId');
        },
      );
    });
  }
}