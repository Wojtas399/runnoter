part of 'workout_preview_bloc.dart';

abstract class WorkoutPreviewEvent {
  const WorkoutPreviewEvent();
}

class WorkoutPreviewEventInitialize extends WorkoutPreviewEvent {
  const WorkoutPreviewEventInitialize();
}

class WorkoutPreviewEventDeleteWorkout extends WorkoutPreviewEvent {
  const WorkoutPreviewEventDeleteWorkout();
}
