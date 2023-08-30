import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../additional_model/workout_stage.dart';

part 'workout_preview_event.dart';
part 'workout_preview_state.dart';

class WorkoutPreviewBloc extends BlocWithStatus<WorkoutPreviewEvent,
    WorkoutPreviewState, WorkoutPreviewBlocInfo, dynamic> {
  final String userId;
  final String workoutId;
  final WorkoutRepository _workoutRepository;

  WorkoutPreviewBloc({
    required this.userId,
    required this.workoutId,
    WorkoutPreviewState state = const WorkoutPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _workoutRepository = getIt<WorkoutRepository>(),
        super(state) {
    on<WorkoutPreviewEventInitialize>(_initialize, transformer: restartable());
    on<WorkoutPreviewEventDeleteWorkout>(_deleteWorkout);
  }

  Future<void> _initialize(
    WorkoutPreviewEventInitialize event,
    Emitter<WorkoutPreviewState> emit,
  ) async {
    final Stream<Workout?> workout$ = _workoutRepository.getWorkoutById(
      userId: userId,
      workoutId: workoutId,
    );
    await emit.forEach(
      workout$,
      onData: (Workout? workout) => state.copyWith(
        date: workout?.date,
        workoutName: workout?.name,
        stages: workout?.stages,
        activityStatus: workout?.status,
      ),
    );
  }

  void _deleteWorkout(
    WorkoutPreviewEventDeleteWorkout event,
    Emitter<WorkoutPreviewState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _workoutRepository.deleteWorkout(
      userId: userId,
      workoutId: workoutId,
    );
    emitCompleteStatus(emit, info: WorkoutPreviewBlocInfo.workoutDeleted);
  }
}

enum WorkoutPreviewBlocInfo { workoutDeleted }
