part of 'health_bloc.dart';

class HealthState extends BlocState {
  final MorningMeasurement? thisMorningMeasurement;
  final ChartRange chartRange;
  final List<MorningMeasurement>? morningMeasurements;

  const HealthState({
    required super.status,
    required this.thisMorningMeasurement,
    required this.chartRange,
    required this.morningMeasurements,
  });

  @override
  List<Object?> get props => [
        status,
        thisMorningMeasurement,
        chartRange,
        morningMeasurements,
      ];

  @override
  HealthState copyWith({
    BlocStatus? status,
    MorningMeasurement? thisMorningMeasurement,
    ChartRange? chartRange,
    List<MorningMeasurement>? morningMeasurements,
  }) =>
      HealthState(
        status: status ?? const BlocStatusComplete(),
        thisMorningMeasurement:
            thisMorningMeasurement ?? this.thisMorningMeasurement,
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
