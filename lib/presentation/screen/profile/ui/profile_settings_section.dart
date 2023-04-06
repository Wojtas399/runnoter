import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/settings.dart' as settings;
import '../../../component/value_with_label_and_icon_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../formatter/settings_formatter.dart';
import '../../../service/navigator_service.dart';
import '../bloc/profile_settings_bloc.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _Header(),
        SizedBox(height: 16),
        _Theme(),
        gap,
        _Language(),
        gap,
        _DistanceUnit(),
        gap,
        _PaceUnit(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        AppLocalizations.of(context)!.profile_screen_settings_section_title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
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

    return ValueWithLabelAndIconComponent(
      label: AppLocalizations.of(context)!.theme_mode_label,
      iconData: Icons.brightness_6_outlined,
      value: themeMode?.toUIFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.themeMode);
  }
}

class _Language extends StatelessWidget {
  const _Language();

  @override
  Widget build(BuildContext context) {
    final settings.Language? language = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.language,
    );

    return ValueWithLabelAndIconComponent(
      label: AppLocalizations.of(context)!.language_label,
      iconData: Icons.translate_outlined,
      value: language?.toUIFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.language);
  }
}

class _DistanceUnit extends StatelessWidget {
  const _DistanceUnit();

  @override
  Widget build(BuildContext context) {
    final settings.DistanceUnit? distanceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.distanceUnit,
    );

    return ValueWithLabelAndIconComponent(
      label: AppLocalizations.of(context)!.distance_unit_label,
      iconData: Icons.route_outlined,
      value: distanceUnit?.toUIFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.distanceUnit);
  }
}

class _PaceUnit extends StatelessWidget {
  const _PaceUnit();

  @override
  Widget build(BuildContext context) {
    final settings.PaceUnit? paceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.paceUnit,
    );

    return ValueWithLabelAndIconComponent(
      label: AppLocalizations.of(context)!.profile_screen_pace_unit_label,
      iconData: Icons.speed_outlined,
      value: paceUnit?.toUIFormat(context) ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.paceUnit);
  }
}
