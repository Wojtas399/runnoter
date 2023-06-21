part of 'workout_preview_bloc.dart';

abstract class WorkoutPreviewEvent {
  const WorkoutPreviewEvent();
}

class WorkoutPreviewEventInitialize extends WorkoutPreviewEvent {
  const WorkoutPreviewEventInitialize();
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
