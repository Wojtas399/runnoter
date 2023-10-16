import 'package:equatable/equatable.dart';

import '../model/entity.dart';

abstract class Activity extends Entity {
  final String userId;
  final DateTime date;
  final String name;
  final ActivityStatus status;

  const Activity({
    required super.id,
    required this.userId,
    required this.date,
    required this.name,
    required this.status,
  });

  double get coveredDistance {
    final ActivityStatus status = this.status;
    return status is ActivityStatusWithParams
        ? status.coveredDistanceInKm
        : 0.0;
  }

  @override
  List<Object?> get props => [id, userId, date, name, status];
}

sealed class ActivityStatus extends Equatable {
  const ActivityStatus();
}

sealed class ActivityStatusWithParams extends ActivityStatus {
  final double coveredDistanceInKm;
  final Pace avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final Duration? duration;
  final String? comment;

  const ActivityStatusWithParams({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.duration,
    required this.comment,
  })  : assert(coveredDistanceInKm >= 0),
        assert(avgHeartRate >= 0 && avgHeartRate <= 400);

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        duration,
        comment,
      ];
}

class ActivityStatusPending extends ActivityStatus {
  const ActivityStatusPending();

  @override
  List<Object> get props => [];
}

class ActivityStatusDone extends ActivityStatusWithParams {
  const ActivityStatusDone({
    required super.coveredDistanceInKm,
    required super.avgPace,
    required super.avgHeartRate,
    required super.moodRate,
    super.duration,
    super.comment,
  });
}

class ActivityStatusAborted extends ActivityStatusWithParams {
  const ActivityStatusAborted({
    required super.coveredDistanceInKm,
    required super.avgPace,
    required super.avgHeartRate,
    required super.moodRate,
    super.duration,
    super.comment,
  });
}

class ActivityStatusUndone extends ActivityStatus {
  const ActivityStatusUndone();

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
  List<Object> get props => [minutes, seconds];
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
