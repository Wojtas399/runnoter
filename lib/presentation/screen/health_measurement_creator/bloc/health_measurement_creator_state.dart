part of 'health_measurement_creator_bloc.dart';

class HealthMeasurementCreatorState
    extends BlocState<HealthMeasurementCreatorState> {
  final DateTime? date;
  final int? restingHeartRate;
  final double? fastingWeight;

  const HealthMeasurementCreatorState({
    required super.status,
    this.date,
    this.restingHeartRate,
    this.fastingWeight,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        restingHeartRate,
        fastingWeight,
      ];

  bool get isRestingHeartRateNegative =>
      restingHeartRate != null && restingHeartRate! < 0;

  bool get isFastingWeightNegative =>
      fastingWeight != null && fastingWeight! < 0;

  bool get isSubmitButtonDisabled =>
      restingHeartRate == null ||
      isRestingHeartRateNegative ||
      fastingWeight == null ||
      isFastingWeightNegative;

  @override
  copyWith({
    BlocStatus? status,
    DateTime? date,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        fastingWeight: fastingWeight ?? this.fastingWeight,
      );
}
