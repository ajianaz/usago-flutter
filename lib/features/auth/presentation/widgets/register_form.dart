import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/context_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Form(
      key: _formKey,
      child: Column(
        children: [
          AnimatedTextField(
            controller: _nameController,
            labelText: context.t.auth.name,
            hintText: context.t.auth.enter_your_name,
            prefixIcon: Icon(
              FontAwesomeIcons.user,
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
              return null;
            },
          ),

          SizedBox(height: _getSpacing(context)),

          AnimatedTextField(
            controller: _emailController,
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
            keyboardType: TextInputType.emailAddress,
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
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
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

          SizedBox(height: _getSpacing(context)),

          AnimatedTextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            labelText: context.t.auth.confirm_password,
            hintText: context.t.auth.confirm_your_password,
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
                _obscureConfirmPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: context.responsiveValue(
                  mobile: 20.0,
                  tablet: 22.0,
                  desktop: 24.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validation.required;
              }
              if (value != _passwordController.text) {
                return context.t.auth.passwords_do_not_match;
              }
              return null;
            },
          ),

          SizedBox(height: _getLargeSpacing(context)),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AnimatedButton(
                text: context.t.auth.register,
                isLoading: state is AuthLoading,
                isFullWidth: true,
                onPressed: _submitForm,
                size: _getButtonSize(context),
              );
            },
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
