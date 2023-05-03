import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/model/workout_status.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'workout_status_creator_event.dart';
part 'workout_status_creator_state.dart';

class WorkoutStatusCreatorBloc extends BlocWithStatus<WorkoutStatusCreatorEvent,
    WorkoutStatusCreatorState, WorkoutStatusCreatorInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;

  WorkoutStatusCreatorBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? workoutId,
    WorkoutStatusType? workoutStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          WorkoutStatusCreatorState(
            status: status,
            workoutId: workoutId,
            workoutStatusType: workoutStatusType,
            coveredDistanceInKm: coveredDistanceInKm,
            moodRate: moodRate,
            averagePaceMinutes: averagePaceMinutes,
            averagePaceSeconds: averagePaceSeconds,
            averageHeartRate: averageHeartRate,
            comment: comment,
          ),
        ) {
    on<WorkoutStatusCreatorEventInitialize>(_initialize);
    on<WorkoutStatusCreatorEventWorkoutStatusTypeChanged>(
      _workoutStatusTypeChanged,
    );
    on<WorkoutStatusCreatorEventCoveredDistanceInKmChanged>(
      _coveredDistanceInKmChanged,
    );
    on<WorkoutStatusCreatorEventMoodRateChanged>(_moodRateChanged);
    on<WorkoutStatusCreatorEventAvgPaceMinutesChanged>(_avgPaceMinutesChanged);
    on<WorkoutStatusCreatorEventAvgPaceSecondsChanged>(_avgPaceSecondsChanged);
    on<WorkoutStatusCreatorEventAvgHeartRateChanged>(_avgHeartRateChanged);
    on<WorkoutStatusCreatorEventCommentChanged>(_commentChanged);
    on<WorkoutStatusCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    WorkoutStatusCreatorEventInitialize event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) async {
    if (event.workoutStatusType != null) {
      emit(state.copyWith(
        workoutId: event.workoutId,
        workoutStatusType: event.workoutStatusType,
      ));
      return;
    }
    const BlocStatus blocStatus = BlocStatusComplete<WorkoutStatusCreatorInfo>(
      info: WorkoutStatusCreatorInfo.workoutStatusInitialized,
    );
    final Workout? workout = await _loadWorkoutById(event.workoutId, emit);
    final WorkoutStatus? workoutStatus = workout?.status;
    if (workoutStatus is FinishedWorkout) {
      emit(state.copyWith(
        status: blocStatus,
        workoutId: event.workoutId,
        workoutStatus: workoutStatus,
        workoutStatusType: _getWorkoutStatusType(workoutStatus),
        coveredDistanceInKm: workoutStatus.coveredDistanceInKm,
        moodRate: workoutStatus.moodRate,
        averagePaceMinutes: workoutStatus.avgPace.minutes,
        averagePaceSeconds: workoutStatus.avgPace.seconds,
        averageHeartRate: workoutStatus.avgHeartRate,
        comment: workoutStatus.comment,
      ));
    } else if (workoutStatus is WorkoutStatusPending) {
      emit(state.copyWith(
        status: blocStatus,
        workoutId: event.workoutId,
        workoutStatus: workoutStatus,
        workoutStatusType: WorkoutStatusType.pending,
      ));
    }
  }

  void _workoutStatusTypeChanged(
    WorkoutStatusCreatorEventWorkoutStatusTypeChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      workoutStatusType: event.workoutStatusType,
    ));
  }

  void _coveredDistanceInKmChanged(
    WorkoutStatusCreatorEventCoveredDistanceInKmChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      coveredDistanceInKm: event.coveredDistanceInKm,
    ));
  }

  void _moodRateChanged(
    WorkoutStatusCreatorEventMoodRateChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      moodRate: event.moodRate,
    ));
  }

  void _avgPaceMinutesChanged(
    WorkoutStatusCreatorEventAvgPaceMinutesChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePaceMinutes: event.minutes,
    ));
  }

  void _avgPaceSecondsChanged(
    WorkoutStatusCreatorEventAvgPaceSecondsChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePaceSeconds: event.seconds,
    ));
  }

  void _avgHeartRateChanged(
    WorkoutStatusCreatorEventAvgHeartRateChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averageHeartRate: event.averageHeartRate,
    ));
  }

  void _commentChanged(
    WorkoutStatusCreatorEventCommentChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      comment: event.comment,
    ));
  }

  Future<void> _submit(
    WorkoutStatusCreatorEventSubmit event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) async {
    if (state.workoutId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    if (state.isFormValid) {
      emitLoadingStatus(emit);
      final WorkoutStatus newStatus = _createStatus();
      await _workoutRepository.updateWorkout(
        workoutId: state.workoutId!,
        userId: loggedUserId,
        status: newStatus,
      );
      emitCompleteStatus(emit, WorkoutStatusCreatorInfo.workoutStatusSaved);
    }
  }

  Future<Workout?> _loadWorkoutById(
    String workoutId,
    Emitter<WorkoutStatusCreatorState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return null;
    }
    return await _workoutRepository
        .getWorkoutById(
          workoutId: workoutId,
          userId: loggedUserId,
        )
        .first;
  }

  WorkoutStatusType _getWorkoutStatusType(WorkoutStatus workoutStatus) {
    if (workoutStatus is WorkoutStatusPending) {
      return WorkoutStatusType.pending;
    } else if (workoutStatus is WorkoutStatusCompleted) {
      return WorkoutStatusType.completed;
    } else if (workoutStatus is WorkoutStatusUncompleted) {
      return WorkoutStatusType.uncompleted;
    } else {
      throw '[WorkoutStatusCreatorBloc]: Unknown workout status';
    }
  }

  WorkoutStatus _createStatus() {
    switch (state.workoutStatusType!) {
      case WorkoutStatusType.pending:
        return const WorkoutStatusPending();
      case WorkoutStatusType.completed:
        return WorkoutStatusCompleted(
          coveredDistanceInKm: state.coveredDistanceInKm!,
          avgPace: Pace(
            minutes: state.averagePaceMinutes!,
            seconds: state.averagePaceSeconds!,
          ),
          avgHeartRate: state.averageHeartRate!,
          moodRate: state.moodRate!,
          comment: state.comment,
        );
      case WorkoutStatusType.uncompleted:
        return WorkoutStatusUncompleted(
          coveredDistanceInKm: state.coveredDistanceInKm!,
          avgPace: Pace(
            minutes: state.averagePaceMinutes!,
            seconds: state.averagePaceSeconds!,
          ),
          avgHeartRate: state.averageHeartRate!,
          moodRate: state.moodRate!,
          comment: state.comment,
        );
    }
  }
}
