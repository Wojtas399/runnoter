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
      final WorkoutStageDto expectedWorkoutStageDto = WorkoutStageCardioDto(
        distanceInKilometers: 10,
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
      final WorkoutStageDto expectedWorkoutStageDto = WorkoutStageZone2Dto(
        distanceInKilometers: 5.0,
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
      final WorkoutStageDto expectedWorkoutStageDto = WorkoutStageZone3Dto(
        distanceInKilometers: 5.0,
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
        'name': 'strength',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 20,
        'breakJogDistanceInMeters': 80,
      };
      final WorkoutStageDto expectedWorkoutStageDto = WorkoutStageStrengthDto(
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
        'name': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 0,
        'breakJogDistanceInMeters': 200,
      };
      final WorkoutStageDto expectedWorkoutStageDto = WorkoutStageRhythmsDto(
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
    'from json, '
    'stretching, '
    'should map json with type key set as stretching to stretching workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'stretching',
      };
      const WorkoutStageDto expectedWorkoutStageDto =
          WorkoutStageStretchingDto();

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'strengthening, '
    'should map json with type key set as strengthening to strengthening workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'strengthening',
      };
      const WorkoutStageDto expectedWorkoutStageDto =
          WorkoutStageStrengtheningDto();

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'from json, '
    'foam rolling, '
    'should map json with type key set as foam rolling to foam rolling workout stage',
    () {
      final Map<String, dynamic> json = {
        'name': 'foamRolling',
      };
      const WorkoutStageDto expectedWorkoutStageDto =
          WorkoutStageFoamRollingDto();

      final WorkoutStageDto dto = WorkoutStageDto.fromJson(json);

      expect(dto, expectedWorkoutStageDto);
    },
  );

  test(
    'to json, '
    'cardio, '
    'should map cardio workout dto to json with type key set as cardio',
    () {
      final WorkoutStageDto dto = WorkoutStageCardioDto(
        distanceInKilometers: 10,
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
      final WorkoutStageDto dto = WorkoutStageZone2Dto(
        distanceInKilometers: 5.0,
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
      final WorkoutStageDto dto = WorkoutStageZone3Dto(
        distanceInKilometers: 5.0,
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
    'strength, '
    'should map strength workout dto to json with type key set as strength',
    () {
      final WorkoutStageDto dto = WorkoutStageStrengthDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 20,
        breakJogDistanceInMeters: 80,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'strength',
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
      final WorkoutStageDto dto = WorkoutStageRhythmsDto(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 0,
        breakJogDistanceInMeters: 200,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'rhythms',
        'amountOfSeries': 10,
        'seriesDistanceInMeters': 100,
        'breakMarchDistanceInMeters': 0,
        'breakJogDistanceInMeters': 200,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'stretching, '
    'should map stretching workout dto to json with type key set as stretching',
    () {
      const WorkoutStageDto dto = WorkoutStageStretchingDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'stretching',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'strengthening, '
    'should map strengthening workout dto to json with type key set as strengthening',
    () {
      const WorkoutStageDto dto = WorkoutStageStrengtheningDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'strengthening',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'foam rolling, '
    'should map foam rolling workout dto to json with type key set as foam rolling',
    () {
      const WorkoutStageDto dto = WorkoutStageFoamRollingDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'foamRolling',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
