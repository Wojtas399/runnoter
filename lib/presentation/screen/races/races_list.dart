import 'package:flutter/material.dart';

import '../../../domain/entity/race.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/navigator_service.dart';

class RacesList extends StatelessWidget {
  final List<Race> races;

  const RacesList({
    super.key,
    required this.races,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: races.length,
      separatorBuilder: (_, int index) => const SizedBox(height: 16),
      itemBuilder: (_, int itemIndex) => _RaceItem(race: races[itemIndex]),
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
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      onPressed: _onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelMedium(race.date.toFullDate(context)),
              Icon(
                race.status.toIcon(),
                color: race.status.toColor(context),
              )
            ],
          ),
          TitleMedium(race.name),
        ],
      ),
    );
  }

  void _onPressed() {
    navigateTo(
      RacePreviewRoute(raceId: race.id),
    );
  }
}
