part of 'activity_status_creator_cubit.dart';

class ActivityStatusCreatorState
    extends CubitState<ActivityStatusCreatorState> {
  final ActivityStatus? originalActivityStatus;
  final ActivityStatusType? activityStatusType;
  final double? coveredDistanceInKm;
  final Duration? duration;
  final MoodRate? moodRate;
  final Pace? avgPace;
  final int? avgHeartRate;
  final String? comment;

  const ActivityStatusCreatorState({
    required super.status,
    this.originalActivityStatus,
    this.activityStatusType,
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
        originalActivityStatus,
        activityStatusType,
        coveredDistanceInKm,
        duration,
        moodRate,
        avgPace,
        avgHeartRate,
        comment,
      ];

  bool get canSubmit => _isFormValid && _areDataDifferentThanOriginal;

  bool get _isFormValid =>
      activityStatusType == ActivityStatusType.pending ||
      activityStatusType == ActivityStatusType.undone ||
      (activityStatusType != null &&
          coveredDistanceInKm != null &&
          coveredDistanceInKm! > 0 &&
          (duration == null || duration!.inSeconds > 0) &&
          moodRate != null &&
          avgPace != null &&
          (avgPace!.minutes > 0 || avgPace!.seconds > 0) &&
          avgHeartRate != null &&
          avgHeartRate! > 0);

  bool get _areDataDifferentThanOriginal {
    if (_doesActivityStatusTypeMatchToOriginalActivityStatus()) {
      final ActivityStatus? originalActivityStatus =
          this.originalActivityStatus;
      if (originalActivityStatus is ActivityStatusWithParams) {
        return coveredDistanceInKm !=
                originalActivityStatus.coveredDistanceInKm ||
            duration != originalActivityStatus.duration ||
            moodRate != originalActivityStatus.moodRate ||
            avgPace != originalActivityStatus.avgPace ||
            avgHeartRate != originalActivityStatus.avgHeartRate ||
            comment != originalActivityStatus.comment;
      }
      return false;
    }
    return true;
  }

  @override
  ActivityStatusCreatorState copyWith({
    CubitStatus? status,
    ActivityStatus? originalActivityStatus,
    ActivityStatusType? activityStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      ActivityStatusCreatorState(
        status: status ?? const CubitStatusComplete(),
        originalActivityStatus:
            originalActivityStatus ?? this.originalActivityStatus,
        activityStatusType: activityStatusType ?? this.activityStatusType,
        coveredDistanceInKm: coveredDistanceInKm ?? this.coveredDistanceInKm,
        duration: duration ?? this.duration,
        moodRate: moodRate ?? this.moodRate,
        avgPace: avgPace ?? this.avgPace,
        avgHeartRate: avgHeartRate ?? this.avgHeartRate,
        comment: comment ?? this.comment,
      );

  bool _doesActivityStatusTypeMatchToOriginalActivityStatus() {
    final activityStatusType = this.activityStatusType;
    final originalActivityStatus = this.originalActivityStatus;
    if (activityStatusType == null || originalActivityStatus == null) {
      return false;
    }
    return (activityStatusType == ActivityStatusType.pending &&
            originalActivityStatus is ActivityStatusPending) ||
        (activityStatusType == ActivityStatusType.done &&
            originalActivityStatus is ActivityStatusDone) ||
        (activityStatusType == ActivityStatusType.aborted &&
            originalActivityStatus is ActivityStatusAborted) ||
        (activityStatusType == ActivityStatusType.undone &&
            originalActivityStatus is ActivityStatusUndone);
  }
}

enum ActivityStatusType { pending, done, aborted, undone }
