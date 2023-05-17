part of 'health_measurement_creator_bloc.dart';

class HealthMeasurementCreatorState
    extends BlocState<HealthMeasurementCreatorState> {
  final HealthMeasurement? measurement;
  final String? restingHeartRateStr;
  final String? fastingWeightStr;

  const HealthMeasurementCreatorState({
    required super.status,
    this.measurement,
    this.restingHeartRateStr,
    this.fastingWeightStr,
  });

  @override
  List<Object?> get props => [
        status,
        measurement,
        restingHeartRateStr,
        fastingWeightStr,
      ];

  bool get isSubmitButtonDisabled =>
      restingHeartRateStr == null ||
      restingHeartRateStr!.isEmpty ||
      fastingWeightStr == null ||
      fastingWeightStr!.isEmpty ||
      _areDataSameAsOriginal;

  @override
  copyWith({
    BlocStatus? status,
    HealthMeasurement? measurement,
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorState(
        status: status ?? const BlocStatusComplete(),
        measurement: measurement ?? this.measurement,
        restingHeartRateStr: restingHeartRateStr ?? this.restingHeartRateStr,
        fastingWeightStr: fastingWeightStr ?? this.fastingWeightStr,
      );

  bool get _areDataSameAsOriginal {
    final int? restingHeartRate = int.tryParse(restingHeartRateStr ?? '');
    final double? fastingWeight = double.tryParse(fastingWeightStr ?? '');
    if (measurement == null ||
        restingHeartRate == null ||
        fastingWeight == null) {
      return false;
    }
    return restingHeartRate == measurement!.restingHeartRate &&
        fastingWeight == measurement!.fastingWeight;
  }
}
