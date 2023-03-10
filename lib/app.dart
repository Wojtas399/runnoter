import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:runnoter/data/service_impl/auth_service_impl.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/presentation/config/navigation/app_navigator.dart';
import 'package:runnoter/presentation/config/theme.dart';
import 'package:runnoter/presentation/service/theme_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthServiceImpl(
        firebaseAuthService: FirebaseAuthService(),
        firebaseUserService: FirebaseUserService(),
      ),
      child: BlocProvider(
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
                Locale('pl'),
              ],
              themeMode: themeMode,
              theme: GlobalTheme.lightTheme,
              darkTheme: GlobalTheme.darkTheme,
              home: const AppNavigator(),
            );
          },
        ),
      ),
    );
  }
}
