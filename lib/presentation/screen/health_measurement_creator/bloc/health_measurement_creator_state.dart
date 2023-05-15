part of 'health_measurement_creator_bloc.dart';

class HealthMeasurementCreatorState
    extends BlocState<HealthMeasurementCreatorState> {
  final DateTime? date;
  final String? restingHeartRateStr;
  final String? fastingWeightStr;

  const HealthMeasurementCreatorState({
    required super.status,
    this.date,
    this.restingHeartRateStr,
    this.fastingWeightStr,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        restingHeartRateStr,
        fastingWeightStr,
      ];

  bool get isSubmitButtonDisabled =>
      restingHeartRateStr == null ||
      restingHeartRateStr!.isEmpty ||
      fastingWeightStr == null ||
      fastingWeightStr!.isEmpty;

  @override
  copyWith({
    BlocStatus? status,
    DateTime? date,
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        restingHeartRateStr: restingHeartRateStr ?? this.restingHeartRateStr,
        fastingWeightStr: fastingWeightStr ?? this.fastingWeightStr,
      );
}
