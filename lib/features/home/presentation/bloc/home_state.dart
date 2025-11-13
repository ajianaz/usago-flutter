import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/user_dashboard.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<MenuItem> menuItems;
  final List<MenuItem> filteredMenuItems;
  final UserDashboard userDashboard;
  final String? selectedCategory;

  const HomeLoaded({
    required this.menuItems,
    required this.userDashboard,
    this.filteredMenuItems = const [],
    this.selectedCategory,
  });

  HomeLoaded copyWith({
    List<MenuItem>? menuItems,
    List<MenuItem>? filteredMenuItems,
    UserDashboard? userDashboard,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      menuItems: menuItems ?? this.menuItems,
      filteredMenuItems: filteredMenuItems ?? this.filteredMenuItems,
      userDashboard: userDashboard ?? this.userDashboard,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        menuItems,
        filteredMenuItems,
        userDashboard,
        selectedCategory,
      ];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class HomeNavigation extends HomeState {
  final String route;
  final MenuItem menuItem;

  const HomeNavigation({
    required this.route,
    required this.menuItem,
  });

  @override
  List<Object?> get props => [route, menuItem];
}

class HomeMenuUsageTracked extends HomeState {
  final String menuId;
  final bool success;

  const HomeMenuUsageTracked({
    required this.menuId,
    required this.success,
  });

  @override
  List<Object?> get props => [menuId, success];
}