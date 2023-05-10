part of 'health_bloc.dart';

class HealthState extends BlocState {
  final MorningMeasurement? todayMorningMeasurement;
  final ChartRange chartRange;
  final List<MorningMeasurement>? morningMeasurements;

  const HealthState({
    required super.status,
    required this.todayMorningMeasurement,
    required this.chartRange,
    required this.morningMeasurements,
  });

  @override
  List<Object?> get props => [
        status,
        todayMorningMeasurement,
        chartRange,
        morningMeasurements,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    MorningMeasurement? todayMorningMeasurement,
    ChartRange? chartRange,
    List<MorningMeasurement>? morningMeasurements,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        todayMorningMeasurement:
            todayMorningMeasurement ?? this.todayMorningMeasurement,
        chartRange: chartRange ?? this.chartRange,
        morningMeasurements: morningMeasurements ?? this.morningMeasurements,
      );
}

enum ChartRange {
  week,
  month,
}

enum HealthBlocInfo {
  morningMeasurementAdded,
}
