import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/navigation/app_navigator.dart';
import 'config/theme.dart';
import 'services/theme_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeService(),
      child: BlocBuilder<ThemeService, ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) {
          return MaterialApp(
            title: 'Runnoter',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
            ],
            themeMode: themeMode,
            theme: GlobalTheme.darkTheme,
            darkTheme: GlobalTheme.darkTheme,
            home: const AppNavigator(),
          );
        },
      ),
    );
  }
}
