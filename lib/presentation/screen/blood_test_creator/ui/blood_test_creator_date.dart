part of 'blood_test_creator_screen.dart';

class _ReadingDate extends StatelessWidget {
  const _ReadingDate();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ReadingDateText(),
              _ReadingDateButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingDateText extends StatelessWidget {
  const _ReadingDateText();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.date,
    );

    if (date == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(date.toFullDate(context)),
    );
  }
}

class _ReadingDateButton extends StatelessWidget {
  const _ReadingDateButton();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.date,
    );

    if (date == null) {
      return FilledButton(
        onPressed: () {
          _onPressed(context);
        },
        child: Text('Wybierz datę'),
      );
    }
    return OutlinedButton(
      onPressed: () {
        _onPressed(context);
      },
      child: Text('Edytuj datę'),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final bloc = context.read<BloodTestCreatorBloc>();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: bloc.state.date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      bloc.add(
        BloodTestCreatorEventDateChanged(date: date),
      );
    }
  }
}
