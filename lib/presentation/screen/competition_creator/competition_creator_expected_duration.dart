part of 'competition_creator_screen.dart';

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.expectedDuration,
    );
    final BlocStatus? blocStatus = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is! BlocStatusInitial) {
      return DurationInput(
        label: Str.of(context).competitionCreatorExpectedDuration,
        initialDuration: duration,
        onDurationChanged: (Duration duration) {
          _onChanged(context, duration);
        },
      );
    }
    return const SizedBox();
  }

  void _onChanged(BuildContext context, Duration duration) {
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
  }
}
