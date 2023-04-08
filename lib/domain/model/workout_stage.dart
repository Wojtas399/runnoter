import 'package:equatable/equatable.dart';

abstract class WorkoutStage extends Equatable {
  const WorkoutStage();

  @override
  List<Object> get props => [];
}

class WorkoutStageOWB extends WorkoutStage {
  final double distance;
  final int maxHeartRate;

  const WorkoutStageOWB({
    required this.distance,
    required this.maxHeartRate,
  });

  @override
  List<Object> get props => [
        distance,
        maxHeartRate,
      ];
}

class WorkoutStageBC2 extends WorkoutStage {
  final double distance;
  final int maxHeartRate;
  final WorkoutStageOWB warmUp;
  final WorkoutStageOWB coolDown;

  const WorkoutStageBC2({
    required this.distance,
    required this.maxHeartRate,
    required this.warmUp,
    required this.coolDown,
  });

  @override
  List<Object> get props => [
        distance,
        maxHeartRate,
        warmUp,
        coolDown,
      ];
}

class WorkoutStageBC3 extends WorkoutStage {
  final double distance;
  final int maxHeartRate;
  final WorkoutStageOWB warmUp;
  final WorkoutStageOWB coolDown;

  const WorkoutStageBC3({
    required this.distance,
    required this.maxHeartRate,
    required this.warmUp,
    required this.coolDown,
  });

  @override
  List<Object> get props => [
        distance,
        maxHeartRate,
        warmUp,
        coolDown,
      ];
}

class WorkoutStageStrength extends WorkoutStage {
  final int amountOfSeries;
  final int ascentDistanceInMeters;
  final int descentMarchDistanceInMeters;
  final int descentJogDistanceInMeters;
  final WorkoutStageOWB warmUp;
  final WorkoutStageOWB coolDown;

  const WorkoutStageStrength({
    required this.amountOfSeries,
    required this.ascentDistanceInMeters,
    required this.descentMarchDistanceInMeters,
    required this.descentJogDistanceInMeters,
    required this.warmUp,
    required this.coolDown,
  });

  @override
  List<Object> get props => [
        amountOfSeries,
        ascentDistanceInMeters,
        descentMarchDistanceInMeters,
        descentJogDistanceInMeters,
        warmUp,
        coolDown,
      ];
}

class WorkoutStageRhythm extends WorkoutStage {
  final int amountOfSeries;
  final int rhythmDistanceInKilometers;
  final int marchDistanceInKilometers;
  final int jogDistanceInKilometers;
  final WorkoutStageOWB warmUp;
  final WorkoutStageOWB coolDown;

  const WorkoutStageRhythm({
    required this.amountOfSeries,
    required this.rhythmDistanceInKilometers,
    required this.marchDistanceInKilometers,
    required this.jogDistanceInKilometers,
    required this.warmUp,
    required this.coolDown,
  });

  @override
  List<Object> get props => [
        amountOfSeries,
        rhythmDistanceInKilometers,
        marchDistanceInKilometers,
        jogDistanceInKilometers,
        warmUp,
        coolDown,
      ];
}
