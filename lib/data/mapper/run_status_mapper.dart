import 'package:firebase/firebase.dart';

import '../../domain/entity/run_status.dart';
import 'mood_rate_mapper.dart';
import 'pace_mapper.dart';

RunStatus mapRunStatusFromDto(RunStatusDto runStatusDto) {
  if (runStatusDto is RunStatusPendingDto) {
    return const RunStatusPending();
  } else if (runStatusDto is RunStatusDoneDto) {
    return RunStatusDone(
      coveredDistanceInKm: runStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(runStatusDto.avgPaceDto),
      avgHeartRate: runStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(runStatusDto.moodRate),
      duration: runStatusDto.duration,
      comment: runStatusDto.comment,
    );
  } else if (runStatusDto is RunStatusAbortedDto) {
    return RunStatusAborted(
      coveredDistanceInKm: runStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(runStatusDto.avgPaceDto),
      avgHeartRate: runStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(runStatusDto.moodRate),
      duration: runStatusDto.duration,
      comment: runStatusDto.comment,
    );
  } else if (runStatusDto is RunStatusUndoneDto) {
    return const RunStatusUndone();
  } else {
    throw '[RunStatusMapper] Unknown workout status dto';
  }
}

RunStatusDto mapRunStatusToDto(RunStatus runStatus) {
  if (runStatus is RunStatusPending) {
    return const RunStatusPendingDto();
  } else if (runStatus is RunStatusDone) {
    return RunStatusDoneDto(
      coveredDistanceInKm: runStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(runStatus.avgPace),
      avgHeartRate: runStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(runStatus.moodRate),
      duration: runStatus.duration,
      comment: runStatus.comment,
    );
  } else if (runStatus is RunStatusAborted) {
    return RunStatusAbortedDto(
      coveredDistanceInKm: runStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(runStatus.avgPace),
      avgHeartRate: runStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(runStatus.moodRate),
      duration: runStatus.duration,
      comment: runStatus.comment,
    );
  } else if (runStatus is RunStatusUndone) {
    return const RunStatusUndoneDto();
  } else {
    throw '[RunStatusMapper] Unknown workout status';
  }
}
