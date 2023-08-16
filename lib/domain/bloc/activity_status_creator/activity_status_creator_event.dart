part of 'activity_status_creator_bloc.dart';

abstract class ActivityStatusCreatorEvent {
  const ActivityStatusCreatorEvent();
}

class ActivityStatusCreatorEventInitialize extends ActivityStatusCreatorEvent {
  const ActivityStatusCreatorEventInitialize();
}

class ActivityStatusCreatorEventActivityStatusTypeChanged
    extends ActivityStatusCreatorEvent {
  final ActivityStatusType? activityStatusType;

  const ActivityStatusCreatorEventActivityStatusTypeChanged({
    required this.activityStatusType,
  });
}

class ActivityStatusCreatorEventCoveredDistanceInKmChanged
    extends ActivityStatusCreatorEvent {
  final double? coveredDistanceInKm;

  const ActivityStatusCreatorEventCoveredDistanceInKmChanged({
    required this.coveredDistanceInKm,
  });
}

class ActivityStatusCreatorEventDurationChanged
    extends ActivityStatusCreatorEvent {
  final Duration? duration;

  const ActivityStatusCreatorEventDurationChanged({required this.duration});
}

class ActivityStatusCreatorEventMoodRateChanged
    extends ActivityStatusCreatorEvent {
  final MoodRate? moodRate;

  const ActivityStatusCreatorEventMoodRateChanged({required this.moodRate});
}

class ActivityStatusCreatorEventAvgPaceChanged
    extends ActivityStatusCreatorEvent {
  final Pace avgPace;

  const ActivityStatusCreatorEventAvgPaceChanged({required this.avgPace});
}

class ActivityStatusCreatorEventAvgHeartRateChanged
    extends ActivityStatusCreatorEvent {
  final int? averageHeartRate;

  const ActivityStatusCreatorEventAvgHeartRateChanged({
    required this.averageHeartRate,
  });
}

class ActivityStatusCreatorEventCommentChanged
    extends ActivityStatusCreatorEvent {
  final String? comment;

  const ActivityStatusCreatorEventCommentChanged({required this.comment});
}

class ActivityStatusCreatorEventSubmit extends ActivityStatusCreatorEvent {
  const ActivityStatusCreatorEventSubmit();
}
