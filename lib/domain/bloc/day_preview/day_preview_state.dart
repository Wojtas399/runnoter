import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../entity/health_measurement.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final HealthMeasurement? healthMeasurement;
  final List<Workout>? workouts;
  final List<Race>? races;

  const DayPreviewState({
    required super.status,
    this.healthMeasurement,
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [status, healthMeasurement, workouts, races];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    HealthMeasurement? healthMeasurement,
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      DayPreviewState(
        status: status ?? const BlocStatusComplete(),
        healthMeasurement: healthMeasurement ?? this.healthMeasurement,
        workouts: workouts ?? this.workouts,
        races: races ?? this.races,
      );
}
