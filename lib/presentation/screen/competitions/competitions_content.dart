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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyContentInfo(
          icon: Icons.emoji_events_outlined,
          title: Str.of(context).bloodTestsNoTestsTitle,
          subtitle: Str.of(context).bloodTestsNoTestsMessage,
        ),
        const SizedBox(height: 32),
        const _AddNewCompetitionButton(),
      ],
    );
  }
}

class _AddNewCompetitionButton extends StatelessWidget {
  const _AddNewCompetitionButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: 'Dodaj nowe zawody',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    //TODO
  }
}
