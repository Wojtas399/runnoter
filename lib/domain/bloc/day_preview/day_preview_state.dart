part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final bool isPastDate;
  final HealthMeasurement? healthMeasurement;
  final List<Workout>? workouts;
  final List<Race>? races;

  const DayPreviewState({
    required super.status,
    this.isPastDate = false,
    this.healthMeasurement,
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [
        status,
        isPastDate,
        healthMeasurement,
        workouts,
        races,
      ];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    bool? isPastDate,
    HealthMeasurement? healthMeasurement,
    bool healthMeasurementAsNull = false,
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      DayPreviewState(
        status: status ?? const BlocStatusComplete(),
        isPastDate: isPastDate ?? this.isPastDate,
        healthMeasurement: healthMeasurementAsNull
            ? null
            : healthMeasurement ?? this.healthMeasurement,
        workouts: workouts ?? this.workouts,
        races: races ?? this.races,
      );
}
