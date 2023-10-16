import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/model/activity.dart';
import '../extension/context_extensions.dart';
import '../extension/double_extensions.dart';
import '../formatter/activity_status_formatter.dart';
import '../formatter/distance_unit_formatter.dart';
import '../formatter/duration_formatter.dart';
import '../formatter/mood_rate_formatter.dart';
import '../formatter/pace_formatter.dart';
import '../formatter/string_formatter.dart';
import 'content_with_label_component.dart';
import 'gap/gap_components.dart';
import 'gap/gap_horizontal_components.dart';
import 'nullable_text_component.dart';
import 'text/body_text_components.dart';
import 'text/label_text_components.dart';

class ActivityStatusInfo extends StatelessWidget {
  final ActivityStatus activityStatus;

  const ActivityStatusInfo({
    super.key,
    required this.activityStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActivityStatusName(activityStatus),
        if (activityStatus is ActivityStatusWithParams)
          _ActivityStats(activityStatus as ActivityStatusWithParams),
      ],
    );
  }
}

class _ActivityStatusName extends StatelessWidget {
  final ActivityStatus status;

  const _ActivityStatusName(this.status);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          status.toIcon(),
          color: status.toColor(context),
        ),
        const GapHorizontal16(),
        BodyMedium(
          status.toLabel(context),
          color: status.toColor(context),
        ),
      ],
    );
  }
}

class _ActivityStats extends StatelessWidget {
  final ActivityStatusWithParams params;

  const _ActivityStats(this.params);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Stats(
            coveredDistanceInKm: params.coveredDistanceInKm,
            duration: params.duration,
            avgPace: params.avgPace,
            avgHeartRate: params.avgHeartRate,
          ),
          const Gap16(),
          ContentWithLabel(
            label: Str.of(context).activityStatusMoodRate,
            content: NullableText(params.moodRate.toUIFormat(context)),
          ),
          const Gap16(),
          ContentWithLabel(
            label: Str.of(context).activityStatusComment,
            content: NullableText(params.comment),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final double coveredDistanceInKm;
  final Duration? duration;
  final Pace avgPace;
  final int avgHeartRate;

  const _Stats({
    required this.coveredDistanceInKm,
    required this.duration,
    required this.avgPace,
    required this.avgHeartRate,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _CoveredDistance(
                  coveredDistanceInKm: coveredDistanceInKm,
                ),
              ),
              if (duration != null) const VerticalDivider(),
              if (duration != null)
                Expanded(
                  child: _StatParam(
                    label: str.activityStatusDuration,
                    value: duration!.toUIFormat(),
                  ),
                ),
            ],
          ),
        ),
        const Divider(),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatParam(
                  label: str.activityStatusAvgPace,
                  value: avgPace.toUIFormat(context),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _StatParam(
                  label: str.activityStatusAvgHeartRate,
                  value: '$avgHeartRate ${str.heartRateUnit}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoveredDistance extends StatelessWidget {
  final double coveredDistanceInKm;

  const _CoveredDistance({
    required this.coveredDistanceInKm,
  });

  @override
  Widget build(BuildContext context) {
    final String coveredDistanceStr = context
        .convertDistanceFromDefaultUnit(coveredDistanceInKm)
        .decimal(2)
        .toString()
        .trimZeros();

    return _StatParam(
      label: Str.of(context).activityStatusCoveredDistance,
      value: '$coveredDistanceStr${context.distanceUnit.toUIShortFormat()}',
    );
  }
}

class _StatParam extends StatelessWidget {
  final String label;
  final String value;

  const _StatParam({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelMedium(label),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
