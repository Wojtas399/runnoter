import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/current_week/current_week_cubit.dart';
import '../../component/card_body_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../formatter/distance_unit_formatter.dart';

class CurrentWeekMobileStats extends StatelessWidget {
  const CurrentWeekMobileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      children: [
        _StatsParam(
          label: str.currentWeekNumberOfActivities,
          child: const _NumberOfActivities(),
        ),
        const Divider(height: 24),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatsParam(
                  label: str.currentWeekScheduledDistance,
                  child: const _ScheduledDistance(),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _StatsParam(
                  label: str.currentWeekCoveredDistance,
                  child: const _CoveredDistance(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CurrentWeekTabletStats extends StatelessWidget {
  const CurrentWeekTabletStats({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          _TabletStatsParam(
            label: str.currentWeekNumberOfActivities,
            child: const _NumberOfActivities(),
          ),
          _TabletStatsParam(
            label: str.currentWeekScheduledDistance,
            child: const _ScheduledDistance(),
          ),
          _TabletStatsParam(
            label: str.currentWeekCoveredDistance,
            child: const _CoveredDistance(),
          ),
        ],
      ),
    );
  }
}

class CurrentWeekDesktopStats extends StatelessWidget {
  const CurrentWeekDesktopStats({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DesktopStatsParam(
            label: str.currentWeekNumberOfActivities,
            child: const _NumberOfActivities(),
          ),
          _DesktopStatsParam(
            label: str.currentWeekScheduledDistance,
            child: const _ScheduledDistance(),
          ),
          _DesktopStatsParam(
            label: str.currentWeekCoveredDistance,
            child: const _CoveredDistance(),
          ),
        ],
      ),
    );
  }
}

class _TabletStatsParam extends StatelessWidget {
  final String label;
  final Widget child;

  const _TabletStatsParam({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: CardBody(
          child: _StatsParam(
            label: label,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _DesktopStatsParam extends StatelessWidget {
  final String label;
  final Widget child;

  const _DesktopStatsParam({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CardBody(
        child: _StatsParam(
          label: label,
          child: child,
        ),
      ),
    );
  }
}

class _StatsParam extends StatelessWidget {
  final String label;
  final Widget child;

  const _StatsParam({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LabelLarge(
          label,
          color: Theme.of(context).colorScheme.outline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StatsParamValue extends StatelessWidget {
  final String? value;

  const _StatsParamValue(this.value);

  @override
  Widget build(BuildContext context) {
    return value == null
        ? const CircularProgressIndicator()
        : BodyLarge(value!);
  }
}

class _NumberOfActivities extends StatelessWidget {
  const _NumberOfActivities();

  @override
  Widget build(BuildContext context) {
    final int? numberOfActivities = context.select(
      (CurrentWeekCubit cubit) => cubit.numberOfActivities,
    );

    return _StatsParamValue(numberOfActivities.toString());
  }
}

class _ScheduledDistance extends StatelessWidget {
  const _ScheduledDistance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInKm = context.select(
      (CurrentWeekCubit cubit) => cubit.scheduledTotalDistance,
    );
    double? convertedDistance;
    if (distanceInKm != null) {
      convertedDistance =
          context.convertDistanceFromDefaultUnit(distanceInKm).decimal(2);
    }

    return _StatsParamValue(
      convertedDistance != null
          ? '$convertedDistance ${context.distanceUnit.toUIShortFormat()}'
          : null,
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
    double? convertedDistance;
    if (distanceInKm != null) {
      convertedDistance =
          context.convertDistanceFromDefaultUnit(distanceInKm).decimal(2);
    }

    return _StatsParamValue(
      convertedDistance != null
          ? '$convertedDistance ${context.distanceUnit.toUIShortFormat()}'
          : null,
    );
  }
}
