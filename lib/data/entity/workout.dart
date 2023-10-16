import 'package:equatable/equatable.dart';

import 'activity.dart';

class Workout extends Activity {
  final List<WorkoutStage> stages;

  const Workout({
    required super.id,
    required super.userId,
    required super.date,
    required super.status,
    required super.name,
    required this.stages,
  });

  @override
  List<Object?> get props => [id, userId, date, status, name, stages];
}

sealed class WorkoutStage extends Equatable {
  const WorkoutStage();
}

sealed class DistanceWorkoutStage extends WorkoutStage {
  final double distanceInKm;
  final int maxHeartRate;

  const DistanceWorkoutStage({
    required this.distanceInKm,
    required this.maxHeartRate,
  })  : assert(distanceInKm > 0),
        assert(maxHeartRate > 0);

  @override
  List<Object?> get props => [distanceInKm, maxHeartRate];
}

sealed class SeriesWorkoutStage extends WorkoutStage {
  final int amountOfSeries;
  final int seriesDistanceInMeters;
  final int walkingDistanceInMeters;
  final int joggingDistanceInMeters;

  const SeriesWorkoutStage({
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.walkingDistanceInMeters,
    required this.joggingDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(walkingDistanceInMeters > 0 || joggingDistanceInMeters > 0);

  @override
  List<Object?> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        walkingDistanceInMeters,
        joggingDistanceInMeters,
      ];
}

class WorkoutStageCardio extends DistanceWorkoutStage {
  const WorkoutStageCardio({
    required super.distanceInKm,
    required super.maxHeartRate,
  });
}

class WorkoutStageZone2 extends DistanceWorkoutStage {
  const WorkoutStageZone2({
    required super.distanceInKm,
    required super.maxHeartRate,
  });
}

class WorkoutStageZone3 extends DistanceWorkoutStage {
  const WorkoutStageZone3({
    required super.distanceInKm,
    required super.maxHeartRate,
  });
}

class WorkoutStageHillRepeats extends SeriesWorkoutStage {
  const WorkoutStageHillRepeats({
    required super.amountOfSeries,
    required super.seriesDistanceInMeters,
    required super.walkingDistanceInMeters,
    required super.joggingDistanceInMeters,
  });
}

class WorkoutStageRhythms extends SeriesWorkoutStage {
  const WorkoutStageRhythms({
    required super.amountOfSeries,
    required super.seriesDistanceInMeters,
    required super.walkingDistanceInMeters,
    required super.joggingDistanceInMeters,
  });
}
