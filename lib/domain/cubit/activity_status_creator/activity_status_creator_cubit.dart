import '../../../../domain/additional_model/bloc_status.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';

part 'activity_status_creator_state.dart';

enum ActivityType { workout, race }

class ActivityStatusCreatorCubit extends CubitWithStatus<
    ActivityStatusCreatorState, ActivityStatusCreatorCubitInfo, dynamic> {
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final String userId;
  final ActivityType activityType;
  final String activityId;

  ActivityStatusCreatorCubit({
    required this.userId,
    required this.activityType,
    required this.activityId,
    ActivityStatusCreatorState initialState = const ActivityStatusCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(initialState);

  Future<void> initialize() async {
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

  void activityStatusTypeChanged(ActivityStatusType? activityStatusType) {
    emit(state.copyWith(activityStatusType: activityStatusType));
  }

  void coveredDistanceInKmChanged(double? coveredDistanceInKm) {
    emit(state.copyWith(coveredDistanceInKm: coveredDistanceInKm));
  }

  void durationChanged(Duration? duration) {
    emit(state.copyWith(duration: duration));
  }

  void moodRateChanged(MoodRate? moodRate) {
    emit(state.copyWith(moodRate: moodRate));
  }

  void avgPaceChanged(Pace? avgPace) {
    emit(state.copyWith(avgPace: avgPace));
  }

  void avgHeartRateChanged(int? avgHeartRate) {
    emit(state.copyWith(avgHeartRate: avgHeartRate));
  }

  void commentChanged(String? comment) {
    emit(state.copyWith(comment: comment));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    final ActivityStatus status = _createStatus();
    emitLoadingStatus();
    await switch (activityType) {
      ActivityType.workout => _workoutRepository.updateWorkout(
          workoutId: activityId,
          userId: userId,
          status: status,
        ),
      ActivityType.race => _raceRepository.updateRace(
          raceId: activityId,
          userId: userId,
          status: status,
        ),
    };
    emitCompleteStatus(
      info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
    );
  }

  Stream<ActivityStatus?> _getActivityStatus() => switch (activityType) {
        ActivityType.workout => _getWorkoutActivityStatus(userId),
        ActivityType.race => _getRaceActivityStatus(userId),
      };

  Stream<ActivityStatus?> _getWorkoutActivityStatus(String userId) =>
      _workoutRepository
          .getWorkoutById(workoutId: activityId, userId: userId)
          .map((Workout? workout) => workout?.status);

  Stream<ActivityStatus?> _getRaceActivityStatus(String userId) =>
      _raceRepository
          .getRaceById(raceId: activityId, userId: userId)
          .map((Race? race) => race?.status);

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

enum ActivityStatusCreatorCubitInfo { activityStatusSaved }
