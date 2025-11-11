import 'package:flutter/material.dart';

class AppSpacing {
  // Base spacing unit
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Padding constants
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  // Symmetric padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  // Margin constants
  static const EdgeInsets marginAllXs = EdgeInsets.all(xs);
  static const EdgeInsets marginAllSm = EdgeInsets.all(sm);
  static const EdgeInsets marginAllMd = EdgeInsets.all(md);
  static const EdgeInsets marginAllLg = EdgeInsets.all(lg);
  static const EdgeInsets marginAllXl = EdgeInsets.all(xl);

  // Symmetric margin
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets marginHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets marginHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  // Specific spacing combinations
  static const EdgeInsets paddingCard = EdgeInsets.all(md);
  static const EdgeInsets paddingScreen = EdgeInsets.all(lg);
  static const EdgeInsets paddingSection = EdgeInsets.symmetric(vertical: lg, horizontal: md);

  static const EdgeInsets marginCard = EdgeInsets.all(sm);
  static const EdgeInsets marginSection = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginBetweenItems = EdgeInsets.only(bottom: md);

  // Gap widgets
  static const Widget gapXs = SizedBox(width: xs);
  static const Widget gapSm = SizedBox(width: sm);
  static const Widget gapMd = SizedBox(width: md);
  static const Widget gapLg = SizedBox(width: lg);
  static const Widget gapXl = SizedBox(width: xl);

  static const Widget verticalGapXs = SizedBox(height: xs);
  static const Widget verticalGapSm = SizedBox(height: sm);
  static const Widget verticalGapMd = SizedBox(height: md);
  static const Widget verticalGapLg = SizedBox(height: lg);
  static const Widget verticalGapXl = SizedBox(height: xl);

  // Border radius
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));

  // Specific radius
  static const BorderRadius radiusCard = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusButton = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusInput = BorderRadius.all(Radius.circular(sm));
}