part of 'health_stats_cubit.dart';

class HealthStatsState extends Equatable {
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<HealthStatsChartPoint>? restingHeartRatePoints;
  final List<HealthStatsChartPoint>? fastingWeightPoints;

  const HealthStatsState({
    this.dateRangeType,
    this.dateRange,
    this.restingHeartRatePoints,
    this.fastingWeightPoints,
  });

  @override
  List<Object?> get props => [
        dateRangeType,
        dateRange,
        restingHeartRatePoints,
        fastingWeightPoints,
      ];

  HealthStatsState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<HealthStatsChartPoint>? restingHeartRatePoints,
    List<HealthStatsChartPoint>? fastingWeightPoints,
  }) =>
      HealthStatsState(
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
