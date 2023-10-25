import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'w1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 4, 10);
  const String dateStr = '2023-04-10';
  final ActivityStatusDto status = ActivityStatusDoneDto(
    coveredDistanceInKm: 10.0,
    avgPaceDto: const PaceDto(minutes: 5, seconds: 30),
    avgHeartRate: 145,
    moodRate: MoodRate.mr8,
    comment: 'comment',
  );
  const String name = 'workout name';
  final List<WorkoutStageDto> stages = [
    const WorkoutStageCardioDto(
      distanceInKm: 3,
      maxHeartRate: 150,
    ),
    const WorkoutStageZone2Dto(
      distanceInKm: 5,
      maxHeartRate: 165,
    ),
    const WorkoutStageCardioDto(
      distanceInKm: 2,
      maxHeartRate: 150,
    ),
  ];
  final List<Map<String, dynamic>> stageJsons = [
    stages[0].toJson(),
    stages[1].toJson(),
    stages[2].toJson(),
  ];

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'date': dateStr,
        'status': status.toJson(),
        'name': name,
        'stages': stageJsons,
      };
      final WorkoutDto expectedDto = WorkoutDto(
        id: id,
        userId: userId,
        date: date,
        status: status,
        name: name,
        stages: stages,
      );

      final WorkoutDto dto = WorkoutDto.fromJson(
        workoutId: id,
        userId: userId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final WorkoutDto dto = WorkoutDto(
        id: id,
        userId: userId,
        date: date,
        status: status,
        name: name,
        stages: stages,
      );
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'status': status.toJson(),
        'name': name,
        'stages': stageJsons,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'date is null, '
    'should not include date in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'status': status.toJson(),
        'stages': stageJsons,
      };

      final Map<String, dynamic> json = createWorkoutJsonToUpdate(
        workoutName: name,
        status: status,
        stages: stages,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'name is null, '
    'should not include name in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'status': status.toJson(),
        'stages': stageJsons,
      };

      final Map<String, dynamic> json = createWorkoutJsonToUpdate(
        date: date,
        status: status,
        stages: stages,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'status is null, '
    'should not include status in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'name': name,
        'stages': stageJsons,
      };

      final Map<String, dynamic> json = createWorkoutJsonToUpdate(
        date: date,
        workoutName: name,
        stages: stages,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'stages are null, '
    'should not include stages in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'name': name,
        'status': status.toJson(),
      };

      final Map<String, dynamic> json = createWorkoutJsonToUpdate(
        date: date,
        workoutName: name,
        status: status,
      );

      expect(json, expectedJson);
    },
  );
}
