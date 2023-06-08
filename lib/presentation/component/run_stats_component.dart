import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/run_status.dart';
import '../formatter/mood_rate_formatter.dart';
import '../formatter/pace_formatter.dart';
import 'content_with_label_component.dart';
import 'nullable_text_component.dart';

class RunStats extends StatelessWidget {
  final RunStatusWithParams runStatusWithParams;

  const RunStats({
    super.key,
    required this.runStatusWithParams,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Stats(
            coveredDistanceInKm: runStatusWithParams.coveredDistanceInKm,
            avgPace: runStatusWithParams.avgPace,
            avgHeartRate: runStatusWithParams.avgHeartRate,
          ),
          const SizedBox(height: 16),
          ContentWithLabel(
            label: Str.of(context).runStatusMoodRate,
            content: NullableText(
              runStatusWithParams.moodRate.toUIFormat(),
            ),
          ),
          const SizedBox(height: 16),
          ContentWithLabel(
            label: Str.of(context).runStatusComment,
            content: NullableText(
              runStatusWithParams.comment,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final double coveredDistanceInKm;
  final Pace avgPace;
  final int avgHeartRate;

  const _Stats({
    required this.coveredDistanceInKm,
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
                child: _StatParam(
                  label: str.runStatusCoveredDistance,
                  value: '$coveredDistanceInKm km',
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
                  value: avgPace.toUIFormat(),
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
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
