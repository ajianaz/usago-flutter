import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usago/features/brand/presentation/pages/brand_selection_page.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BrandSelectionPage Simple Tests', () {
    setUpAll(() async {
      // Initialize SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});

      // Initialize GetIt for tests
      await getIt.reset();
      await setupDependencies();
    });

    tearDownAll(() async {
      // Clean up GetIt after tests
      await getIt.reset();
    });

    testWidgets('should instantiate BrandSelectionPage without errors', (WidgetTester tester) async {
      // Just verify widget can be instantiated
      expect(() => BrandSelectionPage(), returnsNormally);
    });
  });
}