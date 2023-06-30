import 'package:equatable/equatable.dart';

sealed class WorkoutStage extends Equatable {
  const WorkoutStage();
}

sealed class DistanceWorkoutStage extends WorkoutStage {
  final double distanceInKilometers;
  final int maxHeartRate;

  const DistanceWorkoutStage({
    required this.distanceInKilometers,
    required this.maxHeartRate,
  })  : assert(distanceInKilometers > 0),
        assert(maxHeartRate > 0);

  @override
  List<Object?> get props => [
        distanceInKilometers,
        maxHeartRate,
      ];
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

class WorkoutStageBaseRun extends DistanceWorkoutStage {
  const WorkoutStageBaseRun({
    required super.distanceInKilometers,
    required super.maxHeartRate,
  });
}

class WorkoutStageZone2 extends DistanceWorkoutStage {
  const WorkoutStageZone2({
    required super.distanceInKilometers,
    required super.maxHeartRate,
  });
}

class WorkoutStageZone3 extends DistanceWorkoutStage {
  const WorkoutStageZone3({
    required super.distanceInKilometers,
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
