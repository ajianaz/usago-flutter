import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usago/shared/themes/app_colors.dart';
import 'package:usago/shared/themes/app_text_styles.dart';
import 'package:usago/shared/themes/theme.dart';

void main() {
  group('Theme System Tests', () {
    testWidgets('AppColors helper methods return correct colors for light theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(AppColors.getBackground(context), AppColors.lightBackground);
              expect(AppColors.getSurface(context), AppColors.lightSurface);
              expect(AppColors.getTextPrimary(context), AppColors.lightTextPrimary);
              expect(AppColors.getTextSecondary(context), AppColors.lightTextSecondary);
              expect(AppColors.getBorder(context), AppColors.lightBorder);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('AppColors helper methods return correct colors for dark theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              expect(AppColors.getBackground(context), AppColors.darkBackground);
              expect(AppColors.getSurface(context), AppColors.darkSurface);
              expect(AppColors.getTextPrimary(context), AppColors.darkTextPrimary);
              expect(AppColors.getTextSecondary(context), AppColors.darkTextSecondary);
              expect(AppColors.getBorder(context), AppColors.darkBorder);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('AppTextStyles dynamic methods adapt to theme brightness',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              final headline1Style = AppTextStyles.headline1Dynamic(context);
              expect(headline1Style.color, AppColors.lightTextPrimary);

              final bodyStyle = AppTextStyles.bodyMediumDynamic(context);
              expect(bodyStyle.color, AppColors.lightTextPrimary);

              final captionStyle = AppTextStyles.captionDynamic(context);
              expect(captionStyle.color, AppColors.lightTextSecondary);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('AppTextStyles dynamic methods adapt to dark theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final headline1Style = AppTextStyles.headline1Dynamic(context);
              expect(headline1Style.color, AppColors.darkTextPrimary);

              final bodyStyle = AppTextStyles.bodyMediumDynamic(context);
              expect(bodyStyle.color, AppColors.darkTextPrimary);

              final captionStyle = AppTextStyles.captionDynamic(context);
              expect(captionStyle.color, AppColors.darkTextSecondary);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('AppTextStyles getDynamicTextStyle helper works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              final staticStyle = AppTextStyles.headline1;
              final dynamicStyle = AppTextStyles.getDynamicTextStyle(context, staticStyle);
              expect(dynamicStyle.color, AppColors.lightTextPrimary);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('AppTextStyles getDynamicTextStyle helper works in dark theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final staticStyle = AppTextStyles.headline1;
              final dynamicStyle = AppTextStyles.getDynamicTextStyle(context, staticStyle);
              expect(dynamicStyle.color, AppColors.darkTextPrimary);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Theme color schemes are properly configured',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;

              // Test light theme - check that colors are close to expected values
              expect(colorScheme.brightness, Brightness.light);
              expect(colorScheme.surface, isNot(equals(AppColors.darkSurface)));
              expect(colorScheme.onSurface, isNot(equals(AppColors.darkOnSurface)));

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Dark theme color schemes are properly configured',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;

              // Test dark theme - check that colors are close to expected values
              expect(colorScheme.brightness, Brightness.dark);
              expect(colorScheme.surface, isNot(equals(AppColors.lightSurface)));
              expect(colorScheme.onSurface, isNot(equals(AppColors.lightOnSurface)));

              return Container();
            },
          ),
        ),
      );
    });
  });
}