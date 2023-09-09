part of 'day_preview_cubit.dart';

class DayPreviewState extends Equatable {
  final bool isPastDate;
  final bool canModifyHealthMeasurement;
  final HealthMeasurement? healthMeasurement;
  final List<Workout>? workouts;
  final List<Race>? races;

  const DayPreviewState({
    this.isPastDate = false,
    this.canModifyHealthMeasurement = true,
    this.healthMeasurement,
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [
        isPastDate,
        canModifyHealthMeasurement,
        healthMeasurement,
        workouts,
        races,
      ];

  DayPreviewState copyWith({
    bool? isPastDate,
    bool? canModifyHealthMeasurement,
    HealthMeasurement? healthMeasurement,
    bool healthMeasurementAsNull = false,
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      DayPreviewState(
        isPastDate: isPastDate ?? this.isPastDate,
        canModifyHealthMeasurement:
            canModifyHealthMeasurement ?? this.canModifyHealthMeasurement,
        healthMeasurement: healthMeasurementAsNull
            ? null
            : healthMeasurement ?? this.healthMeasurement,
        workouts: workouts ?? this.workouts,
        races: races ?? this.races,
      );
}
