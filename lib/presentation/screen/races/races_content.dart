import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/races/races_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../component/card_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import 'races_list.dart';

class RacesContent extends StatelessWidget {
  const RacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: GetIt.I.get<BodySizes>().mediumBodyWidth,
        ),
        child: const Paddings24(
          child: ResponsiveLayout(
            mobileBody: _Races(),
            tabletBody: CardBody(child: _Races()),
            desktopBody: CardBody(child: _Races()),
          ),
        ),
      ),
    );
  }
}

class _Races extends StatelessWidget {
  const _Races();

  @override
  Widget build(BuildContext context) {
    final List<Race>? races = context.select(
      (RacesCubit cubit) => cubit.state,
    );

    return switch (races) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          icon: Icons.emoji_events_outlined,
          title: Str.of(context).racesNoRacesTitle,
          subtitle: Str.of(context).racesNoRacesMessage,
        ),
      [...] => RacesList(races: races),
    };
  }
}
