part of 'calendar_component.dart';

class _DayLabels extends StatelessWidget {
  const _DayLabels();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final List<String> dayShortLabels = [
      appLocalizations.monday_short,
      appLocalizations.tuesday_short,
      appLocalizations.wednesday_short,
      appLocalizations.thursday_short,
      appLocalizations.friday_short,
      appLocalizations.saturday_short,
      appLocalizations.sunday_short,
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
