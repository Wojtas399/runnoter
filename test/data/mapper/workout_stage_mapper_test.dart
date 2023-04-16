import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_stage_mapper.dart';
import 'package:runnoter/domain/model/workout_stage.dart';

void main() {
  test(
    'map workout stage from firebase, '
    'workout stage cardio dto should be mapped to domain workout stage cardio model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final firebase.WorkoutStageCardioDto stageDto =
          firebase.WorkoutStageCardioDto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageCardio expectedStage = WorkoutStageCardio(
        distanceInKilometers: distanceInKm,
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
      final firebase.WorkoutStageZone2Dto stageDto =
          firebase.WorkoutStageZone2Dto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageZone2 expectedStage = WorkoutStageZone2(
        distanceInKilometers: distanceInKm,
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
      final firebase.WorkoutStageZone3Dto stageDto =
          firebase.WorkoutStageZone3Dto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageZone3 expectedStage = WorkoutStageZone3(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage strength dto should be mapped to domain workout stage strength model',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int breakMarchDistanceInMeters = 0;
      const int breakJogDistanceInMeters = 200;
      final firebase.WorkoutStageStrengthDto stageDto =
          firebase.WorkoutStageStrengthDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakMarchDistanceInMeters,
        breakJogDistanceInMeters: breakJogDistanceInMeters,
      );
      final WorkoutStageStrength expectedStage = WorkoutStageStrength(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakMarchDistanceInMeters,
        breakJogDistanceInMeters: breakJogDistanceInMeters,
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
      const int breakMarchDistanceInMeters = 0;
      const int breakJogDistanceInMeters = 200;
      final firebase.WorkoutStageRhythmsDto stageDto =
          firebase.WorkoutStageRhythmsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakMarchDistanceInMeters,
        breakJogDistanceInMeters: breakJogDistanceInMeters,
      );
      final WorkoutStageRhythms expectedStage = WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakMarchDistanceInMeters,
        breakJogDistanceInMeters: breakJogDistanceInMeters,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage stretching dto should be mapped to domain workout stage stretching model',
    () {
      const firebase.WorkoutStageStretchingDto stageDto =
          firebase.WorkoutStageStretchingDto();
      const WorkoutStageStretching expectedStage = WorkoutStageStretching();

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage strengthening dto should be mapped to domain workout stage strengthening model',
    () {
      const firebase.WorkoutStageStrengtheningDto stageDto =
          firebase.WorkoutStageStrengtheningDto();
      const WorkoutStageStrengthening expectedStage =
          WorkoutStageStrengthening();

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage foam rolling dto should be mapped to domain workout stage foam rolling model',
    () {
      const firebase.WorkoutStageFoamRollingDto stageDto =
          firebase.WorkoutStageFoamRollingDto();
      const WorkoutStageFoamRolling expectedStage = WorkoutStageFoamRolling();

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );
}
