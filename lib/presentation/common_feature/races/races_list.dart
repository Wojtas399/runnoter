import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/races_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/activity_status_formatter.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';

class RacesList extends StatelessWidget {
  final List<RacesFromYear> racesGroupedByYear;

  const RacesList({
    super.key,
    required this.racesGroupedByYear,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: racesGroupedByYear.length,
      separatorBuilder: (_, int index) => const ResponsiveLayout(
        mobileBody: Divider(height: 32),
        desktopBody: Gap24(),
      ),
      itemBuilder: (_, int itemIndex) {
        final Widget races = _RacesFromYear(
          racesFromYear: racesGroupedByYear[itemIndex],
        );
        return ResponsiveLayout(
          mobileBody: races,
          desktopBody: CardBody(child: races),
        );
      },
    );
  }
}

class _RacesFromYear extends StatelessWidget {
  final RacesFromYear racesFromYear;

  const _RacesFromYear({
    required this.racesFromYear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleLarge(racesFromYear.year.toString()),
        const Gap16(),
        ...racesFromYear.elements.map(
          (Race race) => _RaceItem(race: race),
        ),
      ],
    );
  }
}

class _RaceItem extends StatelessWidget {
  final Race race;

  const _RaceItem({
    required this.race,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
        ),
        onPressed: () => _onPressed(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMedium(race.date.toFullDate(context)),
                TitleMedium(race.name),
              ],
            ),
            Icon(
              race.status.toIcon(),
              color: race.status.toColor(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(RacePreviewRoute(
      userId: context.read<RacesCubit>().userId,
      raceId: race.id,
    ));
  }
}
