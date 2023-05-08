import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/settings.dart' as settings;
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../service/navigator_service.dart';
import '../../service/theme_service.dart';
import 'theme_mode_cubit.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: _CubitListener(
        child: _Content(),
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
    return BlocProvider<ThemeModeCubit>(
      create: (BuildContext context) => ThemeModeCubit(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeModeCubit, settings.ThemeMode?>(
      listener: (BuildContext context, settings.ThemeMode? themeMode) {
        if (themeMode != null) {
          _manageThemeMode(context, themeMode);
        }
      },
      child: child,
    );
  }

  void _manageThemeMode(
    BuildContext context,
    settings.ThemeMode themeMode,
  ) {
    final themeService = context.read<ThemeService>();
    switch (themeMode) {
      case settings.ThemeMode.dark:
        themeService.changeTheme(ThemeMode.dark);
        break;
      case settings.ThemeMode.light:
        themeService.changeTheme(ThemeMode.light);
        break;
      case settings.ThemeMode.system:
        themeService.changeTheme(ThemeMode.system);
        break;
    }
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Str.of(context).themeMode,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
            SizedBox(height: 16),
            _SystemThemeDescription(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Text(
        Str.of(context).themeModeSelect,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
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
    final str = Str.of(context);

    return Column(
      children: [
        RadioListTile<settings.ThemeMode>(
          title: Text(
            str.themeModeLight,
          ),
          value: settings.ThemeMode.light,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeChanged(context, themeMode);
          },
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(
            str.themeModeDark,
          ),
          value: settings.ThemeMode.dark,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeChanged(context, themeMode);
          },
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(
            str.themeModeSystem,
          ),
          value: settings.ThemeMode.system,
          groupValue: selectedThemeMode,
          onChanged: (settings.ThemeMode? themeMode) {
            _onThemeModeChanged(context, themeMode);
          },
        ),
      ],
    );
  }

  void _onThemeModeChanged(
    BuildContext context,
    settings.ThemeMode? newThemeMode,
  ) {
    if (newThemeMode != null) {
      context.read<ThemeModeCubit>().updateThemeMode(
            newThemeMode: newThemeMode,
          );
    }
  }
}

class _SystemThemeDescription extends StatelessWidget {
  const _SystemThemeDescription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Text(
        Str.of(context).systemThemeModeDescription,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
