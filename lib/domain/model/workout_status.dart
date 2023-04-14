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
  final double coveredDistanceInKm;
  final Pace avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusDone({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class WorkoutStatusFailed extends WorkoutStatus {
  final double coveredDistanceInKm;
  final Pace avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusFailed({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class Pace extends Equatable {
  final int minutes;
  final int seconds;

  const Pace({
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object> get props => [
        minutes,
        seconds,
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
