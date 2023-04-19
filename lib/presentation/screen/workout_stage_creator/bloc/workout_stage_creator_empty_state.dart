import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorEmptyState extends WorkoutStageCreatorState {
  @override
  bool get areDataCorrect => true;

  @override
  WorkoutStageCreatorState copyWith() => WorkoutStageCreatorEmptyState();

  @override
  List<Object?> get props => [];
}
