import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usago/features/brand/presentation/pages/brand_transfer_page.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BrandTransferPage Simple Tests', () {
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

    testWidgets('should instantiate BrandTransferPage without errors', (WidgetTester tester) async {
      // Create a mock brand for testing
      final testBrand = Brand(
        id: 'test-id',
        name: 'Test Brand',
        slug: 'test-brand',
        ownerId: 'test-owner',
        businessType: 'RETAIL',
        settings: {},
        timezone: 'Asia/Jakarta',
        currency: 'IDR',
        subscriptionTier: 'BASIC',
        subscriptionStatus: 'ACTIVE',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Just verify widget can be instantiated
      expect(() => BrandTransferPage(brand: testBrand), returnsNormally);
    });
  });
}