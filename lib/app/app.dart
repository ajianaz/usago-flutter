import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/themes/theme.dart';
import '../core/di/injection_container.dart';
import '../core/services/locale_service.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../l10n/app_localizations.g.dart';
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
      child: MaterialApp.router(
        title: 'Usago',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter.config(),
        debugShowCheckedModeBanner: false,
        locale: localeService.getCurrentLocale(),
        supportedLocales: localeService.getSupportedLocales(),
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
        ],
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
    return false;
  }

  @override
  String toString() => 'AppLocalizationsDelegate(${supportedLocales.join(', ')})';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];
}