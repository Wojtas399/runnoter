import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkoutCreatorWorkoutStages extends StatelessWidget {
  const WorkoutCreatorWorkoutStages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Title(),
          SizedBox(height: 8),
          _NoWorkoutStagesInfo(),
          SizedBox(height: 16),
          _AddStageButton()
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.workout_creator_screen_workout_stages,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _NoWorkoutStagesInfo extends StatelessWidget {
  const _NoWorkoutStagesInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.workout_creator_screen_no_stages_info,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!
                .workout_creator_screen_add_stage_instruction,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AddStageButton extends StatelessWidget {
  const _AddStageButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: Text(
            AppLocalizations.of(context)!
                .workout_creator_screen_add_stage_button_label,
          ),
        ),
      ],
    );
  }
}
