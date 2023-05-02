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

class WorkoutStatusCreatorEventMoodRateChanged
    extends WorkoutStatusCreatorEvent {
  final MoodRate moodRate;

  const WorkoutStatusCreatorEventMoodRateChanged({
    required this.moodRate,
  });
}

class WorkoutStatusCreatorEventAvgPaceMinutesChanged
    extends WorkoutStatusCreatorEvent {
  final int minutes;

  const WorkoutStatusCreatorEventAvgPaceMinutesChanged({
    required this.minutes,
  });
}

class WorkoutStatusCreatorEventAvgPaceSecondsChanged
    extends WorkoutStatusCreatorEvent {
  final int seconds;

  const WorkoutStatusCreatorEventAvgPaceSecondsChanged({
    required this.seconds,
  });
}
