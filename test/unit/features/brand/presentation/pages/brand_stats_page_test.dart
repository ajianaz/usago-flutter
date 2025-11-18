import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usago/features/brand/presentation/pages/brand_stats_page.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BrandStatsPage Simple Tests', () {
    late Brand testBrand;

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

    setUp(() {
      final now = DateTime.now();
      testBrand = Brand(
        id: '1',
        name: 'Test Brand',
        slug: 'test-brand',
        ownerId: 'owner-1',
        businessType: 'RETAIL',
        settings: {},
        timezone: 'Asia/Jakarta',
        currency: 'IDR',
        subscriptionTier: 'BASIC',
        subscriptionStatus: 'ACTIVE',
        createdAt: now,
        updatedAt: now,
      );
    });

    testWidgets('should instantiate BrandStatsPage without errors', (WidgetTester tester) async {
      // Just verify widget can be instantiated
      expect(() => BrandStatsPage(brand: testBrand), returnsNormally);
    });
  });
}