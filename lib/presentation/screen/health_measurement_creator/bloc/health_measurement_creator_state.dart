import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

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

  bool get isSubmitButtonDisabled =>
      restingHeartRate == null || fastingWeight == null;

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
