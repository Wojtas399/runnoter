part of 'calendar_component.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _PreviousMonthButton(),
          _Month(),
          _NextMonthButton(),
        ],
      ),
    );
  }
}

class _Month extends StatelessWidget {
  const _Month();

  @override
  Widget build(BuildContext context) {
    final DisplayingMonth? displayingMonth = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    if (displayingMonth == null) {
      return const SizedBox();
    }
    return Text(
      '${_getMonthName(context, displayingMonth.month)} ${displayingMonth.year}',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  String _getMonthName(BuildContext context, int month) {
    final appLocalizations = AppLocalizations.of(context)!;
    final List<String> monthLabels = [
      appLocalizations.january,
      appLocalizations.february,
      appLocalizations.march,
      appLocalizations.april,
      appLocalizations.may,
      appLocalizations.june,
      appLocalizations.july,
      appLocalizations.august,
      appLocalizations.september,
      appLocalizations.october,
      appLocalizations.november,
      appLocalizations.december,
    ];
    return monthLabels[month - 1];
  }
}

class _PreviousMonthButton extends StatelessWidget {
  const _PreviousMonthButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.chevron_left),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarCubit>().previousMonth();
  }
}

class _NextMonthButton extends StatelessWidget {
  const _NextMonthButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.chevron_right),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarCubit>().nextMonth();
  }
}
