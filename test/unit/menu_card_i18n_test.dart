import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/features/home/domain/entities/menu_item.dart';
import 'package:usago/features/home/presentation/widgets/menu_card.dart';
import 'package:usago/i18n/translations.g.dart';

void main() {
  group('MenuCard i18n Tests', () {
    late MenuItem testMenuItem;

    setUp(() {
      testMenuItem = const MenuItem(
        id: '1',
        title: 'Dashboard',
        description: 'Lihat overview dan statistik',
        icon: 'dashboard',
        route: '/dashboard',
      );
    });

    testWidgets('MenuCard displays translated title and description in English', (WidgetTester tester) async {
      // Set up English locale
      await LocaleSettings.setLocale(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: MenuCard(
                menuItem: testMenuItem,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Verify English translations are displayed
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('View overview and statistics'), findsOneWidget);
    });

    testWidgets('MenuCard displays translated title and description in Indonesian', (WidgetTester tester) async {
      // Set up Indonesian locale
      await LocaleSettings.setLocale(AppLocale.id);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: MenuCard(
                menuItem: testMenuItem,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Verify Indonesian translations are displayed
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Lihat overview dan statistik'), findsOneWidget);
    });

    testWidgets('MenuCard falls back to original text when translation not found', (WidgetTester tester) async {
      // Create a menu item with an ID that doesn't have translations
      const untranslatedMenuItem = MenuItem(
        id: '999',
        title: 'Original Title',
        description: 'Original Description',
        icon: 'dashboard',
        route: '/dashboard',
      );

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: MenuCard(
                menuItem: untranslatedMenuItem,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Verify original text is displayed as fallback
      expect(find.text('Original Title'), findsOneWidget);
      expect(find.text('Original Description'), findsOneWidget);
    });
  });
}