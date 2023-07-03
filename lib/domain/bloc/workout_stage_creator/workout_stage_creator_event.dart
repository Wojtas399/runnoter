part of 'workout_stage_creator_bloc.dart';

abstract class WorkoutStageCreatorEvent {
  const WorkoutStageCreatorEvent();
}

class WorkoutStageCreatorEventInitialize extends WorkoutStageCreatorEvent {
  const WorkoutStageCreatorEventInitialize();
}

class WorkoutStageCreatorEventStageTypeChanged
    extends WorkoutStageCreatorEvent {
  final WorkoutStageType stageType;

  const WorkoutStageCreatorEventStageTypeChanged({
    required this.stageType,
  });
}

class WorkoutStageCreatorEventDistanceChanged extends WorkoutStageCreatorEvent {
  final double distanceInKm;

  const WorkoutStageCreatorEventDistanceChanged({
    required this.distanceInKm,
  });
}

class WorkoutStageCreatorEventMaxHeartRateChanged
    extends WorkoutStageCreatorEvent {
  final int maxHeartRate;

  const WorkoutStageCreatorEventMaxHeartRateChanged({
    required this.maxHeartRate,
  });
}

class WorkoutStageCreatorEventAmountOfSeriesChanged
    extends WorkoutStageCreatorEvent {
  final int amountOfSeries;

  const WorkoutStageCreatorEventAmountOfSeriesChanged({
    required this.amountOfSeries,
  });
}

class WorkoutStageCreatorEventSeriesDistanceChanged
    extends WorkoutStageCreatorEvent {
  final int seriesDistanceInMeters;

  const WorkoutStageCreatorEventSeriesDistanceChanged({
    required this.seriesDistanceInMeters,
  });
}

class WorkoutStageCreatorEventWalkingDistanceChanged
    extends WorkoutStageCreatorEvent {
  final int walkingDistanceInMeters;

  const WorkoutStageCreatorEventWalkingDistanceChanged({
    required this.walkingDistanceInMeters,
  });
}

class WorkoutStageCreatorEventJoggingDistanceChanged
    extends WorkoutStageCreatorEvent {
  final int joggingDistanceInMeters;

  const WorkoutStageCreatorEventJoggingDistanceChanged({
    required this.joggingDistanceInMeters,
  });
}

class WorkoutStageCreatorEventSubmit extends WorkoutStageCreatorEvent {
  const WorkoutStageCreatorEventSubmit();
}
