part of 'health_bloc.dart';

class HealthState extends BlocState {
  final HealthMeasurement? todayMeasurement;
  final ChartRange chartRange;
  final DateTime? chartStartDate;
  final DateTime? chartEndDate;
  final List<HealthChartPoint>? restingHeartRatePoints;
  final List<HealthChartPoint>? fastingWeightPoints;

  const HealthState({
    required super.status,
    this.todayMeasurement,
    required this.chartRange,
    this.chartStartDate,
    this.chartEndDate,
    this.restingHeartRatePoints,
    this.fastingWeightPoints,
  });

  @override
  List<Object?> get props => [
        status,
        todayMeasurement,
        chartRange,
        chartStartDate,
        chartEndDate,
        restingHeartRatePoints,
        fastingWeightPoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    HealthMeasurement? todayMeasurement,
    bool removedTodayMeasurement = false,
    ChartRange? chartRange,
    DateTime? chartStartDate,
    DateTime? chartEndDate,
    List<HealthChartPoint>? restingHeartRatePoints,
    List<HealthChartPoint>? fastingWeightPoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        todayMeasurement: removedTodayMeasurement
            ? null
            : todayMeasurement ?? this.todayMeasurement,
        chartRange: chartRange ?? this.chartRange,
        chartStartDate: chartStartDate ?? this.chartStartDate,
        chartEndDate: chartEndDate ?? this.chartEndDate,
        restingHeartRatePoints:
            restingHeartRatePoints ?? this.restingHeartRatePoints,
        fastingWeightPoints: fastingWeightPoints ?? this.fastingWeightPoints,
      );
}

enum HealthBlocInfo {
  healthMeasurementAdded,
}
