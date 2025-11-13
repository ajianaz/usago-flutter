import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/usecases/get_menu_items_usecase.dart';
import '../../domain/usecases/get_user_dashboard_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMenuItemsUseCase _getMenuItemsUseCase;
  final GetUserDashboardUseCase _getUserDashboardUseCase;

  HomeBloc({
    required GetMenuItemsUseCase getMenuItemsUseCase,
    required GetUserDashboardUseCase getUserDashboardUseCase,
  }) : _getMenuItemsUseCase = getMenuItemsUseCase,
       _getUserDashboardUseCase = getUserDashboardUseCase,
       super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<NavigateToMenu>(_onNavigateToMenu);
    on<TrackMenuUsage>(_onTrackMenuUsage);
    on<FilterMenuByCategory>(_onFilterMenuByCategory);
    on<ClearMenuFilter>(_onClearMenuFilter);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final menuItemsResult = await _getMenuItemsUseCase(
      const GetMenuItemsParams(),
    );

    final dashboardResult = await _getUserDashboardUseCase(
      GetUserDashboardParams(userId: event.userId ?? ''),
    );

    return menuItemsResult.fold(
      (failure) => emit(HomeFailure(message: failure.message)),
      (menuItems) {
        return dashboardResult.fold(
          (failure) => emit(HomeFailure(message: failure.message)),
          (dashboard) {
            final enabledMenuItems = menuItems
                .where((item) => item.isEnabled)
                .toList()
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

            emit(HomeLoaded(
              menuItems: enabledMenuItems,
              filteredMenuItems: enabledMenuItems,
              userDashboard: dashboard,
            ));
          },
        );
      },
    );
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // Reuse LoadHomeData logic for refresh
    add(LoadHomeData(userId: event.userId));
  }

  void _onNavigateToMenu(
    NavigateToMenu event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeNavigation(
      route: event.menuItem.route,
      menuItem: event.menuItem,
    ));
  }

  Future<void> _onTrackMenuUsage(
    TrackMenuUsage event,
    Emitter<HomeState> emit,
  ) async {
    // Track usage analytics
    emit(HomeMenuUsageTracked(
      menuId: event.menuId,
      success: true,
    ));
  }

  void _onFilterMenuByCategory(
    FilterMenuByCategory event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final filteredItems = event.category == 'all'
          ? currentState.menuItems
          : currentState.menuItems
              .where((item) => item.category == event.category)
              .toList();

      emit(currentState.copyWith(
        filteredMenuItems: filteredItems,
        selectedCategory: event.category,
      ));
    }
  }

  void _onClearMenuFilter(
    ClearMenuFilter event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        filteredMenuItems: currentState.menuItems,
        selectedCategory: null,
      ));
    }
  }
}