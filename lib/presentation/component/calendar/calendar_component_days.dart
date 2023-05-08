part of 'calendar_component.dart';

class _Days extends StatelessWidget {
  const _Days();

  @override
  Widget build(BuildContext context) {
    final List<CalendarWeek>? weeks = context.select(
      (CalendarComponentCubit cubit) => cubit.state.weeks,
    );

    if (weeks == null) {
      return const SizedBox();
    }
    return Table(
      border: TableBorder.all(
        width: 0.4,
        color: Theme.of(context).colorScheme.outline,
      ),
      children: weeks
          .map(
            (CalendarWeek week) => TableRow(
              children: week.days
                  .map(
                    (CalendarDay day) => TableCell(
                      child: _DayItem(day: day),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}

class _DayItem extends StatelessWidget {
  final CalendarDay day;

  const _DayItem({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: day.isDisabled ? 0.3 : 1,
      child: InkWell(
        onTap: () {
          _onPressed(context);
        },
        child: SizedBox(
          height: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DayNumber(
                number: day.date.day,
                isMarkedAsToday: day.isTodayDay,
              ),
              if (day.icon != null)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: day.icon,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentCubit>().onDayPressed(day.date);
  }
}

class _DayNumber extends StatelessWidget {
  final int number;
  final bool isMarkedAsToday;

  const _DayNumber({
    required this.number,
    required this.isMarkedAsToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isMarkedAsToday ? Theme.of(context).colorScheme.primary : null,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isMarkedAsToday ? Theme.of(context).canvasColor : null,
            ),
      ),
    );
  }
}
