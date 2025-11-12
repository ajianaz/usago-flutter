import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/locale_service.dart';
import '../../l10n/app_localizations.g.dart';

/// Language switcher widget
/// Allows users to switch between supported languages
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeService = getIt<LocaleService>();
    final supportedLocales = localeService.getSupportedLocales();
    final currentLocale = Localizations.localeOf(context);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, size: 20),
      tooltip: 'Change Language',
      onSelected: (Locale locale) {
        _changeLanguage(context, locale);
      },
      itemBuilder: (BuildContext context) {
        return supportedLocales.map((Locale locale) {
          final isSelected = currentLocale.languageCode == locale.languageCode;
          final displayName = localeService.getLocaleDisplayName(locale);

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
      child: const Icon(Icons.language, size: 20),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.t.commonSave),
          content: Text('Change language to ${getIt<LocaleService>().getLocaleDisplayName(locale)}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.t.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Change the language using locale service
                getIt<LocaleService>().changeLocale(locale);
                _showLanguageChangedSnackBar(context, locale);
              },
              child: Text(context.t.commonOk),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageChangedSnackBar(BuildContext context, Locale locale) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${getIt<LocaleService>().getLocaleDisplayName(locale)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}