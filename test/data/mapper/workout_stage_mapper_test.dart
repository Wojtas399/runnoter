import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_stage_mapper.dart';
import 'package:runnoter/domain/model/workout_stage.dart';

void main() {
  test(
    'map workout stage from firebase, '
    'workout stage owb dto should be mapped to domain workout stage owb model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final firebase.WorkoutStageOWBDto stageDto = firebase.WorkoutStageOWBDto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageOWB expectedStage = WorkoutStageOWB(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage bc2 dto should be mapped to domain workout stage bc2 model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final firebase.WorkoutStageBC2Dto stageDto = firebase.WorkoutStageBC2Dto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageBC2 expectedStage = WorkoutStageBC2(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      final WorkoutStage stage = mapWorkoutStageFromFirebase(stageDto);

      expect(stage, expectedStage);
    },
  );

  test(
    'map workout stage from firebase, '
    'workout stage bc3 dto should be mapped to domain workout stage bc3 model',
    () {
      const double distanceInKm = 14.0;
      const int maxHeartRate = 150;
      final firebase.WorkoutStageBC3Dto stageDto = firebase.WorkoutStageBC3Dto(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      final WorkoutStageBC3 expectedStage = WorkoutStageBC3(
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
}
