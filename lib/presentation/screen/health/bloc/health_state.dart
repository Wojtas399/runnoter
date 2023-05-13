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

enum HealthBlocInfo {
  morningMeasurementAdded,
}
