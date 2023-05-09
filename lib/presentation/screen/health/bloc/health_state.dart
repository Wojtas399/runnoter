import 'package:equatable/equatable.dart';

import '../../../../domain/model/morning_measurement.dart';

class HealthState extends Equatable {
  final MorningMeasurement? todayMorningMeasurement;
  final ChartRange chartRange;
  final List<MorningMeasurement>? morningMeasurements;

  const HealthState({
    required this.todayMorningMeasurement,
    required this.chartRange,
    required this.morningMeasurements,
  });

  @override
  List<Object?> get props => [
        todayMorningMeasurement,
        chartRange,
        morningMeasurements,
      ];

  HealthState copyWith({
    MorningMeasurement? todayMorningMeasurement,
    ChartRange? chartRange,
    List<MorningMeasurement>? morningMeasurements,
  }) =>
      HealthState(
        todayMorningMeasurement:
            todayMorningMeasurement ?? this.todayMorningMeasurement,
        chartRange: chartRange ?? this.chartRange,
        morningMeasurements: morningMeasurements ?? this.morningMeasurements,
      );
}

enum ChartRange {
  week,
  month,
}
