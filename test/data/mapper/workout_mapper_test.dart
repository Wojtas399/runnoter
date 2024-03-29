import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_mapper.dart';
import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/data/model/workout.dart';

import '../../creators/workout_creator.dart';

void main() {
  test(
    'mapWorkoutFromDto, '
    'should map dto model to entity model',
    () {
      const String id = 'w1';
      const String userId = 'u1';
      final DateTime date = DateTime(2023, 4, 10);
      const String name = 'workout name';
      const double coveredDistanceInKm = 9;
      const int avgPaceMin = 6;
      const int avgPaceSeconds = 30;
      const int avgHeartRate = 155;
      final firebase.WorkoutDto dto = firebase.WorkoutDto(
        id: id,
        userId: userId,
        date: date,
        status: firebase.ActivityStatusDoneDto(
          coveredDistanceInKm: coveredDistanceInKm,
          avgPaceDto: const firebase.PaceDto(
            minutes: avgPaceMin,
            seconds: avgPaceSeconds,
          ),
          avgHeartRate: avgHeartRate,
          moodRate: firebase.MoodRate.mr8,
          comment: 'comment',
        ),
        name: name,
        stages: const [
          firebase.WorkoutStageCardioDto(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
          firebase.WorkoutStageZone2Dto(
            distanceInKm: 5,
            maxHeartRate: 165,
          ),
          firebase.WorkoutStageCardioDto(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
        ],
      );
      final Workout expectedEntity = createWorkout(
        id: id,
        userId: userId,
        date: date,
        status: const ActivityStatusDone(
          coveredDistanceInKm: coveredDistanceInKm,
          avgPace: Pace(minutes: avgPaceMin, seconds: avgPaceSeconds),
          avgHeartRate: avgHeartRate,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        name: name,
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKm: 5,
            maxHeartRate: 165,
          ),
          WorkoutStageCardio(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
        ],
      );

      final Workout entity = mapWorkoutFromDto(dto);

      expect(entity, expectedEntity);
    },
  );
}
