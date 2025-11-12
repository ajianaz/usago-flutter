import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'app/app.dart';
import 'core/helpers/instant_theme_helper.dart';
import 'core/helpers/instant_locale_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup all dependencies at startup
  await setupDependencies();

  // Initialize instant helpers for immediate theme and locale updates
  await Future.wait([
    InstantThemeHelper.instance.initialize(),
    InstantLocaleHelper.instance.initialize(),
  ]);

  runApp(const MyApp());
}
