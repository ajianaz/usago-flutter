import 'package:flutter/material.dart';

// Placeholder for auth page - will be created when auth feature is implemented
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Login Page - Will be implemented'),
      ),
    );
  }
}

// Simple router for now - will be replaced with auto_route later
class AppRouter {
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}