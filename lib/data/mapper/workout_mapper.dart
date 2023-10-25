import 'package:firebase/firebase.dart';

import '../model/workout.dart';
import 'activity_status_mapper.dart';
import 'workout_stage_mapper.dart';

Workout mapWorkoutFromDto(WorkoutDto workoutDto) {
  return Workout(
    id: workoutDto.id,
    userId: workoutDto.userId,
    date: workoutDto.date,
    status: mapActivityStatusFromDto(workoutDto.status),
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
