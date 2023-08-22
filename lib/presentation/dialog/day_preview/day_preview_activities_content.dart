import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/day_preview_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../../domain/entity/workout.dart';
import '../../component/activity_item_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../service/navigator_service.dart';
import 'day_preview_dialog_actions.dart';

class DayPreviewActivities extends StatelessWidget {
  const DayPreviewActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPastDate = context.select(
      (DayPreviewCubit cubit) => cubit.isPastDate,
    );
    final List<Workout>? workouts = context.select(
      (DayPreviewCubit cubit) => cubit.state?.workouts,
    );
    final List<Race>? races = context.select(
      (DayPreviewCubit cubit) => cubit.state?.races,
    );

    if (workouts == null && races == null) {
      return const Center(
        child: Paddings24(
          child: LoadingInfo(),
        ),
      );
    } else if (workouts?.isEmpty == true && races?.isEmpty == true) {
      final str = Str.of(context);
      return Center(
        child: Paddings24(
          child: EmptyContentInfo(
            title: str.dayPreviewNoActivitiesTitle,
            subtitle: isPastDate
                ? str.dayPreviewNoActivitiesMessagePastDay
                : str.dayPreviewNoActivitiesMessageFutureDay,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Paddings24(
        child: _Activities(workouts: workouts, races: races),
      ),
    );
  }
}

class _Activities extends StatelessWidget {
  final List<Workout>? workouts;
  final List<Race>? races;

  const _Activities({
    required this.workouts,
    required this.races,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...?workouts?.map(
          (workout) => ActivityItem(
            activity: workout,
            onPressed: () => _onWorkoutPressed(workout.id),
          ),
        ),
        ...?races?.map(
          (race) => ActivityItem(
            activity: race,
            onPressed: () => _onRacePressed(race.id),
          ),
        ),
      ],
    );
  }

  void _onWorkoutPressed(String workoutId) {
    popRoute(
      result: DayPreviewDialogActionShowWorkout(workoutId: workoutId),
    );
  }

  void _onRacePressed(String raceId) {
    popRoute(
      result: DayPreviewDialogActionShowRace(raceId: raceId),
    );
  }
}
