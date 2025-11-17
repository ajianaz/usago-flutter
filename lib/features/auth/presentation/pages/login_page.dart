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
import '../widgets/login_form.dart';

/// Login Page
/// Handles user authentication with responsive design
@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      title: Text(context.t.authLogin),
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
    } else if (state is PasswordResetEmailSent) {
      context.showSuccessSnackBar('Password reset email sent to ${state.email}');
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
        // Left side - Login Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: context.responsivePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginForm(),
                const SizedBox(height: 24),
                _buildRegisterLink(context),
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
                const LoginForm(),
                const SizedBox(height: 24),
                _buildRegisterLink(context),
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
          const LoginForm(),
          const SizedBox(height: 24),
          _buildRegisterLink(context),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthBloc authBloc) {
    return const LoginForm();
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.lock,
          size: context.responsiveValue(
            mobile: 48.0,
            tablet: 64.0,
            desktop: 96.0,
          ),
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          context.t.authWelcomeBack,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: context.responsiveFontSize(24),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.t.authSignInToContinue,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: context.responsiveFontSize(16),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.t.authDontHaveAccount),
        TextButton(
          onPressed: () {
            context.router.pushNamed('/register');
          },
          child: Text(context.t.authRegister),
        ),
      ],
    );
  }
}