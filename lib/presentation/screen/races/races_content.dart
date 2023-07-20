import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/races/races_cubit.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import 'races_list.dart';

class RacesContent extends StatelessWidget {
  const RacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediumBody(
      child: Paddings24(
        child: ResponsiveLayout(
          mobileBody: _Races(),
          desktopBody: _DesktopContent(),
        ),
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AddRaceButton(),
        SizedBox(height: 24),
        Expanded(
          child: _Races(),
        ),
      ],
    );
  }
}

class _AddRaceButton extends StatelessWidget {
  const _AddRaceButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).racesAddNewRace,
          onPressed: () => navigateTo(RaceCreatorRoute()),
        ),
      ],
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
