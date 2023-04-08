import 'package:equatable/equatable.dart';

abstract class WorkoutStatus extends Equatable {
  const WorkoutStatus();
}

class WorkoutStatusPending extends WorkoutStatus {
  const WorkoutStatusPending();

  @override
  List<Object> get props => [];
}

class WorkoutStatusDone extends WorkoutStatus {
  final double coveredDistance;
  final String avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusDone({
    required this.coveredDistance,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  @override
  List<Object?> get props => [
        coveredDistance,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class WorkoutStatusFailed extends WorkoutStatus {
  final double coveredDistance;
  final String avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusFailed({
    required this.coveredDistance,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  @override
  List<Object?> get props => [
        coveredDistance,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

enum MoodRate {
  mr1,
  mr2,
  mr3,
  mr4,
  mr5,
  mr6,
  mr7,
  mr8,
  mr9,
  mr10,
}
