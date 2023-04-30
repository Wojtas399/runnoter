part of 'workout_status_creator_screen.dart';

enum _WorkoutStatusType {
  pending,
  completed,
  uncompleted,
}

class _StatusType extends StatelessWidget {
  const _StatusType();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        labelText:
            AppLocalizations.of(context)!.workout_status_creator_screen_title,
      ),
      items: <DropdownMenuItem<_WorkoutStatusType>>[
        ..._WorkoutStatusType.values.map(
          (_WorkoutStatusType statusType) => DropdownMenuItem(
            value: statusType,
            child: _WorkoutStatusDescription(
              statusType: statusType,
            ),
          ),
        ),
      ],
      onChanged: (_WorkoutStatusType? statusType) {
        //TODO
      },
    );
  }
}

class _WorkoutStatusDescription extends StatelessWidget {
  final _WorkoutStatusType statusType;

  const _WorkoutStatusDescription({
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    WorkoutStatus? status;
    switch (statusType) {
      case _WorkoutStatusType.pending:
        status = const WorkoutStatusPending();
        break;
      case _WorkoutStatusType.completed:
        status = WorkoutStatusCompleted(
          coveredDistanceInKm: 0,
          avgPace: const Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case _WorkoutStatusType.uncompleted:
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
