import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            themeMode: themeMode,
            theme: GlobalTheme.lightTheme,
            darkTheme: GlobalTheme.darkTheme,
            home: const AppNavigator(),
          );
        },
      ),
    );
  }
}
