import 'package:firebase/firebase.dart';

import '../../domain/additional_model/workout_stage.dart';

WorkoutStage mapWorkoutStageFromFirebase(WorkoutStageDto workoutStageDto) =>
    switch (workoutStageDto) {
      WorkoutStageCardioDto() => WorkoutStageCardio(
          distanceInKm: workoutStageDto.distanceInKm,
          maxHeartRate: workoutStageDto.maxHeartRate,
        ),
      WorkoutStageZone2Dto() => WorkoutStageZone2(
          distanceInKm: workoutStageDto.distanceInKm,
          maxHeartRate: workoutStageDto.maxHeartRate,
        ),
      WorkoutStageZone3Dto() => WorkoutStageZone3(
          distanceInKm: workoutStageDto.distanceInKm,
          maxHeartRate: workoutStageDto.maxHeartRate,
        ),
      WorkoutStageHillRepeatsDto() => WorkoutStageHillRepeats(
          amountOfSeries: workoutStageDto.amountOfSeries,
          seriesDistanceInMeters: workoutStageDto.seriesDistanceInMeters,
          walkingDistanceInMeters: workoutStageDto.walkingDistanceInMeters,
          joggingDistanceInMeters: workoutStageDto.joggingDistanceInMeters,
        ),
      WorkoutStageRhythmsDto() => WorkoutStageRhythms(
          amountOfSeries: workoutStageDto.amountOfSeries,
          seriesDistanceInMeters: workoutStageDto.seriesDistanceInMeters,
          walkingDistanceInMeters: workoutStageDto.walkingDistanceInMeters,
          joggingDistanceInMeters: workoutStageDto.joggingDistanceInMeters,
        ),
    };

WorkoutStageDto mapWorkoutStageToFirebase(WorkoutStage workoutStage) =>
    switch (workoutStage) {
      WorkoutStageCardio() => WorkoutStageCardioDto(
          distanceInKm: workoutStage.distanceInKm,
          maxHeartRate: workoutStage.maxHeartRate,
        ),
      WorkoutStageZone2() => WorkoutStageZone2Dto(
          distanceInKm: workoutStage.distanceInKm,
          maxHeartRate: workoutStage.maxHeartRate,
        ),
      WorkoutStageZone3() => WorkoutStageZone3Dto(
          distanceInKm: workoutStage.distanceInKm,
          maxHeartRate: workoutStage.maxHeartRate,
        ),
      WorkoutStageHillRepeats() => WorkoutStageHillRepeatsDto(
          amountOfSeries: workoutStage.amountOfSeries,
          seriesDistanceInMeters: workoutStage.seriesDistanceInMeters,
          walkingDistanceInMeters: workoutStage.walkingDistanceInMeters,
          joggingDistanceInMeters: workoutStage.joggingDistanceInMeters,
        ),
      WorkoutStageRhythms() => WorkoutStageRhythmsDto(
          amountOfSeries: workoutStage.amountOfSeries,
          seriesDistanceInMeters: workoutStage.seriesDistanceInMeters,
          walkingDistanceInMeters: workoutStage.walkingDistanceInMeters,
          joggingDistanceInMeters: workoutStage.joggingDistanceInMeters,
        ),
    };
