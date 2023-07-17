part of 'current_week_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Days(),
        SizedBox(width: 16),
        _Stats(),
      ],
    );
  }
}

class _Days extends StatelessWidget {
  const _Days();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: CardBody(
        child: _ListOfDays(),
      ),
    );
  }
}

class _ListOfDays extends StatelessWidget {
  const _ListOfDays();

  @override
  Widget build(BuildContext context) {
    final List<Day>? days = context.select(
      (CurrentWeekCubit cubit) => cubit.state,
    );

    return days == null
        ? const LoadingInfo()
        : ListView.separated(
            itemCount: days.length,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            itemBuilder: (_, int itemIndex) => DayItem(day: days[itemIndex]),
            separatorBuilder: (_, int itemIndex) => const Divider(),
          );
  }
}
