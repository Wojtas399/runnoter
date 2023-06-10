part of 'competitions_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<Competition>? competitions = context.select(
      (CompetitionsCubit cubit) => cubit.state,
    );

    return switch (competitions) {
      null => const _LoadingContent(),
      [] => const _NoCompetitionsInfo(),
      [...] => _CompetitionsList(competitions: competitions),
    };
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NoCompetitionsInfo extends StatelessWidget {
  const _NoCompetitionsInfo();

  @override
  Widget build(BuildContext context) {
    return DefaultPaddings(
      child: EmptyContentInfo(
        icon: Icons.emoji_events_outlined,
        title: Str.of(context).competitionsNoCompetitionsTitle,
        subtitle: Str.of(context).competitionsNoCompetitionsMessage,
      ),
    );
  }
}
