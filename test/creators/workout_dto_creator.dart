import 'package:firebase/firebase.dart';

WorkoutDto createWorkoutDto({
  String id = 'w1',
  String userId = 'u1',
  DateTime? date,
  RunStatusDto status = const RunStatusPendingDto(),
  String name = '',
  List<WorkoutStageDto> stages = const [],
}) {
  return WorkoutDto(
    id: id,
    userId: userId,
    date: date ?? DateTime(2023, 1, 1),
    status: status,
    name: name,
    stages: stages,
  );
}
