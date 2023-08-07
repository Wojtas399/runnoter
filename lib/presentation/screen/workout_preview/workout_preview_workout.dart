import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../component/big_button_component.dart';
import '../../component/content_with_label_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/nullable_text_component.dart';
import '../../component/run_status_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/list_of_workout_stages_formatter.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/navigator_service.dart';
import 'workout_preview_actions.dart';

class WorkoutPreviewWorkoutInfo extends StatelessWidget {
  const WorkoutPreviewWorkoutInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = Gap16();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            gap,
            ContentWithLabel(
              label: str.date,
              content: const _WorkoutDate(),
            ),
            gap,
            ContentWithLabel(
              label: str.workoutPreviewWorkoutStages,
              content: const _WorkoutStages(),
            ),
            gap,
            ContentWithLabel(
              label: str.workoutPreviewTotalDistance,
              content: const _WorkoutDistance(),
            ),
            gap,
            ContentWithLabel(
              label: str.runStatus,
              content: const _RunStatus(),
            ),
          ],
        ),
        const Gap32(),
        const _RunStatusButton(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _WorkoutName(),
        if (!context.isMobileSize) const WorkoutPreviewWorkoutActions(),
      ],
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.workoutName,
    );

    return TitleLarge(name ?? '');
  }
}

class _WorkoutDate extends StatelessWidget {
  const _WorkoutDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.date,
    );

    return NullableText(date?.toFullDate(context));
  }
}

class _WorkoutStages extends StatelessWidget {
  const _WorkoutStages();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.stages,
    );

    return stages == null
        ? const NullableText(null)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...stages.asMap().entries.map(
                    (MapEntry<int, WorkoutStage> entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < stages.length ? 8 : 0,
                      ),
                      child: Text(
                        '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
                      ),
                    ),
                  ),
            ],
          );
  }
}

class _WorkoutDistance extends StatelessWidget {
  const _WorkoutDistance();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.stages,
    );

    return NullableText(stages?.toUIDetailedTotalDistance(context));
  }
}

class _RunStatus extends StatelessWidget {
  const _RunStatus();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.runStatus,
    );

    return runStatus == null
        ? const NullableText(null)
        : RunStatusInfo(runStatus: runStatus);
  }
}

class _RunStatusButton extends StatelessWidget {
  const _RunStatusButton();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.runStatus,
    );
    String label = Str.of(context).runStatusEditStatus;
    if (runStatus is RunStatusPending) {
      label = Str.of(context).runStatusFinish;
    }

    return BigButton(
      label: label,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    final String? workoutId = context.read<WorkoutPreviewBloc>().workoutId;
    if (workoutId != null) {
      navigateTo(
        RunStatusCreatorRoute(
          entityType: RunStatusCreatorEntityType.workout.name,
          entityId: workoutId,
        ),
      );
    }
  }
}
