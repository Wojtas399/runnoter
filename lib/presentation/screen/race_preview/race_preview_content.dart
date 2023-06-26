part of 'race_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 16);

    return const Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: Paddings24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RaceName(),
                  gap,
                  _RaceDate(),
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
              _FinishRaceButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RaceName extends StatelessWidget {
  const _RaceName();

  @override
  Widget build(BuildContext context) {
    final String? raceName = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.name,
    );

    return TitleLarge(
      raceName ?? '--',
    );
  }
}

class _RaceDate extends StatelessWidget {
  const _RaceDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.date,
    );

    return ContentWithLabel(
      label: Str.of(context).raceDate,
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
      (RacePreviewBloc bloc) => bloc.state.race?.place,
    );

    return ContentWithLabel(
      label: Str.of(context).racePlace,
      content: NullableText(place),
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distance = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.distance,
    );
    String? distanceStr;
    if (distance != null) {
      distanceStr = context
          .convertDistanceFromDefaultUnit(distance)
          .decimal(2)
          .toString()
          .trimZeros();
      distanceStr += context.distanceUnit.toUIShortFormat();
    }

    return ContentWithLabel(
      label: Str.of(context).raceDistance,
      content: NullableText(distanceStr),
    );
  }
}

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? expectedDuration = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.expectedDuration,
    );

    return ContentWithLabel(
      label: Str.of(context).raceExpectedDuration,
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
      (RacePreviewBloc bloc) => bloc.state.race?.status,
    );

    return Column(
      children: [
        ContentWithLabel(
          label: Str.of(context).runStatus,
          content: switch (status) {
            null => const Text('--'),
            RunStatus() => Row(
                children: [
                  Icon(
                    status.toIcon(),
                    color: status.toColor(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.toLabel(context),
                    style: TextStyle(
                      color: status.toColor(context),
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

class _FinishRaceButton extends StatelessWidget {
  const _FinishRaceButton();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.status,
    );
    return BigButton(
      label: runStatus is RunStatusPending
          ? Str.of(context).runStatusFinish
          : Str.of(context).runStatusEditStatus,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    final RacePreviewBloc bloc = context.read<RacePreviewBloc>();
    final String? raceId = bloc.state.race?.id;
    if (raceId == null) {
      return;
    }
    navigateTo(
      context: context,
      route: RunStatusCreatorRoute(
        creatorArguments: RaceRunStatusCreatorArguments(
          entityId: raceId,
        ),
      ),
    );
  }
}
