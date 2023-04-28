import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/model/workout_stage.dart';
import '../../../../domain/model/workout_status.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'workout_creator_event.dart';
part 'workout_creator_state.dart';

class WorkoutCreatorBloc extends BlocWithStatus<WorkoutCreatorEvent,
    WorkoutCreatorState, WorkoutCreatorInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<Workout?>? _workoutListener;

  WorkoutCreatorBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    BlocStatus status = const BlocStatusComplete(),
    WorkoutCreatorMode creatorMode = WorkoutCreatorMode.add,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          WorkoutCreatorState(
            status: status,
            creatorMode: creatorMode,
            date: date,
            workoutName: workoutName,
            stages: stages,
          ),
        ) {
    on<WorkoutCreatorEventInitialize>(_initialize);
    on<WorkoutCreatorEventWorkoutNameChanged>(_workoutNameChanged);
    on<WorkoutCreatorEventWorkoutStageAdded>(_workoutStageAdded);
    on<WorkoutCreatorEventWorkoutStagesOrderChanged>(
      _workoutStagesOrderChanged,
    );
    on<WorkoutCreatorEventDeleteWorkoutStage>(_deleteWorkoutStage);
    on<WorkoutCreatorEventSubmit>(_submit);
  }

  @override
  Future<void> close() {
    _workoutListener?.cancel();
    _workoutListener = null;
    return super.close();
  }

  Future<void> _initialize(
    WorkoutCreatorEventInitialize event,
    Emitter<WorkoutCreatorState> emit,
  ) async {
    final String? workoutId = event.workoutId;
    if (workoutId != null) {
      final String? loggedUserId = await _authService.loggedUserId$.first;
      if (loggedUserId != null) {
        final Workout? workout = await _loadWorkoutById(
          workoutId,
          loggedUserId,
        );
        emit(state.copyWith(
          status: const BlocStatusComplete<WorkoutCreatorInfo>(
            info: WorkoutCreatorInfo.editModeInitialized,
          ),
          date: event.date,
          workoutName: workout?.name,
          stages: workout?.stages,
        ));
        return;
      }
    }
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _workoutNameChanged(
    WorkoutCreatorEventWorkoutNameChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      workoutName: event.workoutName,
    ));
  }

  void _workoutStageAdded(
    WorkoutCreatorEventWorkoutStageAdded event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      stages: [
        ...state.stages,
        event.workoutStage,
      ],
    ));
  }

  void _workoutStagesOrderChanged(
    WorkoutCreatorEventWorkoutStagesOrderChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      stages: event.workoutStages,
    ));
  }

  void _deleteWorkoutStage(
    WorkoutCreatorEventDeleteWorkoutStage event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    final List<WorkoutStage> updatedStages = [
      ...state.stages,
    ];
    updatedStages.removeAt(event.index);
    emit(state.copyWith(
      stages: updatedStages,
    ));
  }

  Future<void> _submit(
    WorkoutCreatorEventSubmit event,
    Emitter<WorkoutCreatorState> emit,
  ) async {
    final DateTime? date = state.date;
    final String? workoutName = state.workoutName;
    if (date == null ||
        workoutName == null ||
        workoutName.isEmpty ||
        state.stages.isEmpty) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId != null) {
      emitLoadingStatus(emit);
      await _workoutRepository.addWorkout(
        userId: loggedUserId,
        workoutName: workoutName,
        date: date,
        status: const WorkoutStatusPending(),
        stages: state.stages,
      );
      emitCompleteStatus(emit, WorkoutCreatorInfo.workoutHasBeenAdded);
    }
  }

  Future<Workout?> _loadWorkoutById(String workoutId, String userId) async {
    return await _workoutRepository
        .getWorkoutById(
          workoutId: workoutId,
          userId: userId,
        )
        .first;
  }
}
