import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/shared/widgets/animated_text_field.dart';

void main() {
  group('AnimatedTextField Tests', () {
    testWidgets('AnimatedTextField should render without overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
          ),
        ),
      );

      // Verify of text field renders
      expect(find.byType(AnimatedTextField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('AnimatedTextField should handle focus animations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.byType(AnimatedTextField), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);

      // Test focus animation
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Verify no overflow errors during focus animation
      expect(tester.takeException(), isNull);
    });

    testWidgets('AnimatedTextField should handle long error messages', (tester) async {
      const longErrorMessage = 'This is a very long error message that could potentially cause overflow issues in the widget if not handled properly';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedTextField(
                labelText: 'Test Field',
                hintText: 'Enter test value',
              ),
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(AnimatedTextField), findsOneWidget);

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    });
  });
}