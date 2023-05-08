import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'w1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 4, 10);
  final WorkoutStatusDto status = WorkoutStatusCompletedDto(
    coveredDistanceInKm: 10.0,
    avgPaceDto: const PaceDto(minutes: 5, seconds: 30),
    avgHeartRate: 145,
    moodRate: MoodRate.mr8,
    comment: 'comment',
  );
  const String name = 'workout name';
  final List<WorkoutStageDto> stages = [
    WorkoutStageBaseRunDto(
      distanceInKilometers: 3,
      maxHeartRate: 150,
    ),
    WorkoutStageZone2Dto(
      distanceInKilometers: 5,
      maxHeartRate: 165,
    ),
    WorkoutStageBaseRunDto(
      distanceInKilometers: 2,
      maxHeartRate: 150,
    ),
  ];
  final WorkoutDto workoutDtoModel = WorkoutDto(
    id: id,
    userId: userId,
    date: date,
    status: status,
    name: name,
    stages: stages,
  );
  final Map<String, dynamic> workoutJson = {
    'date': '2023-04-10',
    'status': status.toJson(),
    'name': name,
    'stages': [
      stages[0].toJson(),
      stages[1].toJson(),
      stages[2].toJson(),
    ],
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final WorkoutDto dto = WorkoutDto.fromJson(
        docId: id,
        userId: userId,
        json: workoutJson,
      );

      expect(dto, workoutDtoModel);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = workoutDtoModel.toJson();

      expect(json, workoutJson);
    },
  );
}
