import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'presentation/config/navigation/router.dart';
import 'presentation/config/theme.dart';
import 'presentation/provider/repositories_provider.dart';
import 'presentation/provider/services_provider.dart';
import 'presentation/service/language_service.dart';
import 'presentation/service/theme_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ServicesProvider(
      child: BlocBuilder<ThemeService, ThemeMode>(
        builder: (_, ThemeMode themeMode) {
          return BlocBuilder<LanguageService, AppLanguage?>(
            builder: (BuildContext context, AppLanguage? language) {
              return RepositoriesProvider(
                child: MaterialApp.router(
                  title: 'Runnoter',
                  localizationsDelegates: const [
                    Str.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    SfGlobalLocalizations.delegate,
                  ],
                  supportedLocales: [
                    AppLanguage.polish.locale!,
                    AppLanguage.english.locale!,
                  ],
                  locale: language?.locale,
                  themeMode: themeMode,
                  theme: GlobalTheme.lightTheme,
                  darkTheme: GlobalTheme.darkTheme,
                  routerConfig: GetIt.I.get<AppRouter>().config(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
