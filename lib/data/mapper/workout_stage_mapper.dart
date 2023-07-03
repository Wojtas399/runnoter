import 'package:firebase/firebase.dart';

import '../../domain/entity/workout_stage.dart';

WorkoutStage mapWorkoutStageFromFirebase(WorkoutStageDto workoutStageDto) =>
    switch (workoutStageDto) {
      WorkoutStageBaseRunDto() => WorkoutStageBaseRun(
          distanceInKilometers: workoutStageDto.distanceInKilometers,
          maxHeartRate: workoutStageDto.maxHeartRate,
        ),
      WorkoutStageZone2Dto() => WorkoutStageZone2(
          distanceInKilometers: workoutStageDto.distanceInKilometers,
          maxHeartRate: workoutStageDto.maxHeartRate,
        ),
      WorkoutStageZone3Dto() => WorkoutStageZone3(
          distanceInKilometers: workoutStageDto.distanceInKilometers,
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
      WorkoutStageBaseRun() => WorkoutStageBaseRunDto(
          distanceInKilometers: workoutStage.distanceInKilometers,
          maxHeartRate: workoutStage.maxHeartRate,
        ),
      WorkoutStageZone2() => WorkoutStageZone2Dto(
          distanceInKilometers: workoutStage.distanceInKilometers,
          maxHeartRate: workoutStage.maxHeartRate,
        ),
      WorkoutStageZone3() => WorkoutStageZone3Dto(
          distanceInKilometers: workoutStage.distanceInKilometers,
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
