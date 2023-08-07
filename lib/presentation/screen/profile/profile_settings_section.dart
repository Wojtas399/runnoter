import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../../domain/entity/settings.dart' as settings;
import '../../component/gap/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/dialog_service.dart';
import 'profile_distance_unit_dialog.dart';
import 'profile_language_dialog.dart';
import 'profile_pace_unit_dialog.dart';
import 'profile_theme_mode_dialog.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = Gap8();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TitleLarge(Str.of(context).profileSettings),
        ),
        const Gap16(),
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
