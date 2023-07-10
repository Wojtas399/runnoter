part of 'race_preview_screen.dart';

class _Race extends StatelessWidget {
  const _Race();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = SizedBox(height: 16);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            gap,
            ContentWithLabel(
              label: str.raceDate,
              content: const _RaceDate(),
            ),
            gap,
            ContentWithLabel(
              label: str.racePlace,
              content: const _Place(),
            ),
            gap,
            ContentWithLabel(
              label: str.raceDistance,
              content: const _Distance(),
            ),
            gap,
            ContentWithLabel(
              label: str.raceExpectedDuration,
              content: const _ExpectedDuration(),
            ),
            gap,
            ContentWithLabel(
              label: str.runStatus,
              content: const _RunStatus(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const _FinishRaceButton(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _RaceName(),
        if (!context.isMobileSize) const _RaceActions(),
      ],
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

    return TitleLarge(raceName ?? '--');
  }
}

class _RaceDate extends StatelessWidget {
  const _RaceDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.date,
    );

    return NullableText(date?.toFullDate(context));
  }
}

class _Place extends StatelessWidget {
  const _Place();

  @override
  Widget build(BuildContext context) {
    final String? place = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.place,
    );

    return NullableText(place);
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

    return NullableText(distanceStr);
  }
}

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? expectedDuration = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.expectedDuration,
    );

    return NullableText(expectedDuration?.toUIFormat());
  }
}

class _RunStatus extends StatelessWidget {
  const _RunStatus();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.status,
    );

    return runStatus == null
        ? const NullableText(null)
        : RunStatusInfo(runStatus: runStatus);
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
    final String? raceId = context.read<RacePreviewBloc>().state.race?.id;
    if (raceId == null) {
      return;
    }
    navigateTo(
      route: RunStatusCreatorRoute(
        creatorArguments: RaceRunStatusCreatorArguments(
          entityId: raceId,
        ),
      ),
    );
  }
}
