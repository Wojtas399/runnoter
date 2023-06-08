import 'package:equatable/equatable.dart';

sealed class RunStatus extends Equatable {
  const RunStatus();
}

sealed class RunStatusWithParams extends RunStatus {
  final double coveredDistanceInKm;
  final Pace avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const RunStatusWithParams({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  })  : assert(coveredDistanceInKm >= 0),
        assert(avgHeartRate >= 0 && avgHeartRate <= 400);

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class RunStatusPending extends RunStatus {
  const RunStatusPending();

  @override
  List<Object> get props => [];
}

class RunStatusDone extends RunStatusWithParams {
  const RunStatusDone({
    required super.coveredDistanceInKm,
    required super.avgPace,
    required super.avgHeartRate,
    required super.moodRate,
    required super.comment,
  });
}

class RunStatusAborted extends RunStatusWithParams {
  const RunStatusAborted({
    required super.coveredDistanceInKm,
    required super.avgPace,
    required super.avgHeartRate,
    required super.moodRate,
    required super.comment,
  });
}

class RunStatusUndone extends RunStatus {
  const RunStatusUndone();

  @override
  List<Object?> get props => [];
}

class Pace extends Equatable {
  final int minutes;
  final int seconds;

  const Pace({
    required this.minutes,
    required this.seconds,
  })  : assert(minutes >= 0 && minutes <= 59),
        assert(seconds >= 0 && seconds <= 59);

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
