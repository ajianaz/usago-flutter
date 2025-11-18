import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTextStyles.buttonLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.inputLabel,
        hintStyle: AppTextStyles.inputHint,
        contentPadding: AppSpacing.paddingAllMd,
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.paddingAllMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.buttonSmall,
        unselectedLabelStyle: AppTextStyles.buttonSmall,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline4.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTextStyles.buttonLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding:
              AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.inputLabel.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(
          color: AppColors.darkTextDisabled,
        ),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
        contentPadding: AppSpacing.paddingAllMd,
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.paddingAllMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.buttonSmall,
        unselectedLabelStyle: AppTextStyles.buttonSmall,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      iconTheme: IconThemeData(
        color: AppColors.darkTextPrimary,
      ),
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.darkTextPrimary),
        displayMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.darkTextPrimary),
        displaySmall:
            AppTextStyles.headline3.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge:
            AppTextStyles.headline4.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium:
            AppTextStyles.headline5.copyWith(color: AppColors.darkTextPrimary),
        headlineSmall:
            AppTextStyles.headline6.copyWith(color: AppColors.darkTextPrimary),
        titleLarge:
            AppTextStyles.headline6.copyWith(color: AppColors.darkTextPrimary),
        titleMedium:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        titleSmall:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
        bodySmall:
            AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
        labelLarge:
            AppTextStyles.buttonLarge.copyWith(color: AppColors.darkTextPrimary),
        labelMedium: AppTextStyles.buttonMedium
            .copyWith(color: AppColors.darkTextPrimary),
        labelSmall:
            AppTextStyles.buttonSmall.copyWith(color: AppColors.darkTextPrimary),
      ),
    );
  }
}