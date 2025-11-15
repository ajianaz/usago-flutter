// File: apps/mobile/lib/features/auth/presentation/pages/profile_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/router.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/profile_form.dart';

/// Responsive Profile Page
/// Handles user profile management with responsive design
@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayout<AuthBloc, AuthState>(
      builder: (context, authBloc, state, deviceType) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context, authBloc, state, deviceType),
        );
      },
      listener: (context, state) {
        _handleAuthStates(context, state);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
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
      ],
    );
  }

  void _handleAuthStates(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      context.showErrorSnackBar(state.message);
    }
  }

  Widget _buildBody(BuildContext context, AuthBloc authBloc, AuthState state,
      DeviceType deviceType) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is! AuthSuccess) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.user,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Please login to view profile',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.router.pushNamed('/login');
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }

    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context, authBloc, state.user!);
      case DeviceType.tablet:
        return _buildTabletLayout(context, authBloc, state.user!);
      case DeviceType.mobile:
        return _buildMobileLayout(context, authBloc, state.user!);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, AuthBloc authBloc, user) {
    return Row(
      children: [
        // Left side - Profile Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: context.responsivePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileForm(),
                const SizedBox(height: 24),
                _buildActionButtons(context, user),
              ],
            ),
          ),
        ),
        // Right side - Welcome Section
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary.withOpacity(0.1),
                  context.colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: _buildWelcomeSection(context, user),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AuthBloc authBloc, user) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileForm(),
                const SizedBox(height: 24),
                _buildActionButtons(context, user),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: _buildWelcomeSection(context, user),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthBloc authBloc, user) {
    return SingleChildScrollView(
      padding: context.responsivePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          _buildWelcomeSection(context, user),
          const SizedBox(height: 40),
          const ProfileForm(),
          const SizedBox(height: 24),
          _buildActionButtons(context, user),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.userCircle,
          size: context.responsiveValue(
            mobile: 48.0,
            tablet: 64.0,
            desktop: 96.0,
          ),
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'My Profile',
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: context.responsiveFontSize(24),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your personal information and preferences',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: context.responsiveFontSize(16),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    user.isEmailVerified
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circleExclamation,
                    size: 16,
                    color: user.isEmailVerified
                        ? context.colorScheme.primary
                        : context.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.isEmailVerified
                        ? 'Email Verified'
                        : 'Email Not Verified',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: user.isEmailVerified
                          ? context.colorScheme.primary
                          : context.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, user) {
    return Column(
      children: [
        // Change Password Button
        OutlinedButton.icon(
          onPressed: () {
            context.router.pushNamed('/change-password');
          },
          icon: const Icon(FontAwesomeIcons.key, size: 16),
          label: const Text('Change Password'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Delete Account Button
        TextButton.icon(
          onPressed: () {
            _showDeleteAccountDialog(context, user);
          },
          icon: Icon(
            FontAwesomeIcons.trash,
            size: 16,
            color: context.colorScheme.error,
          ),
          label: Text(
            'Delete Account',
            style: TextStyle(
              color: context.colorScheme.error,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.router.maybePop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.router.maybePop();
                // TODO: Implement delete account functionality
                context.showSnackBar('Delete account will be implemented soon');
              },
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
