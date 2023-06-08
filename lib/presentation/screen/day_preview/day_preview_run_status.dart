part of 'day_preview_screen.dart';

class _RunStatus extends StatelessWidget {
  const _RunStatus();

  @override
  Widget build(BuildContext context) {
    final RunStatus? status = context.select(
      (DayPreviewBloc bloc) => bloc.state.runStatus,
    );

    if (status == null) {
      return const NullableText(null);
    }
    return Column(
      children: [
        _RunStatusName(status: status),
        if (status is RunStatusWithParams)
          RunStats(runStatusWithParams: status),
      ],
    );
  }
}

class _RunStatusName extends StatelessWidget {
  final RunStatus status;

  const _RunStatusName({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          status.toIcon(),
          color: status.toColor(),
        ),
        const SizedBox(width: 16),
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
