import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/register_form.dart';
import '../../../../app/router.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../../../../core/extensions/context_extension.dart';

/// Register page
/// Handles user registration
@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('authRegister')),
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
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to home page on successful registration
            context.router.replace(const HomeRoute());
          } else if (state is AuthFailure) {
            // Show error message
            context.showErrorSnackBar(state.message);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    context.tr('authCreateAccount'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('authSignUpToContinue'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  const RegisterForm(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.tr('authAlreadyHaveAccount')),
                      TextButton(
                        onPressed: () {
                          context.router.pushNamed('/login');
                        },
                        child: Text(context.tr('authLogin')),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}