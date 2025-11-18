import 'package:flutter/material.dart';
import 'app_colors.dart';

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

  // Headline Styles (Static for backward compatibility)
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

  // Body Text Styles (Static for backward compatibility)
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

  // Button Text Styles (Static for backward compatibility)
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

  // Caption Styles (Static for backward compatibility)
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

  // Input Field Styles (Static for backward compatibility)
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

  // Link Styles (Static for backward compatibility)
  static TextStyle get link => TextStyle(
        fontSize: fontSizeLink,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: lineHeightTight,
        decoration: TextDecoration.underline,
      );

  // Error Styles (Static for backward compatibility)
  static TextStyle get error => TextStyle(
        fontSize: fontSizeError,
        fontWeight: FontWeight.normal,
        color: AppColors.error,
        height: lineHeightLoose,
      );

  // Success Styles (Static for backward compatibility)
  static TextStyle get success => TextStyle(
        fontSize: fontSizeSuccess,
        fontWeight: FontWeight.normal,
        color: AppColors.success,
        height: lineHeightLoose,
      );

  // Dynamic methods that adapt to theme brightness
  static TextStyle headline1Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline1,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle headline2Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline2,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle headline3Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline3,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle headline4Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline4,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle headline5Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline5,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle headline6Dynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeHeadline6,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  // Dynamic Body Text Styles
  static TextStyle bodyLargeDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeBodyLarge,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextPrimary(context),
        height: lineHeightNormal,
      );

  static TextStyle bodyMediumDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeBodyMedium,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextPrimary(context),
        height: lineHeightNormal,
      );

  static TextStyle bodySmallDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeBodySmall,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextPrimary(context),
        height: lineHeightNormal,
      );

  // Dynamic Button Text Styles
  static TextStyle buttonLargeDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeButtonLarge,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  static TextStyle buttonMediumDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeButtonMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  static TextStyle buttonSmallDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeButtonSmall,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: lineHeightTight,
      );

  // Dynamic Caption Styles
  static TextStyle captionDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextSecondary(context),
        height: lineHeightLoose,
      );

  static TextStyle overlineDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeOverline,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextSecondary(context),
        height: lineHeightLoose,
      );

  // Dynamic Input Field Styles
  static TextStyle inputLabelDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeInputLabel,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextSecondary(context),
        height: lineHeightTight,
      );

  static TextStyle inputTextDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeInputText,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextPrimary(context),
        height: lineHeightTight,
      );

  static TextStyle inputHintDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeInputHint,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextDisabled(context),
        height: lineHeightTight,
      );

  // Dynamic Link Styles
  static TextStyle linkDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeLink,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: lineHeightTight,
        decoration: TextDecoration.underline,
      );

  // Dynamic Error Styles (Theme-independent)
  static TextStyle errorDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeError,
        fontWeight: FontWeight.normal,
        color: AppColors.error,
        height: lineHeightLoose,
      );

  // Dynamic Success Styles (Theme-independent)
  static TextStyle successDynamic(BuildContext context) => TextStyle(
        fontSize: fontSizeSuccess,
        fontWeight: FontWeight.normal,
        color: AppColors.success,
        height: lineHeightLoose,
  );

  // Helper method to get appropriate text style based on brightness
  static TextStyle getTextStyleForBrightness({
    required BuildContext context,
    required TextStyle lightStyle,
    required TextStyle darkStyle,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? darkStyle : lightStyle;
  }

  // Helper method to get dynamic text style with context
  static TextStyle getDynamicTextStyle(BuildContext context, TextStyle staticStyle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor;

    // Determine the appropriate color based on the original style
    if (staticStyle.color == AppColors.textPrimary ||
        staticStyle.color == AppColors.lightTextPrimary) {
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else if (staticStyle.color == AppColors.textSecondary ||
               staticStyle.color == AppColors.lightTextSecondary) {
      textColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    } else if (staticStyle.color == AppColors.textDisabled ||
               staticStyle.color == AppColors.lightTextDisabled) {
      textColor = isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled;
    } else {
      // Keep the original color if it's not a text color
      textColor = staticStyle.color ?? AppColors.getTextPrimary(context);
    }

    return staticStyle.copyWith(color: textColor);
  }
}