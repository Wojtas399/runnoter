import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/additional_model/activity_status.dart';
import '../../../data/additional_model/workout_stage.dart';
import '../../../data/entity/workout.dart';
import '../../../data/interface/repository/workout_repository.dart';
import '../../../dependency_injection.dart';

part 'workout_preview_state.dart';

class WorkoutPreviewCubit extends Cubit<WorkoutPreviewState> {
  final String userId;
  final String workoutId;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<Workout?>? _workoutListener;

  WorkoutPreviewCubit({
    required this.userId,
    required this.workoutId,
    WorkoutPreviewState initialState = const WorkoutPreviewState(),
  })  : _workoutRepository = getIt<WorkoutRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _workoutListener?.cancel();
    _workoutListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _workoutListener ??= _workoutRepository
        .getWorkoutById(userId: userId, workoutId: workoutId)
        .listen(
          (Workout? workout) => emit(state.copyWith(
            date: workout?.date,
            workoutName: workout?.name,
            stages: workout?.stages,
            activityStatus: workout?.status,
          )),
        );
  }

  Future<void> deleteWorkout() async {
    await _workoutRepository.deleteWorkout(
      userId: userId,
      workoutId: workoutId,
    );
  }
}
