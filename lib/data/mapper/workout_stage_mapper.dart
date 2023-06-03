import 'package:firebase/firebase.dart';

import '../../domain/entity/workout_stage.dart';

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
      walkingDistanceInMeters: workoutStageDto.walkingDistanceInMeters,
      joggingDistanceInMeters: workoutStageDto.joggingDistanceInMeters,
    );
  } else if (workoutStageDto is WorkoutStageRhythmsDto) {
    return WorkoutStageRhythms(
      amountOfSeries: workoutStageDto.amountOfSeries,
      seriesDistanceInMeters: workoutStageDto.seriesDistanceInMeters,
      walkingDistanceInMeters: workoutStageDto.walkingDistanceInMeters,
      joggingDistanceInMeters: workoutStageDto.joggingDistanceInMeters,
    );
  } else if (workoutStageDto is WorkoutStageStretchingDto) {
    return const WorkoutStageStretching();
  } else if (workoutStageDto is WorkoutStageStrengtheningDto) {
    return const WorkoutStageStrengthening();
  } else if (workoutStageDto is WorkoutStageFoamRollingDto) {
    return const WorkoutStageFoamRolling();
  } else {
    throw '[WorkoutStageMapper] Unknown workout stage dto';
  }
}

WorkoutStageDto mapWorkoutStageToFirebase(WorkoutStage workoutStage) {
  if (workoutStage is WorkoutStageBaseRun) {
    return WorkoutStageBaseRunDto(
      distanceInKilometers: workoutStage.distanceInKilometers,
      maxHeartRate: workoutStage.maxHeartRate,
    );
  } else if (workoutStage is WorkoutStageZone2) {
    return WorkoutStageZone2Dto(
      distanceInKilometers: workoutStage.distanceInKilometers,
      maxHeartRate: workoutStage.maxHeartRate,
    );
  } else if (workoutStage is WorkoutStageZone3) {
    return WorkoutStageZone3Dto(
      distanceInKilometers: workoutStage.distanceInKilometers,
      maxHeartRate: workoutStage.maxHeartRate,
    );
  } else if (workoutStage is WorkoutStageHillRepeats) {
    return WorkoutStageHillRepeatsDto(
      amountOfSeries: workoutStage.amountOfSeries,
      seriesDistanceInMeters: workoutStage.seriesDistanceInMeters,
      walkingDistanceInMeters: workoutStage.walkingDistanceInMeters,
      joggingDistanceInMeters: workoutStage.joggingDistanceInMeters,
    );
  } else if (workoutStage is WorkoutStageRhythms) {
    return WorkoutStageRhythmsDto(
      amountOfSeries: workoutStage.amountOfSeries,
      seriesDistanceInMeters: workoutStage.seriesDistanceInMeters,
      walkingDistanceInMeters: workoutStage.walkingDistanceInMeters,
      joggingDistanceInMeters: workoutStage.joggingDistanceInMeters,
    );
  } else if (workoutStage is WorkoutStageStretching) {
    return const WorkoutStageStretchingDto();
  } else if (workoutStage is WorkoutStageStrengthening) {
    return const WorkoutStageStrengtheningDto();
  } else if (workoutStage is WorkoutStageFoamRolling) {
    return const WorkoutStageFoamRollingDto();
  } else {
    throw '[WorkoutStageMapper] Unknown workout stage';
  }
}
