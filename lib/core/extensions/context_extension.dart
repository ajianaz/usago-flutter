import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../i18n/app_localizations.g.dart';
import '../../shared/widgets/responsive_builder.dart';

/// Extension methods on BuildContext
extension ContextExtension on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is mobile (phone)
  /// Range: < 600dp
  bool get isMobile => screenWidth < 600;

  /// Check if device is tablet
  /// Range: 600dp - 1200dp
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if device is desktop
  /// Range: ≥ 1200dp
  bool get isDesktop => screenWidth >= 1200;

  /// Get device type as string
  String get deviceType {
    if (isDesktop) return 'desktop';
    if (isTablet) return 'tablet';
    return 'mobile';
  }

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get localizations using Slang extension
  AppLocalizations get t => AppLocalizationsExtension(this).t;

  /// Show snackbar
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Get BLoC of type [T]
  T readBloc<T extends BlocBase>() {
    return read<T>();
  }

  /// Watch BLoC of type [T]
  T watchBloc<T extends BlocBase>() {
    return watch<T>();
  }

  /// Navigate to named route
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// Replace with named route
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pop until route with name
  void popUntilNamed(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }


  /// Responsive layout builder helper
  Widget responsiveLayout({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.mobile:
            return mobile;
        }
      },
    );
  }

  /// Get responsive value based on device type
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  // Tambahkan di context_extension.dart
/// Get responsive padding
EdgeInsets get responsivePadding {
  if (isDesktop) return const EdgeInsets.all(32.0);
  if (isTablet) return const EdgeInsets.all(24.0);
  return const EdgeInsets.all(16.0);
}

/// Get responsive margin
EdgeInsets get responsiveMargin {
  if (isDesktop) return const EdgeInsets.all(24.0);
  if (isTablet) return const EdgeInsets.all(16.0);
  return const EdgeInsets.all(12.0);
}

/// Get responsive spacing
double get responsiveSpacing {
  if (isDesktop) return 24.0;
  if (isTablet) return 16.0;
  return 12.0;
}

/// Get responsive font size
double responsiveFontSize(double baseSize) {
  if (isDesktop) return baseSize * 1.2;
  if (isTablet) return baseSize * 1.1;
  return baseSize;
}

}