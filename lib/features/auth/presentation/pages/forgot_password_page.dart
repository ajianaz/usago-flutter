import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/router.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Forgot Password Page
/// Handles password reset requests with responsive design
@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
      title: Text(context.t.authForgotPassword),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();
        },
      ),
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
    setState(() {
      _isSubmitting = state is AuthLoading;
    });

    if (state is PasswordResetEmailSent) {
      context.showSuccessSnackBar(context.t.passwordResetEmailSent(state.email));
      // Navigate back to login after successful submission
      Future.delayed(const Duration(seconds: 2), () {
        context.pop();
      });
    } else if (state is AuthFailure) {
      context.showErrorSnackBar(state.message);
    }
  }

  Widget _buildBody(BuildContext context, AuthBloc authBloc, AuthState state, DeviceType deviceType) {
    if (state is AuthLoading && _isSubmitting) {
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
        // Left side - Forgot Password Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: context.responsivePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildForgotPasswordForm(context, authBloc),
                const SizedBox(height: 24),
                _buildBackToLoginLink(context),
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
                _buildForgotPasswordForm(context, authBloc),
                const SizedBox(height: 24),
                _buildBackToLoginLink(context),
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
          _buildForgotPasswordForm(context, authBloc),
          const SizedBox(height: 24),
          _buildBackToLoginLink(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.key,
          size: context.responsiveValue(
            mobile: 48.0,
            tablet: 64.0,
            desktop: 96.0,
          ),
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          context.t.authForgotPassword,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: context.responsiveFontSize(24),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.t.forgotPasswordDescription,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: context.responsiveFontSize(16),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm(BuildContext context, AuthBloc authBloc) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: context.t.authEmail,
              hintText: context.t.enterYourEmail,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: context.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: context.colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return context.t.validationEmailInvalid;
              }
              return null;
            },
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 24),

          // Submit Button
          ElevatedButton(
            onPressed: _isSubmitting ? null : () => _submitForm(authBloc),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : Text(context.t.sendResetLink),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.t.rememberPassword),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(context.t.backToLogin),
        ),
      ],
    );
  }

  void _submitForm(AuthBloc authBloc) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      authBloc.add(ForgotPasswordEvent(email: email));
    }
  }
}