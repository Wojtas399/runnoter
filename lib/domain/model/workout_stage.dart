import 'package:equatable/equatable.dart';

abstract class WorkoutStage extends Equatable {
  const WorkoutStage();
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

class WorkoutStageRhythms extends WorkoutStage {
  final int amountOfSeries;
  final int rhythmDistanceInMeters;
  final int marchDistanceInMeters;
  final int jogDistanceInMeters;

  const WorkoutStageRhythms({
    required this.amountOfSeries,
    required this.rhythmDistanceInMeters,
    required this.marchDistanceInMeters,
    required this.jogDistanceInMeters,
  });

  @override
  List<Object> get props => [
        amountOfSeries,
        rhythmDistanceInMeters,
        marchDistanceInMeters,
        jogDistanceInMeters,
      ];
}
