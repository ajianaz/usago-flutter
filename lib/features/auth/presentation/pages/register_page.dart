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
import '../widgets/register_form.dart';

/// Register Page
/// Handles user registration with responsive design
@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
      title: Text(context.t.authRegister),
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
    if (state is AuthSuccess) {
      context.router.replace(const HomeRoute());
    } else if (state is AuthFailure) {
      context.showErrorSnackBar(state.message);
    }
  }

  Widget _buildBody(BuildContext context, AuthBloc authBloc, AuthState state, DeviceType deviceType) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context, authBloc);
      case DeviceType.tablet:
        return _buildTabletLayout(context, authBloc);
      case DeviceType.mobile:
        return _buildMobileLayout(context, authBloc);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, AuthBloc authBloc) {
    return Row(
      children: [
        // Left side - Register Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: context.responsivePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegisterForm(),
                const SizedBox(height: 24),
                _buildLoginLink(context),
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
            child: _buildWelcomeSection(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AuthBloc authBloc) {
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
                const RegisterForm(),
                const SizedBox(height: 24),
                _buildLoginLink(context),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: _buildWelcomeSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthBloc authBloc) {
    return SingleChildScrollView(
      padding: context.responsivePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          _buildWelcomeSection(context),
          const SizedBox(height: 40),
          const RegisterForm(),
          const SizedBox(height: 24),
          _buildLoginLink(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.userPlus,
          size: context.responsiveValue(
            mobile: 48.0,
            tablet: 64.0,
            desktop: 96.0,
          ),
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          context.t.authCreateAccount,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: context.responsiveFontSize(24),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.t.authSignUpToContinue,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: context.responsiveFontSize(16),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.t.authAlreadyHaveAccount),
        TextButton(
          onPressed: () {
            context.router.pushNamed('/login');
          },
          child: Text(context.t.authLogin),
        ),
      ],
    );
  }
}