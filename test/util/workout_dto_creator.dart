import 'package:firebase/firebase.dart';

WorkoutDto createWorkoutDto({
  String id = 'w1',
  String userId = 'u1',
  DateTime? date,
  WorkoutStatusDto status = const WorkoutStatusPendingDto(),
  String name = '',
  List<WorkoutStageDto> stages = const [],
  AdditionalWorkout? additionalWorkout,
}) {
  return WorkoutDto(
    id: id,
    userId: userId,
    date: date ?? DateTime(2023, 1, 1),
    status: status,
    name: name,
    stages: stages,
    additionalWorkout: additionalWorkout,
  );
}
