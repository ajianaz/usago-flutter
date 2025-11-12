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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.tr('name'),
              hintText: context.tr('enterYourName'),
              prefixIcon: Icon(
                FontAwesomeIcons.user,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('validationRequired');
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.tr('authEmail'),
              hintText: context.tr('enterYourEmail'),
              prefixIcon: Icon(
                FontAwesomeIcons.envelope,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
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

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: context.tr('authPassword'),
              hintText: context.tr('enterYourPassword'),
              prefixIcon: Icon(
                FontAwesomeIcons.lock,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
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

          SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: context.tr('confirmPassword'),
              hintText: context.tr('confirmYourPassword'),
              prefixIcon: Icon(
                FontAwesomeIcons.lock,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('validationRequired');
              }
              if (value != _passwordController.text) {
                return context.tr('passwordsDoNotMatch');
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: context.tr('authRegister'),
                isLoading: state is AuthLoading,
                onPressed: _submitForm,
              );
            },
          ),
        ],
      ),
    );
  }
}
