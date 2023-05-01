part of 'workout_status_creator_bloc.dart';

class WorkoutStatusCreatorState extends BlocState<WorkoutStatusCreatorState> {
  final WorkoutStatusType? workoutStatusType;
  final double? coveredDistanceInKm;
  final MoodRate? moodRate;
  final Pace? averagePace;
  final int? averageHeartRate;
  final String? comment;

  const WorkoutStatusCreatorState({
    required super.status,
    this.workoutStatusType,
    this.coveredDistanceInKm,
    this.moodRate,
    this.averagePace,
    this.averageHeartRate,
    this.comment,
  });

  @override
  List<Object?> get props => [
        status,
        workoutStatusType,
        coveredDistanceInKm,
        moodRate,
        averagePace,
        averageHeartRate,
        comment,
      ];

  @override
  WorkoutStatusCreatorState copyWith({
    BlocStatus? status,
    WorkoutStatusType? workoutStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    Pace? averagePace,
    int? averageHeartRate,
    String? comment,
  }) =>
      WorkoutStatusCreatorState(
        status: status ?? const BlocStatusComplete(),
        workoutStatusType: workoutStatusType ?? this.workoutStatusType,
        coveredDistanceInKm: coveredDistanceInKm ?? this.coveredDistanceInKm,
        moodRate: moodRate ?? this.moodRate,
        averagePace: averagePace ?? this.averagePace,
        averageHeartRate: averageHeartRate ?? this.averageHeartRate,
        comment: comment ?? this.comment,
      );
}

enum WorkoutStatusType {
  pending,
  completed,
  uncompleted,
}
