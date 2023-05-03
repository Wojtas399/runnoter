part of 'workout_status_creator_bloc.dart';

class WorkoutStatusCreatorState extends BlocState<WorkoutStatusCreatorState> {
  final String? workoutId;
  final WorkoutStatus? workoutStatus;
  final WorkoutStatusType? workoutStatusType;
  final double? coveredDistanceInKm;
  final MoodRate? moodRate;
  final int? averagePaceMinutes;
  final int? averagePaceSeconds;
  final int? averageHeartRate;
  final String? comment;

  const WorkoutStatusCreatorState({
    required super.status,
    this.workoutId,
    this.workoutStatus,
    this.workoutStatusType,
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
        workoutStatus,
        workoutStatusType,
        coveredDistanceInKm,
        moodRate,
        averagePaceMinutes,
        averagePaceSeconds,
        averageHeartRate,
        comment,
      ];

  bool get isFormValid =>
      workoutStatusType == WorkoutStatusType.pending ||
      (workoutStatusType != null &&
          coveredDistanceInKm != null &&
          moodRate != null &&
          averagePaceMinutes != null &&
          averagePaceSeconds != null &&
          averageHeartRate != null);

  @override
  WorkoutStatusCreatorState copyWith({
    BlocStatus? status,
    String? workoutId,
    WorkoutStatus? workoutStatus,
    WorkoutStatusType? workoutStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      WorkoutStatusCreatorState(
        status: status ?? const BlocStatusComplete(),
        workoutId: workoutId ?? this.workoutId,
        workoutStatus: workoutStatus ?? this.workoutStatus,
        workoutStatusType: workoutStatusType ?? this.workoutStatusType,
        coveredDistanceInKm: coveredDistanceInKm ?? this.coveredDistanceInKm,
        moodRate: moodRate ?? this.moodRate,
        averagePaceMinutes: averagePaceMinutes ?? this.averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds ?? this.averagePaceSeconds,
        averageHeartRate: averageHeartRate ?? this.averageHeartRate,
        comment: comment ?? this.comment,
      );
}

enum WorkoutStatusType {
  pending,
  completed,
  uncompleted,
}

enum WorkoutStatusCreatorInfo {
  workoutStatusInitialized,
  workoutStatusSaved,
}
