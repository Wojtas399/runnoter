part of 'race_creator_screen.dart';

class _RaceDate extends StatelessWidget {
  const _RaceDate();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          Str.of(context).raceDate,
        ),
        const SizedBox(height: 8),
        const _RaceDateValue(),
      ],
    );
  }
}

class _RaceDateValue extends StatelessWidget {
  const _RaceDateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RaceCreatorBloc bloc) => bloc.state.date,
    );

    return DateSelector(
      date: date,
      onDateSelected: (DateTime date) {
        _onDateSelected(context, date);
      },
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventDateChanged(date: date),
        );
  }
}
