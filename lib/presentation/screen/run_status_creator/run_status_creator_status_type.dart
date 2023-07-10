part of 'run_status_creator_screen.dart';

class _StatusType extends StatelessWidget {
  const _StatusType();

  @override
  Widget build(BuildContext context) {
    final RunStatusType? runStatusType = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.runStatusType,
    );

    return DropdownButtonFormField<RunStatusType>(
      value: runStatusType,
      decoration: InputDecoration(
        labelText: Str.of(context).runStatusCreatorScreenTitle,
      ),
      items: <DropdownMenuItem<RunStatusType>>[
        ...RunStatusType.values.map(
          (RunStatusType statusType) => DropdownMenuItem(
            value: statusType,
            child: _RunStatusDescription(
              statusType: statusType,
            ),
          ),
        ),
      ],
      onChanged: (RunStatusType? statusType) {
        _onChanged(context, statusType);
      },
    );
  }

  void _onChanged(
    BuildContext context,
    RunStatusType? runStatusType,
  ) {
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventRunStatusTypeChanged(
            runStatusType: runStatusType,
          ),
        );
  }
}

class _RunStatusDescription extends StatelessWidget {
  final RunStatusType statusType;

  const _RunStatusDescription({
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    RunStatus? status;
    switch (statusType) {
      case RunStatusType.pending:
        status = const RunStatusPending();
        break;
      case RunStatusType.done:
        status = const RunStatusDone(
          coveredDistanceInKm: 0,
          avgPace: Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case RunStatusType.aborted:
        status = const RunStatusAborted(
          coveredDistanceInKm: 0,
          avgPace: Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case RunStatusType.undone:
        status = const RunStatusUndone();
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          status.toIcon(),
          size: 20,
          color: status.toColor(context),
        ),
        const SizedBox(width: 8),
        Text(
          status.toLabel(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: status.toColor(context),
              ),
        ),
      ],
    );
  }
}
