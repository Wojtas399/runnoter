part of 'run_status_creator_bloc.dart';

abstract class RunStatusCreatorEvent {
  const RunStatusCreatorEvent();
}

class RunStatusCreatorEventInitialize extends RunStatusCreatorEvent {
  final String workoutId;
  final RunStatusType? runStatusType;

  RunStatusCreatorEventInitialize({
    required this.workoutId,
    this.runStatusType,
  });
}

class RunStatusCreatorEventRunStatusTypeChanged extends RunStatusCreatorEvent {
  final RunStatusType? runStatusType;

  const RunStatusCreatorEventRunStatusTypeChanged({
    required this.runStatusType,
  });
}

class RunStatusCreatorEventCoveredDistanceInKmChanged
    extends RunStatusCreatorEvent {
  final double? coveredDistanceInKm;

  const RunStatusCreatorEventCoveredDistanceInKmChanged({
    required this.coveredDistanceInKm,
  });
}

class RunStatusCreatorEventMoodRateChanged extends RunStatusCreatorEvent {
  final MoodRate? moodRate;

  const RunStatusCreatorEventMoodRateChanged({
    required this.moodRate,
  });
}

class RunStatusCreatorEventAvgPaceMinutesChanged extends RunStatusCreatorEvent {
  final int? minutes;

  const RunStatusCreatorEventAvgPaceMinutesChanged({
    required this.minutes,
  });
}

class RunStatusCreatorEventAvgPaceSecondsChanged extends RunStatusCreatorEvent {
  final int? seconds;

  const RunStatusCreatorEventAvgPaceSecondsChanged({
    required this.seconds,
  });
}

class RunStatusCreatorEventAvgHeartRateChanged extends RunStatusCreatorEvent {
  final int? averageHeartRate;

  const RunStatusCreatorEventAvgHeartRateChanged({
    required this.averageHeartRate,
  });
}

class RunStatusCreatorEventCommentChanged extends RunStatusCreatorEvent {
  final String? comment;

  const RunStatusCreatorEventCommentChanged({
    required this.comment,
  });
}

class RunStatusCreatorEventSubmit extends RunStatusCreatorEvent {
  const RunStatusCreatorEventSubmit();
}
