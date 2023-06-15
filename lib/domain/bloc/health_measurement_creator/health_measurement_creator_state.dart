part of 'health_measurement_creator_bloc.dart';

class HealthMeasurementCreatorState
    extends BlocState<HealthMeasurementCreatorState> {
  final HealthMeasurement? measurement;
  final int? restingHeartRate;
  final double? fastingWeight;

  const HealthMeasurementCreatorState({
    required super.status,
    this.measurement,
    this.restingHeartRate,
    this.fastingWeight,
  });

  @override
  List<Object?> get props => [
        status,
        measurement,
        restingHeartRate,
        fastingWeight,
      ];

  bool get canSubmit =>
      restingHeartRate != null &&
      restingHeartRate! > 0 &&
      fastingWeight != null &&
      fastingWeight! > 0 &&
      _areDataDifferentThanOriginal;

  @override
  copyWith({
    BlocStatus? status,
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        status: status ?? const BlocStatusComplete(),
        measurement: measurement ?? this.measurement,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        fastingWeight: fastingWeight ?? this.fastingWeight,
      );

  bool get _areDataDifferentThanOriginal {
    if (measurement != null &&
        restingHeartRate != null &&
        fastingWeight != null) {
      return restingHeartRate != measurement!.restingHeartRate ||
          fastingWeight != measurement!.fastingWeight;
    }
    return true;
  }
}
