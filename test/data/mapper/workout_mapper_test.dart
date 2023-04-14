import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_mapper.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/domain/model/workout_status.dart';

import '../../util/workout_creator.dart';

void main() {
  test(
    'map workout from firebase, '
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
        status: const firebase.WorkoutStatusDoneDto(
          coveredDistanceInKilometers: coveredDistanceInKm,
          avgPace: firebase.PaceDto(
            minutes: avgPaceMin,
            seconds: avgPaceSeconds,
          ),
          avgHeartRate: avgHeartRate,
          moodRate: firebase.MoodRate.mr8,
          comment: 'comment',
        ),
        name: name,
        stages: [
          firebase.WorkoutStageOWBDto(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
          firebase.WorkoutStageBC2Dto(
            distanceInKilometers: 5,
            maxHeartRate: 165,
          ),
          firebase.WorkoutStageOWBDto(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
        ],
        additionalWorkout: firebase.AdditionalWorkout.stretching,
      );
      final Workout expectedEntity = createWorkout(
        id: id,
        userId: userId,
        date: date,
        status: const WorkoutStatusDone(
          coveredDistanceInKm: coveredDistanceInKm,
          avgPace: Pace(minutes: avgPaceMin, seconds: avgPaceSeconds),
          avgHeartRate: avgHeartRate,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        name: name,
        stages: [
          WorkoutStageOWB(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageBC2(
            distanceInKilometers: 5,
            maxHeartRate: 165,
          ),
          WorkoutStageOWB(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
        ],
        additionalWorkout: AdditionalWorkout.stretching,
      );

      final Workout entity = mapWorkoutFromFirebase(dto);

      expect(entity, expectedEntity);
    },
  );
}
