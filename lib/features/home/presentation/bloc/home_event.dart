import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/user_dashboard.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadHomeData extends HomeEvent {
  final String? userId;

  const LoadHomeData({this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshHomeData extends HomeEvent {
  final String? userId;

  const RefreshHomeData({this.userId});

  @override
  List<Object?> get props => [userId];
}

class NavigateToMenu extends HomeEvent {
  final MenuItem menuItem;

  const NavigateToMenu(this.menuItem);

  @override
  List<Object?> get props => [menuItem];
}

class TrackMenuUsage extends HomeEvent {
  final String menuId;
  final String userId;

  const TrackMenuUsage({
    required this.menuId,
    required this.userId,
  });

  @override
  List<Object?> get props => [menuId, userId];
}

class FilterMenuByCategory extends HomeEvent {
  final String category;

  const FilterMenuByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ClearMenuFilter extends HomeEvent {
  const ClearMenuFilter();

  @override
  List<Object?> get props => [];
}