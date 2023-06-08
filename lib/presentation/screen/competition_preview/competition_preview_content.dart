part of 'competition_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Competition preview'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompetitionName(),
                  gap,
                  _CompetitionDate(),
                  gap,
                  _Place(),
                  gap,
                  _Distance(),
                  gap,
                  _ExpectedDuration(),
                  gap,
                  _Status(),
                ],
              ),
              _FinishCompetitionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompetitionName extends StatelessWidget {
  const _CompetitionName();

  @override
  Widget build(BuildContext context) {
    final String? competitionName = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.name,
    );

    return TitleLarge(
      competitionName ?? '--',
    );
  }
}

class _CompetitionDate extends StatelessWidget {
  const _CompetitionDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.date,
    );

    return ContentWithLabel(
      label: 'Data',
      content: NullableText(
        date?.toFullDate(context),
      ),
    );
  }
}

class _Place extends StatelessWidget {
  const _Place();

  @override
  Widget build(BuildContext context) {
    final String? place = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.place,
    );

    return ContentWithLabel(
      label: 'Miejsce',
      content: NullableText(place),
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distance = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.distance,
    );

    return ContentWithLabel(
      label: 'Dystans',
      content: NullableText(
        distance != null ? '$distance km' : null,
      ),
    );
  }
}

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? expectedDuration = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.expectedDuration,
    );

    return ContentWithLabel(
      label: 'Oczekiwany czas',
      content: NullableText(
        expectedDuration?.toUIFormat(),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status();

  @override
  Widget build(BuildContext context) {
    final RunStatus? status = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.status,
    );

    return Column(
      children: [
        ContentWithLabel(
          label: 'Status',
          content: switch (status) {
            null => const Text('--'),
            RunStatus() => Row(
                children: [
                  Icon(
                    status.toIcon(),
                    color: status.toColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.toLabel(context),
                    style: TextStyle(
                      color: status.toColor(),
                    ),
                  )
                ],
              ),
          },
        ),
        if (status is RunStatusWithParams)
          RunStats(
            runStatusWithParams: status,
          ),
      ],
    );
  }
}

class _FinishCompetitionButton extends StatelessWidget {
  const _FinishCompetitionButton();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (CompetitionPreviewBloc bloc) => bloc.state.competition?.status,
    );
    if (runStatus is RunStatusPending) {
      return BigButton(
        label: 'Zakończ',
        onPressed: () {
          _onPressed(context);
        },
      );
    }
    return const SizedBox();
  }

  void _onPressed(BuildContext context) {
    final CompetitionPreviewBloc bloc = context.read<CompetitionPreviewBloc>();
    final String? competitionId = bloc.state.competition?.id;
    if (competitionId == null) {
      return;
    }
    navigateTo(
      context: context,
      route: RunStatusCreatorRoute(
        creatorArguments: CompetitionRunStatusCreatorArguments(
          entityId: competitionId,
        ),
      ),
    );
  }
}
