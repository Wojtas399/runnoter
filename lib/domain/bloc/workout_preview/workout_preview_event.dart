part of 'workout_preview_bloc.dart';

abstract class WorkoutPreviewEvent {
  const WorkoutPreviewEvent();
}

class WorkoutPreviewEventInitialize extends WorkoutPreviewEvent {
  final DateTime date;

  const WorkoutPreviewEventInitialize({
    required this.date,
  });
}

class WorkoutPreviewEventWorkoutUpdated extends WorkoutPreviewEvent {
  final Workout? workout;

  const WorkoutPreviewEventWorkoutUpdated({
    required this.workout,
  });
}

class WorkoutPreviewEventDeleteWorkout extends WorkoutPreviewEvent {
  const WorkoutPreviewEventDeleteWorkout();
}
