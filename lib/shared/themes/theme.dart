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
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
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
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
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
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.border),
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
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
          side: const BorderSide(color: AppColors.border),
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
        color: AppColors.border,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
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
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline4?.copyWith(
          color: const Color(0xFFFFFFFF),
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
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusButton,
          ),
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
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
          padding: AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusInput,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.inputLabel?.copyWith(
          color: const Color(0xFFAAAAAA),
        ),
        hintStyle: AppTextStyles.inputHint?.copyWith(
          color: const Color(0xFF666666),
        ),
        contentPadding: AppSpacing.paddingAllMd,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
          side: const BorderSide(color: Color(0xFF333333)),
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
        color: Color(0xFF333333),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        contentTextStyle: AppTextStyles.bodyMedium?.copyWith(
          color: const Color(0xFFFFFFFF),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusCard,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFFAAAAAA),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.buttonSmall,
        unselectedLabelStyle: AppTextStyles.buttonSmall,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}