import 'package:flutter/material.dart';
import '../../core/helpers/instant_locale_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../i18n/translations.g.dart';

/// Language switcher widget with no delay
/// Uses InstantLocaleHelper for immediate language updates
class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  final InstantLocaleHelper _localeHelper = InstantLocaleHelper.instance;

  @override
  void initState() {
    super.initState();
    _localeHelper.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLocale>(
      valueListenable: _localeHelper.localeNotifier,
      builder: (context, currentLocale, child) {
        final supportedLocales = _localeHelper.getSupportedLocales();

        return PopupMenuButton<AppLocale>(
          icon: const FaIcon(FontAwesomeIcons.language, size: 20),
          tooltip: 'Change Language',
          onSelected: (AppLocale locale) {
            _localeHelper.changeLocale(locale);
            _showLanguageChangedSnackBar(context, locale);
          },
          itemBuilder: (BuildContext context) {
            return AppLocale.values.map((AppLocale locale) {
              final isSelected = currentLocale == locale;
              final displayName = _localeHelper.getLocaleDisplayName(locale);

              return PopupMenuItem<AppLocale>(
                value: locale,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FaIcon(FontAwesomeIcons.check, color: Colors.blue, size: 16),
                      )
                    else
                      const SizedBox(width: 24),
                    Flexible(
                      child: Text(
                        displayName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  void _showLanguageChangedSnackBar(BuildContext context, AppLocale locale) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${_localeHelper.getLocaleDisplayName(locale)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}