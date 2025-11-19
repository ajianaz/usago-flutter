import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/user_header.dart';
import '../widgets/feature_grid.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';

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
          context.t.auth.login,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: const ThemeSwitcher(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const LanguageSwitcher(),
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is AuthFailure) {
            context.showErrorSnackBar(authState.message);
          }
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, homeState) {
            if (homeState is HomeFailure) {
              context.showErrorSnackBar(homeState.message);
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // User Header Section
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, homeState) {
                          return UserHeader(
                            user: authState is AuthSuccess ? authState.user : null,
                            userDashboard: homeState is HomeLoaded ? homeState.userDashboard : null,
                            onProfileTap: () {
                              context.router.pushNamed('/profile');
                            },
                            onNotificationTap: () {
                              context.router.pushNamed('/notifications');
                            },
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Welcome Section
                  Text(
                    context.t.auth.welcome_back,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    context.t.auth.sign_in_to_continue,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

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
                            context.router.pushNamed(menuItem.route);
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}