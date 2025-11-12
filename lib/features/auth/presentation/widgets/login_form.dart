import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/context_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: context.tr('authEmail'),
              hintText: context.tr('enterYourEmail'),
              prefixIcon: const FaIcon(FontAwesomeIcons.envelope),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('validationRequired');
              }
              if (!value.isValidEmail) {
                return context.tr('validationEmailInvalid');
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.md),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: context.tr('authPassword'),
              hintText: context.tr('enterYourPassword'),
              prefixIcon: const FaIcon(FontAwesomeIcons.lock),
              suffixIcon: IconButton(
                icon: FaIcon(_obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('validationRequired');
              }
              if (value.length < 6) {
                return context.tr('validationPasswordTooShort');
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Login button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: context.tr('authLogin'),
                isLoading: state is AuthLoading,
                onPressed: _submitForm,
              );
            },
          ),

          SizedBox(height: AppSpacing.md),

          // Forgot password link
          TextButton(
            onPressed: () {
              // TODO: Navigate to forgot password
            },
            child: Text(context.tr('authForgotPassword')),
          ),
        ],
      ),
    );
  }
}