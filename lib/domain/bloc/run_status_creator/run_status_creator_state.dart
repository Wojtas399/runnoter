part of 'run_status_creator_bloc.dart';

class RunStatusCreatorState extends BlocState<RunStatusCreatorState> {
  final String? workoutId;
  final RunStatus? runStatus;
  final RunStatusType? runStatusType;
  final double? coveredDistanceInKm;
  final MoodRate? moodRate;
  final int? averagePaceMinutes;
  final int? averagePaceSeconds;
  final int? averageHeartRate;
  final String? comment;

  const RunStatusCreatorState({
    required super.status,
    this.workoutId,
    this.runStatus,
    this.runStatusType,
    this.coveredDistanceInKm,
    this.moodRate,
    this.averagePaceMinutes,
    this.averagePaceSeconds,
    this.averageHeartRate,
    this.comment,
  });

  @override
  List<Object?> get props => [
        status,
        workoutId,
        runStatus,
        runStatusType,
        coveredDistanceInKm,
        moodRate,
        averagePaceMinutes,
        averagePaceSeconds,
        averageHeartRate,
        comment,
      ];

  bool get isFormValid =>
      runStatusType == RunStatusType.pending ||
      runStatusType == RunStatusType.undone ||
      (runStatusType != null &&
          coveredDistanceInKm != null &&
          moodRate != null &&
          averagePaceMinutes != null &&
          averagePaceSeconds != null &&
          averageHeartRate != null);

  bool get areDataSameAsOriginal {
    if (_doesRunStatusTypeMatchToRunStatus()) {
      final RunStatus? runStatus = this.runStatus;
      if (runStatus is RunStats) {
        return coveredDistanceInKm == runStatus.coveredDistanceInKm &&
            moodRate == runStatus.moodRate &&
            averagePaceMinutes == runStatus.avgPace.minutes &&
            averagePaceSeconds == runStatus.avgPace.seconds &&
            averageHeartRate == runStatus.avgHeartRate &&
            (comment ?? '') == (runStatus.comment ?? '');
      }
    }
    return false;
  }

  @override
  RunStatusCreatorState copyWith({
    BlocStatus? status,
    String? workoutId,
    RunStatus? runStatus,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorState(
        status: status ?? const BlocStatusComplete(),
        workoutId: workoutId ?? this.workoutId,
        runStatus: runStatus ?? this.runStatus,
        runStatusType: runStatusType ?? this.runStatusType,
        coveredDistanceInKm: coveredDistanceInKm ?? this.coveredDistanceInKm,
        moodRate: moodRate ?? this.moodRate,
        averagePaceMinutes: averagePaceMinutes ?? this.averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds ?? this.averagePaceSeconds,
        averageHeartRate: averageHeartRate ?? this.averageHeartRate,
        comment: comment ?? this.comment,
      );

  bool _doesRunStatusTypeMatchToRunStatus() {
    final runStatusType = this.runStatusType;
    final runStatus = this.runStatus;
    if (runStatusType == null || runStatus == null) {
      return false;
    }
    return (runStatusType == RunStatusType.pending &&
            runStatus is RunStatusPending) ||
        (runStatusType == RunStatusType.done && runStatus is RunStatusDone) ||
        (runStatusType == RunStatusType.aborted &&
            runStatus is RunStatusAborted) ||
        (runStatusType == RunStatusType.undone && runStatus is RunStatusUndone);
  }
}

enum RunStatusType {
  pending,
  done,
  aborted,
  undone,
}
