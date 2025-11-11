import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup all dependencies at startup
  await setupDependencies();

  runApp(const MyApp());
}
