part of 'mileage_bloc.dart';

class MileageState extends BlocState {
  final DateRangeType? dateRangeType;
  final DateRange? dateRange;
  final List<MileageChartPoint>? mileageChartPoints;

  const MileageState({
    required super.status,
    this.dateRangeType,
    this.dateRange,
    this.mileageChartPoints,
  });

  @override
  List<Object?> get props => [
        status,
        dateRangeType,
        dateRange,
        mileageChartPoints,
      ];

  @override
  MileageState copyWith({
    BlocStatus? status,
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<MileageChartPoint>? mileageChartPoints,
  }) =>
      MileageState(
        status: status ?? const BlocStatusComplete(),
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        mileageChartPoints: mileageChartPoints ?? this.mileageChartPoints,
      );
}

class MileageChartPoint extends Equatable {
  final DateTime date;
  final double mileage;

  const MileageChartPoint({required this.date, required this.mileage});

  @override
  List<Object?> get props => [date, mileage];
}
