import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/entity/workout_stage.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';

part 'workout_preview_event.dart';
part 'workout_preview_state.dart';

class WorkoutPreviewBloc extends BlocWithStatus<WorkoutPreviewEvent,
    WorkoutPreviewState, WorkoutPreviewBlocInfo, dynamic> {
  final String? workoutId;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;

  WorkoutPreviewBloc({
    required this.workoutId,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    WorkoutPreviewState state = const WorkoutPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(state) {
    on<WorkoutPreviewEventInitialize>(_initialize, transformer: restartable());
    on<WorkoutPreviewEventDeleteWorkout>(_deleteWorkout);
  }

  Future<void> _initialize(
    WorkoutPreviewEventInitialize event,
    Emitter<WorkoutPreviewState> emit,
  ) async {
    if (workoutId == null) return;
    final Stream<Workout?> workout$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => _workoutRepository.getWorkoutById(
                userId: loggedUserId,
                workoutId: workoutId!,
              ),
            );
    await emit.forEach(
      workout$,
      onData: (Workout? workout) => state.copyWith(
        date: workout?.date,
        workoutName: workout?.name,
        stages: workout?.stages,
        runStatus: workout?.status,
      ),
    );
  }

  void _deleteWorkout(
    WorkoutPreviewEventDeleteWorkout event,
    Emitter<WorkoutPreviewState> emit,
  ) async {
    if (workoutId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emitLoadingStatus(emit);
    await _workoutRepository.deleteWorkout(
      userId: loggedUserId,
      workoutId: workoutId!,
    );
    emitCompleteStatus(emit, WorkoutPreviewBlocInfo.workoutDeleted);
  }
}

enum WorkoutPreviewBlocInfo {
  workoutDeleted,
}
