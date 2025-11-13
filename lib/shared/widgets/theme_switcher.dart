import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          icon: FaIcon(
            FontAwesomeIcons.circleHalfStroke,
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
                    FaIcon(FontAwesomeIcons.sun, size: 20),
                    const SizedBox(width: 8),
                    Text('Light'),
                    if (themeMode == ThemeMode.light) ...[
                      const Spacer(),
                      FaIcon(FontAwesomeIcons.check, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.moon, size: 20),
                    const SizedBox(width: 8),
                    Text('Dark'),
                    if (themeMode == ThemeMode.dark) ...[
                      const Spacer(),
                      FaIcon(FontAwesomeIcons.check, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.desktop, size: 20),
                    const SizedBox(width: 8),
                    Text('System'),
                    if (themeMode == ThemeMode.system) ...[
                      const Spacer(),
                      FaIcon(FontAwesomeIcons.check, color: Colors.blue, size: 16),
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