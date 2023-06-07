part of 'blood_test_creator_screen.dart';

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Str.of(context).bloodTestCreatorDate,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Date(),
              _DateButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.date,
    );

    if (date == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(date.toDateWithDots()),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton();

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
        child: Text(
          Str.of(context).bloodTestCreatorSelectDate,
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        _onPressed(context);
      },
      child: Text(
        Str.of(context).bloodTestCreatorChangeDate,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final bloc = context.read<BloodTestCreatorBloc>();
    final DateTime? date = await askForDate(
      context: context,
      initialDate: bloc.state.date,
    );
    if (date != null) {
      bloc.add(
        BloodTestCreatorEventDateChanged(date: date),
      );
    }
  }
}
