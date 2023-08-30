import 'package:firebase/firebase.dart';

import '../../domain/additional_model/activity_status.dart';
import 'mood_rate_mapper.dart';
import 'pace_mapper.dart';

ActivityStatus mapActivityStatusFromDto(ActivityStatusDto activityStatusDto) {
  if (activityStatusDto is ActivityStatusPendingDto) {
    return const ActivityStatusPending();
  } else if (activityStatusDto is ActivityStatusDoneDto) {
    return ActivityStatusDone(
      coveredDistanceInKm: activityStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(activityStatusDto.avgPaceDto),
      avgHeartRate: activityStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(activityStatusDto.moodRate),
      duration: activityStatusDto.duration,
      comment: activityStatusDto.comment,
    );
  } else if (activityStatusDto is ActivityStatusAbortedDto) {
    return ActivityStatusAborted(
      coveredDistanceInKm: activityStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(activityStatusDto.avgPaceDto),
      avgHeartRate: activityStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(activityStatusDto.moodRate),
      duration: activityStatusDto.duration,
      comment: activityStatusDto.comment,
    );
  } else if (activityStatusDto is ActivityStatusUndoneDto) {
    return const ActivityStatusUndone();
  } else {
    throw '[ActivityStatusMapper] Unknown workout status dto';
  }
}

ActivityStatusDto mapActivityStatusToDto(ActivityStatus activityStatus) {
  if (activityStatus is ActivityStatusPending) {
    return const ActivityStatusPendingDto();
  } else if (activityStatus is ActivityStatusDone) {
    return ActivityStatusDoneDto(
      coveredDistanceInKm: activityStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(activityStatus.avgPace),
      avgHeartRate: activityStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(activityStatus.moodRate),
      duration: activityStatus.duration,
      comment: activityStatus.comment,
    );
  } else if (activityStatus is ActivityStatusAborted) {
    return ActivityStatusAbortedDto(
      coveredDistanceInKm: activityStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(activityStatus.avgPace),
      avgHeartRate: activityStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(activityStatus.moodRate),
      duration: activityStatus.duration,
      comment: activityStatus.comment,
    );
  } else if (activityStatus is ActivityStatusUndone) {
    return const ActivityStatusUndoneDto();
  } else {
    throw '[ActivityStatusMapper] Unknown workout status';
  }
}
