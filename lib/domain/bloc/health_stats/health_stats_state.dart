part of 'health_stats_bloc.dart';

class HealthStatsState extends BlocState {
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<HealthStatsChartPoint>? restingHeartRatePoints;
  final List<HealthStatsChartPoint>? fastingWeightPoints;

  const HealthStatsState({
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
  HealthStatsState copyWith({
    BlocStatus? status,
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<HealthStatsChartPoint>? restingHeartRatePoints,
    List<HealthStatsChartPoint>? fastingWeightPoints,
  }) =>
      HealthStatsState(
        status: status ?? const BlocStatusComplete(),
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        restingHeartRatePoints:
            restingHeartRatePoints ?? this.restingHeartRatePoints,
        fastingWeightPoints: fastingWeightPoints ?? this.fastingWeightPoints,
      );
}

class HealthStatsChartPoint extends Equatable {
  final DateTime date;
  final num? value;

  const HealthStatsChartPoint({required this.date, required this.value});

  @override
  List<Object?> get props => [date, value];
}
