import 'package:equatable/equatable.dart';

abstract class WorkoutStageCreatorState extends Equatable {
  const WorkoutStageCreatorState();

  bool get areDataCorrect;

  WorkoutStageCreatorState copyWith();
}
