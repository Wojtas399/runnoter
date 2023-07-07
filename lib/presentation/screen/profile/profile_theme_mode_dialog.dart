part of 'profile_screen.dart';

class _ThemeModeDialog extends StatelessWidget {
  final DialogMode dialogMode;

  const _ThemeModeDialog({
    required this.dialogMode,
  });

  @override
  Widget build(BuildContext context) {
    return _ThemeModeCubitProvider(
      child: _CubitListener(
        child: switch (dialogMode) {
          DialogMode.normal => const _NormalDialog(),
          DialogMode.fullScreen => const _FullScreenDialog(),
        },
      ),
    );
  }
}

class _ThemeModeCubitProvider extends StatelessWidget {
  final Widget child;

  const _ThemeModeCubitProvider({
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

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.themeMode),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: const SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
            SizedBox(height: 16),
            _SystemThemeDescription(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(context: context),
          child: Text(str.close),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).themeMode),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              SizedBox(height: 16),
              _OptionsToSelect(),
              SizedBox(height: 16),
              _SystemThemeDescription(),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyLarge(Str.of(context).themeModeSelect),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyMedium(
        Str.of(context).systemThemeModeDescription,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
