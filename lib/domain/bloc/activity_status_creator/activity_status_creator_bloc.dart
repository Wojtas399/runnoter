import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

part 'activity_status_creator_event.dart';
part 'activity_status_creator_state.dart';

enum ActivityStatusCreatorEntityType {
  workout,
  race,
}

class ActivityStatusCreatorBloc extends BlocWithStatus<
    ActivityStatusCreatorEvent,
    ActivityStatusCreatorState,
    ActivityStatusCreatorBlocInfo,
    dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final ActivityStatusCreatorEntityType? entityType;
  final String? entityId;

  ActivityStatusCreatorBloc({
    required this.entityType,
    required this.entityId,
    ActivityStatusCreatorState state = const ActivityStatusCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(state) {
    on<ActivityStatusCreatorEventInitialize>(_initialize);
    on<ActivityStatusCreatorEventActivityStatusTypeChanged>(
        _activityStatusTypeChanged);
    on<ActivityStatusCreatorEventCoveredDistanceInKmChanged>(
      _coveredDistanceInKmChanged,
    );
    on<ActivityStatusCreatorEventDurationChanged>(_durationChanged);
    on<ActivityStatusCreatorEventMoodRateChanged>(_moodRateChanged);
    on<ActivityStatusCreatorEventAvgPaceChanged>(_avgPaceChanged);
    on<ActivityStatusCreatorEventAvgHeartRateChanged>(_avgHeartRateChanged);
    on<ActivityStatusCreatorEventCommentChanged>(_commentChanged);
    on<ActivityStatusCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    ActivityStatusCreatorEventInitialize event,
    Emitter<ActivityStatusCreatorState> emit,
  ) async {
    if (entityType == null || entityId == null) return;
    final Stream<ActivityStatus?> activityStatus$ = _getActivityStatus();
    await for (final activityStatus in activityStatus$) {
      if (activityStatus == null) return;
      ActivityStatusCreatorState updatedState = state.copyWith(
        originalActivityStatus: activityStatus,
        activityStatusType: _getActivityStatusType(activityStatus),
      );
      if (activityStatus is ActivityStatusWithParams) {
        updatedState = updatedState.copyWith(
          coveredDistanceInKm: activityStatus.coveredDistanceInKm,
          duration: activityStatus.duration,
          moodRate: activityStatus.moodRate,
          avgPace: activityStatus.avgPace,
          avgHeartRate: activityStatus.avgHeartRate,
          comment: activityStatus.comment,
        );
      }
      emit(updatedState);
      return;
    }
  }

  void _activityStatusTypeChanged(
    ActivityStatusCreatorEventActivityStatusTypeChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      activityStatusType: event.activityStatusType,
    ));
  }

  void _coveredDistanceInKmChanged(
    ActivityStatusCreatorEventCoveredDistanceInKmChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      coveredDistanceInKm: event.coveredDistanceInKm,
    ));
  }

  void _durationChanged(
    ActivityStatusCreatorEventDurationChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      duration: event.duration,
    ));
  }

  void _moodRateChanged(
    ActivityStatusCreatorEventMoodRateChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      moodRate: event.moodRate,
    ));
  }

  void _avgPaceChanged(
    ActivityStatusCreatorEventAvgPaceChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      avgPace: event.avgPace,
    ));
  }

  void _avgHeartRateChanged(
    ActivityStatusCreatorEventAvgHeartRateChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      avgHeartRate: event.averageHeartRate,
    ));
  }

  void _commentChanged(
    ActivityStatusCreatorEventCommentChanged event,
    Emitter<ActivityStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      comment: event.comment,
    ));
  }

  Future<void> _submit(
    ActivityStatusCreatorEventSubmit event,
    Emitter<ActivityStatusCreatorState> emit,
  ) async {
    if (!state.canSubmit || entityType == null || entityId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final ActivityStatus status = _createStatus();
    emitLoadingStatus(emit);
    await switch (entityType!) {
      ActivityStatusCreatorEntityType.workout =>
        _workoutRepository.updateWorkout(
          workoutId: entityId!,
          userId: loggedUserId,
          status: status,
        ),
      ActivityStatusCreatorEntityType.race => _raceRepository.updateRace(
          raceId: entityId!,
          userId: loggedUserId,
          status: status,
        ),
    };
    emitCompleteStatus(emit,
        info: ActivityStatusCreatorBlocInfo.activityStatusSaved);
  }

  Stream<ActivityStatus?> _getActivityStatus() =>
      _authService.loggedUserId$.whereType<String>().switchMap(
            (String loggedUserId) => switch (entityType!) {
              ActivityStatusCreatorEntityType.workout =>
                _getWorkoutActivityStatus(loggedUserId),
              ActivityStatusCreatorEntityType.race =>
                _getRaceActivityStatus(loggedUserId),
            },
          );

  Stream<ActivityStatus?> _getWorkoutActivityStatus(String loggedUserId) =>
      _workoutRepository
          .getWorkoutById(workoutId: entityId!, userId: loggedUserId)
          .map((workout) => workout?.status);

  Stream<ActivityStatus?> _getRaceActivityStatus(String loggedUserId) =>
      _raceRepository
          .getRaceById(raceId: entityId!, userId: loggedUserId)
          .map((race) => race?.status);

  ActivityStatusType _getActivityStatusType(ActivityStatus activityStatus) =>
      switch (activityStatus) {
        ActivityStatusPending() => ActivityStatusType.done,
        ActivityStatusDone() => ActivityStatusType.done,
        ActivityStatusAborted() => ActivityStatusType.aborted,
        ActivityStatusUndone() => ActivityStatusType.undone,
      };

  ActivityStatus _createStatus() => switch (state.activityStatusType!) {
        ActivityStatusType.pending => const ActivityStatusPending(),
        ActivityStatusType.done => ActivityStatusDone(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            duration: state.duration,
            avgPace: state.avgPace!,
            avgHeartRate: state.avgHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        ActivityStatusType.aborted => ActivityStatusAborted(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            duration: state.duration,
            avgPace: state.avgPace!,
            avgHeartRate: state.avgHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        ActivityStatusType.undone => const ActivityStatusUndone(),
      };
}

enum ActivityStatusCreatorBlocInfo { activityStatusSaved }
