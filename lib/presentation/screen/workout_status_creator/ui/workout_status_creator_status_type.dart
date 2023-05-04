part of 'workout_status_creator_screen.dart';

class _StatusType extends StatelessWidget {
  const _StatusType();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatusType? workoutStatusType = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.workoutStatusType,
    );

    return DropdownButtonFormField<WorkoutStatusType>(
      value: workoutStatusType,
      decoration: InputDecoration(
        filled: true,
        labelText: Str.of(context).workoutStatusCreatorScreenTitle,
      ),
      items: <DropdownMenuItem<WorkoutStatusType>>[
        ...WorkoutStatusType.values.map(
          (WorkoutStatusType statusType) => DropdownMenuItem(
            value: statusType,
            child: _WorkoutStatusDescription(
              statusType: statusType,
            ),
          ),
        ),
      ],
      onChanged: (WorkoutStatusType? statusType) {
        _onChanged(context, statusType);
      },
    );
  }

  void _onChanged(
    BuildContext context,
    WorkoutStatusType? workoutStatusType,
  ) {
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventWorkoutStatusTypeChanged(
            workoutStatusType: workoutStatusType,
          ),
        );
  }
}

class _WorkoutStatusDescription extends StatelessWidget {
  final WorkoutStatusType statusType;

  const _WorkoutStatusDescription({
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    WorkoutStatus? status;
    switch (statusType) {
      case WorkoutStatusType.pending:
        status = const WorkoutStatusPending();
        break;
      case WorkoutStatusType.completed:
        status = WorkoutStatusCompleted(
          coveredDistanceInKm: 0,
          avgPace: const Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case WorkoutStatusType.uncompleted:
        status = WorkoutStatusUncompleted(
          coveredDistanceInKm: 0,
          avgPace: const Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          status.toIcon(),
          size: 20,
          color: status.toColor(),
        ),
        const SizedBox(width: 8),
        Text(
          status.toLabel(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: status.toColor(),
              ),
        ),
      ],
    );
  }
}
