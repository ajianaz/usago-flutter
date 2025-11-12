import 'package:flutter/material.dart';
import '../../core/helpers/instant_theme_helper.dart';

/// Theme switcher widget with no delay
/// Uses InstantThemeHelper for immediate theme updates
class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  final InstantThemeHelper _themeHelper = InstantThemeHelper.instance;

  @override
  void initState() {
    super.initState();
    _themeHelper.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeHelper.themeNotifier,
      builder: (context, themeMode, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            Icons.brightness_6,
            color: Theme.of(context).iconTheme.color,
          ),
          tooltip: 'Change theme',
          onSelected: (ThemeMode selectedThemeMode) {
            _themeHelper.changeTheme(selectedThemeMode);
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode, size: 20),
                    const SizedBox(width: 8),
                    Text('Light'),
                    if (themeMode == ThemeMode.light) ...[
                      const Spacer(),
                      Icon(Icons.check, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode, size: 20),
                    const SizedBox(width: 8),
                    Text('Dark'),
                    if (themeMode == ThemeMode.dark) ...[
                      const Spacer(),
                      Icon(Icons.check, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.settings_brightness, size: 20),
                    const SizedBox(width: 8),
                    Text('System'),
                    if (themeMode == ThemeMode.system) ...[
                      const Spacer(),
                      Icon(Icons.check, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }
}