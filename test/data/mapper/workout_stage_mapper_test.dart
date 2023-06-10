import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_stage_mapper.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

void main() {
  test(
    'map workout stage from firebase, '
    'workout stage base run dto should be mapped to domain workout stage base run model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final firebase.WorkoutStageBaseRunDto stageDto =
          firebase.WorkoutStageBaseRunDto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageBaseRun expectedStage = WorkoutStageBaseRun(
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
    'workout stage hill repeats dto should be mapped to domain workout stage hill repeats model',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int walkingDistanceInMeters = 0;
      const int joggingDistanceInMeters = 200;
      final firebase.WorkoutStageHillRepeatsDto stageDto =
          firebase.WorkoutStageHillRepeatsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      final WorkoutStageHillRepeats expectedStage = WorkoutStageHillRepeats(
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
      final firebase.WorkoutStageRhythmsDto stageDto =
          firebase.WorkoutStageRhythmsDto(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      final WorkoutStageRhythms expectedStage = WorkoutStageRhythms(
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

  test(
    'map workout stage to firebase, '
    'workout stage base run should be mapped to workout stage base run dto',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final WorkoutStageBaseRun stage = WorkoutStageBaseRun(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final firebase.WorkoutStageBaseRunDto expectedDto =
          firebase.WorkoutStageBaseRunDto(
        distanceInKilometers: distanceInKm,
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
      final WorkoutStageZone2 stage = WorkoutStageZone2(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final firebase.WorkoutStageZone2Dto expectedDto =
          firebase.WorkoutStageZone2Dto(
        distanceInKilometers: distanceInKm,
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
      final WorkoutStageZone3 stage = WorkoutStageZone3(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final firebase.WorkoutStageZone3Dto expectedDto =
          firebase.WorkoutStageZone3Dto(
        distanceInKilometers: distanceInKm,
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
      final WorkoutStageHillRepeats stage = WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      final firebase.WorkoutStageHillRepeatsDto expectedDto =
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
      final WorkoutStageRhythms stage = WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );
      final firebase.WorkoutStageRhythmsDto expectedDto =
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

  test(
    'map workout stage to firebase, '
    'workout stage stretching should be mapped to domain workout stage stretching dto',
    () {
      const WorkoutStageStretching stage = WorkoutStageStretching();
      const firebase.WorkoutStageStretchingDto expectedDto =
          firebase.WorkoutStageStretchingDto();

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage strengthening should be mapped to domain workout stage strengthening dto',
    () {
      const WorkoutStageStrengthening stage = WorkoutStageStrengthening();
      const firebase.WorkoutStageStrengtheningDto expectedDto =
          firebase.WorkoutStageStrengtheningDto();

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout stage to firebase, '
    'workout stage foam rolling should be mapped to domain workout stage foam rolling dto',
    () {
      const WorkoutStageFoamRolling stage = WorkoutStageFoamRolling();
      const firebase.WorkoutStageFoamRollingDto expectedDto =
          firebase.WorkoutStageFoamRollingDto();

      final WorkoutStageDto dto = mapWorkoutStageToFirebase(stage);

      expect(dto, expectedDto);
    },
  );
}
