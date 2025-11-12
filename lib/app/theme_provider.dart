import 'package:flutter/material.dart';
import '../core/services/theme_service.dart';

/// Provider for managing theme state
class ThemeProvider extends StatefulWidget {
  final Widget child;

  const ThemeProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await ThemeService.instance.getThemeMode();
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  Future<void> _updateThemeMode(ThemeMode themeMode) async {
    await ThemeService.instance.saveThemeMode(themeMode);
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeProvider(
      themeMode: _themeMode,
      updateTheme: _updateThemeMode,
      child: widget.child,
    );
  }

  /// Method to update theme from outside
  static void updateTheme(BuildContext context, ThemeMode themeMode) async {
    final updateFunction = _InheritedThemeProvider.getUpdateTheme(context);
    if (updateFunction != null) {
      await updateFunction(themeMode);
    }
  }
}

class _InheritedThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final Widget child;
  final Function(ThemeMode)? updateTheme;

  const _InheritedThemeProvider({
    Key? key,
    required this.themeMode,
    required this.child,
    this.updateTheme,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedThemeProvider oldWidget) {
    return oldWidget.themeMode != themeMode;
  }

  static ThemeMode? of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_InheritedThemeProvider>();
    return provider?.themeMode;
  }

  static Function(ThemeMode)? getUpdateTheme(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_InheritedThemeProvider>();
    return provider?.updateTheme;
  }
}