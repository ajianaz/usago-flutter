import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';

class AppSpacing {
  // Base spacing unit
  static double get xs => UIConstants.spacingTiny;
  static double get sm => UIConstants.spacingSmall;
  static double get md => UIConstants.spacingDefault;
  static double get lg => UIConstants.spacingLarge;
  static double get xl => UIConstants.spacingExtraLarge;
  static double get xxl => 48.0;
  static double get xxxl => 64.0;

  // Padding constants
  static EdgeInsets get paddingAllXs => EdgeInsets.all(xs);
  static EdgeInsets get paddingAllSm => EdgeInsets.all(sm);
  static EdgeInsets get paddingAllMd => EdgeInsets.all(md);
  static EdgeInsets get paddingAllLg => EdgeInsets.all(lg);
  static EdgeInsets get paddingAllXl => EdgeInsets.all(xl);

  // Symmetric padding
  static EdgeInsets get paddingVerticalSm => EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get paddingVerticalMd => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get paddingVerticalLg => EdgeInsets.symmetric(vertical: lg);

  static EdgeInsets get paddingHorizontalSm => EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get paddingHorizontalMd => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get paddingHorizontalLg => EdgeInsets.symmetric(horizontal: lg);

  // Margin constants
  static EdgeInsets get marginAllXs => EdgeInsets.all(xs);
  static EdgeInsets get marginAllSm => EdgeInsets.all(sm);
  static EdgeInsets get marginAllMd => EdgeInsets.all(md);
  static EdgeInsets get marginAllLg => EdgeInsets.all(lg);
  static EdgeInsets get marginAllXl => EdgeInsets.all(xl);

  // Symmetric margin
  static EdgeInsets get marginVerticalSm => EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get marginVerticalMd => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get marginVerticalLg => EdgeInsets.symmetric(vertical: lg);

  static EdgeInsets get marginHorizontalSm => EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get marginHorizontalMd => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get marginHorizontalLg => EdgeInsets.symmetric(horizontal: lg);

  // Specific spacing combinations
  static EdgeInsets get paddingCard => EdgeInsets.all(md);
  static EdgeInsets get paddingScreen => EdgeInsets.all(lg);
  static EdgeInsets get paddingSection => EdgeInsets.symmetric(vertical: lg, horizontal: md);

  static EdgeInsets get marginCard => EdgeInsets.all(sm);
  static EdgeInsets get marginSection => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get marginBetweenItems => EdgeInsets.only(bottom: md);

  // Gap widgets
  static Widget get gapXs => SizedBox(width: xs);
  static Widget get gapSm => SizedBox(width: sm);
  static Widget get gapMd => SizedBox(width: md);
  static Widget get gapLg => SizedBox(width: lg);
  static Widget get gapXl => SizedBox(width: xl);

  static Widget get verticalGapXs => SizedBox(height: xs);
  static Widget get verticalGapSm => SizedBox(height: sm);
  static Widget get verticalGapMd => SizedBox(height: md);
  static Widget get verticalGapLg => SizedBox(height: lg);
  static Widget get verticalGapXl => SizedBox(height: xl);

  // Border radius
  static BorderRadius get radiusXs => BorderRadius.all(Radius.circular(xs));
  static BorderRadius get radiusSm => BorderRadius.all(Radius.circular(sm));
  static BorderRadius get radiusMd => BorderRadius.all(Radius.circular(md));
  static BorderRadius get radiusLg => BorderRadius.all(Radius.circular(lg));
  static BorderRadius get radiusXl => BorderRadius.all(Radius.circular(xl));

  // Specific radius
  static BorderRadius get radiusCard => BorderRadius.all(Radius.circular(md));
  static BorderRadius get radiusButton => BorderRadius.all(Radius.circular(sm));
  static BorderRadius get radiusInput => BorderRadius.all(Radius.circular(sm));
}