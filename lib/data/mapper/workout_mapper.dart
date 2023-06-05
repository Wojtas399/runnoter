import 'package:firebase/firebase.dart';

import '../../domain/entity/workout.dart';
import 'run_status_mapper.dart';
import 'workout_stage_mapper.dart';

Workout mapWorkoutFromFirebase(WorkoutDto workoutDto) {
  return Workout(
    id: workoutDto.id,
    userId: workoutDto.userId,
    date: workoutDto.date,
    status: mapRunStatusFromFirebase(workoutDto.status),
    name: workoutDto.name,
    stages: workoutDto.stages
        .map(
          (WorkoutStageDto workoutStageDto) => mapWorkoutStageFromFirebase(
            workoutStageDto,
          ),
        )
        .toList(),
  );
}
