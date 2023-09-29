import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../domain/cubit/day_preview/day_preview_cubit.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/material_3_speed_dial_component.dart';
import '../../../extension/context_extensions.dart';
import '../../../service/navigator_service.dart';
import 'day_preview_dialog_actions.dart';

class DayPreviewAddActivityButton extends StatelessWidget {
  const DayPreviewAddActivityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    if (context.isMobileSize) {
      return Material3SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.emoji_events),
            label: str.race,
            onTap: () => _addRace(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_run_outlined),
            label: str.workout,
            onTap: () => _addWorkout(context),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () => _addWorkout(context),
              child: Text('${str.add} ${str.workout}'),
            ),
          ),
          const GapHorizontal24(),
          Expanded(
            child: FilledButton(
              onPressed: () => _addRace(context),
              child: Text('${str.add} ${str.race}'),
            ),
          ),
        ],
      ),
    );
  }

  void _addWorkout(BuildContext context) {
    popRoute(
      result: DayPreviewDialogActionAddWorkout(
        date: context.read<DayPreviewCubit>().date,
      ),
    );
  }

  void _addRace(BuildContext context) {
    popRoute(
      result: DayPreviewDialogActionAddRace(
        date: context.read<DayPreviewCubit>().date,
      ),
    );
  }
}
