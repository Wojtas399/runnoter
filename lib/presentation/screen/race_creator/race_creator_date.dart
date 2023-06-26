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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RaceDateValue(),
            _RaceDateButton(),
          ],
        ),
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

    if (date == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(date.toDateWithDots()),
    );
  }
}

class _RaceDateButton extends StatelessWidget {
  const _RaceDateButton();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RaceCreatorBloc bloc) => bloc.state.date,
    );

    if (date == null) {
      return FilledButton(
        onPressed: () {
          _onPressed(context);
        },
        child: Text(
          Str.of(context).select,
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        _onPressed(context);
      },
      child: Text(
        Str.of(context).change,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final RaceCreatorBloc bloc = context.read<RaceCreatorBloc>();
    final DateTime? date = await askForDate(
      context: context,
      initialDate: bloc.state.date,
    );
    if (date != null) {
      bloc.add(
        RaceCreatorEventDateChanged(date: date),
      );
    }
  }
}
