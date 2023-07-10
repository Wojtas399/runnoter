part of 'profile_screen.dart';

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: Str.of(context).profileSettings,
        ),
        const SizedBox(height: 16),
        const _Theme(),
        gap,
        const _Language(),
        gap,
        const _DistanceUnit(),
        gap,
        const _PaceUnit(),
      ],
    );
  }
}

class _Theme extends StatelessWidget {
  const _Theme();

  @override
  Widget build(BuildContext context) {
    final settings.ThemeMode? themeMode = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.themeMode,
    );

    return ValueWithLabelAndIcon(
      label: Str.of(context).themeMode,
      iconData: Icons.brightness_6_outlined,
      value: themeMode?.toUIFormat(context) ?? '',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileSettingsBloc>(),
          child: const ProfileThemeModeDialog(),
        ),
      );
}

class _Language extends StatelessWidget {
  const _Language();

  @override
  Widget build(BuildContext context) {
    final settings.Language? language = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.language,
    );

    return ValueWithLabelAndIcon(
      label: Str.of(context).language,
      iconData: Icons.translate_outlined,
      value: language?.toUIFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileSettingsBloc>(),
          child: const ProfileLanguageDialog(),
        ),
      );
}

class _DistanceUnit extends StatelessWidget {
  const _DistanceUnit();

  @override
  Widget build(BuildContext context) {
    final settings.DistanceUnit? distanceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.distanceUnit,
    );

    return ValueWithLabelAndIcon(
      label: Str.of(context).distanceUnit,
      iconData: Icons.route_outlined,
      value: distanceUnit?.toUIFullFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileSettingsBloc>(),
          child: const ProfileDistanceUnitDialog(),
        ),
      );
}

class _PaceUnit extends StatelessWidget {
  const _PaceUnit();

  @override
  Widget build(BuildContext context) {
    final settings.PaceUnit? paceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.paceUnit,
    );

    return ValueWithLabelAndIcon(
      label: Str.of(context).paceUnit,
      iconData: Icons.speed_outlined,
      value: paceUnit?.toUIFormat() ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileSettingsBloc>(),
          child: const ProfilePaceUnitDialog(),
        ),
      );
}
