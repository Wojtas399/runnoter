import 'package:firebase/firebase.dart';

import '../../domain/model/workout_status.dart';

Pace mapPaceFromDto(PaceDto paceDto) {
  return Pace(
    minutes: paceDto.minutes,
    seconds: paceDto.seconds,
  );
}
