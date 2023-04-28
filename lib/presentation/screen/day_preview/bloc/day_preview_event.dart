import '../../../../domain/model/workout.dart';

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

class DayPreviewEventEditWorkout extends DayPreviewEvent {
  const DayPreviewEventEditWorkout();
}

class DayPreviewEventDeleteWorkout extends DayPreviewEvent {
  const DayPreviewEventDeleteWorkout();
}
