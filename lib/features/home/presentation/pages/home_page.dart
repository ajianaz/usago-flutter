import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/user_header.dart';
import '../widgets/feature_grid.dart';

/// Home page
/// Main dashboard after user login
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<HomeBloc>()),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Load home data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const LoadHomeData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usago',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              // TODO: Implement logout
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const RefreshHomeData());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header Section
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  return BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, homeState) {
                      return UserHeader(
                        user: authState is AuthSuccess ? authState.user : null,
                        userDashboard: homeState is HomeLoaded ? homeState.userDashboard : null,
                        onProfileTap: () {
                          // TODO: Navigate to profile
                        },
                        onNotificationTap: () {
                          // TODO: Navigate to notifications
                        },
                      );
                    },
                  );
                },
              ),

              AppSpacing.verticalGapLg,

              // Welcome Section
              Text(
                'Apa yang ingin Anda lakukan hari ini? 🎯',
                style: AppTextStyles.headline4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              AppSpacing.verticalGapSm,

              Text(
                'Pilih fitur yang tersedia di bawah ini',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              AppSpacing.verticalGapLg,

              // Menu Grid Section
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  if (homeState is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (homeState is HomeLoaded) {
                    return FeatureGrid(
                      menuItems: homeState.filteredMenuItems,
                      onMenuTap: (menuItem) {
                        context.read<HomeBloc>().add(NavigateToMenu(menuItem));
                        // TODO: Navigate to menu route
                        // context.router.pushNamed(menuItem.route);
                      },
                    );
                  }

                  if (homeState is HomeFailure) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          AppSpacing.verticalGapMd,
                          Text(
                            'Terjadi kesalahan',
                            style: AppTextStyles.headline6.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          AppSpacing.verticalGapSm,
                          Text(
                            homeState.message,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.verticalGapMd,
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(const LoadHomeData());
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}