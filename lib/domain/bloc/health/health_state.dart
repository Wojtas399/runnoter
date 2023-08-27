part of 'health_bloc.dart';

class HealthState extends BlocState {
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<HealthChartPoint>? restingHeartRatePoints;
  final List<HealthChartPoint>? fastingWeightPoints;

  const HealthState({
    required super.status,
    this.dateRangeType,
    this.dateRange,
    this.restingHeartRatePoints,
    this.fastingWeightPoints,
  });

  @override
  List<Object?> get props => [
        status,
        dateRangeType,
        dateRange,
        restingHeartRatePoints,
        fastingWeightPoints,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<HealthChartPoint>? restingHeartRatePoints,
    List<HealthChartPoint>? fastingWeightPoints,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
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
