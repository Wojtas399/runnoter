part of 'race_creator_screen.dart';

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (RaceCreatorBloc bloc) => bloc.state.expectedDuration,
    );
    final BlocStatus? blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is! BlocStatusInitial) {
      return DurationInput(
        label: Str.of(context).raceExpectedDuration,
        initialDuration: duration,
        onDurationChanged: (Duration duration) {
          _onChanged(context, duration);
        },
      );
    }
    return const SizedBox();
  }

  void _onChanged(BuildContext context, Duration duration) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
  }
}
