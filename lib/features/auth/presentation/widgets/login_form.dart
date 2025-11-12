import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../l10n/app_localizations.g.dart';

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
              labelText: context.t.authEmail,
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (!value.isValidEmail) {
                return context.t.validationEmailInvalid;
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
              labelText: context.t.authPassword,
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (value.length < 6) {
                return context.t.validationPasswordTooShort;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Login button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: context.t.authLogin,
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
            child: Text(context.t.authForgotPassword),
          ),
        ],
      ),
    );
  }
}