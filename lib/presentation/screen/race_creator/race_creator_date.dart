import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../component/date_selector_component.dart';
import '../../component/text/title_text_components.dart';

class RaceCreatorDate extends StatelessWidget {
  const RaceCreatorDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(Str.of(context).raceDate),
        const SizedBox(height: 8),
        const _RaceDateValue(),
      ],
    );
  }
}

class _RaceDateValue extends StatelessWidget {
  const _RaceDateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RaceCreatorBloc bloc) => bloc.state.date,
    );

    return DateSelector(
      date: date,
      onDateSelected: (DateTime date) => _onDateSelected(context, date),
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventDateChanged(date: date),
        );
  }
}
