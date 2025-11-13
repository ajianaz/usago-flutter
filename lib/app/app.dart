import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../shared/themes/theme.dart';
import '../core/di/injection_container.dart';
import '../core/services/locale_service.dart';
import '../core/helpers/instant_theme_helper.dart';
import '../core/helpers/instant_locale_helper.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../i18n/app_localizations.g.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final localeService = getIt<LocaleService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: InstantThemeHelper.instance.themeNotifier,
        builder: (context, themeMode, child) {
          return ValueListenableBuilder<Locale>(
            valueListenable: InstantLocaleHelper.instance.localeNotifier,
            builder: (context, locale, child) {
              return MaterialApp.router(
                title: 'Usago',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: appRouter.config(),
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: localeService.getSupportedLocales(),
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'id') {
      return const AppLocalizationsId();
    }
    return const AppLocalizations();
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true;
  }

  @override
  String toString() => 'AppLocalizationsDelegate(${supportedLocales.join(', ')})';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];
}