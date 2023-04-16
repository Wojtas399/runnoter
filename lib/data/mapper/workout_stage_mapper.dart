import 'package:firebase/firebase.dart';

import '../../domain/model/workout_stage.dart';

WorkoutStage mapWorkoutStageFromFirebase(WorkoutStageDto workoutStageDto) {
  if (workoutStageDto is WorkoutStageOWBDto) {
    return WorkoutStageOWB(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageBC2Dto) {
    return WorkoutStageBC2(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageBC3Dto) {
    return WorkoutStageBC3(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageStrengthDto) {
    return WorkoutStageStrength(
      amountOfSeries: workoutStageDto.amountOfSeries,
      seriesDistanceInMeters: workoutStageDto.seriesDistanceInMeters,
      breakMarchDistanceInMeters: workoutStageDto.breakMarchDistanceInMeters,
      breakJogDistanceInMeters: workoutStageDto.breakJogDistanceInMeters,
    );
  } else if (workoutStageDto is WorkoutStageRhythmsDto) {
    return WorkoutStageRhythms(
      amountOfSeries: workoutStageDto.amountOfSeries,
      seriesDistanceInMeters: workoutStageDto.seriesDistanceInMeters,
      breakMarchDistanceInMeters: workoutStageDto.breakMarchDistanceInMeters,
      breakJogDistanceInMeters: workoutStageDto.breakJogDistanceInMeters,
    );
  } else if (workoutStageDto is WorkoutStageStretchingDto) {
    return const WorkoutStageStretching();
  } else if (workoutStageDto is WorkoutStageStrengtheningDto) {
    return const WorkoutStageStrengthening();
  } else if (workoutStageDto is WorkoutStageFoamRollingDto) {
    return const WorkoutStageFoamRolling();
  } else {
    throw '[WorkoutStageMapper] Unknown workout stage';
  }
}
