import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/menu_item_model.dart';
import '../models/user_dashboard_model.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/user_dashboard.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    try {
      final result = await _remoteDataSource.getMenuItems();

      return result.fold(
        (failure) => Left(failure),
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          return Right(entities);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get menu items: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, UserDashboard>> getUserDashboard() async {
    try {
      final result = await _remoteDataSource.getUserDashboard('');

      return result.fold(
        (failure) => Left(failure),
        (dashboard) {
          final entity = dashboard.toEntity();
          return Right(entity);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get user dashboard: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
      String category) async {
    try {
      final result = await _remoteDataSource.getMenuItemsByCategory(category);

      return result.fold(
        (failure) => Left(failure),
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          return Right(entities);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get menu items by category: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasMenuPermission(
      String menuId, String userId) async {
    try {
      final result = await _remoteDataSource.getMenuItems();

      return result.fold(
        (failure) => Left(failure),
        (menuItems) {
          final menuItem =
              menuItems.where((item) => item.id == menuId).firstOrNull;

          if (menuItem == null) {
            return const Right(false);
          }

          // For now, assume all authenticated users have permission
          // In real implementation, this would check user permissions
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to check menu permission: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuickStats(
    String userId,
    Map<String, dynamic> stats,
  ) async {
    try {
      // For now, just return success
      // In real implementation, this would update user stats
      await Future.delayed(const Duration(milliseconds: 100));

      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to update quick stats: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getFeaturedMenuItems() async {
    try {
      final result = await _remoteDataSource.getFeaturedMenuItems();

      return result.fold(
        (failure) => Left(failure),
        (menuItems) {
          final entities = menuItems.map((model) => model.toEntity()).toList();
          return Right(entities);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get featured menu items: ${e.toString()}',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> trackMenuUsage(
      String menuId, String userId) async {
    try {
      final result = await _remoteDataSource.trackMenuUsage(menuId, userId);

      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to track menu usage: ${e.toString()}',
        originalError: e,
      ));
    }
  }
}
