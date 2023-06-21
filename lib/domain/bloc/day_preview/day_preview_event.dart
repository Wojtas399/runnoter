part of 'day_preview_bloc.dart';

abstract class DayPreviewEvent {
  const DayPreviewEvent();
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  final DateTime date;

  const DayPreviewEventInitialize({
    required this.date,
  });
}

class DayPreviewEventWorkoutUpdated extends DayPreviewEvent {
  final Workout? workout;

  const DayPreviewEventWorkoutUpdated({
    required this.workout,
  });
}

class DayPreviewEventDeleteWorkout extends DayPreviewEvent {
  const DayPreviewEventDeleteWorkout();
}
