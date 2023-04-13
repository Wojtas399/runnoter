import 'package:firebase/firebase.dart';

import '../../domain/model/workout.dart';
import 'additional_workout_mapper.dart';
import 'workout_stage_mapper.dart';
import 'workout_status_mapper.dart';

Workout mapWorkoutFromFirebase(WorkoutDto workoutDto) {
  return Workout(
    id: workoutDto.id,
    userId: workoutDto.userId,
    date: workoutDto.date,
    status: mapWorkoutStatusFromFirebase(workoutDto.status),
    name: workoutDto.name,
    stages: workoutDto.stages
        .map(
          (WorkoutStageDto workoutStageDto) => mapWorkoutStageFromFirebase(
            workoutStageDto,
          ),
        )
        .toList(),
    additionalWorkout: workoutDto.additionalWorkout != null
        ? mapAdditionalWorkoutFromFirebase(workoutDto.additionalWorkout!)
        : null,
  );
}
