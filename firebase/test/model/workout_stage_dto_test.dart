import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'from json, '
    'cardio, '
    'should map json with type key set as cardio to cardio workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'cardio',
        'distanceInKilometers': 10.0,
        'maxHeartRate': 150,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageCardioDto(
        distanceInKm: 10,
        maxHeartRate: 150,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'zone2, '
    'should map json with type key set as zone2 to zone2 workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'zone2',
        'distanceInKilometers': 5.0,
        'maxHeartRate': 165,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageZone2Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'zone3, '
    'should map json with type key set as zone3 to zone3 workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'zone3',
        'distanceInKilometers': 5.0,
        'maxHeartRate': 165,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageZone3Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'hill repeats, '
    'should map json with type key set as hill repeats to hill repeats workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'hillRepeats',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'walkingDistanceInMeters': 20,
        'joggingDistanceInMeters': 80,
      };
      const WorkoutStageDto expectedWorkoutStageDto =
          WorkoutStageHillRepeatsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'rhythms, '
    'should map json with type key set as rhythms to rhythms workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'walkingDistanceInMeters': 0,
        'joggingDistanceInMeters': 200,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageRhythmsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: 200,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'to json, '
    'cardio, '
    'should map cardio workout dto to json with type key set as cardio',
    () {
      const WorkoutStageDto dto = WorkoutStageCardioDto(
        distanceInKm: 10,
        maxHeartRate: 150,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'cardio',
        'distanceInKilometers': 10.0,
        'maxHeartRate': 150,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'zone2, '
    'should map zone2 workout dto to json with type key set as zone2',
    () {
      const WorkoutStageDto dto = WorkoutStageZone2Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'zone2',
        'distanceInKilometers': 5.0,
        'maxHeartRate': 165,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'zone3, '
    'should map zone3 workout dto to json with type key set as zone3',
    () {
      const WorkoutStageDto dto = WorkoutStageZone3Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'zone3',
        'distanceInKilometers': 5.0,
        'maxHeartRate': 165,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'hill repeats, '
    'should map hill repeats workout dto to json with type key set as hill repeats',
    () {
      const WorkoutStageDto dto = WorkoutStageHillRepeatsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'hillRepeats',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'walkingDistanceInMeters': 20,
        'joggingDistanceInMeters': 80,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'rhythms, '
    'should map rhythms workout dto to json with type key set as rhythms',
    () {
      const WorkoutStageDto dto = WorkoutStageRhythmsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: 200,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'walkingDistanceInMeters': 0,
        'joggingDistanceInMeters': 200,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
