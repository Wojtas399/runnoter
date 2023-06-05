import 'package:equatable/equatable.dart';

abstract class RunStatus extends Equatable {
  const RunStatus();
}

class RunStatusPending extends RunStatus {
  const RunStatusPending();

  @override
  List<Object> get props => [];
}

class RunStatusDone extends RunStatus with RunStats {
  RunStatusDone({
    required double coveredDistanceInKm,
    required Pace avgPace,
    required int avgHeartRate,
    required MoodRate moodRate,
    required String? comment,
  })  : assert(coveredDistanceInKm >= 0),
        assert(avgHeartRate >= 0 && avgHeartRate <= 400) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPace = avgPace;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.comment = comment;
  }

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class RunStatusAborted extends RunStatus with RunStats {
  RunStatusAborted({
    required double coveredDistanceInKm,
    required Pace avgPace,
    required int avgHeartRate,
    required MoodRate moodRate,
    required String? comment,
  })  : assert(coveredDistanceInKm >= 0),
        assert(avgHeartRate >= 0 && avgHeartRate <= 400) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPace = avgPace;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.comment = comment;
  }

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];
}

class RunStatusUndone extends RunStatus {
  const RunStatusUndone();

  @override
  List<Object?> get props => [];
}

mixin RunStats on RunStatus {
  late final double coveredDistanceInKm;
  late final Pace avgPace;
  late final int avgHeartRate;
  late final MoodRate moodRate;
  late final String? comment;
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
