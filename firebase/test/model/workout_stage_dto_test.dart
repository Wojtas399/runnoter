import 'package:firebase/model/workout_stage_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'from json, '
    'owb, '
    'should map json with type key set as owb to owb workout stage',
    () {
      final Map<String, dynamic> json = {
        'type': 'owb',
        'distanceInKm': 10.0,
        'maxHeartRate': 150,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageOWBDto(
        distanceInKm: 10,
        maxHeartRate: 150,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'bc2, '
    'should map json with type key set as bc2 to bc2 workout stage',
    () {
      final Map<String, dynamic> json = {
        'type': 'bc2',
        'distanceInKm': 5.0,
        'maxHeartRate': 165,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageBC2Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'bc3, '
    'should map json with type key set as bc3 to bc3 workout stage',
    () {
      final Map<String, dynamic> json = {
        'type': 'bc3',
        'distanceInKm': 5.0,
        'maxHeartRate': 165,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageBC3Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'strength, '
    'should map json with type key set as strength to strength workout stage',
    () {
      final Map<String, dynamic> json = {
        'type': 'strength',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 20,
        'breakJogDistanceInMeters': 80,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageStrengthDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 20,
        breakJogDistanceInMeters: 80,
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
        'type': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 0,
        'breakJogDistanceInMeters': 200,
      };
      const WorkoutStageDto expectedWorkoutStageDto = WorkoutStageRhythmsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 0,
        breakJogDistanceInMeters: 200,
      );

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'to json, '
    'owb, '
    'should map owb workout dto to json with type key set as owb',
    () {
      const WorkoutStageDto dto = WorkoutStageOWBDto(
        distanceInKm: 10,
        maxHeartRate: 150,
      );
      final Map<String, dynamic> expectedJson = {
        'type': 'owb',
        'distanceInKm': 10.0,
        'maxHeartRate': 150,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'bc2, '
    'should map bc2 workout dto to json with type key set as bc2',
    () {
      const WorkoutStageDto dto = WorkoutStageBC2Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );
      final Map<String, dynamic> expectedJson = {
        'type': 'bc2',
        'distanceInKm': 5.0,
        'maxHeartRate': 165,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'bc3, '
    'should map bc3 workout dto to json with type key set as bc3',
    () {
      const WorkoutStageDto dto = WorkoutStageBC3Dto(
        distanceInKm: 5.0,
        maxHeartRate: 165,
      );
      final Map<String, dynamic> expectedJson = {
        'type': 'bc3',
        'distanceInKm': 5.0,
        'maxHeartRate': 165,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'strength, '
    'should map strength workout dto to json with type key set as strength',
    () {
      const WorkoutStageDto dto = WorkoutStageStrengthDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 20,
        breakJogDistanceInMeters: 80,
      );
      final Map<String, dynamic> expectedJson = {
        'type': 'strength',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 20,
        'breakJogDistanceInMeters': 80,
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
        breakMarchDistanceInMeters: 0,
        breakJogDistanceInMeters: 200,
      );
      final Map<String, dynamic> expectedJson = {
        'type': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 0,
        'breakJogDistanceInMeters': 200,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
