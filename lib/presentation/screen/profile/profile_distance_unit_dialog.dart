import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../../domain/entity/settings.dart';
import '../../component/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/navigator_service.dart';

class ProfileDistanceUnitDialog extends StatelessWidget {
  const ProfileDistanceUnitDialog({super.key});

  @override
  Widget build(BuildContext context) => const ResponsiveLayout(
        mobileBody: _FullScreenDialog(),
        desktopBody: _NormalDialog(),
      );
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.distanceUnit),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: const SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            Gap16(),
            _OptionsToSelect(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
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
        title: Text(Str.of(context).distanceUnit),
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Gap16(),
              _OptionsToSelect(),
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
      child: BodyLarge(Str.of(context).distanceUnitSelection),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final DistanceUnit? selectedDistanceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.distanceUnit,
    );

    return Column(
      children: DistanceUnit.values
          .map(
            (DistanceUnit distanceUnit) => RadioListTile<DistanceUnit>(
              title: Text(distanceUnit.toUIFullFormat(context)),
              value: distanceUnit,
              groupValue: selectedDistanceUnit,
              onChanged: (DistanceUnit? distanceUnit) {
                _onDistanceUnitChanged(context, distanceUnit);
              },
            ),
          )
          .toList(),
    );
  }

  void _onDistanceUnitChanged(
    BuildContext context,
    DistanceUnit? newDistanceUnit,
  ) {
    if (newDistanceUnit != null) {
      context.read<ProfileSettingsBloc>().add(
            ProfileSettingsEventUpdateDistanceUnit(
              newDistanceUnit: newDistanceUnit,
            ),
          );
    }
  }
}
