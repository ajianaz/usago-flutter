import 'package:flutter/material.dart';
import '../../core/helpers/instant_locale_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return ValueListenableBuilder<Locale>(
      valueListenable: _localeHelper.localeNotifier,
      builder: (context, currentLocale, child) {
        final supportedLocales = _localeHelper.getSupportedLocales();

        return PopupMenuButton<Locale>(
          icon: const FaIcon(FontAwesomeIcons.language, size: 20),
          tooltip: 'Change Language',
          onSelected: (Locale locale) {
            _localeHelper.changeLocale(locale);
            _showLanguageChangedSnackBar(context, locale);
          },
          itemBuilder: (BuildContext context) {
            return supportedLocales.map((Locale locale) {
              final isSelected = currentLocale.languageCode == locale.languageCode;
              final displayName = _localeHelper.getLocaleDisplayName(locale);

              return PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.check, color: Colors.blue, size: 16),
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

  void _showLanguageChangedSnackBar(BuildContext context, Locale locale) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${_localeHelper.getLocaleDisplayName(locale)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}