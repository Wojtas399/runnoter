part of 'workout_status_creator_bloc.dart';

abstract class WorkoutStatusCreatorEvent {
  const WorkoutStatusCreatorEvent();
}

class WorkoutStatusCreatorEventWorkoutStatusTypeChanged
    extends WorkoutStatusCreatorEvent {
  final WorkoutStatusType workoutStatusType;

  const WorkoutStatusCreatorEventWorkoutStatusTypeChanged({
    required this.workoutStatusType,
  });
}

class WorkoutStatusCreatorEventCoveredDistanceInKmChanged
    extends WorkoutStatusCreatorEvent {
  final double? coveredDistanceInKm;

  const WorkoutStatusCreatorEventCoveredDistanceInKmChanged({
    required this.coveredDistanceInKm,
  });
}
