import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../../domain/entity/settings.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../service/navigator_service.dart';

class ProfilePaceUnitDialog extends StatelessWidget {
  const ProfilePaceUnitDialog({super.key});

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
      title: Text(str.paceUnit),
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
        title: Text(Str.of(context).paceUnit),
        leading: const CloseButton(),
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
      child: BodyLarge(Str.of(context).paceUnitSelection),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final PaceUnit? selectedDistanceUnit = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.paceUnit,
    );

    return Column(
      children: PaceUnit.values
          .map(
            (PaceUnit paceUnit) => RadioListTile<PaceUnit>(
              title: Text(paceUnit.toUIFormat()),
              value: paceUnit,
              groupValue: selectedDistanceUnit,
              onChanged: (PaceUnit? paceUnit) {
                _onPaceUnitChanged(context, paceUnit);
              },
            ),
          )
          .toList(),
    );
  }

  void _onPaceUnitChanged(
    BuildContext context,
    PaceUnit? newPaceUnit,
  ) {
    if (newPaceUnit != null) {
      context.read<ProfileSettingsBloc>().add(
            ProfileSettingsEventUpdatePaceUnit(newPaceUnit: newPaceUnit),
          );
    }
  }
}
