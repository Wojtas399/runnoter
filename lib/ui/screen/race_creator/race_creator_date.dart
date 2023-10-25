import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/date_selector_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../cubit/race_creator/race_creator_cubit.dart';

class RaceCreatorDate extends StatelessWidget {
  const RaceCreatorDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(Str.of(context).date),
        const Gap8(),
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
      (RaceCreatorCubit cubit) => cubit.state.date,
    );

    return DateSelector(
      date: date,
      onDateSelected: context.read<RaceCreatorCubit>().dateChanged,
    );
  }
}
