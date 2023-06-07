part of 'competitions_screen.dart';

class _CompetitionsList extends StatelessWidget {
  final List<Competition> competitions;

  const _CompetitionsList({
    required this.competitions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: competitions.length,
      separatorBuilder: (_, int index) => const SizedBox(height: 16),
      padding: const EdgeInsets.all(24),
      itemBuilder: (_, int itemIndex) => _CompetitionItem(
        competition: competitions[itemIndex],
      ),
    );
  }
}

class _CompetitionItem extends StatelessWidget {
  final Competition competition;

  const _CompetitionItem({
    required this.competition,
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
        //TODO
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelMedium(
                competition.date.toFullDate(context),
              ),
              Icon(
                competition.status.toIcon(),
                color: competition.status.toColor(),
              )
            ],
          ),
          TitleMedium(competition.name),
        ],
      ),
    );
  }
}
