part of 'health_bloc.dart';

class HealthState extends BlocState {
  final HealthMeasurement? todayMeasurement;
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<HealthChartPoint>? restingHeartRatePoints;
  final List<HealthChartPoint>? fastingWeightPoints;

  const HealthState({
    required super.status,
    this.todayMeasurement,
    this.dateRangeType,
    this.dateRange,
    this.restingHeartRatePoints,
    this.fastingWeightPoints,
  });

  @override
  List<Object?> get props => [
        status,
        todayMeasurement,
        dateRangeType,
        dateRange,
        restingHeartRatePoints,
        fastingWeightPoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    HealthMeasurement? todayMeasurement,
    bool removedTodayMeasurement = false,
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<HealthChartPoint>? restingHeartRatePoints,
    List<HealthChartPoint>? fastingWeightPoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        todayMeasurement: removedTodayMeasurement
            ? null
            : todayMeasurement ?? this.todayMeasurement,
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        restingHeartRatePoints:
            restingHeartRatePoints ?? this.restingHeartRatePoints,
        fastingWeightPoints: fastingWeightPoints ?? this.fastingWeightPoints,
      );
}

class HealthChartPoint extends Equatable {
  final DateTime date;
  final num? value;

  const HealthChartPoint({required this.date, required this.value});

  @override
  List<Object?> get props => [date, value];
}
