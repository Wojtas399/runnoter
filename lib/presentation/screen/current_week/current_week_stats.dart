import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/current_week_cubit.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/shimmer/shimmer_container.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../formatter/distance_unit_formatter.dart';

class CurrentWeekMobileStats extends StatelessWidget {
  const CurrentWeekMobileStats({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          _NumberOfActivities(),
          Divider(height: 24),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _ScheduledDistance()),
                VerticalDivider(),
                Expanded(child: _CoveredDistance()),
              ],
            ),
          ),
        ],
      );
}

class CurrentWeekTabletStats extends StatelessWidget {
  const CurrentWeekTabletStats({super.key});

  @override
  Widget build(BuildContext context) => const IntrinsicHeight(
        child: Row(
          children: [
            _NumberOfActivities(),
            _ScheduledDistance(),
            _CoveredDistance(),
          ],
        ),
      );
}

class CurrentWeekDesktopStats extends StatelessWidget {
  const CurrentWeekDesktopStats({super.key});

  @override
  Widget build(BuildContext context) => const IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NumberOfActivities(),
            _ScheduledDistance(),
            _CoveredDistance(),
          ],
        ),
      );
}

class _NumberOfActivities extends StatelessWidget {
  const _NumberOfActivities();

  @override
  Widget build(BuildContext context) {
    final int? numberOfActivities = context.select(
      (CurrentWeekCubit cubit) => cubit.numberOfActivities,
    );

    return _ResponsiveStatsParam(
      label: Str.of(context).currentWeekNumberOfActivities,
      value: numberOfActivities?.toString(),
    );
  }
}

class _ScheduledDistance extends StatelessWidget {
  const _ScheduledDistance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInKm = context.select(
      (CurrentWeekCubit cubit) => cubit.scheduledTotalDistance,
    );
    String? value;
    if (distanceInKm != null) {
      final double convertedDistance =
          context.convertDistanceFromDefaultUnit(distanceInKm).decimal(2);
      value = '$convertedDistance ${context.distanceUnit.toUIShortFormat()}';
    }

    return _ResponsiveStatsParam(
      label: Str.of(context).currentWeekScheduledDistance,
      value: value,
    );
  }
}

class _CoveredDistance extends StatelessWidget {
  const _CoveredDistance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInKm = context.select(
      (CurrentWeekCubit cubit) => cubit.coveredTotalDistance,
    );
    String? value;
    if (distanceInKm != null) {
      final double convertedDistance =
          context.convertDistanceFromDefaultUnit(distanceInKm).decimal(2);
      value = '$convertedDistance ${context.distanceUnit.toUIShortFormat()}';
    }

    return _ResponsiveStatsParam(
      label: Str.of(context).currentWeekCoveredDistance,
      value: value,
    );
  }
}

class _ResponsiveStatsParam extends StatelessWidget {
  final String label;
  final String? value;

  const _ResponsiveStatsParam({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final Widget statsParamWidget = _StatsParam(label: label, value: value);

    return ResponsiveLayout(
      mobileBody: statsParamWidget,
      tabletBody: Expanded(
        child: SizedBox(
          height: double.infinity,
          child: CardBody(child: statsParamWidget),
        ),
      ),
      desktopBody: SizedBox(
        width: double.infinity,
        child: CardBody(child: statsParamWidget),
      ),
    );
  }
}

class _StatsParam extends StatelessWidget {
  final String label;
  final String? value;

  const _StatsParam({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => value == null
      ? const _StatsParamShimmer()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelLarge(
              label,
              color: Theme.of(context).colorScheme.outline,
              textAlign: TextAlign.center,
            ),
            const Gap8(),
            BodyLarge(value!),
          ],
        );
}

class _StatsParamShimmer extends StatelessWidget {
  const _StatsParamShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerContainer(
          constraints: BoxConstraints(maxWidth: 150),
          width: double.infinity,
          height: 16,
        ),
        Gap16(),
        ShimmerContainer(width: 60, height: 16)
      ],
    );
  }
}
