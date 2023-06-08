part of 'competition_creator_screen.dart';

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    return DurationInput(
      onDurationChanged: (Duration duration) {
        _onChanged(context, duration);
      },
    );
  }

  void _onChanged(BuildContext context, Duration duration) {
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
  }
}
