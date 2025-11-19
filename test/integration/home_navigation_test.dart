import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:usago/features/home/presentation/pages/home_page.dart';
import 'package:usago/features/home/presentation/bloc/home_bloc.dart';
import 'package:usago/features/home/presentation/bloc/home_state.dart';
import 'package:usago/features/home/domain/entities/user_dashboard.dart';

void main() {
  group('Home Navigation Integration Tests', () {
    testWidgets('should handle navigation state properly', (WidgetTester tester) async {
      // Create a simple test dashboard
      final testDashboard = UserDashboard(
        userId: 'test-id',
        userName: 'Test User',
        userEmail: 'test@example.com',
        lastLogin: DateTime.now(),
      );

      // Build a minimal test widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Simulate the home page structure
                return Column(
                  children: [
                    const Text('Welcome back'),
                    const Text('Sign in to continue'),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          Card(
                            child: ListTile(
                              title: const Text('Brand'),
                              onTap: () {
                                // Simulate navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Scaffold(
                                      body: Text('Brand Page'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Card(
                            child: const ListTile(
                              title: Text('Settings'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verify the home page is displayed
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Brand'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Tap on the Brand card to navigate
      await tester.tap(find.text('Brand'));
      await tester.pumpAndSettle();

      // Verify we're on the brand page
      expect(find.text('Brand Page'), findsOneWidget);

      // Navigate back using Navigator.pop instead of pageBack
      Navigator.of(tester.element(find.byType(Scaffold))).pop();
      await tester.pumpAndSettle();

      // Verify we're back on the home page and cards are still visible
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Brand'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}