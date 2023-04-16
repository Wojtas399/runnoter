import 'package:equatable/equatable.dart';

abstract class WorkoutStage extends Equatable {
  const WorkoutStage();
}

class WorkoutStageOWB extends WorkoutStage with DistanceWorkout {
  WorkoutStageOWB({
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

class WorkoutStageBC2 extends WorkoutStage with DistanceWorkout {
  WorkoutStageBC2({
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

class WorkoutStageBC3 extends WorkoutStage with DistanceWorkout {
  WorkoutStageBC3({
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

class WorkoutStageStrength extends WorkoutStage with SeriesWorkout {
  WorkoutStageStrength({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int breakMarchDistanceInMeters,
    required int breakJogDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(breakMarchDistanceInMeters > 0 || breakJogDistanceInMeters > 0) {
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.breakMarchDistanceInMeters = breakMarchDistanceInMeters;
    this.breakJogDistanceInMeters = breakJogDistanceInMeters;
  }

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
      ];
}

class WorkoutStageRhythms extends WorkoutStage with SeriesWorkout {
  WorkoutStageRhythms({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int breakMarchDistanceInMeters,
    required int breakJogDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(breakMarchDistanceInMeters > 0 || breakJogDistanceInMeters > 0) {
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.breakMarchDistanceInMeters = breakMarchDistanceInMeters;
    this.breakJogDistanceInMeters = breakJogDistanceInMeters;
  }

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
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

mixin DistanceWorkout on WorkoutStage {
  late final double distanceInKilometers;
  late final int maxHeartRate;
}

mixin SeriesWorkout on WorkoutStage {
  late final int amountOfSeries;
  late final int seriesDistanceInMeters;
  late final int breakMarchDistanceInMeters;
  late final int breakJogDistanceInMeters;
}
