import 'package:flutter/material.dart';

/// Konstanta UI yang digunakan di seluruh aplikasi
class UIConstants {
  const UIConstants._();

  // ==================== Spacing & Padding ====================

  /// Padding default untuk container (16.0)
  static const double paddingDefault = 16.0;

  /// Padding kecil (8.0)
  static const double paddingSmall = 8.0;

  /// padding sangat kecil (4.0)
  static const double paddingTiny = 4.0;

  /// Padding besar (24.0)
  static const double paddingLarge = 24.0;

  /// Padding sangat besar (32.0)
  static const double paddingExtraLarge = 32.0;

  // ==================== Border Radius ====================

  /// Border radius default (8.0)
  static const double borderRadiusDefault = 8.0;

  /// Border radius kecil (4.0)
  static const double borderRadiusSmall = 4.0;

  /// Border radius besar (12.0)
  static const double borderRadiusLarge = 12.0;

  /// Border radius untuk circular widget
  static const double borderRadiusCircular = 100.0;

  // ==================== Breakpoints ====================

  /// Breakpoint untuk mobile (600dp)
  static const double breakpointMobile = 600.0;

  /// Breakpoint untuk tablet (1200dp)
  static const double breakpointTablet = 1200.0;

  /// Breakpoint untuk desktop (1920dp)
  static const double breakpointDesktop = 1920.0;

  // ==================== EdgeInsets Helpers ====================

  /// EdgeInsets symmetric horizontal default
  static const EdgeInsets paddingHorizontal =
      EdgeInsets.symmetric(horizontal: paddingDefault);

  /// EdgeInsets symmetric vertical default
  static const EdgeInsets paddingVertical =
      EdgeInsets.symmetric(vertical: paddingDefault);

  /// EdgeInsets all default
  static const EdgeInsets paddingAll = EdgeInsets.all(paddingDefault);

  /// EdgeInsets all small
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);

  /// EdgeInsets all tiny
  static const EdgeInsets paddingAllTiny = EdgeInsets.all(paddingTiny);

  // ==================== Dimensions ====================

  /// Height untuk button default (48.0)
  static const double buttonHeight = 48.0;

  /// Height untuk button small (36.0)
  static const double buttonHeightSmall = 36.0;

  /// Height untuk input field default (56.0)
  static const double inputFieldHeight = 56.0;

  /// Width untuk icon default (24.0)
  static const double iconSizeDefault = 24.0;

  /// Width untuk icon small (16.0)
  static const double iconSizeSmall = 16.0;

  /// Width untuk icon large (32.0)
  static const double iconSizeLarge = 32.0;

  // ==================== Spacing ====================

  /// Spacing antar items kecil (4.0)
  static const double spacingTiny = 4.0;

  /// Spacing antar items small (8.0)
  static const double spacingSmall = 8.0;

  /// Spacing antar items default (16.0)
  static const double spacingDefault = 16.0;

  /// Spacing antar items besar (24.0)
  static const double spacingLarge = 24.0;

  /// Spacing antar items sangat besar (32.0)
  static const double spacingExtraLarge = 32.0;

  // ==================== Shadow ====================

  /// Elevation untuk card default
  static const double elevationCard = 4.0;

  /// Elevation untuk button
  static const double elevationButton = 2.0;

  /// Elevation untuk modal/dialog
  static const double elevationModal = 8.0;

  // ==================== Screen ====================

  /// Minimum width untuk responsive layout
  static const double minScreenWidth = 320.0;

  /// Maximum width untuk content pada desktop
  static const double maxContentWidth = 1200.0;
}