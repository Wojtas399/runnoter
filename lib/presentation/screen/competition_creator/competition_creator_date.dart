part of 'competition_creator_screen.dart';

class _CompetitionDate extends StatelessWidget {
  const _CompetitionDate();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          Str.of(context).competitionCreatorDate,
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CompetitionDateValue(),
            _CompetitionDateButton(),
          ],
        ),
      ],
    );
  }
}

class _CompetitionDateValue extends StatelessWidget {
  const _CompetitionDateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.date,
    );

    if (date == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(date.toDateWithDots()),
    );
  }
}

class _CompetitionDateButton extends StatelessWidget {
  const _CompetitionDateButton();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.date,
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
    final CompetitionCreatorBloc bloc = context.read<CompetitionCreatorBloc>();
    final DateTime? date = await askForDate(
      context: context,
      initialDate: bloc.state.date,
    );
    if (date != null) {
      bloc.add(
        CompetitionCreatorEventDateChanged(date: date),
      );
    }
  }
}
