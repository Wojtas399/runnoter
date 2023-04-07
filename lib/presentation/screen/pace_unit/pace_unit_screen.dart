import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/model/settings.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/navigator_service.dart';

class PaceUnitScreen extends StatelessWidget {
  const PaceUnitScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pace_unit_label,
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
        AppLocalizations.of(context)!.pace_unit_selection_text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    const PaceUnit selectedDistanceUnit = PaceUnit.minutesPerKilometer;

    return Column(
      children: PaceUnit.values
          .map(
            (PaceUnit paceUnit) => RadioListTile<PaceUnit>(
              title: Text(
                paceUnit.toUIFormat(context),
              ),
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
      //TODO
    }
  }
}
