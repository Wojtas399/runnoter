import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../formatter/date_formatter.dart';
import '../service/dialog_service.dart';
import 'text/title_text_components.dart';

class DateSelector extends StatelessWidget {
  final DateTime? date;
  final Function(DateTime date) onDateSelected;
  final DateTime? lastDate;

  const DateSelector({
    super.key,
    required this.date,
    required this.onDateSelected,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Value(date: date),
        _Button(
          date: date,
          onDateSelected: onDateSelected,
          lastDate: lastDate,
        ),
      ],
    );
  }
}

class _Value extends StatelessWidget {
  final DateTime? date;

  const _Value({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(
        date!.toDateWithDots(),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final DateTime? date;
  final Function(DateTime date) onDateSelected;
  final DateTime? lastDate;

  const _Button({
    required this.date,
    required this.onDateSelected,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
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
    final DateTime? newDate = await askForDate(
      context: context,
      initialDate: date,
      lastDate: lastDate,
    );
    if (newDate != null) {
      onDateSelected(newDate);
    }
  }
}
