import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usago/i18n/translations.g.dart';
import '../shared/themes/theme.dart';
import '../core/di/injection_container.dart';
import '../core/services/locale_service.dart';
import '../core/helpers/instant_theme_helper.dart';
import '../core/helpers/instant_locale_helper.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/brand/presentation/bloc/brand_bloc.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final localeService = getIt<LocaleService>();

    return TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt<AuthBloc>(),
          ),
          BlocProvider.value(
            value: getIt<BrandBloc>(),
          ),
        ],
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: InstantThemeHelper.instance.themeNotifier,
          builder: (context, themeMode, child) {
            return ValueListenableBuilder<AppLocale>(
              valueListenable: InstantLocaleHelper.instance.localeNotifier,
              builder: (context, locale, child) {
                return MaterialApp.router(
                  title: 'Usago',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  routerConfig: appRouter.config(),
                  debugShowCheckedModeBanner: false,
                  locale: locale.flutterLocale,
                  supportedLocales: AppLocaleUtils.supportedLocales,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
