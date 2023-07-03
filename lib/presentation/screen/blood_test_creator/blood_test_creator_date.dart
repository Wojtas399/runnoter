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
          TitleMedium(
            Str.of(context).bloodTestCreatorDate,
          ),
          const SizedBox(height: 8),
          const _DateValue(),
        ],
      ),
    );
  }
}

class _DateValue extends StatelessWidget {
  const _DateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.date,
    );

    return DateSelector(
      date: date,
      lastDate: DateTime.now(),
      onDateSelected: (DateTime date) {
        _onDateSelected(context, date);
      },
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<BloodTestCreatorBloc>().add(
          BloodTestCreatorEventDateChanged(date: date),
        );
  }
}
