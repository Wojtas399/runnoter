import '../../../../domain/model/health_measurement.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class HealthMeasurementsState extends BlocState<HealthMeasurementsState> {
  final List<HealthMeasurement>? measurements;

  const HealthMeasurementsState({
    required super.status,
    required this.measurements,
  });

  @override
  List<Object?> get props => [
        status,
        measurements,
      ];

  @override
  HealthMeasurementsState copyWith({
    BlocStatus? status,
    List<HealthMeasurement>? measurements,
  }) =>
      HealthMeasurementsState(
        status: status ?? const BlocStatusComplete(),
        measurements: measurements ?? this.measurements,
      );
}
