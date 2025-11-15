import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../../core/constants/ui_constants.dart';

class AppTextStyles {
  // Font Size Constants
  static const double fontSizeHeadline1 = 32.0;
  static const double fontSizeHeadline2 = 28.0;
  static const double fontSizeHeadline3 = 24.0;
  static const double fontSizeHeadline4 = 20.0;
  static const double fontSizeHeadline5 = 18.0;
  static const double fontSizeHeadline6 = 16.0;
  static const double fontSizeBodyLarge = 16.0;
  static const double fontSizeBodyMedium = 14.0;
  static const double fontSizeBodySmall = 12.0;
  static const double fontSizeButtonLarge = 16.0;
  static const double fontSizeButtonMedium = 14.0;
  static const double fontSizeButtonSmall = 12.0;
  static const double fontSizeCaption = 12.0;
  static const double fontSizeOverline = 10.0;
  static const double fontSizeInputLabel = 14.0;
  static const double fontSizeInputText = 16.0;
  static const double fontSizeInputHint = 14.0;
  static const double fontSizeLink = 14.0;
  static const double fontSizeError = 14.0;
  static const double fontSizeSuccess = 14.0;

  // Line Height Constants
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightLoose = 1.4;

  // Headline Styles
  static TextStyle get headline1 => TextStyle(
        fontSize: fontSizeHeadline1,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get headline2 => TextStyle(
        fontSize: fontSizeHeadline2,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get headline3 => TextStyle(
        fontSize: fontSizeHeadline3,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get headline4 => TextStyle(
        fontSize: fontSizeHeadline4,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get headline5 => TextStyle(
        fontSize: fontSizeHeadline5,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get headline6 => TextStyle(
        fontSize: fontSizeHeadline6,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  // Body Text Styles
  static TextStyle get bodyLarge => TextStyle(
        fontSize: fontSizeBodyLarge,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: lineHeightNormal,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: fontSizeBodyMedium,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: lineHeightNormal,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: fontSizeBodySmall,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: lineHeightNormal,
      );

  // Button Text Styles
  static TextStyle get buttonLarge => TextStyle(
        fontSize: fontSizeButtonLarge,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  static TextStyle get buttonMedium => TextStyle(
        fontSize: fontSizeButtonMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  static TextStyle get buttonSmall => TextStyle(
        fontSize: fontSizeButtonSmall,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  // Caption Styles
  static TextStyle get caption => TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: lineHeightLoose,
      );

  static TextStyle get overline => TextStyle(
        fontSize: fontSizeOverline,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: lineHeightLoose,
      );

  // Input Field Styles
  static TextStyle get inputLabel => TextStyle(
        fontSize: fontSizeInputLabel,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: lineHeightTight,
      );

  static TextStyle get inputText => TextStyle(
        fontSize: fontSizeInputText,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: lineHeightTight,
      );

  static TextStyle get inputHint => TextStyle(
        fontSize: fontSizeInputHint,
        fontWeight: FontWeight.normal,
        color: AppColors.textDisabled,
        height: lineHeightTight,
      );

  // Link Styles
  static TextStyle get link => TextStyle(
        fontSize: fontSizeLink,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: lineHeightTight,
        decoration: TextDecoration.underline,
      );

  // Error Styles
  static TextStyle get error => TextStyle(
        fontSize: fontSizeError,
        fontWeight: FontWeight.normal,
        color: AppColors.error,
        height: lineHeightLoose,
      );

  // Success Styles
  static TextStyle get success => TextStyle(
        fontSize: fontSizeSuccess,
        fontWeight: FontWeight.normal,
        color: AppColors.success,
        height: lineHeightLoose,
      );
}
