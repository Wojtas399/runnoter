part of 'current_week_screen.dart';

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Divider divider = Divider(height: 48);

    return CardBody(
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatsParam(
              label: str.currentWeekNumberOfActivities,
              child: const _NumberOfActivities(),
            ),
            divider,
            _StatsParam(
              label: str.currentWeekScheduledDistance,
              child: const _ScheduledDistance(),
            ),
            divider,
            _StatsParam(
              label: str.currentWeekCoveredDistance,
              child: const _CoveredDistance(),
            ),
          ],
        ),
      ),
    );
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
      children: [
        LabelLarge(
          label,
          color: Theme.of(context).colorScheme.outline,
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
