import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/entity/workout_stage.dart';
import '../../../../domain/entity/workout_status.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';

part 'day_preview_event.dart';
part 'day_preview_state.dart';

class DayPreviewBloc extends BlocWithStatus<DayPreviewEvent, DayPreviewState,
    DayPreviewInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final DateService _dateService;
  StreamSubscription<Workout?>? _workoutListener;

  DayPreviewBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required DateService dateService,
    BlocStatus status = const BlocStatusInitial(),
    String? workoutId,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        _dateService = dateService,
        super(
          DayPreviewState(
            status: status,
            workoutId: workoutId,
          ),
        ) {
    on<DayPreviewEventInitialize>(_initialize);
    on<DayPreviewEventWorkoutUpdated>(_workoutUpdated);
    on<DayPreviewEventEditWorkout>(_editWorkout);
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
      isPastDay: event.date.isBefore(_dateService.getToday()),
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

  void _editWorkout(
    DayPreviewEventEditWorkout event,
    Emitter<DayPreviewState> emit,
  ) {
    emitCompleteStatus(emit, DayPreviewInfo.editWorkout);
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
        .getWorkoutByDate(
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