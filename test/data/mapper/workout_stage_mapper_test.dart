import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/mapper/workout_stage_mapper.dart';

void main() {
  test(
    'map workout stage from firebase, '
    'workout stage cardio dto should be mapped to domain workout stage cardio model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const firebase.WorkoutStageCardioDto stageDto =
          firebase.WorkoutStageCardioDto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const WorkoutStageCardio expectedStage = WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage zone2 dto should be mapped to domain workout stage zone2 model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const firebase.WorkoutStageZone2Dto stageDto =
          firebase.WorkoutStageZone2Dto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const WorkoutStageZone2 expectedStage = WorkoutStageZone2(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage zone3 dto should be mapped to domain workout stage zone3 model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const firebase.WorkoutStageZone3Dto stageDto =
          firebase.WorkoutStageZone3Dto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const WorkoutStageZone3 expectedStage = WorkoutStageZone3(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage hill repeats dto should be mapped to domain workout stage hill repeats model',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int walkingDistanceInMeters = 0;
      const int joggingDistanceInMeters = 200;
      const firebase.WorkoutStageHillRepeatsDto stageDto =
          firebase.WorkoutStageHillRepeatsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      const WorkoutStageHillRepeats expectedStage = WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage rhythms dto should be mapped to domain workout stage rhythms model',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int walkingDistanceInMeters = 0;
      const int joggingDistanceInMeters = 200;
      const firebase.WorkoutStageRhythmsDto stageDto =
          firebase.WorkoutStageRhythmsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      const WorkoutStageRhythms expectedStage = WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage cardio should be mapped to workout stage cardio dto',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const WorkoutStageCardio stage = WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const firebase.WorkoutStageCardioDto expectedDto =
          firebase.WorkoutStageCardioDto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage zone2 should be mapped to domain workout stage zone2 dto',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const WorkoutStageZone2 stage = WorkoutStageZone2(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const firebase.WorkoutStageZone2Dto expectedDto =
          firebase.WorkoutStageZone2Dto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage zone3 should be mapped to domain workout stage zone3 dto',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      const WorkoutStageZone3 stage = WorkoutStageZone3(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      const firebase.WorkoutStageZone3Dto expectedDto =
          firebase.WorkoutStageZone3Dto(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage hill repeats should be mapped to domain workout stage hill repeats dto',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int walkingDistanceInMeters = 0;
      const int joggingDistanceInMeters = 200;
      const WorkoutStageHillRepeats stage = WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      const firebase.WorkoutStageHillRepeatsDto expectedDto =
          firebase.WorkoutStageHillRepeatsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage rhythms should be mapped to domain workout stage rhythms dto',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int walkingDistanceInMeters = 0;
      const int joggingDistanceInMeters = 200;
      const WorkoutStageRhythms stage = WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      const firebase.WorkoutStageRhythmsDto expectedDto =
          firebase.WorkoutStageRhythmsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );
}
