part of 'run_status_creator_bloc.dart';

abstract class RunStatusCreatorEvent {
  const RunStatusCreatorEvent();
}

class RunStatusCreatorEventInitialize extends RunStatusCreatorEvent {
  const RunStatusCreatorEventInitialize();
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

class RunStatusCreatorEventDurationChanged extends RunStatusCreatorEvent {
  final Duration? duration;

  const RunStatusCreatorEventDurationChanged({
    required this.duration,
  });
}

class RunStatusCreatorEventMoodRateChanged extends RunStatusCreatorEvent {
  final MoodRate? moodRate;

  const RunStatusCreatorEventMoodRateChanged({
    required this.moodRate,
  });
}

class RunStatusCreatorEventAvgPaceChanged extends RunStatusCreatorEvent {
  final Pace avgPace;

  const RunStatusCreatorEventAvgPaceChanged({
    required this.avgPace,
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
