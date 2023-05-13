part of 'health_bloc.dart';

class HealthState extends BlocState {
  final MorningMeasurement? thisMorningMeasurement;
  final ChartRange chartRange;
  final DateTime? chartStartDate;
  final DateTime? chartEndDate;
  final List<HealthChartPoint>? restingHeartRatePoints;
  final List<HealthChartPoint>? fastingWeightPoints;

  const HealthState({
    required super.status,
    this.thisMorningMeasurement,
    required this.chartRange,
    this.chartStartDate,
    this.chartEndDate,
    this.restingHeartRatePoints,
    this.fastingWeightPoints,
  });

  @override
  List<Object?> get props => [
        status,
        thisMorningMeasurement,
        chartRange,
        chartStartDate,
        chartEndDate,
        restingHeartRatePoints,
        fastingWeightPoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    MorningMeasurement? thisMorningMeasurement,
    ChartRange? chartRange,
    DateTime? chartStartDate,
    DateTime? chartEndDate,
    List<HealthChartPoint>? restingHeartRatePoints,
    List<HealthChartPoint>? fastingWeightPoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        thisMorningMeasurement:
            thisMorningMeasurement ?? this.thisMorningMeasurement,
        chartRange: chartRange ?? this.chartRange,
        chartStartDate: chartStartDate ?? this.chartStartDate,
        chartEndDate: chartEndDate ?? this.chartEndDate,
        restingHeartRatePoints:
            restingHeartRatePoints ?? this.restingHeartRatePoints,
        fastingWeightPoints: fastingWeightPoints ?? this.fastingWeightPoints,
      );
}

enum HealthBlocInfo {
  morningMeasurementAdded,
}
