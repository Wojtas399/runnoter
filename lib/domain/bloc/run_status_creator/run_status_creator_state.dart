part of 'run_status_creator_bloc.dart';

class RunStatusCreatorState extends BlocState<RunStatusCreatorState> {
  final EntityType entityType;
  final RunStatus? originalRunStatus;
  final RunStatusType? runStatusType;
  final double? coveredDistanceInKm;
  final Duration? duration;
  final MoodRate? moodRate;
  final int? averagePaceMinutes;
  final int? averagePaceSeconds;
  final int? averageHeartRate;
  final String? comment;

  const RunStatusCreatorState({
    required super.status,
    required this.entityType,
    this.originalRunStatus,
    this.runStatusType,
    this.coveredDistanceInKm,
    this.duration,
    this.moodRate,
    this.averagePaceMinutes,
    this.averagePaceSeconds,
    this.averageHeartRate,
    this.comment,
  });

  @override
  List<Object?> get props => [
        status,
        entityType,
        originalRunStatus,
        runStatusType,
        coveredDistanceInKm,
        duration,
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
          coveredDistanceInKm! > 0 &&
          (duration == null || duration!.inSeconds > 0) &&
          moodRate != null &&
          averagePaceMinutes != null &&
          averagePaceSeconds != null &&
          averageHeartRate != null);

  bool get areDataSameAsOriginal {
    if (_doesRunStatusTypeMatchToOriginalRunStatus()) {
      final RunStatus? originalRunStatus = this.originalRunStatus;
      if (originalRunStatus is RunStatusWithParams) {
        return coveredDistanceInKm == originalRunStatus.coveredDistanceInKm &&
            duration == originalRunStatus.duration &&
            moodRate == originalRunStatus.moodRate &&
            averagePaceMinutes == originalRunStatus.avgPace.minutes &&
            averagePaceSeconds == originalRunStatus.avgPace.seconds &&
            averageHeartRate == originalRunStatus.avgHeartRate &&
            (comment ?? '') == (originalRunStatus.comment ?? '');
      }
    }
    return false;
  }

  @override
  RunStatusCreatorState copyWith({
    BlocStatus? status,
    RunStatus? originalRunStatus,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorState(
        status: status ?? const BlocStatusComplete(),
        entityType: entityType,
        originalRunStatus: originalRunStatus ?? this.originalRunStatus,
        runStatusType: runStatusType ?? this.runStatusType,
        coveredDistanceInKm: coveredDistanceInKm ?? this.coveredDistanceInKm,
        duration: duration ?? this.duration,
        moodRate: moodRate ?? this.moodRate,
        averagePaceMinutes: averagePaceMinutes ?? this.averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds ?? this.averagePaceSeconds,
        averageHeartRate: averageHeartRate ?? this.averageHeartRate,
        comment: comment ?? this.comment,
      );

  bool _doesRunStatusTypeMatchToOriginalRunStatus() {
    final runStatusType = this.runStatusType;
    final originalRunStatus = this.originalRunStatus;
    if (runStatusType == null || originalRunStatus == null) {
      return false;
    }
    return (runStatusType == RunStatusType.pending &&
            originalRunStatus is RunStatusPending) ||
        (runStatusType == RunStatusType.done &&
            originalRunStatus is RunStatusDone) ||
        (runStatusType == RunStatusType.aborted &&
            originalRunStatus is RunStatusAborted) ||
        (runStatusType == RunStatusType.undone &&
            originalRunStatus is RunStatusUndone);
  }
}

enum RunStatusType {
  pending,
  done,
  aborted,
  undone,
}
