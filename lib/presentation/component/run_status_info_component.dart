import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/run_status.dart';
import '../extension/context_extensions.dart';
import '../extension/double_extensions.dart';
import '../extension/string_extensions.dart';
import '../formatter/distance_unit_formatter.dart';
import '../formatter/duration_formatter.dart';
import '../formatter/mood_rate_formatter.dart';
import '../formatter/pace_formatter.dart';
import '../formatter/run_status_formatter.dart';
import 'content_with_label_component.dart';
import 'gap/gap_components.dart';
import 'gap/gap_horizontal_components.dart';
import 'nullable_text_component.dart';
import 'text/body_text_components.dart';
import 'text/label_text_components.dart';

class RunStatusInfo extends StatelessWidget {
  final RunStatus runStatus;

  const RunStatusInfo({
    super.key,
    required this.runStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RunStatusName(runStatus),
        if (runStatus is RunStatusWithParams)
          _RunStats(runStatus as RunStatusWithParams),
      ],
    );
  }
}

class _RunStatusName extends StatelessWidget {
  final RunStatus status;

  const _RunStatusName(this.status);

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

class _RunStats extends StatelessWidget {
  final RunStatusWithParams params;

  const _RunStats(this.params);

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
            label: Str.of(context).runStatusMoodRate,
            content: NullableText(params.moodRate.toUIFormat(context)),
          ),
          const Gap16(),
          ContentWithLabel(
            label: Str.of(context).runStatusComment,
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
                    label: str.runStatusDuration,
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
                  label: str.runStatusAvgPace,
                  value: avgPace.toUIFormat(context),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _StatParam(
                  label: str.runStatusAvgHeartRate,
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
      label: Str.of(context).runStatusCoveredDistance,
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
