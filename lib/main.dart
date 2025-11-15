import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'core/config/env_config.dart';
import 'core/config/app_config.dart';
import 'app/app.dart';
import 'core/helpers/instant_theme_helper.dart';
import 'core/helpers/instant_locale_helper.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment configuration first
    await EnvConfig.initialize();

    // Validate required environment variables
    final missingVars = AppConfig.validateRequiredVariables();
    if (missingVars.isNotEmpty) {
      if (kDebugMode) {
        print('Warning: Missing required environment variables: ${missingVars.join(', ')}');
      }
      // In production, you might want to throw an exception or handle this differently
      if (AppConfig.isProduction) {
        throw Exception('Missing required environment variables: ${missingVars.join(', ')}');
      }
    }

    // Debug print configuration in debug mode
    AppConfig.debugPrintConfig();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing environment configuration: $e');
    }
    // Continue with default values if environment initialization fails
    await EnvConfig.initialize(envFileName: '.env.development');
  }

  // Setup all dependencies at startup
  await setupDependencies();

  // Initialize instant helpers for immediate theme and locale updates
  await Future.wait([
    InstantThemeHelper.instance.initialize(),
    InstantLocaleHelper.instance.initialize(),
  ]);

  runApp(const MyApp());
}
