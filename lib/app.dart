import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'dependency_injection.dart';
import 'ui/config/navigation/router.dart';
import 'ui/config/theme.dart';
import 'ui/service/distance_unit_service.dart';
import 'ui/service/language_service.dart';
import 'ui/service/pace_unit_service.dart';
import 'ui/service/theme_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return _ServicesProvider(
      child: BlocBuilder<ThemeService, ThemeMode>(
        builder: (_, ThemeMode themeMode) {
          return BlocBuilder<LanguageService, AppLanguage?>(
            builder: (BuildContext context, AppLanguage? language) {
              return MaterialApp.router(
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
                routerConfig: getIt<AppRouter>().config(
                  navigatorObservers: () => [AutoRouteObserver()],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ServicesProvider extends StatelessWidget {
  final Widget child;

  const _ServicesProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => LanguageService()),
        BlocProvider(create: (_) => ThemeService()),
        BlocProvider(create: (_) => DistanceUnitService()),
        BlocProvider(create: (_) => PaceUnitService()),
      ],
      child: child,
    );
  }
}
