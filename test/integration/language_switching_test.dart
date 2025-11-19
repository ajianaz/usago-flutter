// Language Switching Integration Tests
// Purpose: Test language switching functionality across all brand components
// Follows Flutter development guidelines for testing structure and patterns

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usago/core/di/injection_container.dart';
import 'package:usago/core/helpers/instant_locale_helper.dart';
import 'package:usago/i18n/translations.g.dart';

/// Focused integration tests for language switching functionality
///
/// This test suite verifies:
/// - Instant locale switching functionality
/// - Translation updates across brand components
/// - Slang integration with context.t.* calls
/// - Language preference persistence
///
/// Test Structure:
/// - Follows Arrange-Act-Assert pattern consistently
/// - Tests both English to Indonesian and Indonesian to English switching
/// - Validates UI state changes and text updates
void main() {
  group('Language Switching Integration Tests', () {
    late InstantLocaleHelper localeHelper;

    setUpAll(() async {
      // Initialize mock dependencies for all tests
      SharedPreferences.setMockInitialValues({});
      await setupDependencies();
    });

    setUp(() async {
      // Initialize InstantLocaleHelper for testing
      localeHelper = InstantLocaleHelper.instance;
      await localeHelper.initialize();
    });

    tearDown(() async {
      // Reset to English after each test
      try {
        await localeHelper.changeLocale(AppLocale.en);
      } catch (e) {
        // Ignore if already disposed
      }
    });

    tearDownAll(() async {
      // Clean up dependencies after all tests
      try {
        await resetDependencies();
      } catch (e) {
        // Ignore if already disposed
      }
    });

    testWidgets('Should switch language from English to Indonesian', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text(context.t.brand.brand_selection),
                      Text(context.t.brand.create_brand),
                      Text(context.t.brand.edit_brand),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Initially should be in English (default)
      expect(find.text('Select Brand'), findsOneWidget);
      expect(find.text('Create New Brand'), findsOneWidget);
      expect(find.text('Edit Brand'), findsOneWidget);
      expect(find.text('Pilih Brand'), findsNothing);

      // Act - Switch to Indonesian
      await localeHelper.changeLocale(AppLocale.id);
      await tester.pumpAndSettle();

      // Assert - Should now be in Indonesian
      expect(find.text('Pilih Brand'), findsOneWidget);
      expect(find.text('Buat Brand Baru'), findsOneWidget);
      expect(find.text('Edit Brand'), findsOneWidget);
      expect(find.text('Select Brand'), findsNothing);
    });

    testWidgets('Should switch language from Indonesian to English', (tester) async {
      // Arrange - Start with Indonesian
      await localeHelper.changeLocale(AppLocale.id);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text(context.t.brand.brand_selection),
                      Text(context.t.brand.create_brand),
                      Text(context.t.brand.edit_brand),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Initially should be in Indonesian
      expect(find.text('Pilih Brand'), findsOneWidget);
      expect(find.text('Buat Brand Baru'), findsOneWidget);
      expect(find.text('Edit Brand'), findsOneWidget);
      expect(find.text('Select Brand'), findsNothing);

      // Act - Switch to English
      await localeHelper.changeLocale(AppLocale.en);
      await tester.pumpAndSettle();

      // Assert - Should now be in English
      expect(find.text('Select Brand'), findsOneWidget);
      expect(find.text('Create New Brand'), findsOneWidget);
      expect(find.text('Edit Brand'), findsOneWidget);
      expect(find.text('Pilih Brand'), findsNothing);
    });

    testWidgets('Should toggle language correctly using toggleLanguage method', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Text(context.t.brand.brand_selection);
                },
              ),
            ),
          ),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Initially should be in English
      expect(find.text('Select Brand'), findsOneWidget);

      // Act - Toggle to Indonesian
      await localeHelper.toggleLanguage();
      await tester.pumpAndSettle();

      // Assert - Should now be in Indonesian
      expect(find.text('Pilih Brand'), findsOneWidget);

      // Act - Toggle back to English
      await localeHelper.toggleLanguage();
      await tester.pumpAndSettle();

      // Assert - Should be back to English
      expect(find.text('Select Brand'), findsOneWidget);
    });

    testWidgets('Should handle multiple rapid language switches without errors', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Text(context.t.brand.brand_selection);
                },
              ),
            ),
          ),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Act - Perform multiple rapid switches
      for (int i = 0; i < 5; i++) {
        await localeHelper.toggleLanguage();
        await tester.pump(); // Only pump once per switch to test rapid changes
      }

      await tester.pumpAndSettle();

      // Assert - Should still be functional without crashes
      // Check that text is present in either language
      final hasEnglish = find.text('Select Brand').evaluate().isNotEmpty;
      final hasIndonesian = find.text('Pilih Brand').evaluate().isNotEmpty;
      expect(hasEnglish || hasIndonesian, isTrue);
    });

    testWidgets('Should update form validation messages when language changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text(context.t.brand.brand_name_required),
                      Text(context.t.brand.slug_required),
                      Text(context.t.brand.email_required),
                      Text(context.t.brand.confirmation_code_required),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check English validation messages
      expect(find.text('Brand name is required'), findsOneWidget);
      expect(find.text('Slug is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Confirmation code is required'), findsOneWidget);

      // Act - Switch to Indonesian
      await localeHelper.changeLocale(AppLocale.id);
      await tester.pumpAndSettle();

      // Check Indonesian validation messages
      expect(find.text('Nama brand wajib diisi'), findsOneWidget);
      expect(find.text('Slug wajib diisi'), findsOneWidget);
      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Kode konfirmasi wajib diisi'), findsOneWidget);
    });

    testWidgets('Should update success and error messages when language changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      // Success messages
                      Text(context.t.brand.brand_created_successfully),
                      Text(context.t.brand.brand_updated_successfully),
                      Text(context.t.brand.invitation_sent_successfully),

                      // Error messages
                      Text(context.t.brand.failed_to_load_brands),
                      Text(context.t.brand.brand_creation_failed),
                      Text(context.t.brand.invitation_send_failed),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check English messages
      expect(find.text('Brand created successfully'), findsOneWidget);
      expect(find.text('Brand updated successfully'), findsOneWidget);
      expect(find.text('Invitation sent successfully'), findsOneWidget);
      expect(find.text('Failed to load brands'), findsOneWidget);
      expect(find.text('Brand creation failed'), findsOneWidget);
      expect(find.text('Failed to send invitation'), findsOneWidget);

      // Act - Switch to Indonesian
      await localeHelper.changeLocale(AppLocale.id);
      await tester.pumpAndSettle();

      // Check Indonesian messages
      expect(find.text('Brand berhasil dibuat'), findsOneWidget);
      expect(find.text('Brand berhasil diperbarui'), findsOneWidget);
      expect(find.text('Undangan berhasil dikirim'), findsOneWidget);
      expect(find.text('Gagal memuat brands'), findsOneWidget);
      expect(find.text('Pembuatan brand gagal'), findsOneWidget);
      expect(find.text('Gagal mengirim undangan'), findsOneWidget);
    });

    testWidgets('Should update business type and role labels when language changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      // Business types
                      Text(context.t.brand.service),
                      Text(context.t.brand.retail),
                      Text(context.t.brand.manufacturing),
                      Text(context.t.brand.other),

                      // User roles
                      Text(context.t.brand.brand_owner),
                      Text(context.t.brand.brand_admin),
                      Text(context.t.brand.branch_manager),
                      Text(context.t.brand.branch_admin),
                      Text(context.t.brand.branch_staff),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check English labels
      expect(find.text('Service'), findsOneWidget);
      expect(find.text('Retail'), findsOneWidget);
      expect(find.text('Manufacturing'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
      expect(find.text('Brand Owner'), findsOneWidget);
      expect(find.text('Brand Admin'), findsOneWidget);
      expect(find.text('Branch Manager'), findsOneWidget);
      expect(find.text('Branch Admin'), findsOneWidget);
      expect(find.text('Branch Staff'), findsOneWidget);

      // Act - Switch to Indonesian
      await localeHelper.changeLocale(AppLocale.id);
      await tester.pumpAndSettle();

      // Check Indonesian labels
      expect(find.text('Layanan'), findsOneWidget);
      expect(find.text('Ritel'), findsOneWidget);
      expect(find.text('Manufaktur'), findsOneWidget);
      expect(find.text('Lainnya'), findsOneWidget);
      expect(find.text('Pemilik Brand'), findsOneWidget);
      expect(find.text('Admin Brand'), findsOneWidget);
      expect(find.text('Manajer Cabang'), findsOneWidget);
      expect(find.text('Admin Cabang'), findsOneWidget);
      expect(find.text('Staf Cabang'), findsOneWidget);
    });

    testWidgets('Should persist language preference across app restarts', (tester) async {
      // Act - Set language to Indonesian
      await localeHelper.changeLocale(AppLocale.id);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Text(context.t.brand.brand_selection);
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Verify Indonesian is active
      expect(find.text('Pilih Brand'), findsOneWidget);

      // Act - Simulate app restart by creating new app instance
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Text(context.t.brand.brand_selection);
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Language should still be Indonesian after restart
      expect(find.text('Pilih Brand'), findsOneWidget);
      expect(find.text('Select Brand'), findsNothing);
    });
  });
}