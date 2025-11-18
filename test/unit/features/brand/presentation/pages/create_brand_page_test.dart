import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usago/features/brand/presentation/pages/create_brand_page.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CreateBrandPage Simple Tests', () {
    setUpAll(() async {
      // Initialize SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});

      // Initialize GetIt for testing
      await setupDependencies();
    });

    tearDownAll(() async {
      // Reset GetIt after tests
      await resetDependencies();
    });

    testWidgets('should instantiate CreateBrandPage without errors', (WidgetTester tester) async {
      // Just verify the widget can be instantiated
      expect(() => CreateBrandPage(), returnsNormally);
    });
  });
}