import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'presentation/config/navigation/route_generator.dart';
import 'presentation/config/navigation/routes.dart';
import 'presentation/config/theme.dart';
import 'presentation/provider/repositories_provider.dart';
import 'presentation/provider/services_provider.dart';
import 'presentation/service/language_service.dart';
import 'presentation/service/theme_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
                child: MaterialApp(
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
                  initialRoute: RoutePath.signIn.path,
                  navigatorKey: navigatorKey,
                  onGenerateRoute: onGenerateRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
