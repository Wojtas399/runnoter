part of 'races_screen.dart';

class _RacesList extends StatelessWidget {
  final List<Race> races;

  const _RacesList({
    required this.races,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: races.length,
      separatorBuilder: (_, int index) => const SizedBox(height: 16),
      padding: const EdgeInsets.all(24),
      itemBuilder: (_, int itemIndex) => _RaceItem(
        race: races[itemIndex],
      ),
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
      onPressed: () {
        _onPressed(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelMedium(
                race.date.toFullDate(context),
              ),
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

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: RacePreviewRoute(
        raceId: race.id,
      ),
    );
  }
}
