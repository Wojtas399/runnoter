part of 'calendar_component.dart';

class _DayLabels extends StatelessWidget {
  const _DayLabels();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final List<String> dayShortLabels = [
      str.monday_short,
      str.tuesday_short,
      str.wednesday_short,
      str.thursday_short,
      str.friday_short,
      str.saturday_short,
      str.sunday_short,
    ];

    return Column(
      children: [
        const Divider(),
        Row(
          children: dayShortLabels
              .map(
                (String label) => _DayLabel(label),
              )
              .toList(),
        ),
        const Divider(),
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
