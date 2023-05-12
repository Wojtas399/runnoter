part of 'health_bloc.dart';

class HealthState extends BlocState {
  final MorningMeasurement? thisMorningMeasurement;
  final ChartRange chartRange;
  final List<MorningMeasurement>? morningMeasurements;
  final List<HealthChartPoint>? chartPoints;

  const HealthState({
    required super.status,
    required this.thisMorningMeasurement,
    required this.chartRange,
    required this.morningMeasurements,
    required this.chartPoints,
  });

  @override
  List<Object?> get props => [
        status,
        thisMorningMeasurement,
        chartRange,
        morningMeasurements,
        chartPoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    MorningMeasurement? thisMorningMeasurement,
    ChartRange? chartRange,
    List<MorningMeasurement>? morningMeasurements,
    List<HealthChartPoint>? chartPoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        thisMorningMeasurement:
            thisMorningMeasurement ?? this.thisMorningMeasurement,
        chartRange: chartRange ?? this.chartRange,
        morningMeasurements: morningMeasurements ?? this.morningMeasurements,
        chartPoints: chartPoints ?? this.chartPoints,
      );
}

class HealthChartPoint {
  final DateTime date;
  final num? value;

  const HealthChartPoint({
    required this.date,
    required this.value,
  });
}

enum ChartRange {
  week,
  month,
  year,
}

enum HealthBlocInfo {
  morningMeasurementAdded,
}
