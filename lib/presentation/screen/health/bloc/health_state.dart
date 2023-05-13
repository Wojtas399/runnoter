part of 'health_bloc.dart';

class HealthState extends BlocState {
  final MorningMeasurement? thisMorningMeasurement;
  final ChartRange chartRange;
  final List<MorningMeasurement>? morningMeasurements;
  final List<HealthChartPoint>? restingHeartRatePoints;

  const HealthState({
    required super.status,
    required this.thisMorningMeasurement,
    required this.chartRange,
    required this.morningMeasurements,
    required this.restingHeartRatePoints,
  });

  @override
  List<Object?> get props => [
        status,
        thisMorningMeasurement,
        chartRange,
        morningMeasurements,
        restingHeartRatePoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    MorningMeasurement? thisMorningMeasurement,
    ChartRange? chartRange,
    List<MorningMeasurement>? morningMeasurements,
    List<HealthChartPoint>? restingHeartRatePoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        thisMorningMeasurement:
            thisMorningMeasurement ?? this.thisMorningMeasurement,
        chartRange: chartRange ?? this.chartRange,
        morningMeasurements: morningMeasurements ?? this.morningMeasurements,
        restingHeartRatePoints:
            restingHeartRatePoints ?? this.restingHeartRatePoints,
      );
}

enum HealthBlocInfo {
  morningMeasurementAdded,
}
