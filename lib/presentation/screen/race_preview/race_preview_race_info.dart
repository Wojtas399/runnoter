import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/activity_status.dart';
import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../component/activity_status_info_component.dart';
import '../../component/content_with_label_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/nullable_text_component.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/duration_formatter.dart';
import 'race_preview_actions.dart';

class RacePreviewRaceInfo extends StatelessWidget {
  const RacePreviewRaceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = Gap16();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        gap,
        ContentWithLabel(
          label: str.date,
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
          label: str.activityStatus,
          content: const _ActivityStatus(),
        ),
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
        if (!context.isMobileSize) const RacePreviewActions(),
      ],
    );
  }
}

class _RaceName extends StatelessWidget {
  const _RaceName();

  @override
  Widget build(BuildContext context) {
    final String? raceName = context.select(
      (RacePreviewBloc bloc) => bloc.state.name,
    );

    return TitleLarge(raceName ?? '--');
  }
}

class _RaceDate extends StatelessWidget {
  const _RaceDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (RacePreviewBloc bloc) => bloc.state.date,
    );

    return NullableText(date?.toFullDate(context.languageCode));
  }
}

class _Place extends StatelessWidget {
  const _Place();

  @override
  Widget build(BuildContext context) {
    final String? place = context.select(
      (RacePreviewBloc bloc) => bloc.state.place,
    );

    return NullableText(place);
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distance = context.select(
      (RacePreviewBloc bloc) => bloc.state.distance,
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
      (RacePreviewBloc bloc) => bloc.state.expectedDuration,
    );

    return NullableText(expectedDuration?.toUIFormat());
  }
}

class _ActivityStatus extends StatelessWidget {
  const _ActivityStatus();

  @override
  Widget build(BuildContext context) {
    final ActivityStatus? raceStatus = context.select(
      (RacePreviewBloc bloc) => bloc.state.raceStatus,
    );

    return raceStatus == null
        ? const NullableText(null)
        : ActivityStatusInfo(activityStatus: raceStatus);
  }
}
