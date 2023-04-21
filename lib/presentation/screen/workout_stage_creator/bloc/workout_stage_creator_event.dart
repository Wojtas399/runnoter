import 'workout_stage_creator_state.dart';

abstract class WorkoutStageCreatorEvent {
  const WorkoutStageCreatorEvent();
}

class WorkoutStageCreatorEventStageTypeChanged
    extends WorkoutStageCreatorEvent {
  final WorkoutStage stage;

  const WorkoutStageCreatorEventStageTypeChanged({
    required this.stage,
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
