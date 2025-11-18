import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:usago/features/brand/presentation/pages/brand_invitation_list_page.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/core/di/injection_container.dart';

void main() {
  group('BrandInvitationListPage Simple Tests', () {
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

    testWidgets('should render BrandInvitationListPage without errors', (tester) async {
      // Arrange
      final brandInvitationListPage = BrandInvitationListPage(brand: testBrand);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: brandInvitationListPage,
          ),
        ),
      );

      // Assert
      expect(find.byType(BrandInvitationListPage), findsOneWidget);
    });
  });
}