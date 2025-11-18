import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/animated_text_field.dart';
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
          AnimatedTextField(
            controller: _nameController,
            labelText: context.t.name,
            hintText: context.t.enterYourName,
            prefixIcon: Icon(
              FontAwesomeIcons.user,
              size: 20,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.md),

          AnimatedTextField(
            controller: _emailController,
            labelText: context.t.authEmail,
            hintText: context.t.enterYourEmail,
            prefixIcon: Icon(
              FontAwesomeIcons.envelope,
              size: 20,
            ),
            keyboardType: TextInputType.emailAddress,
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

          AnimatedTextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            labelText: context.t.authPassword,
            hintText: context.t.enterYourPassword,
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

          SizedBox(height: AppSpacing.md),

          AnimatedTextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            labelText: context.t.confirmPassword,
            hintText: context.t.confirmYourPassword,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validationRequired;
              }
              if (value != _passwordController.text) {
                return context.t.passwordsDoNotMatch;
              }
              return null;
            },
          ),

          SizedBox(height: AppSpacing.lg),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AnimatedButton(
                text: context.t.authRegister,
                isLoading: state is AuthLoading,
                isFullWidth: true,
                onPressed: _submitForm,
              );
            },
          ),
        ],
      ),
    );
  }
}
