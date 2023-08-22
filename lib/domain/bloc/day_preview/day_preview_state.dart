part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final bool isPastDay;
  final HealthMeasurement? healthMeasurement;
  final List<Workout>? workouts;
  final List<Race>? races;

  const DayPreviewState({
    required super.status,
    this.isPastDay = false,
    this.healthMeasurement,
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [
        status,
        isPastDay,
        healthMeasurement,
        workouts,
        races,
      ];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    bool? isPastDay,
    HealthMeasurement? healthMeasurement,
    bool healthMeasurementAsNull = false,
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      DayPreviewState(
        status: status ?? const BlocStatusComplete(),
        isPastDay: isPastDay ?? this.isPastDay,
        healthMeasurement: healthMeasurementAsNull
            ? null
            : healthMeasurement ?? this.healthMeasurement,
        workouts: workouts ?? this.workouts,
        races: races ?? this.races,
      );
}
