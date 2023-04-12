import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'w1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 4, 10);
  const WorkoutStatusDto status = WorkoutStatusDoneDto(
    coveredDistanceInKm: 10.0,
    avgPace: PaceDto(minutes: 5, seconds: 30),
    avgHeartRate: 145,
    moodRate: MoodRate.mr8,
    comment: 'comment',
  );
  const String name = 'workout name';
  const List<WorkoutStageDto> stages = [
    WorkoutStageOWBDto(
      distanceInKm: 3,
      maxHeartRate: 150,
    ),
    WorkoutStageBC2Dto(
      distanceInKm: 5,
      maxHeartRate: 165,
    ),
    WorkoutStageOWBDto(
      distanceInKm: 2,
      maxHeartRate: 150,
    ),
  ];
  const AdditionalWorkout additionalWorkout = AdditionalWorkout.strengthening;
  final WorkoutDto workoutDtoModel = WorkoutDto(
    id: id,
    userId: userId,
    date: date,
    status: status,
    name: name,
    stages: stages,
    additionalWorkout: additionalWorkout,
  );
  final Map<String, dynamic> workoutJson = {
    'date': '10-04-2023',
    'status': status.toJson(),
    'name': name,
    'stages': [
      stages[0].toJson(),
      stages[1].toJson(),
      stages[2].toJson(),
    ],
    'additionalWorkout': additionalWorkout.name,
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
