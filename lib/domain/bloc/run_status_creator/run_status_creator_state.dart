part of 'run_status_creator_bloc.dart';

class RunStatusCreatorState extends BlocState<RunStatusCreatorState> {
  final EntityType entityType;
  final RunStatus? originalRunStatus;
  final RunStatusType? runStatusType;
  final double? coveredDistanceInKm;
  final Duration? duration;
  final MoodRate? moodRate;
  final Pace? avgPace;
  final int? avgHeartRate;
  final String? comment;

  const RunStatusCreatorState({
    required super.status,
    required this.entityType,
    this.originalRunStatus,
    this.runStatusType,
    this.coveredDistanceInKm,
    this.duration,
    this.moodRate,
    this.avgPace,
    this.avgHeartRate,
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
        avgPace,
        avgHeartRate,
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
          avgPace != null &&
          (avgPace!.minutes > 0 || avgPace!.seconds > 0) &&
          avgHeartRate != null);

  bool get areDataSameAsOriginal {
    if (_doesRunStatusTypeMatchToOriginalRunStatus()) {
      final RunStatus? originalRunStatus = this.originalRunStatus;
      if (originalRunStatus is RunStatusWithParams) {
        return coveredDistanceInKm == originalRunStatus.coveredDistanceInKm &&
            duration == originalRunStatus.duration &&
            moodRate == originalRunStatus.moodRate &&
            avgPace == originalRunStatus.avgPace &&
            avgHeartRate == originalRunStatus.avgHeartRate &&
            (comment ?? '') == (originalRunStatus.comment ?? '');
      }
      return true;
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
    Pace? avgPace,
    int? avgHeartRate,
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
        avgPace: avgPace ?? this.avgPace,
        avgHeartRate: avgHeartRate ?? this.avgHeartRate,
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
