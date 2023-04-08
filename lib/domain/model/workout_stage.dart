import 'package:equatable/equatable.dart';

abstract class WorkoutStage extends Equatable {
  const WorkoutStage();

  @override
  List<Object> get props => [];
}

class WorkoutStageOWB extends WorkoutStage {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageOWB({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];
}

class WorkoutStageBC2 extends WorkoutStage {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageBC2({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];
}

class WorkoutStageBC3 extends WorkoutStage {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageBC3({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];
}

class WorkoutStageStrength extends WorkoutStage {
  final int amountOfSeries;
  final int ascentDistanceInMeters;
  final int descentMarchDistanceInMeters;
  final int descentJogDistanceInMeters;

  const WorkoutStageStrength({
    required this.amountOfSeries,
    required this.ascentDistanceInMeters,
    required this.descentMarchDistanceInMeters,
    required this.descentJogDistanceInMeters,
  });

  @override
  List<Object> get props => [
        amountOfSeries,
        ascentDistanceInMeters,
        descentMarchDistanceInMeters,
        descentJogDistanceInMeters,
      ];
}

class WorkoutStageRhythm extends WorkoutStage {
  final int amountOfSeries;
  final double rhythmDistanceInKilometers;
  final double marchDistanceInKilometers;
  final double jogDistanceInKilometers;

  const WorkoutStageRhythm({
    required this.amountOfSeries,
    required this.rhythmDistanceInKilometers,
    required this.marchDistanceInKilometers,
    required this.jogDistanceInKilometers,
  });

  @override
  List<Object> get props => [
        amountOfSeries,
        rhythmDistanceInKilometers,
        marchDistanceInKilometers,
        jogDistanceInKilometers,
      ];
}
