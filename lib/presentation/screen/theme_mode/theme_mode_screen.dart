import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/settings.dart' as settings;
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../service/navigator_service.dart';
import 'theme_mode_cubit.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profile_screen_theme_mode_label,
          ),
          leading: IconButton(
            onPressed: () {
              navigateBack(context: context);
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: const SafeArea(
          child: _OptionsToSelect(),
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ThemeModeCubit(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final settings.ThemeMode? selectedThemeMode = context.select(
      (ThemeModeCubit cubit) => cubit.state,
    );

    return Column(
      children: [
        RadioListTile<settings.ThemeMode>(
          title: Text(
            AppLocalizations.of(context)!.settings_theme_mode_light,
          ),
          value: settings.ThemeMode.light,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeSelected(context, themeMode);
          },
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(
            AppLocalizations.of(context)!.settings_theme_mode_dark,
          ),
          value: settings.ThemeMode.dark,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeSelected(context, themeMode);
          },
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(
            AppLocalizations.of(context)!.settings_theme_mode_system,
          ),
          value: settings.ThemeMode.system,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeSelected(context, themeMode);
          },
        ),
      ],
    );
  }

  void _onThemeModeSelected(
    BuildContext context,
    settings.ThemeMode? themeMode,
  ) {
    if (themeMode != null) {
      context.read<ThemeModeCubit>().updateThemeMode(
            themeMode: themeMode,
          );
    }
  }
}
