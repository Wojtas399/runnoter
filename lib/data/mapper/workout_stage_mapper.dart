import 'package:firebase/firebase.dart';

import '../../domain/model/workout_stage.dart';

WorkoutStage mapWorkoutStageFromFirebase(WorkoutStageDto workoutStageDto) {
  if (workoutStageDto is WorkoutStageBaseRunDto) {
    return WorkoutStageBaseRun(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageZone2Dto) {
    return WorkoutStageZone2(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageZone3Dto) {
    return WorkoutStageZone3(
      distanceInKilometers: workoutStageDto.distanceInKilometers,
      maxHeartRate: workoutStageDto.maxHeartRate,
    );
  } else if (workoutStageDto is WorkoutStageHillRepeatsDto) {
    return WorkoutStageHillRepeats(
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
