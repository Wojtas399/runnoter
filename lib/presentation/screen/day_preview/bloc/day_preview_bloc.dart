import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'day_preview_event.dart';
import 'day_preview_state.dart';

class DayPreviewBloc extends BlocWithStatus<DayPreviewEvent, DayPreviewState,
    DayPreviewInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<Workout?>? _workoutListener;

  DayPreviewBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? workoutId,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          DayPreviewState(
            status: status,
            workoutId: workoutId,
          ),
        ) {
    on<DayPreviewEventInitialize>(_initialize);
    on<DayPreviewEventWorkoutUpdated>(_workoutUpdated);
    on<DayPreviewEventDeleteWorkout>(_deleteWorkout);
  }

  @override
  Future<void> close() {
    _workoutListener?.cancel();
    _workoutListener = null;
    return super.close();
  }

  Future<void> _initialize(
    DayPreviewEventInitialize event,
    Emitter<DayPreviewState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emit(state.copyWith(
      date: event.date,
    ));
    _setWorkoutListener(loggedUserId, event.date);
  }

  void _workoutUpdated(
    DayPreviewEventWorkoutUpdated event,
    Emitter<DayPreviewState> emit,
  ) {
    final Workout? workout = event.workout;
    emit(state.copyWith(
      workoutId: workout?.id,
      workoutIdAsNull: workout == null,
      workoutName: workout?.name,
      stages: workout?.stages,
      workoutStatus: workout?.status,
    ));
  }

  void _deleteWorkout(
    DayPreviewEventDeleteWorkout event,
    Emitter<DayPreviewState> emit,
  ) async {
    final String? workoutId = state.workoutId;
    if (workoutId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _workoutRepository.deleteWorkout(
      userId: loggedUserId,
      workoutId: workoutId,
    );
    emitCompleteStatus(emit, DayPreviewInfo.workoutDeleted);
  }

  void _setWorkoutListener(String loggedUserId, DateTime date) {
    _workoutListener ??= _workoutRepository
        .getWorkoutByUserIdAndDate(
          userId: loggedUserId,
          date: date,
        )
        .listen(
          (Workout? workout) => add(
            DayPreviewEventWorkoutUpdated(
              workout: workout,
            ),
          ),
        );
  }
}
