import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/races_cubit.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import 'races_list.dart';

class RacesContent extends StatelessWidget {
  const RacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediumBody(
      child: Paddings24(
        child: _Races(),
      ),
    );
  }
}

class _Races extends StatelessWidget {
  const _Races();

  @override
  Widget build(BuildContext context) {
    final List<RacesFromYear>? racesGroupedByYear = context.select(
      (RacesCubit cubit) => cubit.state,
    );

    return switch (racesGroupedByYear) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          icon: Icons.emoji_events_outlined,
          title: Str.of(context).racesNoRacesTitle,
          subtitle: Str.of(context).racesNoRacesMessage,
        ),
      [...] => RacesList(racesGroupedByYear: racesGroupedByYear),
    };
  }
}
