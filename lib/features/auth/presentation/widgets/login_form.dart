import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../i18n/translations.g.dart';

/// Login form widget
/// Handles user input for login
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        context.read<AuthBloc>().add(LoginEvent(
          email: email,
          password: password,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          AnimatedTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: context.t.auth.email,
            hintText: context.t.auth.enter_your_email,
            prefixIcon: Icon(
              FontAwesomeIcons.envelope,
              size: context.responsiveValue(
                mobile: 20.0,
                tablet: 22.0,
                desktop: 24.0,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validation.required;
              }
              if (!value.isValidEmail) {
                return context.t.validation.email_invalid;
              }
              return null;
            },
          ),

          SizedBox(height: _getSpacing(context)),

          // Password field
          AnimatedTextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            labelText: context.t.auth.password,
            hintText: context.t.auth.enter_your_password,
            prefixIcon: Icon(
              FontAwesomeIcons.lock,
              size: context.responsiveValue(
                mobile: 20.0,
                tablet: 22.0,
                desktop: 24.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: context.responsiveValue(
                  mobile: 20.0,
                  tablet: 22.0,
                  desktop: 24.0,
                ),
              ),
              onPressed: _togglePasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validation.required;
              }
              if (value.length < 6) {
                return context.t.validation.password_too_short;
              }
              return null;
            },
          ),

          SizedBox(height: _getLargeSpacing(context)),

          // Login button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AnimatedButton(
                text: context.t.auth.login,
                isLoading: state is AuthLoading,
                onPressed: _submitForm,
                isFullWidth: true,
                size: _getButtonSize(context),
              );
            },
          ),

          SizedBox(height: _getSpacing(context)),

          // Forgot password link
          TextButton(
            onPressed: () {
              context.router.pushNamed('/forgot-password');
            },
            child: Text(
              context.t.auth.forgot_password,
              style: TextStyle(
                fontSize: context.responsiveFontSize(14),
              ),
            ),
          ),
        ],
      ),
    );

    // Apply desktop constraint if needed
    if (context.isDesktop) {
      return DesktopConstrainedContent(child: formContent);
    }

    return formContent;
  }

  double _getSpacing(BuildContext context) {
    return context.responsiveValue(
      mobile: AppSpacing.md,
      tablet: AppSpacing.lg,
      desktop: AppSpacing.xl,
    );
  }

  double _getLargeSpacing(BuildContext context) {
    return context.responsiveValue(
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxl,
    );
  }

  AnimatedButtonSize _getButtonSize(BuildContext context) {
    if (context.isMobile) {
      return AnimatedButtonSize.medium;
    }
    return AnimatedButtonSize.large;
  }
}