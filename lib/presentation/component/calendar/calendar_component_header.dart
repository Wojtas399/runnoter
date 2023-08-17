import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'calendar_component_cubit.dart';

class CalendarComponentHeader extends StatelessWidget {
  const CalendarComponentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
    final int? displayingMonth = context.select(
      (CalendarComponentCubit cubit) => cubit.state.displayingMonth,
    );
    final int? displayingYear = context.select(
      (CalendarComponentCubit cubit) => cubit.state.displayingYear,
    );

    return displayingMonth == null
        ? const SizedBox()
        : Text(
            '${_getMonthName(context, displayingMonth)} $displayingYear',
            style: Theme.of(context).textTheme.titleMedium,
          );
  }

  String _getMonthName(BuildContext context, int month) {
    final str = Str.of(context);
    final List<String> monthLabels = [
      str.january,
      str.february,
      str.march,
      str.april,
      str.may,
      str.june,
      str.july,
      str.august,
      str.september,
      str.october,
      str.november,
      str.december,
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
    context.read<CalendarComponentCubit>().previousMonth();
  }
}

class _NextMonthButton extends StatelessWidget {
  const _NextMonthButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.chevron_right),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentCubit>().nextMonth();
  }
}
