import 'package:firebase/firebase.dart';

WorkoutDto createWorkoutDto({
  String id = '',
  String userId = '',
  DateTime? date,
  ActivityStatusDto status = const ActivityStatusPendingDto(),
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
