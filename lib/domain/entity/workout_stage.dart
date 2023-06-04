import 'package:equatable/equatable.dart';

abstract class WorkoutStage extends Equatable {
  const WorkoutStage();
}

class WorkoutStageBaseRun extends WorkoutStage with DistanceWorkoutStage {
  WorkoutStageBaseRun({
    required double distanceInKilometers,
    required int maxHeartRate,
  })  : assert(distanceInKilometers > 0),
        assert(maxHeartRate > 0) {
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  @override
  List<Object> get props => [
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageZone2 extends WorkoutStage with DistanceWorkoutStage {
  WorkoutStageZone2({
    required double distanceInKilometers,
    required int maxHeartRate,
  })  : assert(distanceInKilometers > 0),
        assert(maxHeartRate > 0) {
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  @override
  List<Object> get props => [
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageZone3 extends WorkoutStage with DistanceWorkoutStage {
  WorkoutStageZone3({
    required double distanceInKilometers,
    required int maxHeartRate,
  })  : assert(distanceInKilometers > 0),
        assert(maxHeartRate > 0) {
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  @override
  List<Object> get props => [
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageHillRepeats extends WorkoutStage with SeriesWorkoutStage {
  WorkoutStageHillRepeats({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int walkingDistanceInMeters,
    required int joggingDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(walkingDistanceInMeters > 0 || joggingDistanceInMeters > 0) {
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.walkingDistanceInMeters = walkingDistanceInMeters;
    this.joggingDistanceInMeters = joggingDistanceInMeters;
  }

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        walkingDistanceInMeters,
        joggingDistanceInMeters,
      ];
}

class WorkoutStageRhythms extends WorkoutStage with SeriesWorkoutStage {
  WorkoutStageRhythms({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int walkingDistanceInMeters,
    required int joggingDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(walkingDistanceInMeters > 0 || joggingDistanceInMeters > 0) {
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.walkingDistanceInMeters = walkingDistanceInMeters;
    this.joggingDistanceInMeters = joggingDistanceInMeters;
  }

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        walkingDistanceInMeters,
        joggingDistanceInMeters,
      ];
}

class WorkoutStageStretching extends WorkoutStage {
  const WorkoutStageStretching();

  @override
  List<Object> get props => [];
}

class WorkoutStageStrengthening extends WorkoutStage {
  const WorkoutStageStrengthening();

  @override
  List<Object> get props => [];
}

class WorkoutStageFoamRolling extends WorkoutStage {
  const WorkoutStageFoamRolling();

  @override
  List<Object> get props => [];
}

mixin DistanceWorkoutStage on WorkoutStage {
  late final double distanceInKilometers;
  late final int maxHeartRate;
}

mixin SeriesWorkoutStage on WorkoutStage {
  late final int amountOfSeries;
  late final int seriesDistanceInMeters;
  late final int walkingDistanceInMeters;
  late final int joggingDistanceInMeters;
}