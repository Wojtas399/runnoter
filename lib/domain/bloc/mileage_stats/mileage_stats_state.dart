part of 'mileage_stats_bloc.dart';

class MileageStatsState extends Equatable {
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<MileageStatsChartPoint>? mileageChartPoints;

  const MileageStatsState({
    this.dateRangeType,
    this.dateRange,
    this.mileageChartPoints,
  });

  @override
  List<Object?> get props => [
        dateRangeType,
        dateRange,
        mileageChartPoints,
      ];

  MileageStatsState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<MileageStatsChartPoint>? mileageChartPoints,
  }) =>
      MileageStatsState(
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        mileageChartPoints: mileageChartPoints ?? this.mileageChartPoints,
      );
}

class MileageStatsChartPoint extends Equatable {
  final DateTime date;
  final double mileage;

  const MileageStatsChartPoint({required this.date, required this.mileage});

  @override
  List<Object?> get props => [date, mileage];
}
